#!/bin/sh
# SessionStart hook: plain stdout from this hook is added to Claude's context.
# Prints the session rules, then the root index of the project memory.
dir=$(dirname "$0")
cat "$dir/session-context.md" 2>/dev/null

index="${CLAUDE_PROJECT_DIR:-.}/.claude/memory/INDEX.md"
if [ -f "$index" ]; then
  printf '\n## Project memory root index (%s, first 200 lines)\n\n' ".claude/memory/INDEX.md"
  head -n 200 "$index" 2>/dev/null
fi
exit 0
