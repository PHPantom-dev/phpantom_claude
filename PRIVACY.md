# Privacy Policy

This plugin does not collect, store, or transmit any of your code, prompts,
or personal data. It contains no analytics and no telemetry, and the project
has no way to know who has installed it or how it is used.

## What the plugin does

- **Language server.** `phpantom_lsp` runs entirely on your machine. It
  reads the PHP files in your project to answer completion, diagnostic,
  hover, definition, and reference requests, and never sends that code, or
  anything derived from it, anywhere.
- **`php -l` hook.** Runs the `php` binary already on your machine against
  the file Claude just edited. Nothing leaves your machine.
- **`phpantom_lsp analyze` / `phpantom_lsp fix`.** Same as the language
  server: local, static analysis of files on disk.

## Network access

The plugin makes no network requests. It doesn't download or install
`phpantom_lsp`; it runs the copy you installed yourself, from Homebrew,
crates.io, or
[GitHub Releases](https://github.com/PHPantom-dev/phpantom_lsp/releases).
That download happens outside the plugin, under the privacy terms of
whichever source you installed from.

## Third parties

This plugin is a thin integration layer between Claude Code and the
PHPantom language server; it is not affiliated with Anthropic. Your use of
Claude Code itself is governed by
[Anthropic's privacy policy](https://www.anthropic.com/legal/privacy). This
document only covers what this plugin does on top of that.

## Contact

Questions or concerns can be raised via
[GitHub Issues](https://github.com/PHPantom-dev/phpantom_claude/issues) on
this repository.
