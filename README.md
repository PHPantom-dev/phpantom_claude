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
- **A `php -l` syntax check** run automatically after Claude edits a `.php` file,
  so a syntax error is caught and surfaced immediately (skipped when `php` or
  `jq` is not installed).

## Requirements

- Claude Code v2.1.0 or later (for LSP plugin support).
- `curl` or `wget` on your PATH, only if you want the plugin to download the
  language server for you. If `phpantom_lsp` is already installed you need
  neither.

You do **not** need Docker, PHP, or a Rust toolchain. The language server is a
single static binary that the plugin downloads for your platform on first use.

## Install

Add this marketplace and install the plugin:

```
/plugin marketplace add PHPantom-dev/phpantom_claude
/plugin install phpantom@phpantom
```

Then restart Claude Code. Open a PHP file and the language server starts
automatically; on first run it downloads the correct `phpantom_lsp` binary for
your platform (macOS, Linux, or Windows; x86-64 or ARM64) from GitHub Releases
and caches it under `~/.cache/phpantom-lsp`.

### Using your own binary

The launcher resolves a `phpantom_lsp` binary in this order:

1. `$PHPANTOM_SERVER_PATH` if it points at an executable.
2. `phpantom_lsp` on your `PATH`.
3. A previously downloaded, cached binary.
4. A fresh download from GitHub Releases.

So if you already build or install PHPantom yourself, put it on your `PATH` (or
set `PHPANTOM_SERVER_PATH`) and nothing is downloaded.

## Configuration

The launcher reads these environment variables:

| Variable               | Purpose                                                                 |
| :--------------------- | :---------------------------------------------------------------------- |
| `PHPANTOM_SERVER_PATH` | Absolute path to a `phpantom_lsp` binary to use as-is.                  |
| `PHPANTOM_RELEASE_TAG` | Pin a release tag to download (e.g. `0.9.0`). Defaults to the latest.   |
| `PHPANTOM_CACHE_DIR`   | Where downloads are cached. Default: `${XDG_CACHE_HOME:-~/.cache}/phpantom-lsp`. |
| `PHPANTOM_NO_DOWNLOAD` | Set to `1` to disable auto-download (the launcher then requires a binary on PATH or via `PHPANTOM_SERVER_PATH`). |

## How it works

Claude Code launches `phpantom/bin/phpantom-lsp-launcher.sh` as the language
server and speaks LSP over its stdin/stdout. The launcher locates or downloads
`phpantom_lsp`, then `exec`s it so the protocol stream passes straight through.
The server performs static analysis only; it never runs your PHP application.

## Editor extensions

If you also use an editor, PHPantom ships first-party extensions for
[VS Code / Cursor](https://github.com/PHPantom-dev/phpantom_vsix) and Zed that
provide the same analysis.

## License

MIT. See [LICENSE](LICENSE).
