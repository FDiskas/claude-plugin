#!/bin/sh
# UserPromptSubmit hook: plain stdout from this hook is added to Claude's context.
# Repeats the skill rules, because SessionStart text weakens in long sessions.
cat >/dev/null 2>&1
echo "coders plugin rule: the first tool call of a task is the Skill tool with coders:auto-memory (recall)."
echo "coders plugin rule: before the first edit of a .ts or .tsx file, load coders:boy-scout and coders:typescript-clean-code (and coders:clean-tests for test files)."
exit 0
