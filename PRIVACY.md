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

## The one network request

The only network access this plugin performs is downloading the
`phpantom_lsp` binary for your platform from
[GitHub Releases](https://github.com/PHPantom-dev/phpantom_lsp/releases),
the first time it runs and whenever a newer release is needed. This is an
ordinary file download (equivalent to `curl`/`wget` fetching a file, or
`git clone`), subject to [GitHub's own privacy
statement](https://docs.github.com/en/site-policy/privacy-policies/github-privacy-statement)
for the request itself (e.g. your IP address, as with any HTTP request).
The plugin does not add tracking identifiers, analytics parameters, or any
other identifying information to this request, and downloads no other data.

Once downloaded, the binary is cached locally
(`~/.cache/phpantom-lsp` by default) and this download does not repeat
unless a new release is available.

If you set `PHPANTOM_SERVER_PATH` to a binary you already have, or put
`phpantom_lsp` on your `PATH`, this plugin makes no network requests at
all.

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
