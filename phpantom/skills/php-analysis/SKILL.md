---
description: Run project-wide PHP analysis, refactoring, and automated fixes with the phpantom_lsp CLI. Use when the user asks to check type-coverage across a PHP project, find unresolved classes/members/function calls, audit diagnostics for a whole codebase or directory, find remaining call sites of a deprecated symbol for a migration, move or rename a class or namespace and update every reference to it, or apply automated code fixes (e.g. remove unused imports) across many files. The `phpantom_lsp` command is on PATH whenever this plugin is enabled and PHPantom is installed.
---

# Project-wide PHP analysis and refactoring with the phpantom_lsp CLI

While this plugin is enabled, the `phpantom_lsp` binary is on the Bash tool's
PATH. Beyond the per-file code intelligence Claude Code gets over LSP, the same
binary has CLI subcommands for **whole-project** operations. Reach for these when
the request spans more than the file currently open.

The plugin's `phpantom_lsp` is a launcher for the copy the user installed; it
never downloads one. If it exits with a `[phpantom] ERROR:` saying phpantom_lsp
wasn't found, tell the user it needs installing and pass on the install options
the error lists, rather than installing it yourself. A subcommand reported as
unrecognized, such as `move`, means the installed version predates 0.11.0 and
needs upgrading.

The analysis is 100% static. It never boots the user's PHP application or runs
project code, so it is safe to run on any codebase.

## `phpantom_lsp analyze` — type-coverage and diagnostics report

Runs PHPantom's own diagnostics across the codebase (no PHPStan, no external
tools). The goal is full type coverage: every class, member, and function call
resolvable. Unresolved symbols are exactly the spots where completion and type
inference break down.

```
phpantom_lsp analyze [PATH] [OPTIONS]
```

- `[PATH]` — file or directory to analyze. Defaults to the entire project.
- `--severity <all|warning|error>` — minimum severity to report (default `all`).
- `--format <table|github|json>` — output format. Use `json` when you need to
  parse results programmatically; `table` (default) is best for showing a human.
- `--project-root <DIR>` — project root. Defaults to the current directory.
- `--no-colour` — disable ANSI colour (use this when capturing output).

Examples:

```bash
# Whole-project coverage report, plain text
phpantom_lsp analyze --no-colour

# Only a subdirectory, errors only
phpantom_lsp analyze src/ --severity error --no-colour

# Machine-readable output to reason over the findings
phpantom_lsp analyze --format json
```

When the current working directory is not the project root, pass
`--project-root <DIR>` (a path to the project) rather than trying to `cd` into it.

### Diagnostics `analyze` reports

| Rule                   | Severity | What it means                                          |
| ----------------------- | -------- | ------------------------------------------------------- |
| `syntax_error`          | Error    | PHP parse errors                                         |
| `unknown_class`         | Warning  | Class, interface, trait, or enum not resolvable          |
| `unknown_member`        | Warning  | Property or method not found on the resolved class       |
| `unknown_function`      | Error    | Function call not resolvable                             |
| `argument_count`        | Error    | Wrong number of arguments to a function or method        |
| `implementation_error`  | Error    | Missing required interface or abstract methods           |
| `scalar_member_access`  | Error    | Member access on a scalar type (int, string, etc.)       |
| `unused_import`         | Hint     | `use` statement with no references in the file           |
| `deprecated`            | Hint     | Reference to a symbol with an `@deprecated` docblock      |

`deprecated` is worth calling out on its own: it isn't just a lint, it reads
the `@deprecated` docblock on the referenced symbol and flags every call site
still using it. That makes it a live migration checklist — e.g. "this helper
is deprecated in favor of `__('key')`, and here are the N remaining places
that call it" — not something you'd otherwise get without hovering every
call site by hand.

## `phpantom_lsp fix` — apply automated fixes across files

Works like php-cs-fixer: pick rules and PHPantom rewrites files across the
codebase. With no `--rule`, all preferred native fixers run.

```
phpantom_lsp fix [PATH] [OPTIONS]
```

- `--rule <RULE>` — rule to apply; repeatable. Native rule: `unused_import`.
  PHPStan-based rules are prefixed `phpstan.` and require `--with-phpstan`.
