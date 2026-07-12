# Backup, Transfer, and Merge Between Codex Profiles

This guide describes how to move reusable local Codex data between isolated profiles created by the Codex Multi-Profile Launcher.

It is intended for people who actively use both profiles for their work and want a second profile to continue from the first profile’s local context.

## What can be transferred

The following local data can be backed up and transferred into another profile:

- Codex session and archived-session files
- Local conversation history and session indexes
- Local memory files and databases
- Goals and local state databases
- Local SQLite continuity data
- Worker instructions, prompts, skills, MCP configuration templates, and plugin activation settings
- Local project trust registrations
- Local project folders, when both profiles use the same computer filesystem

The destination profile should keep its own login and authentication state. Transfer the working context, not the destination profile’s identity.

## What cannot be reliably synchronized

The desktop app’s named local project containers and sidebar project metadata are not exposed as a portable project record. They may be rebuilt by the app from account- or application-specific state, so copying profile files does not reliably recreate the same visible Projects list.

That means:

- Local project folders remain available on disk.
- Local chat/session history can be preserved and continued from the destination profile.
- The destination profile may not show the original named project container in its desktop sidebar.
- A project may need to be recreated or re-added in the destination profile’s UI.

This is a limitation of the desktop project index, not evidence that the local files or chat history were lost.

## Safe migration principles

1. Back up the destination profile before merging.
2. Never copy `auth.json`, OAuth stores, cookies, tokens, API keys, or browser session state.
3. Keep the destination profile’s `CODEX_HOME`, login, and desktop user-data directory intact.
4. Merge sessions, memories, state, skills, prompts, and non-secret configuration separately.
5. Re-authenticate MCP services independently in the destination profile.
6. Restart the destination desktop profile after the merge.
7. Verify the process is using the intended `--user-data-dir` and `CODEX_HOME`.

## Example data boundaries

For the default launcher names:

```text
Original Codex home: ~/.codex
C1 Codex home:      ~/.codex-business

Original desktop data: ~/Library/Application Support/Codex
C1 desktop data:      ~/Library/Application Support/Codex-C1-Business
```

The desktop data directories must remain separate because they contain account and application session state. Do not replace the C1 desktop directory with the original directory.

## Expected result

After a successful migration, the destination profile can continue from the transferred local session history, memories, skills, prompts, and project folders. The visible desktop project list may still differ because named project containers are not reliably transferable.

This workflow is useful when both isolated profiles are actively used for work and the goal is continuity, backup, and local recovery rather than account or project-container cloning.
