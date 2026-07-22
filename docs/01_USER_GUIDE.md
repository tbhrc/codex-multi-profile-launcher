# User Guide

## 1. Bootstrap

```bash
cd codex-multi-profile-launcher
bash scripts/bootstrap.sh
```

This creates the two Codex homes if missing:

```text
~/.codex-business
~/.codex
```

It copies safe config files only. It does not create or copy credentials.

## 2. Authenticate Profiles

Authenticate `C1 / Codex Business`:

```bash
bash scripts/auth-codex-business.sh
```

Authenticate `C2 / Codex David`:

```bash
bash scripts/auth-codex-david.sh
```

Do not copy `auth.json` between homes. Do not place `auth.json` in this repo.

## 3. Check Status

```bash
bash scripts/status.sh
```

## 4. Start an Interactive Profile

Use `C1` for production implementation:

```bash
bash scripts/start-codex-business.sh
```

Use `C2` when the task needs David's original Codex profile, existing project/chat context, general investigation, or independent review:

```bash
bash scripts/start-codex-david.sh
```

## 4a. Use Dock Launchers

The macOS launcher apps are:

```text
~/Applications/Codex C1 Business.app
~/Applications/Codex C2 David.app
```

Drag either app to the Dock. These launchers keep both the Codex CLI home and the desktop app data separate from the regular app and from each other.

## 5. Run a Delegated Task

The task should usually live in your task system, for example:

```text
/path/to/your/task-workspace/Team Inbox/2_ready/NNN-some-task-YYYY-MM-DD.md
```

The global default is C2 through Anti-Gravity:

```bash
bash wrappers/delegate_to_local_cli.sh \
  --task-file "/path/to/your/task-workspace/Team Inbox/2_ready/NNN-some-task-YYYY-MM-DD.md" \
  --workdir "/path/to/your/project"
```

Use Claude Code only when explicitly selected:

```bash
bash wrappers/delegate_to_local_cli.sh \
  --provider claude \
  --task-file "/path/to/your/task-workspace/Team Inbox/2_ready/NNN-some-task-YYYY-MM-DD.md" \
  --workdir "/path/to/your/project"
```

The existing Codex-only wrapper remains available when specifically needed:

```bash
bash wrappers/delegate_to_codex.sh \
  --worker C2 \
  --task-file "/path/to/your/task-workspace/Team Inbox/2_ready/NNN-some-task-YYYY-MM-DD.md" \
  --workdir "/path/to/your/project"
```

Do not silently fall back to C1 when C2 or the selected provider is unavailable.

## 6. Read Results

The wrapper writes:

```text
runtime/outputs/<TASK-ID>/
  status.json
  summary.md
  run.log
  events.jsonl
  artifacts/
```

Larry should summarize the result back into the task file and update `TRACKER.md`.

## 7. Troubleshooting

If both workers appear to use the same account, check:

```bash
CODEX_HOME="$HOME/.codex-business" codex login status
CODEX_HOME="$HOME/.codex" codex login status
```

If validation fails:

```bash
python3 tools/aosctl.py validate --verbose
```
