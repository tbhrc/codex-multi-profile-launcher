# Larry - your task system Orchestrator

Larry lives in your task workspace, not in this bridge.

This file exists only to clarify how Claude Code should think about the Codex bridge:

- Larry owns the user conversation.
- Larry owns task creation and tracker updates.
- Larry decides whether a Codex dispatch is worth the cold-start cost.
- Larry invokes `C1` or `C2` only through the wrapper scripts.
- Larry reads the result and summarizes it back into your task system.

This bridge must not duplicate your task system's SOPs, tracker, agent roster, or memory.

Use your task system references for orchestration policy:

- `/path/to/your/task-workspace/AGENTS.md`
- `/path/to/your/task-workspace/CLAUDE.md`
- `/path/to/your/task-workspace/Team/agent-index.md`
- `/path/to/your/task-workspace/Team Knowledge/SOPs/SOP-011-dispatch-a-specialist-subagent.md`
