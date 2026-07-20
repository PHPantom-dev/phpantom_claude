# phpantom (Claude Code plugin)

PHP code intelligence for Claude Code powered by the
[PHPantom](https://github.com/PHPantom-dev/phpantom_lsp) language server.

- `.lsp.json` wires the PHPantom language server into Claude Code over stdio.
- `bin/phpantom_lsp` resolves a `phpantom_lsp` binary
  (`$PHPANTOM_SERVER_PATH` → `PATH` → cached download → GitHub Releases) and
  `exec`s it. No Docker, PHP, or Rust toolchain required. Because it sits in
  `bin/`, it is also on the Bash tool's PATH, so Claude can run
  `phpantom_lsp analyze` / `phpantom_lsp fix` for project-wide operations.
- `skills/php-analysis` tells Claude when and how to use the project-wide CLI
  (type-coverage reports and automated fixes across the whole codebase).
- `hooks/hooks.json` runs `php -l` after Claude edits a `.php` file (a graceful
  no-op when `php` or `jq` is missing).

See the [repository README](../README.md) for install instructions and
configuration options.
