# Start Here

This package is a Codex multi-profile launcher.

1. Bootstrap the two isolated Codex homes:

```bash
cd codex-multi-profile-launcher
bash scripts/bootstrap.sh
```

2. Authenticate the profiles you need:

```bash
bash scripts/auth-codex-business.sh   # C1
bash scripts/auth-codex-david.sh      # C2
```

3. Keep real work in your task system:

```text
/path/to/your/task-workspace/Team Inbox/
```

4. Dispatch a task only when Larry decides it is economical. The default is C2 through Anti-Gravity:

```bash
bash wrappers/delegate_to_local_cli.sh \
  --task-file "/path/to/your/task-workspace/Team Inbox/2_ready/example.md" \
  --workdir "/path/to/your/project"
```

Use `--provider claude` only for an explicit Claude Code dispatch. Do not silently fall
back to C1 when C2 or the selected provider is unavailable.
