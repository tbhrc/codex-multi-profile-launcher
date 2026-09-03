# Maintenance SOP

This SOP is for agents maintaining the Codex Multi-Profile Launcher repo.

## 1. Intake

Classify the request before editing:

| Request type | Usual location |
|---|---|
| public installation clarity | `README.md` |
| architecture or boundaries | `docs/00_MASTER_ARCHITECTURE.md` |
| user setup flow | `docs/01_USER_GUIDE.md` |
| orchestrator behavior | `docs/02_OPERATING_MODEL.md` |
| future plan | `docs/03_BUILD_ROADMAP.md` |
| backup, transfer, merge | `docs/04_BACKUP_TRANSFER_MERGE.md` |
| maintenance context | `docs/05_FRESH_SESSION_HANDOFF.md` |
| background continuity sync | `scripts/profile-sync-watch.sh`, `scripts/install-profile-sync-watch.sh` |
| repeatable process | this file |
| executable behavior | `scripts/`, `wrappers/`, `tools/`, `tests/` |

If the request belongs in the user's task workspace instead of this bridge, stop and say so.

## 2. Startup Check

Run the repo startup check:

```bash
sed -n '1,220p' README.md
sed -n '1,220p' docs/00_MASTER_ARCHITECTURE.md
cat runtime/active_worker.json
python3 tools/aosctl.py validate
git status --short --branch
```

Read the relevant worker file under `agents/` when the request touches C1, C2, or orchestration.

## 3. Edit Rules

- Keep changes small and scoped.
- Do not touch `auth.json`.
- Do not copy credentials between profiles.
- Do not modify another profile home unless the task explicitly targets it.
- Do not delete app data or runtime data without explicit approval.
- Do not publish, deploy, or push unless explicitly requested.
- Prefer adding clear docs over adding automation when the behavior is not repeated yet.

## 4. Runtime-State Rule

Treat these as runtime evidence, not normal source edits:

```text
runtime/active_worker.json
runtime/outputs/
runtime/logs/
runtime/tmp/
runtime/worktrees/
```

If one appears modified after validation or profile activation, inspect the diff before staging:

```bash
git diff -- runtime/active_worker.json
```

Commit runtime files only when the requested change is specifically about runtime state. Otherwise leave them local or restore them to the neutral repo state after confirming they contain no user work.

## 5. Documentation Update Pattern

When a new lesson is learned:

1. Add the user-facing version to `README.md` if it affects public installation.
2. Add the maintainer version to `docs/05_FRESH_SESSION_HANDOFF.md`.
3. Add repeatable steps to this SOP if the lesson changes future workflow.
4. Add or update tests only when executable behavior changed.

Do not bury important instructions only in hidden files. The README must remain useful to an average user who only reads the GitHub landing page.

## 6. Launcher Verification

For C1:

```bash
open -n "$HOME/Applications/Codex C1 Business.app"
```

Expected process argument:

```text
--user-data-dir=/Users/<you>/Library/Application Support/Codex-C1-Business
```

For C2:

```bash
open -n "$HOME/Applications/Codex C2 David.app"
```

Expected process argument:

```text
--user-data-dir=/Users/<you>/Library/Application Support/Codex-C2-David
```

Use narrow process checks that search only for the profile-specific user-data directory. Do not dump broad process lists because unrelated tools may include secrets in arguments.

## 7. Profile Backup and Merge

Use `scripts/profile-sync.sh` for repeatable backup and merge work:

```bash
bash scripts/profile-sync.sh backup --to "$HOME/.codex-business"
bash scripts/profile-sync.sh merge --from "$HOME/.codex" --to "$HOME/.codex-business"
bash scripts/profile-sync.sh verify --profile "$HOME/.codex-business"
```

Remember:

- destination profile identity must remain intact
- credentials are never copied
- desktop project containers are not reliably portable
- SQLite files should not be copied while the related Codex app is running
- manual project re-addition in the desktop UI may still be required

For optional ongoing continuity sync:

```bash
bash scripts/install-profile-sync-watch.sh
launchctl print "gui/$(id -u)/com.codex.multi-profile.sync"
tail -n 50 "$HOME/Library/Logs/com.codex.multi-profile.sync.log"
```

Stop it with:

```bash
launchctl bootout "gui/$(id -u)" "$HOME/Library/LaunchAgents/com.codex.multi-profile.sync.plist"
```

The watcher runs every five minutes, skips when continuity files have no recent changes, uses a lock to prevent overlap, and never copies credentials or live SQLite databases.

## 8. Validation

For docs-only changes:

```bash
python3 tools/aosctl.py validate --verbose
```

For script or tool changes:

```bash
python3 tools/aosctl.py validate --verbose
python3 -m unittest tests/test_aosctl.py
bash -n scripts/*.sh wrappers/*.sh
```

For installer changes, run a temporary install test instead of overwriting real apps when possible:

```bash
APPS_DIR="$(mktemp -d)" \
C1_APP_NAME="Codex C1 Test" \
C2_APP_NAME="Codex C2 Test" \
bash scripts/install-macos-launchers.sh
```

Remove the temporary directory after inspection.

## 9. Commit Hygiene

Before committing:

```bash
git status --short --branch
git diff --stat
```

Stage only the files that belong to the task. If unrelated runtime files changed, do not stage them.

Use direct commit messages:

```text
Add agent install prompt to README
Add OpenAI non-affiliation disclaimer
Add side-by-side profile screenshot
Document profile backup and merge workflow
```

## 10. Handoff Response

A final maintenance response should include:

- the concrete outcome
- files changed
- tests or validation run
- anything intentionally not changed
- next manual step, if any

Keep it short enough that the user can act on it immediately.
