# User Guide

## Bootstrap

```bash
cd codex-multi-profile-launcher
bash scripts/bootstrap.sh
```

This creates the two Codex homes if missing:

```text
~/.codex-business
~/.codex-david
```

It copies safe config files only. It does not create or copy credentials.

## Authenticate profiles

C1 / Codex Business:

```bash
bash scripts/auth-codex-business.sh
```

C2 / Codex David:

```bash
bash scripts/auth-codex-david.sh
```

Never copy `auth.json` between homes or into this repository.

## Check status

```bash
bash scripts/status.sh
```

Login status proves authentication only; provider credits/capacity are separate runtime state.

## Start a profile

```bash
bash scripts/start-codex-business.sh   # C1
bash scripts/start-codex-david.sh      # C2
```

Aliases:

```text
C1 = Codex Business = ~/.codex-business
C2 = Codex David    = ~/.codex-david
```

The normal/default `~/.codex` profile is separate and is not C2.

The controller selects a seat/provider based on task fit and live availability. The launcher never silently swaps identities.

## Run a local delegated task

An Issue/PR may preserve durable continuity when useful, but it is **not required to unlock Codex execution**.

```bash
bash wrappers/delegate_to_codex.sh \
  --worker C2 \
  --task-file "/absolute/path/to/task.md" \
  --workdir "/absolute/path/to/worktree"
```

Use `--worker C1` when C1 is selected.

The wrapper uses the current tested execution configuration and the selected `CODEX_HOME` for authentication. Do not add another approval/sandbox/credential layer without a concrete demonstrated threat.

For controller-driven remote execution, use any existing authorised route that can reach the Mac/launcher. Do not create another bridge merely because one preferred route is unavailable.

## Results

Runtime evidence may be written under `runtime/outputs/<TASK-ID>/`. Keep only what helps verification/continuity; it is not a task tracker or permission system.

## Troubleshooting

Check the exact profiles directly:

```bash
CODEX_HOME="$HOME/.codex-business" codex login status
CODEX_HOME="$HOME/.codex-david" codex login status
```

If C1 is authenticated but out of credits, return that state once. **Do not silently change C1 into C2 inside the launcher.** The controller may immediately reroute the work to another authorised provider/seat. One exhausted seat is not a global blocker.

Run validation only when diagnosing launcher/config behaviour or after a relevant launcher change:

```bash
python3 tools/aosctl.py validate --verbose
```
