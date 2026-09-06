# TBHRC GitHub + AI Engine Integration

## Purpose

The Codex C1/C2 launcher is a **runtime adapter**. It isolates exact local Codex identities; it is not a task system, approval system or mandatory AI Engine hop.

## Ownership

```text
tbhrc/skills = reusable HOW / routing guidance
owning domain system = work truth
controller = chooses provider/seat/route
tbhrc/ai-engine = privileged runtime capability when actually needed
codex-multi-profile-launcher = exact C1/C2 local execution
```

Issues/PRs may preserve durable work/evidence but are not prerequisites for local execution.

## Identities

| Alias | Identity | CODEX_HOME |
|---|---|---|
| `C1` | Codex Business | `~/.codex-business` |
| `C2` | Codex David | `~/.codex-david` |

`~/.codex` is separate and is not C2.

The launcher never silently swaps identities.

## Normal route

```text
authorised task
→ controller chooses C1/C2 when Codex is useful
→ use the simplest existing authorised route that can reach the selected profile
→ execute inside assigned workspace
→ return result or exact unavailable state
→ controller continues/reroutes
```

AI Engine is used only when its trusted Mac/runtime capability is genuinely needed. Do not force every Codex task through AI Engine merely because the integration exists.

If one seat/provider/route is unavailable, report that state once and let the controller use another already-authorised provider/route. **Do not turn seat failure into a global fail-closed system.**

## Real boundaries

- preserve exact C1/C2 identity;
- never read/copy/print/move `auth.json` or credentials;
- keep local implementation inside the assigned workspace;
- PR review treats PR code as untrusted data and does not execute it merely for review;
- deployment, sends, destructive external mutation, credential changes, spend, private-data disclosure and other genuinely consequential actions require appropriate authority.

The tested workspace/profile isolation protects real file/identity boundaries. Do not add another sandbox, approval gate, work-order prerequisite, credential hop or proof programme unless a concrete new threat demonstrates a material gap.

## PR review

```text
@codex-business review -> C1
@codex-david review    -> C2
```

The router may verify the requester has authority to post the external review. It must not execute PR code or silently change profile identity.

## Evidence

Return only the evidence useful to verify the requested outcome. A GitHub Issue/PR may receive that evidence when it genuinely owns the durable work; do not require one for every run.

**Preserve identity. Use existing authorised capability. Keep work moving.**
