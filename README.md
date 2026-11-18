# fe-dev-kit

A Claude Code plugin for front-end work in TypeScript and Next.js.

It gives Claude:

- **Skills** for clean TypeScript code, Next.js App Router work, and a persistent project memory.
- **Session rules** that load at the start of every session through a `SessionStart` hook.

## Install

Add this repository as a marketplace, then install the plugin:

```text
/plugin marketplace add https://github.com/FDiskas/claude-plugin
/plugin install fe-dev-kit@fe-dev-kit
```

To try a local checkout without installing it:

```sh
claude --plugin-dir /path/to/claude-plugin
```

Restart Claude Code (or run `/reload-plugins`) after you install or change the plugin.

## What is included

### Skills

Plugin skills are namespaced. Call them as `/fe-dev-kit:<skill>`, or let Claude pick them from their descriptions.

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

The upstream source and commit of each skill is in [skills-lock.json](skills-lock.json).

### Session rules (`SessionStart` hook)

A plugin cannot ship a `CLAUDE.md`. This plugin uses a `SessionStart` hook instead. The hook prints [hooks/session-context.md](hooks/session-context.md), and Claude Code adds that text to the context. It runs on `startup`, `resume`, `clear`, and `compact`, so the rules stay in context after a compaction.

The rules tell Claude to:

1. Write reports to the user in ASD-STE100 Simplified Technical English.
2. Stop every process it started (dev servers, watchers, the CDP browser) before it ends a turn, and verify the stop.
3. Ask clarifying questions when a task is unclear.

To change the rules, edit [hooks/session-context.md](hooks/session-context.md).

## Layout

```text
.claude-plugin/
  plugin.json          Plugin manifest
  icon.png             Plugin icon (1024 x 1024 PNG)
  marketplace.json     Single-plugin marketplace for this repo
hooks/
  hooks.json           SessionStart hook registration
  session-start.sh     Prints session-context.md
  session-context.md   The session rules
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
