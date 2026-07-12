# Source Notes

The old ChatGPT-Web draft treated this folder like a separate control plane. That strategy has been retired.

Current source of truth:

- your task workspace root: `/path/to/your/task-workspace`
- Claude Code pointer: `/path/to/your/task-workspace/CLAUDE.md`
- your task system root contract: `/path/to/your/task-workspace/AGENTS.md`
- Agent roster: `/path/to/your/task-workspace/Team/agent-index.md`
- Dispatch economics: `/path/to/your/task-workspace/Team Knowledge/SOPs/SOP-011-dispatch-a-specialist-subagent.md`

This bridge keeps only the Codex profile-isolation idea:

- `C1 / Codex Business` uses `~/.codex-business`
- `C2 / Codex David` uses `~/.codex-david`
