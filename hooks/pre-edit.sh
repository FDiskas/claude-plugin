#!/bin/sh
# PreToolUse hook for Edit|Write|MultiEdit.
# Adds a context note that names the coders skills for TypeScript and test files.
# Plain stdout does not reach Claude for PreToolUse, so the note is sent as
# hookSpecificOutput.additionalContext. The hook never blocks the edit.
input=$(cat 2>/dev/null) || input=""

file_path=$(printf '%s' "$input" | tr '\n' ' ' \
  | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1)

case "$file_path" in
  *.ts|*.tsx) ;;
  *) exit 0 ;;
esac

skills='coders:boy-scout and coders:typescript-clean-code'
case "${file_path##*/}" in
  *.test.*|*.spec.*) skills='coders:boy-scout, coders:typescript-clean-code, and coders:clean-tests' ;;
esac

message="coders plugin rule: this edit changes a TypeScript file. The skills $skills must be loaded with the Skill tool before this edit, if they were not loaded earlier in this session. This includes text and i18n changes."

printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":"%s"}}\n' "$message"
exit 0
