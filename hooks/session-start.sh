#!/bin/sh
# SessionStart hook: plain stdout from this hook is added to Claude's context.
set -eu
cat "$(dirname "$0")/session-context.md"
