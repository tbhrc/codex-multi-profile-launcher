# Controller / Orchestrator Bridge Note

This file is retained at its historical path for compatibility. It no longer defines a Larry-specific Claude Code control plane.

TBHRC orchestration now starts from the Workspace master router and selected canonical Skills:

```text
founder/user request
-> tbhrc/workspace/AGENTS.md
-> owning GitHub repository + optional Issue/PR when useful
-> selected canonical Skill in tbhrc/workspace/.folderdesk/skills when specialist HOW is required
-> authorised controller chooses executor
-> tbhrc/ai-engine when trusted Mac-local execution is required
-> explicit C1 or C2 through this bridge
-> verified evidence returned to the owning work record
```

The controller owns:

- user/founder intent;
- repository/work routing;
- provider/seat choice based on task fit, permissions, availability and budget;
- deciding whether local Codex dispatch is worth the boundary/cold-start cost;
- explicit `C1` or `C2` selection;
- verification of the result;
- applying authorised durable changes through the owning repository workflow;
- final synthesis and handoff.

This bridge owns only Codex profile isolation and bounded local execution.

Do not duplicate the Skill Bank, GitHub work state, provider routing policy, or durable tracker here. `tbhrc/skills` is retired provenance/compatibility only.

Canonical references:

- https://github.com/tbhrc/workspace/blob/main/AGENTS.md
- https://github.com/tbhrc/workspace/tree/main/.folderdesk/skills/human-ai-operations-map
- https://github.com/tbhrc/workspace/tree/main/.folderdesk/skills/github-agent-workflow
- https://github.com/tbhrc/workspace/tree/main/.folderdesk/skills/github-multi-agent-orchestrator
- https://github.com/tbhrc/workspace/tree/main/.folderdesk/skills/gh-mac-runner-operator-maintenance
- https://github.com/tbhrc/ai-engine
