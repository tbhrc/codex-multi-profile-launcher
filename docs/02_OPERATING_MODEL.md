# Operating Model

## Principle

your task system routes the work. Codex executes selected work.

Do not build a second queue, second tracker, or second orchestration identity here.

## Larry's Role

Larry in Claude Code:

- receives the user request
- creates or updates the task
- decides whether Codex dispatch is worth it
- chooses `C1` or `C2`
- reads the Codex result
- updates your task system and reports to the user

## Codex Worker Roles

`C1 / Codex Business` is the default for production implementation and hardening.

`C2 / Codex David` is the default for bootstrap experiments, prototypes, and independent review.

## Dispatch Fit

Good Codex dispatch:

- clear input file
- clear output expectation
- limited project directory
- mechanical or implementation-heavy work
- separate context is useful

Poor Codex dispatch:

- a quick question
- ambiguous strategy discussion
- work requiring ongoing human judgment
- anything involving credentials or external writes

## Approval Rules

Codex workers may do local, reversible work in the assigned folder.

Ask for human approval before:

- deploying or publishing
- sending messages
- deleting material data
- changing credentials or auth
- touching `auth.json`
- using external production systems

## your task system Sync

After every meaningful Codex run, Larry should update the task with:

- worker used: `C1` or `C2`
- status
- files changed
- tests run
- output path under this bridge
- next action
