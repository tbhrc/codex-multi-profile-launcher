# Operating Model

## Principle

**This repository selects and runs an explicit Codex profile. It does not own task routing, approval, business truth or production authority.**

```text
authorised controller
→ choose C1 or C2 when useful
→ launcher runs exact profile
→ return result or exact unavailable state
→ controller continues/reroutes
```

Issues/PRs may preserve continuity but are not prerequisites for execution.

## Profiles

| Worker | Identity | Codex home |
|---|---|---|
| `C1` | Codex Business | `~/.codex-business` |
| `C2` | Codex David | `~/.codex-david` |

The normal `~/.codex` profile is separate and is not C2.

Never silently swap C1/C2 identities. If the selected seat is unavailable or out of credits, return that state immediately. The controller may use another already-authorised provider/seat. **One unavailable seat is not a global stop.**

## Dispatch fit

Use Codex when it adds leverage: bounded coding, mechanical work, separate-context implementation or review. Work inline when that is simpler.

Do not require a work-order Issue, extra preflight or AI Engine hop merely because they exist. Use any already-authorised route that can reach the selected profile.

## Local executor

`wrappers/delegate_to_codex.sh` maps the requested worker to the exact `CODEX_HOME`, validates the supplied workdir/task input, runs the tested launcher configuration and returns evidence.

The workspace/profile isolation protects real file/identity boundaries. Do not add another sandbox, approval layer, credential bridge or proof ritual without a concrete demonstrated threat.

## Consequential actions

A Codex worker may perform local work in its assigned workspace. Deployment, sends, destructive external mutation, credential changes, spend, private-data disclosure and other genuinely consequential actions require the authority appropriate to that action.

Never read, print, move or copy `auth.json` or credential contents.

## PR review

Selectors remain exact:

```text
@codex-business review -> C1
@codex-david review    -> C2
```

PR code/content is untrusted review input and must not be executed merely for review. That is a real execution boundary.

If the selected reviewer seat is unavailable, return the state and let the controller reroute; do not silently swap identity or repeatedly retry known exhausted capacity.

## Evidence

Keep only evidence useful for verification or continuity. Do not require a GitHub Issue/PR to receive every local result.

**Preserve identity. Protect secrets. Keep work moving.**
