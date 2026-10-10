# PHPantom for Claude Code

A [Claude Code](https://claude.com/claude-code) plugin that gives Claude
real-time PHP code intelligence via [PHPantom](https://github.com/PHPantom-dev/phpantom_lsp),
a fast PHP language server written in Rust with Laravel and PHPStan-aware type
inference.

With the plugin installed, Claude sees diagnostics as it edits, and can use
go-to-definition, find-references, hover types, and completion while working in
your PHP project, the same code intelligence the PHPantom editor extensions
provide.

## What you get

- **Instant diagnostics** after every edit (unknown classes/members, argument
  count mismatches, unused imports, deprecations, and more).
- **Code navigation**: go to definition, find references, hover types.
- **Framework awareness**: Laravel Eloquent relationships, scopes, casts, and
  PHPStan generics and conditional return types.
- **Project-wide CLI operations.** While the plugin is enabled, `phpantom_lsp`
  is on Claude's PATH, and a bundled skill tells Claude when to use it: whole
  project type-coverage reports (`phpantom_lsp analyze`) and automated fixes
  across many files (`phpantom_lsp fix`), all from static analysis.
- **Refactors that update the whole project.** `phpantom_lsp move` renames a
  class or moves a whole namespace, rewriting declarations, imports, references,
  and PSR-4 file paths in one pass, so Claude no longer has to approximate it
  with a search and replace. Claude previews with `--dry-run` before applying,
  and the command reports what it could not reach on its own, a class named in a
  Blade template or a directory spelled out inside a path string, with the file
  and line to fix by hand.
- **A `php -l` syntax check** run automatically after Claude edits a `.php` file,
  so a syntax error is caught and surfaced immediately (skipped when `php` or
  `jq` is not installed).

## Requirements

- Claude Code v2.1.0 or later (for LSP plugin support).
- [PHPantom](https://github.com/PHPantom-dev/phpantom_lsp) 0.11.0 or later,
  installed so that `phpantom_lsp` is on your `PATH`. The plugin doesn't
  include the language server and doesn't download it for you.

You do **not** need Docker or PHP: the language server is a single static
binary.

## Install

Install the language server with one of:

```
brew install phpantom-lsp             # macOS and Linux
cargo binstall phpantom_lsp           # prebuilt binary, via cargo-binstall
cargo install phpantom_lsp --locked   # build from source
```

or download the archive for your platform from
[GitHub Releases](https://github.com/PHPantom-dev/phpantom_lsp/releases) and put
the `phpantom_lsp` binary in a directory on your `PATH`. Whichever you use, that
directory (for example `~/.cargo/bin`) must be on the `PATH` of the shell you
start Claude Code from.

Then add this marketplace and install the plugin:

```
/plugin marketplace add PHPantom-dev/phpantom_claude
/plugin install phpantom@phpantom
```

Then restart Claude Code. Open a PHP file and the language server starts
automatically.

### Using a binary that isn't on your PATH

If you build PHPantom yourself or keep the binary somewhere else, set
`PHPANTOM_SERVER_PATH` to its absolute path before starting Claude Code. The
launcher then runs that binary instead of looking on your `PATH`.

### Upgrading from an earlier version of this plugin

Earlier versions of this plugin downloaded `phpantom_lsp` for you into
`~/.cache/phpantom-lsp`. That copy is no longer used: install the language
server as described above, and you can delete that directory.

## How it works

Claude Code launches `bin/phpantom_lsp` as the language server and
speaks LSP over its stdin/stdout. The wrapper finds the `phpantom_lsp` you
installed (`$PHPANTOM_SERVER_PATH`, then your `PATH`) and `exec`s it, so the
protocol stream passes straight through. It never downloads anything; if no
binary is found it prints install instructions and exits. The same wrapper is
on the Bash tool's PATH, so Claude can also invoke `phpantom_lsp analyze`,
`phpantom_lsp fix`, and `phpantom_lsp move` for whole-project work. The server
performs static analysis only; it never runs your PHP application.

## Editor extensions

If you also use an editor, PHPantom ships first-party extensions for
[VS Code / Cursor](https://github.com/PHPantom-dev/phpantom_vsix) and Zed that
provide the same analysis.

## Privacy

This plugin runs entirely on your machine and makes no network requests, with
no analytics or telemetry. See [PRIVACY.md](PRIVACY.md).

## License

MIT. See [LICENSE](LICENSE).
