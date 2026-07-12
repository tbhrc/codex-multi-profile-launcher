# Architecture

## Summary

This package is a **Codex multi-profile launcher**. Its job is to let an orchestrator delegate selected work to one of two isolated Codex profiles without turning Codex into a separate operating system.

Your task workspace remains the system of record.

```text
User
  |
  v
task workspace / orchestrator
  |  owns tasks, routing, review, synthesis
  |
  +--> Codex Bridge
         |
         +--> C1 / Codex Business  (~/.codex-business)
         +--> C2 / Codex David     (~/.codex-david)
```

## Boundaries

### Your Task System Owns

- task intake
- visible status
- routing
- review and approval
- review, approval, changelog, and session memory

### This Bridge Owns

- `C1` and `C2` worker identity
- separate `CODEX_HOME` directories
- profile-specific launcher scripts
- controlled `codex exec` wrapper calls
- local execution logs and result files

## Worker Map

| Code | Worker | Use For | Avoid For |
|---|---|---|---|
| `C1` | Codex Business | production implementation, hardening, integration follow-through | early fuzzy exploration |
| `C2` | Codex David | prototypes, bootstrap work, reviews, second-pass critique | production deployment decisions |

## Dispatch Rule

Dispatch Codex only when the task economics make sense:

- self-contained coding task
- mechanical change with a clear checklist
- independent review of a diff or implementation
- work that benefits from separate context

Work inline when the task is tiny, judgment-heavy, or depends on evolving conversation context.

## Authentication Model

Each Codex worker has its own home:

```text
~/.codex-business   # C1
~/.codex-david      # C2
```

Each home may contain its own `auth.json`, config, logs, and history. This repository must never contain those credentials.

The desktop launchers also separate the GUI app data:

```text
~/Library/Application Support/Codex-C1-Business
~/Library/Application Support/Codex-C2-David
```

The normal ChatGPT/Codex app continues to use `~/Library/Application Support/Codex`.

## Normal Execution

1. Create or update the real task in your task workspace.
2. Decide that Codex dispatch is useful.
3. Choose `C1` or `C2`.
4. Invoke `wrappers/delegate_to_codex.sh`.
5. The wrapper writes execution evidence under `runtime/outputs/`.
6. Read the result and update the task record.

## Design Principle

The bridge should stay boring. If a feature duplicates your task system, remove it from this package or leave it in your task system only.
