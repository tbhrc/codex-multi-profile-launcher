# Claude Code / Larry Bridge Note

Inside your task workspace, Claude Code speaks as Larry.

Use this bridge only when `SOP-011` says real delegation is economical: self-contained implementation, mechanical code work, prototypes, or independent review.

Worker choice:

- `C1 / tbhrc Login`: production implementation and hardening
- `C2 / David Login`: the original David profile, existing projects/chats/tasks, general work, and review

Do not create normal work here. Create or update the real task in:

```text
/path/to/your/task-workspace/Team Inbox/
```

Then dispatch:

```bash
bash /path/to/codex-multi-profile-launcher/wrappers/delegate_to_codex.sh \
  --worker C1 \
  --task-file "/path/to/your/task-workspace/Team Inbox/2_ready/<task>.md" \
  --workdir "/path/to/project"
```

After the run, read `runtime/outputs/<TASK-ID>/`, update the task, and update `TRACKER.md`.
