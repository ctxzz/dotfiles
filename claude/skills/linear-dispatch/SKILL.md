---
name: linear-dispatch
description: >-
  Hand a Linear issue (or a batch of them) off to the right executor — a human or
  an AI agent — and prepare it so work can start unattended. Use this skill whenever
  the user wants to assign, delegate, dispatch, route, or "投げる/振る/任せる" an
  issue to someone or something: phrases like "これ誰にやらせる", "Copilotに任せて",
  "このタスク振り分けて", "agent/needed のやつ捌いて", or when they point at an
  issue and ask who should do it. The skill picks the best runner based on the
  issue's type label and whether a target repository exists, sets the assignee,
  adds the agent/needed label, and writes a concise handoff brief as a comment so
  the assigned agent has everything it needs. Prefer this over manually assigning,
  because a bare assignment without a handoff brief usually stalls.
---

# Linear Dispatch

## Why this skill exists

In this workspace, execution is increasingly delegated: an issue gets an assignee,
and that assignee — human or agent — does the work. The bottleneck is rarely the
assignment click; it's that the issue arrives at the executor without enough
context to act. An AI agent assigned to a thin issue produces thin work or stalls.

This skill's job is to make delegation *land*: choose an appropriate runner, set
the assignee and routing labels, and leave a short, high-signal handoff brief so
the executor can start immediately. It complements `linear-task-creator` (which
captures the task well) by handling the next step (getting it to the right doer).

## Workspace conventions (ctxzz)

**Team:** `ctxzz`

**Assignee = the runner.** The assignee decides who executes:

| Assignee | Use when |
| -- | -- |
| `me` | The user will do it themselves, or it needs human judgment first |
| `Copilot` | `type/dev` work that lives in a known GitHub repo (Copilot for Linear opens a PR) |
| `Devin` | `type/dev`/`type/automation` work where a more autonomous agent is wanted |
| `Claude` | Research, content, or analysis where Claude is connected as a Linear agent |

These are guidelines, not laws — honor an explicit instruction from the user over
the table.

**Routing labels:** add `agent/needed` when an agent should execute it. (If the
workspace has adopted intermediate states like `agent/in-progress` /
`agent/review-needed`, set those as appropriate; otherwise just `agent/needed`.)

**Type label drives the runner choice.** `type/dev` → repo-backed agent (Copilot/
Devin); `type/research`/`type/content` → Claude or human; `type/automation` →
Devin/Claude/human; `type/review` → human or Claude.

## The dispatch flow

1. **Load the issue(s).** Use the Linear MCP `get_issue` / `list_issues` tools to
   read title, description, labels, project, and current assignee. When the user
   says something broad like "agent/needed のを捌いて", list the matching open
   issues first and confirm the set before acting.

2. **Check readiness.** An issue is dispatch-ready only if it has a clear goal and
   acceptance criteria. If the description is thin, don't dispatch a hollow issue —
   say so and offer to enrich it first (this is where `linear-task-creator`'s
   description template helps). Garbage in, garbage out applies doubly to agents.

3. **Pick the runner.** Combine the type label with repository availability:
   - `type/dev` **with** a known target repo → `Copilot` (or `Devin` if the user
     prefers more autonomy). If no repo is mapped yet, ask which repo before
     assigning — a repo-backed agent can't act without one.
   - `type/research` / `type/content` → `Claude` if connected as a Linear agent,
     else `me`.
   - `type/automation` → `Devin`/`Claude`/`me` depending on scope.
   - `type/review` → usually `me`; `Claude` for first-pass drafts.
   State your choice and the one-line reason; let the user override.

4. **Write the handoff brief** as an issue comment using the template below. This
   is the heart of the skill — it's what turns an assignment into actionable work.

5. **Apply the assignment.** Use `save_issue` to set `assignee` and add
   `agent/needed` (and any agreed intermediate-state label). Confirm back the
   issue identifier, the chosen runner, and a link.

## Handoff brief template

Keep it short and executor-facing. Write in the user's language.

```markdown
## 担当への引き継ぎ
**Runner:** <Copilot / Devin / Claude / me> — <one-line reason>
**対象リポジトリ:** <org/repo + branch>  ← type/dev のとき必須
**ゴール:** <what done looks like, 1–2 lines>
**最初の一歩:** <concrete first action the executor can take>
**境界・注意:** <out of scope, constraints, things not to touch>
**完了の合図:** <PR / コメント / 成果物 — how the executor should report back>
```

The `最初の一歩` line matters a lot: agents perform far better when the issue names
a concrete starting action rather than only a goal.

## Examples

These are illustrative — adapt to the actual issue.

**Example 1 (dev issue → Copilot)**
Input: "<repo>のこのバグ、Copilotに任せて"
Action: confirm the type is `type/dev` and the repo is known; if the description
lacks repro/expected behavior, ask for it; write the handoff brief naming the repo
and a first step ("該当モジュールを特定→失敗する最小ケースを再現"); set
`assignee: Copilot`, add `agent/needed`.

**Example 2 (batch triage)**
Input: "agent/needed のついてるやつ、振り分けといて"
Action: list open issues with `agent/needed`, group by type, propose a runner per
issue in a table, get a yes, then apply assignments and handoff briefs in one pass.
Flag any issue too thin to dispatch and exclude it.

**Example 3 (research → Claude)**
Input: "この調査タスク、Claudeにやらせたい"
Action: confirm `type/research`; ensure the issue states the question and the
comparison axes; write a handoff brief with the expected output format
(agent_configs/01-research style); set `assignee: Claude`, add `agent/needed`.

## Notes on robustness

- Linear MCP tool names carry an environment-specific connector prefix — use
  whatever `get_issue` / `list_issues` / `save_issue` tools are available; don't
  hardcode a prefix.
- Never assign a repo-backed agent (Copilot/Devin) to a `type/dev` issue without a
  known target repository — ask first. This is the most common cause of a stalled
  agent run.
- If asked to dispatch many issues, do the readiness check per issue and report
  which ones you skipped and why, rather than blindly assigning everything.
