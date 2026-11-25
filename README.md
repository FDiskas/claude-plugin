# coders

A Claude Code plugin for front-end work in TypeScript and Next.js.

It gives Claude:

- **Skills** for clean TypeScript code, Next.js App Router work, a persistent project memory, and design grilling with domain modeling.
- **Session rules** that load at the start of every session through a `SessionStart` hook.
- **Skill hooks** that tell Claude to load the right skills before each task and before each TypeScript edit.

## Install

Add this repository as a marketplace, then install the plugin:

```text
/plugin marketplace add https://github.com/FDiskas/claude-plugin
/plugin install coders@coders
```

To try a local checkout without installing it:

```sh
claude --plugin-dir /path/to/claude-plugin
```

Restart Claude Code (or run `/reload-plugins`) after you install or change the plugin.

## What is included

### Skills

Plugin skills are namespaced. Call them as `/coders:<skill>`, or let Claude pick them from their descriptions.

| Skill | Use it for |
| --- | --- |
| `typescript-clean-code` | The full Clean Code catalog for TypeScript. |
| `boy-scout` | Leave touched code cleaner. Calls the other clean-code skills. |
| `clean-names` | Names of variables, functions, types, and modules. |
| `clean-functions` | Function size, arguments, and single responsibility. |
| `clean-comments` | Comments and TSDoc. |
| `clean-general` | DRY, magic numbers, clear intent, abstractions. |
| `clean-tests` | Test speed, boundaries, and one concept per test. |
| `nextjs-developer` | Next.js 14+ App Router, Server Components, Server Actions, deployment. |
| `auto-memory` | Save and recall project facts under `.claude/memory/` in your project. |
| `grilling` | Interview you in rounds of questions to stress-test a plan or decision. |
| `domain-modeling` | Sharpen domain terms and keep `GLOSSARY.md` and ADRs in `docs/adr/` up to date. |
| `grill-with-docs` | Run `grilling` and `domain-modeling` together. Call it manually only. |

The upstream source and commit of each skill is in [skills-lock.json](skills-lock.json).

### Session rules (`SessionStart` hook)

A plugin cannot ship a `CLAUDE.md`. This plugin uses a `SessionStart` hook instead. The hook prints [hooks/session-context.md](hooks/session-context.md), and Claude Code adds that text to the context. It runs on `startup`, `resume`, `clear`, and `compact`, so the rules stay in context after a compaction.

If the project has `.claude/memory/INDEX.md`, the hook also prints the first 200 lines of that file after the rules. The path is relative to `$CLAUDE_PROJECT_DIR`.

The rules tell Claude to:

1. Load the plugin skills every time their scope applies:

   | Situation | Skills |
   | --- | --- |
   | Start of every task, in every project | `coders:auto-memory` (recall) |
   | End of every turn that produced durable facts | `coders:auto-memory` (save) |
   | Before the first edit of a `.ts` or `.tsx` file (text and i18n changes included) | `coders:boy-scout`, `coders:typescript-clean-code` |
   | Before the first edit of a test file (`*.test.*`, `*.spec.*`) | `coders:clean-tests` |
   | Work on a Next.js app | `coders:nextjs-developer` |

2. Write reports to the user in ASD-STE100 Simplified Technical English.
3. Stop every process it started (dev servers, watchers, the CDP browser) before it ends a turn, and verify the stop.
4. Ask clarifying questions when a task is unclear.

To change the rules, edit [hooks/session-context.md](hooks/session-context.md).

### Skill hooks

A hook cannot call a skill. It can only add text to the context. Two more hooks repeat the skill rules where they matter:

- **`UserPromptSubmit`** ([hooks/prompt-reminder.sh](hooks/prompt-reminder.sh)) adds two lines to every prompt: call `coders:auto-memory` first, and load the TypeScript skills before a code edit. `SessionStart` text weakens in long sessions.
- **`PreToolUse`** on `Edit|Write|MultiEdit` ([hooks/pre-edit.sh](hooks/pre-edit.sh)) adds a note through `hookSpecificOutput.additionalContext` when the target file is `.ts` or `.tsx`. The note names `coders:boy-scout` and `coders:typescript-clean-code`, and also `coders:clean-tests` for test files. The hook never blocks the edit.

## Layout

```text
.claude-plugin/
  plugin.json          Plugin manifest
  icon.png             Plugin icon (1024 x 1024 PNG)
  marketplace.json     Single-plugin marketplace for this repo
hooks/
  hooks.json           Hook registration (SessionStart, UserPromptSubmit, PreToolUse)
  session-start.sh     Prints session-context.md and the root memory index
  session-context.md   The session rules
  prompt-reminder.sh   Prints the skill reminder on each prompt
  pre-edit.sh          Adds the skill note before .ts and .tsx edits
skills/<name>/SKILL.md Skills
skills-lock.json       Upstream sources of the skills
```

## Development

Validate the plugin and the marketplace:

```sh
claude plugin validate .
```

Load the working copy in a session:

```sh
claude --plugin-dir .
```

Bump `version` in [.claude-plugin/plugin.json](.claude-plugin/plugin.json) when you release a change. Installed copies update only when the version changes.
