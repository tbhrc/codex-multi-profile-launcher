# Claude Code / Larry Bridge Note

Inside your task workspace, Claude Code speaks as Larry.

Use this bridge only when `SOP-011` says real delegation is economical: self-contained implementation, mechanical code work, prototypes, or independent review.

Worker choice:

- `C2 / David Login` + Anti-Gravity: global default for delegated work
- Claude Code: explicit alternate provider when its capability is needed
- `C1 / tbhrc Login`: explicit legacy/isolated choice only; never an implicit fallback

Do not create normal work here. Create or update the real task in:

```text
/path/to/your/task-workspace/Team Inbox/
```

Then dispatch through the default route:

```bash
bash /path/to/codex-multi-profile-launcher/wrappers/delegate_to_local_cli.sh \
  --task-file "/path/to/your/task-workspace/Team Inbox/2_ready/<task>.md" \
  --workdir "/path/to/project"
```

Use `--provider claude` only when explicitly selected. If C2 or the selected provider
is unavailable, record the blocker; do not silently use C1.

After the run, read `runtime/outputs/<TASK-ID>/`, update the task, and update `TRACKER.md`.
