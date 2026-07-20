---
description: Run project-wide PHP analysis and automated fixes with the phpantom_lsp CLI. Use when the user asks to check type-coverage across a PHP project, find unresolved classes/members/function calls, audit diagnostics for a whole codebase or directory, or apply automated code fixes (e.g. remove unused imports) across many files. The `phpantom_lsp` binary is on PATH whenever this plugin is enabled.
---

# Project-wide PHP analysis with the phpantom_lsp CLI

While this plugin is enabled, the `phpantom_lsp` binary is on the Bash tool's
PATH. Beyond the per-file code intelligence Claude Code gets over LSP, the same
binary has CLI subcommands for **whole-project** operations. Reach for these when
the request spans more than the file currently open.

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

## `phpantom_lsp init`

Creates a default `.phpantom.toml` in the current directory. Useful when a
project needs explicit configuration (e.g. full indexing for a monorepo
subproject).

## Guidance

- For "is my project fully typed / where does inference break", run `analyze`
  and summarize the unresolved-symbol findings.
- For "clean up imports / apply fixes", run `fix --dry-run` first, show the
  planned changes, then run `fix` once the user agrees.
- Use `--format json` when you need to filter, count, or reason over findings;
  use the default table when reporting to the user.