- `--dry-run` — show what would change without writing files. **Prefer running
  a dry-run first** and showing the user before applying.
- `--with-phpstan` — enable PHPStan-based fixers (this runs PHPStan).
- `--format <table|github|json>`, `--project-root <DIR>`, `--no-colour` — as above.

Examples:

```bash
# Preview all native fixes without writing
phpantom_lsp fix --dry-run --no-colour

# Remove unused imports across the whole project
phpantom_lsp fix --rule unused_import
```

`fix` currently requires a single Composer project (a `composer.json` at the
project root).

## `phpantom_lsp move` — move a class or namespace, updating every reference

Moves one class or a whole namespace and rewrites its declaration, its imports,
every reference to it, and its PSR-4 file paths, in a single pass across the
project. Reach for this instead of `grep` plus `sed`: a search and replace misses
references reached through an alias or through a shared namespace with no `use`
line at all, catches unrelated names that merely start the same, and leaves files
sitting at paths the autoloader no longer maps to their name.

```
phpantom_lsp move [OPTIONS] <FROM> <TO>
```

- `<FROM>` — the class, namespace, PHP file, or PSR-4 directory to move.
- `<TO>` — the destination, read the same way as `FROM`.
- `--dry-run` — report the move without writing files. **Prefer a dry run first**
  and show the user before applying.
- `--format <table|github|json>`, `--project-root <DIR>`, `--no-colour` — as above.

Examples:

```bash
# Rename a class, updating imports and references project-wide
phpantom_lsp move 'App\Old\Widget' 'App\Domain\Gadget'

# The same move written as paths (path forms need a PSR-4 mapping)
phpantom_lsp move src/Old/Widget.php src/Domain/Gadget.php

# Move a whole namespace, taking its directory with it
phpantom_lsp move 'App\Old' 'App\Domain'

# Validate without touching the project
phpantom_lsp move --dry-run --no-colour src/Old src/Domain
```

`TO` is a full destination name, not a parent to drop the class into:
`move 'App\Old\Widget' 'App\Domain'` renames the class to `Domain`, so moving it
into `App\Domain` under its own name is written out as `'App\Domain\Widget'`.

### Read the warnings back to the user

The rewriter only reaches what it can resolve as a symbol, so a class named in a
Blade template, a YAML config, a PHPStan baseline, or a plain path string is
invisible to it. Rather than leave those unreported, the project is scanned as it
will look afterwards and every leftover mention of the old name or the old
location comes back with the file and line it sits on:

```
Would move namespace `App\Entity` to `App\Domain\Entity` (71 file(s) changed, 1 path(s) moved).
Warning: config/packages/doctrine.yaml:26: The old path `src/Entity` still appears here. ...
```

Those are the follow-up edits the command could not make for itself. Relay them,
and do not report the move as complete while they are outstanding. `--format
json` emits the `{"totals": …, "files": …, "errors": []}` shape `analyze` emits,
with the move's own counters under a `move` key, so both commands can be
consumed the same way.

### What it refuses

A move that cannot be carried out cleanly exits 1 with a reason and changes
nothing, so a refusal is safe to retry differently:

- a destination class or file that already exists;
- a namespace merge where both sides declare the same class name;
- a class installed by Composer, which is not yours to move;
- a namespace Composer spreads over more than one PSR-4 root, where there is no
  single directory to move.

A destination that no PSR-4 mapping covers is not refused. The declarations and
references are rewritten, but no file can follow them there, so the autoloader
stops finding them. That comes back as a warning worth surfacing prominently.

## `phpantom_lsp init`

Creates a default `.phpantom.toml` in the current directory. Useful when a
project needs explicit configuration (e.g. full indexing for a monorepo
subproject).

## Guidance

- For "is my project fully typed / where does inference break", run `analyze`
  and summarize the unresolved-symbol findings.
- For "clean up imports / apply fixes", run `fix --dry-run` first, show the
  planned changes, then run `fix` once the user agrees.
- For "rename this class / move this namespace", use `move` rather than editing
  the files by hand or with `sed`. Run `move --dry-run` first, show the planned
  changes and the warnings, then run it for real once the user agrees, and
  report what the warnings say was left behind.
- Use `--format json` when you need to filter, count, or reason over findings;
  use the default table when reporting to the user.
