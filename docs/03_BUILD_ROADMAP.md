# Roadmap

## Stage 0 - Simplify

- remove standalone control-plane assumptions
- use `C1` and `C2` everywhere
- keep your task system as the source of truth
- keep validation and tests passing

Exit: docs, schemas, scripts, and tests agree on the lean bridge model.

## Stage 1 - Reliable Local Profiles

- bootstrap `~/.codex-business`
- bootstrap `~/.codex-david`
- verify each profile can report login status
- document any OmniRoute/Codex-specific constraints in your task system, not here

Exit: both profiles can be started intentionally without credential mixing.

## Stage 2 - your task system Task Dispatch

- make `delegate_to_codex.sh` accept task files cleanly
- preserve output evidence under `runtime/outputs/`
- make the result easy for Larry to paste/summarize into the task file
- keep lock files to prevent duplicate runs

Exit: one task can be delegated to `C1` or `C2` and summarized back.

## Stage 3 - Claude Code Adoption

- add a short your task system note telling Larry how to use this bridge
- avoid duplicating your task system SOPs in this repo
- reference `SOP-011` for dispatch economics

Exit: Claude Code can use the bridge without adopting a separate operating model.

## Stage 4 - Optional Hardening

- add stronger validation for task inputs
- improve result summaries
- add tests for wrapper failure modes
- add worktree isolation only if real collisions occur

Exit: hardening exists only where repeated use proves it is needed.
