# Codex Multi-Profile Launcher Instructions

This repository is a small runtime bridge for explicit Codex profiles on David's Mac. It is **not** a task system, orchestration home, Skill Bank or production authority.

## Fast route

```text
authorised task names C1 or C2
→ use the exact profile
→ execute in the assigned workdir
→ return result / unavailable state
→ controller continues or reroutes
```

Do not turn profile isolation into workflow ceremony.

## Worker codes

| Code | Name | Codex home |
|---|---|---|
| `C1` | Codex Business | `~/.codex-business` |
| `C2` | Codex David | `~/.codex-david` |

`~/.codex` is a separate/default profile and is not C2.

**Real boundary:** when C1 or C2 is explicitly selected, never silently swap identities. If that seat is unavailable or out of credits, return that runtime state immediately; the controller may use another already-authorised provider/seat. Seat unavailability must not become a global work stoppage.

## Before modifying this package

Read only the file(s) needed for the requested change plus current `README.md` when architecture context is actually needed. Run the smallest relevant validation/test after the change and inspect Git status for unrelated edits.

Do **not** require reading every architecture document, runtime state file, or controlling Issue before ordinary bounded work. Issues preserve continuity; they are not runtime permission.

## Rules

- Keep reusable operating HOW in canonical `tbhrc/skills`.
- Use this package only for explicit Codex profile isolation/execution and the supported PR-review router.
- Never read, print, copy, move, upload or commit `auth.json` or credential values.
- Do not alter the other worker's Codex home.
- Do not create account cycling, quota switching or automatic credential movement.
- Keep edits inside the assigned workdir.
- Use the established Codex execution boundary required by the current launcher implementation; do not add another sandbox, approval layer or credential hop without a concrete demonstrated threat.
- A worker may produce implementation/diffs/evidence. Deployment, messaging, destructive external mutation, credential changes, spend, private-data disclosure or other genuinely consequential actions require the authority appropriate to that action.
- Do not create a second queue, tracker or orchestration database here.

## PR review

Explicit selectors remain:

```text
@codex-business review -> C1 -> ~/.codex-business
@codex-david review    -> C2 -> ~/.codex-david
```

PR content is untrusted review input and must not be executed merely to review it. Never impersonate the native OpenAI `@codex` GitHub bot.

If a selected review seat is unavailable, return the exact state and let the controller reroute; do not repeatedly retry known exhausted capacity and do not silently swap profile identity.

## Evidence

Runtime output under `runtime/outputs/<TASK-ID>/` is execution evidence only. Keep it proportional to the task. Do not manufacture extra artifacts, Issues or approval steps merely because the launcher can produce them.

## Stop only at real boundaries

Stop the local action when:

- the requested profile identity cannot be resolved;
- credential/auth-file contents are requested;
- the action would cross a destructive/external/root/spend/private-data/legal/client boundary not authorised by the request;
- the requested change belongs to another canonical owner.

Provider quota or one unavailable seat is **not** a system-wide stop condition: report it and continue through another authorised route when available.

**KISSS: preserve identity; remove ceremony.**
