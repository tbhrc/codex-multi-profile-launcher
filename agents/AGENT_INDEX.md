# Agent and Worker Index

This is the canonical quick-reference map for the agents in this bridge.

## Ownership

The external task workspace or orchestrator owns task intake, routing, tracker updates, review, approval, and synthesis. This repository owns only isolated Codex runtime profiles, dispatch wrappers, local evidence, and profile maintenance.

## Agent map

| Code | Agent file | Role | Codex home | Desktop data | Best for |
|---|---|---|---|---|---|
| Larry | [`agents/claude-orchestrator/AGENT.md`](claude-orchestrator/AGENT.md) | Task orchestrator | External task workspace | External task workspace | Intake, routing, review, synthesis |
| C1 | [`agents/codex-business/AGENT.md`](codex-business/AGENT.md) | Production worker | `~/.codex-business` | `~/Library/Application Support/Codex-C1-Business` | Implementation, integration, hardening, tests |
| C2 | [`agents/codex-david/AGENT.md`](codex-david/AGENT.md) | Prototype/review worker | `~/.codex-david` | `~/Library/Application Support/Codex-C2-David` | Prototypes, bootstrap, independent review, critique |

## Routing map

Use C1 when the task has a clear production objective and needs implementation, integration, hardening, cleanup, or test fixes.

Use C2 when the task is exploratory, prototype-oriented, a bootstrap experiment, or an independent review of C1 work.

Keep the work inline when it is tiny, highly conversational, or depends on rapidly changing context. Dispatch only when a separate Codex context provides enough value to justify the startup cost.

## Shared boundaries

- Do not read, print, copy, or modify `auth.json`.
- Do not alter the other worker’s Codex home.
- Do not deploy, publish, delete, or write to external systems without approval.
- Keep the task workspace as the source of truth.
- Return execution evidence: status, files changed, tests run, failures, risks, and next action.

## Source files

- Worker definitions: [`config/workers.yaml`](../config/workers.yaml)
- Routing rules: [`config/routing_rules.yaml`](../config/routing_rules.yaml)
- Architecture: [`docs/00_MASTER_ARCHITECTURE.md`](../docs/00_MASTER_ARCHITECTURE.md)
- Fresh-session handoff: [`docs/05_FRESH_SESSION_HANDOFF.md`](../docs/05_FRESH_SESSION_HANDOFF.md)
- Maintenance SOP: [`docs/06_MAINTENANCE_SOP.md`](../docs/06_MAINTENANCE_SOP.md)
- Dispatch wrapper: [`wrappers/delegate_to_codex.sh`](../wrappers/delegate_to_codex.sh)
