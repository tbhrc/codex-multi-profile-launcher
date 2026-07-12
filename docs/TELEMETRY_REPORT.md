# Codex Build Telemetry Report

This report captures the local Codex telemetry for the implementation session that created and published this repository.

The numbers below are taken from Codex session metadata, not estimated from the visible chat transcript. Cost is not included because ChatGPT-authenticated Codex runs do not expose invoice-exact pricing in the local telemetry.

## Snapshot

| Field | Value |
|---|---:|
| Session ID | `019f51c9-f039-7242-8add-61dbc5ff7821` |
| Captured through | 2026-07-12 21:43:11 UTC |
| Captured through, Dubai time | 2026-07-13 01:43:11 GST |
| Model recorded | `gpt-5.5` |
| Context window | 258,400 tokens |
| Context compactions | 1 |

## Token Usage

| Metric | Value |
|---|---:|
| Input tokens | 19,502,852 |
| Cached input tokens | 18,463,872 |
| Output tokens | 74,061 |
| Reasoning output tokens | 16,463 |
| Stored total tokens | 19,576,913 |
| Token events | 150 |

Cached input tokens are a subset of input tokens. Reasoning output tokens are reported separately by Codex telemetry and are not added again into the stored total.

## Time Frame

| Metric | Value |
|---|---:|
| Start UTC | 2026-07-11 15:26:57 |
| Latest recorded event UTC | 2026-07-12 21:43:38 |
| Start Dubai time | 2026-07-11 19:26:57 GST |
| Latest recorded event Dubai time | 2026-07-13 01:43:38 GST |
| Wall-clock span | 30h 16m 41s |

The wall-clock span includes pauses, user review time, app testing, GitHub publication, screenshot handling, and documentation updates.

## Turn Timing

| Metric | Value |
|---|---:|
| In-session task starts | 14 |
| Completed task turns | 12 |
| Total model turn duration | 31m 53s |
| Average completed turn duration | 2m 39s |
| Fastest completed turn | 20.0s |
| Slowest completed turn | 6m 43.7s |
| Average time to first token | 11.1s |
| Fastest time to first token | 3.4s |
| Slowest time to first token | 46.8s |

Codex turn duration measures model/runtime turn time, not full human elapsed workflow time.

## Notes

- This report is a point-in-time snapshot from the original repository build conversation.
- Later maintenance work may increase the session totals if it continues in the same Codex task.
- The local telemetry source is intentionally not committed to this repository because it can contain private session metadata.
