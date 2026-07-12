# Codex Multi-Profile Launcher Instructions

This repository is a small bridge for running two isolated Codex profiles from your preferred task workspace.

Your task workspace remains the orchestration home:

```text
/path/to/your/task-workspace
```

Your orchestrator owns task intake, routing, tracker updates, review, and synthesis. This folder only provides the Codex runtime boundary.

## Repository Structure

Use this map before searching broadly:

```text
AGENTS.md                         # root operating rules and stop conditions
README.md                         # public setup, security, and user-facing overview
agents/                           # worker instructions and canonical agent index
  AGENT_INDEX.md                  # roster, roles, routing, and profile paths
  claude-orchestrator/AGENT.md    # Larry/task-orchestrator boundary
  codex-business/AGENT.md         # C1 production worker
  codex-david/AGENT.md       # C2 David original-profile worker
config/                           # worker registry, routing, and safe baseline config
docs/                             # architecture, guide, roadmap, handoff, and SOPs
prompts/                          # reusable worker and review prompts
scripts/                          # bootstrap, launchers, and profile sync
wrappers/                         # controlled task delegation entrypoint
tools/                            # validation and repository tooling
tests/                            # automated tests
runtime/                          # local evidence and runtime state; not source of truth
schemas/                          # output contracts
references/                       # source notes and boundary references
```

For worker identity or routing, read `agents/AGENT_INDEX.md` and the relevant worker file. For setup or continuity, read `docs/01_USER_GUIDE.md`, `docs/04_BACKUP_TRANSFER_MERGE.md`, and `docs/06_MAINTENANCE_SOP.md`. For architecture or ownership, read `docs/00_MASTER_ARCHITECTURE.md`.

## Worker Codes

| Code | Name | Role | Codex home |
|---|---|---|---|
| `C1` | tbhrc Login | Production implementation, hardening, integration work | `~/.codex-business` |
| `C2` | David Login | Prototypes, bootstrap work, independent review | `~/.codex` |

These codes are examples. Rename them if they conflict with your own agent roster.

## Startup Check

Before changing files in this package:

1. Read `README.md`.
2. Read `docs/00_MASTER_ARCHITECTURE.md`.
3. Read the relevant worker file under `agents/`.
4. Read `runtime/active_worker.json`.
5. Run `python3 tools/aosctl.py validate`.
6. Inspect Git status and avoid unrelated changes.

## Rules

- Keep tasks in your task system.
- Use this package only for Codex profile isolation and wrapper execution.
- Do not read, print, copy, or commit any `auth.json`.
- Do not alter the other worker's Codex home.
- Do not create account cycling, quota switching, or automatic credential movement.
- Keep edits small, local, and reversible.
- Do not deploy, publish, delete, or write to external systems without human approval.

## Output Contract

Wrapper runs write local execution evidence under:

```text
runtime/outputs/<TASK-ID>/
  status.json
  summary.md
  run.log
  events.jsonl
  artifacts/
  error.md      # only on failure
```

The task remains the human source of truth. These files are execution evidence.

## Stop Conditions

Stop and report when:

- the expected worker identity is missing or wrong
- a task asks for credentials or `auth.json`
- a destructive or external action is needed
- tests fail for unrelated reasons
- the requested change belongs in your task system instead of this bridge
