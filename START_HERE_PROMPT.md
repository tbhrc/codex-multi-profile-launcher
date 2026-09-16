# Start Here

This package is the local Codex C1/C2 execution bridge: C1 is isolated; C2 is the normal/default Codex profile.

## 1. Bootstrap C1; preserve default C2

```bash
cd codex-multi-profile-launcher
bash scripts/bootstrap.sh
```

## 2. Authenticate the profiles you need

```bash
bash scripts/auth-codex-business.sh   # C1 -> ~/.codex-business
bash scripts/auth-codex-c2.sh         # C2 -> default ~/.codex
```

Never copy authentication between profiles and never read/print `auth.json`.

## 3. Keep real work in GitHub

Organisation-wide routing starts at `tbhrc/workspace/AGENTS.md`. Durable work belongs in the owning GitHub repository; use an Issue/PR when it materially improves continuity. Reusable HOW belongs in `tbhrc/workspace/.folderdesk/skills/`. Remote privileged access to this Mac-local bridge belongs in `tbhrc/ai-engine`.

Use the current routing chain:

```text
Workspace AGENTS.md
-> owning GitHub repository
-> selected canonical Skill when specialist HOW is required
-> controller chooses an authorised executor
-> if Mac-local Codex is required: tbhrc/ai-engine
-> explicit C1 or C2
-> this launcher
-> verified evidence back to GitHub
```

`tbhrc/skills` is retired provenance/compatibility only.

## 4. Local manual dispatch

For a bounded local worktree/task file:

```bash
bash wrappers/delegate_to_codex.sh \
  --worker C2 \
  --task-file "/absolute/path/to/task.md" \
  --workdir "/absolute/path/to/bounded/worktree"
```

Worker mapping is fixed:

```text
C1 = Codex Business = ~/.codex-business
C2 = default Codex = ~/.codex
```

Do not use a permanent C1-first/C2-second hierarchy. The controller explicitly selects a profile based on task fit, permissions, current availability and remaining budget. The launcher never performs automatic account rotation or silent fallback.

For GitHub-controlled general work-order dispatch, follow the current Workspace router and owning AI Engine capability; do not invent a direct remote-control path in this repository.
