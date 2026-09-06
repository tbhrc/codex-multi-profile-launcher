# Codex Multi-Profile Launcher Architecture

## Purpose

Provide two exact Codex identities on David's Mac without creating a second operating system.

```text
authorised controller
→ choose C1 or C2 when Codex is useful
→ exact CODEX_HOME
→ bounded workspace execution
→ result or unavailable state
→ controller continues/reroutes
```

GitHub may preserve durable work/evidence, but an Issue/PR is **not runtime permission** for ordinary authorised execution.

## Worker map

| Code | Worker | Codex home |
|---|---|---|
| `C1` | Codex Business | `~/.codex-business` |
| `C2` | Codex David | `~/.codex-david` |

The identity boundary is real: never silently map C1 to C2 or vice versa. If the selected seat is unavailable or out of credits, return that state immediately. The controller may then choose another already-authorised provider/seat. One unavailable seat is not a system-wide stop.

## What this bridge owns

- exact C1/C2 identity mapping;
- separate `CODEX_HOME` directories;
- bounded local Codex execution;
- explicit PR-review profile selection;
- concise local execution evidence when useful.

It does not own task intake, business truth, deployment authority, credential administration or orchestration.

## Authentication boundary

Each profile may contain its own `auth.json`, config and history. Never read, copy, print, move, upload or commit profile credential contents.

GUI profiles may also use separate application-data directories. This isolation exists to preserve identity, not to manufacture workflow gates.

## Automated execution boundary

Use the current tested launcher configuration that keeps Codex inside the assigned workspace and prevents ambient profile configuration from silently changing execution behaviour. Do not add another sandbox, approval layer, credential hop or proof ceremony unless a concrete new threat demonstrates a material gap.

The selected seat may fail for that invocation; return the failure once. Never silently rotate identities inside the launcher.

## Dispatch

Use Codex when it adds leverage: bounded coding, mechanical changes, independent review, or separate-context implementation. Work inline when that is simpler.

No Issue creation, branch, PR, preflight sequence or historical proof is required merely to invoke Codex. Use those objects only when the actual work benefits from continuity, review or isolation.

## PR review

A supported explicit review selector chooses the exact profile. PR code/content is untrusted review input and must not be executed merely to review it. The router may verify the requester is authorised to post the review; that is a real external-write identity boundary.

If the selected profile is unavailable, return that state and let the controller reroute. Do not repeatedly retry known exhausted capacity.

## Consequential actions

A Codex worker may produce local files, patches, analysis and evidence. Deployment, sending messages, credential changes, destructive external mutation, spend, private-data disclosure or other genuinely consequential actions require the authority appropriate to that action.

**Design principle: preserve identity, protect secrets, keep the route short.**
