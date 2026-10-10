#!/usr/bin/env bash
#
# PostToolUse hook: run `php -l` on a PHP file Claude just wrote or edited.
#
# Reads the hook's JSON payload on stdin. A syntax error is printed to stderr
# with exit code 2, which feeds it back to Claude. Blade templates and non-PHP
# files are skipped, and so is everything when `jq` or `php` is not installed.

input="$(cat)"
command -v jq >/dev/null 2>&1 || exit 0
file="$(printf '%s' "${input}" | jq -r '.tool_input.file_path // empty')"
[ -z "${file}" ] && exit 0

case "${file}" in
  *.blade.php) exit 0 ;;
  *.php) ;;
  *) exit 0 ;;
esac

command -v php >/dev/null 2>&1 || exit 0
out="$(php -l "${file}" 2>&1)" || { printf '%s\n' "${out}" >&2; exit 2; }
exit 0
