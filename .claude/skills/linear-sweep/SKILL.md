---
name: linear-sweep
description: >-
  Run housekeeping over Linear: find overdue issues, issues with empty or thin
  descriptions, untriaged items, and long-stale tasks, then propose archive /
  relabel / promote / enrich actions for each. Use this skill whenever the user
  wants to clean up, tidy, triage, prune, groom, or "棚卸し/掃除/整理" their Linear
  workspace, or says things like "01-misc 片付けたい", "ideabin 見直したい",
  "放置タスク整理して", "期限切れある？", or is doing a weekly/monthly review. Prefer
  this over manual scanning, because it applies the workspace's own housekeeping
  rules (01-misc swept every 1–2 weeks, 03-idea-bin reviewed monthly) and never
  changes anything without showing the proposed actions first.
---

# Linear Sweep

## Why this skill exists

A personal task system silts up: one-off tasks pile in the catch-all project, ideas
accumulate in the idea bin, due dates slide past unnoticed, and issues get created
with empty descriptions that no one (and no agent) can act on. The operating doc
already prescribes the cure — sweep `01-misc` every 1–2 weeks, review `03-idea-bin`
monthly — but doing it by hand is exactly the kind of chore that gets skipped.

This skill surfaces what needs attention and proposes a specific action per issue,
so housekeeping becomes a quick review-and-approve rather than a manual hunt. It
never mutates Linear on its own; the human stays in control of every change.

## Workspace conventions (ctxzz)

**Team:** `ctxzz`

**Housekeeping cadence (from the operating doc):**
- `01-misc` — light/one-off tasks, swept every 1–2 weeks
- `03-idea-bin` — ideas, reviewed (棚卸し) monthly
- `02-sandbox` — prototypes; graduate to a `<product>-<goal>` project or discard

**A healthy issue** has a single `type/*` label and a description with a goal and
acceptance criteria. Empty descriptions are the most common rot and the highest-value
thing to flag (they block both humans and agents).

## What the sweep looks for

Scan the target scope (a project, or the whole workspace) and bucket issues:

1. **Overdue** — `dueDate` in the past and not completed.
2. **Empty / thin description** — no description, or a one-liner with no goal or
   acceptance criteria. These can't be executed (especially by agents).
3. **Untriaged** — missing a `type/*` label, or sitting with no project.
4. **Stale** — not updated in a long time (e.g. >30 days in `01-misc`, or aging
   ideas in `03-idea-bin`), still open.
5. **Graduation candidates** — `02-sandbox` items that look like they've outgrown a
   prototype and deserve their own `<product>-<goal>` project.

## The sweep flow

1. **Confirm scope.** Ask (or infer) whether to sweep a specific project (e.g.
   `01-misc`) or the whole workspace. Default to the project the user named.

2. **Pull and bucket.** Use the Linear MCP `list_issues` tool (filter by project,
   include open states; check `dueDate`, `updatedAt`, `labels`, `description`).
   Sort each issue into the buckets above. An issue can appear in more than one.

3. **Propose one action per issue.** For each flagged issue, recommend a concrete
   action with a one-line reason:
   - Overdue → reschedule, or complete/cancel if no longer relevant
   - Empty description → enrich (hand to `linear-task-creator`) or archive if dead
   - Untriaged → add the right `type/*` label / assign a project
   - Stale → archive, or revive with a fresh due date
   - Graduation candidate → propose a new project name following `<product>-<goal>`

4. **Present as a review table**, grouped by bucket, so the user can approve in bulk
   or pick. Make "do nothing" an easy default for anything that's actually fine.

5. **Apply approved actions** via `save_issue` (labels, project, dueDate, state) and
   archiving where supported. Report what changed and what was left untouched.

## Output shape

```markdown
# Sweep: <scope> (<date>)

## 期限切れ (<n>)
| Issue | 提案 | 理由 |
| -- | -- | -- |
| CTX-XX タイトル | リスケ → <date> | 期限を3週間超過 |

## description が空/薄い (<n>)
| Issue | 提案 | 理由 |
| -- | -- | -- |
| CTX-XX | 補強 or アーカイブ | 目的・完了条件なし |

## 未triage (<n>)
...

## 放置 (<n>)
...

## 昇格候補 (<n>)
...
```

## Examples

These are illustrative — adapt to the actual data.

**Example 1 (weekly misc sweep)**
Input: "01-misc 片付けたい"
Action: scope to `01-misc`, bucket the open issues, present the review table,
apply approved archives/reschedules/labels.

**Example 2 (monthly idea review)**
Input: "ideabin の棚卸しして"
Action: scope to `03-idea-bin`, focus on stale and still-relevant ideas, propose
promote-to-project / keep / archive for each.

**Example 3 (empty-description hunt)**
Input: "説明が空のタスクある？埋めたい"
Action: scan the chosen scope for empty/thin descriptions, list them, and offer to
enrich each via the task-creator description template before anything is dispatched.

## Notes on robustness

- Linear MCP tool names carry an environment-specific connector prefix — use
  whatever `list_issues` / `save_issue` tools are available; don't hardcode a prefix.
- Always show proposed actions and get approval before mutating or archiving — this
  is a cleanup tool, and surprise deletions are the worst possible outcome. Bias
  toward archiving (reversible) over destructive changes.
- Don't over-flag. If an issue is genuinely fine (clear, on-track, recently
  updated), leave it out of the report rather than inventing busywork.
