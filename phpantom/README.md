# phpantom (Claude Code plugin)

PHP code intelligence for Claude Code powered by the
[PHPantom](https://github.com/PHPantom-dev/phpantom_lsp) language server.

Requires `phpantom_lsp` 0.11.0 or later on your `PATH`, for example from
`brew install phpantom-lsp` or `cargo binstall phpantom_lsp`. The plugin
doesn't download it for you.

- `.lsp.json` wires the PHPantom language server into Claude Code over stdio.
- `bin/phpantom_lsp` resolves the `phpantom_lsp` binary you installed
  (`$PHPANTOM_SERVER_PATH` → `PATH`) and `exec`s it. Because it sits in
  `bin/`, it is also on the Bash tool's PATH, so Claude can run
  `phpantom_lsp analyze` / `phpantom_lsp fix` / `phpantom_lsp move` for
  project-wide operations.
- `skills/php-analysis` tells Claude when and how to use the project-wide CLI
  (type-coverage reports, automated fixes, and class and namespace moves that
  update every reference across the codebase).
- `hooks/hooks.json` runs `php -l` after Claude edits a `.php` file (a graceful
  no-op when `php` or `jq` is missing).

See the [repository README](../README.md) for install instructions and
configuration options.
