---
name: linear-cycle-review
description: >-
  Generate an end-of-cycle retrospective from Linear: pull the current (or named)
  cycle's completed and incomplete issues, summarize what shipped, what slipped,
  and what to carry over, and produce a structured review in the team's review
  format. Use this skill whenever the user wants a cycle/sprint retrospective,
  a "振り返り", a wrap-up of the week/iteration, or says things like "今サイクルの
  まとめ作って", "スプリント振り返りたい", "先週何が終わった", or is closing out a
  cycle. Prefer this over an ad-hoc summary, because it follows the workspace's
  review template and surfaces carryover and process signals an agent or human
  can act on next cycle.
---

# Linear Cycle Review

## Why this skill exists

The workspace operating doc ends every cycle with a `type/review` retrospective and
a housekeeping pass. Done by hand, this is tedious enough to skip — and skipping it
means carryover and recurring blockers go unnoticed. This skill makes the cycle
close cheap: it gathers the cycle's issues, computes a simple completion picture,
and writes a retrospective in the established review shape so the output is
consistent and immediately useful for planning the next cycle.

The aim is insight, not just a list. A good retrospective answers "what should we do
differently next cycle", not merely "here's what was in the cycle".

## Workspace conventions (ctxzz)

**Team:** `ctxzz`

**Cycle運用:** cycles run 1–2 weeks. The close sequence is: tidy incomplete work →
sweep the catch-all views → run the `type/review` retrospective.

**Review output shape** mirrors `agent_configs/04-review`: always give both
strengths and improvements, and end with concrete next actions.

## The review flow

1. **Resolve the cycle.** Use the Linear MCP `list_cycles` tool to find the current
   cycle for team `ctxzz` (or the one the user named). Confirm which cycle you're
   reviewing before pulling data.

2. **Pull the issues.** Use `list_issues` filtered to that cycle. Separate them into
   completed (`statusType: completed`), in-progress/incomplete (started or todo),
   and canceled. Note assignees and type labels — they reveal where effort went.

3. **Compute a light picture.** Completion rate (done / planned), counts by
   `type/*`, and carryover (incomplete items that will roll forward). Keep the math
   simple and honest; don't manufacture precision the data doesn't support.

4. **Find the signal.** Look for patterns worth naming: a type that consistently
   slips, issues that sat untouched, agent-assigned issues that didn't complete,
   scope that ballooned mid-cycle. These are the useful part of a retrospective.

5. **Write the retrospective** using the template below, in the user's language.

6. **Offer to file it.** Ask whether to save the retrospective as a `type/review`
   issue (or document) in the relevant project, and whether to roll carryover items
   into the next cycle. Don't mutate Linear without confirmation.

## Retrospective template

```markdown
# Cycle <name/number> 振り返り（<期間>）

## サマリ
- 計画 <N> / 完了 <M>（完了率 <X>%） / 繰り越し <K>
- type別: dev <n> · research <n> · content <n> · automation <n> · review <n>

## 良かった点
- <what worked — be specific, cite issues by ID where useful>

## 詰まった点 / 改善点
- <what slipped and the likely cause — process, scope, or blockers>

## 繰り越し
- <incomplete items rolling into next cycle, with a one-line reason each>

## 次サイクルのアクション
- <concrete, checkable changes to try next cycle>
```

## Examples

These are illustrative — adapt to the actual cycle data.

**Example 1 (current cycle wrap-up)**
Input: "今サイクルのまとめ作って"
Action: resolve the active cycle via `list_cycles`, pull its issues, compute the
picture, write the retrospective, then offer to save it as a `type/review` issue.

**Example 2 (named cycle)**
Input: "先週のサイクル振り返りたい"
Action: identify the most recently completed cycle, confirm it's the right one, and
proceed. If two cycles could match, ask which.

**Example 3 (carryover focus)**
Input: "繰り越し分だけ整理して次に回して"
Action: list incomplete issues in the cycle, summarize each with a reason, and —
after confirmation — move them to the next cycle via `save_issue`.

## Notes on robustness

- Linear MCP tool names carry an environment-specific connector prefix — use
  whatever `list_cycles` / `list_issues` / `save_issue` / `save_document` tools are
  available; don't hardcode a prefix.
- If the workspace isn't using cycles for some issues, say so rather than forcing a
  cycle frame — offer a date-range review (e.g. completed in the last 14 days) as a
  fallback.
- Keep the retrospective concise. A wall of text gets skipped; the value is in the
  few sharp observations and the next-cycle actions.
