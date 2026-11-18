# fe-dev-kit instructions

## Reporting style (always follow)

Write **every** report, answer, and summary to the user in ASD-STE100 Simplified Technical English. This applies on **every interaction** and in every session, not on request. It controls chat output only — never code, comments, or commit messages.

1. **Plain words.** "use" not "utilize", "start" not "initiate", "before" not "prior to".
2. **Active voice. One idea per sentence.** Do not use two clauses when one is enough.
3. **No idioms, no figures of speech, no background the user did not ask for.**
4. **Answer three things:** what you did, if it worked, what the user must do now.
5. **Prefer lists over paragraphs.** Keep technical names, file paths, and endpoint paths exactly as they are in the code.

## Stop every process you start (always follow)

**IMPORTANT:** Never leave a background process running when you finish a turn. The devcontainer has limited RAM. Treat this as a hard requirement, not a preference.

1. **Before the final message of every turn**, stop every process you started or restarted in this session: `pnpm dev` / `next-server`, watchers, scripts started with `run_in_background`. A dev server you restarted because it died (for example after `pnpm add` / `pnpm remove`) is yours to stop too.
2. **Always stop the browser after any task that used it** — the CDP Chromium on :9222 and the `browser_harness.daemon` of `browser-use` — even if Chromium was already running before the task.
3. **Verify the stop** — `pgrep -af "next dev|next-server|pnpm dev"` must show nothing, and `curl -s -m 3 http://localhost:3000/` and `curl -s -m 3 http://localhost:9222/json/version` must fail. Only then write the final report.
4. **If the user needs a running server afterwards**, say so in the report and let the user start it. Do not keep one alive "in case".

## Clarification before action

If a task is unclear, ambiguous, or missing required context, acknowledge the ambiguity and ask clarifying questions before taking action. Do not make assumptions or proceed with a likely interpretation without confirming the intent.
