---
name: linear-task-creator
description: >-
  Turn a rough, half-formed task idea into a well-structured Linear issue with a
  complete description, the right project, a single type label, priority, and an
  assignee. Use this skill whenever the user wants to add, create, file, capture,
  log, or "throw into Linear" any task, todo, idea, bug, research item, or piece
  of work — even when they only mutter a one-line thought like "OCRのPoCやりたい"
  or "あとでこれ調べる" and don't explicitly say the word "Linear" or "issue". The
  point is to never let a vague one-liner become a Linear issue with an empty
  description; this skill interviews the user just enough to produce an issue an
  AI agent (Copilot / Devin / Claude) could pick up and act on unattended.
---

# Linear Task Creator

## Why this skill exists

In this workspace, tasks are increasingly executed by AI agents that are assigned
to a Linear issue and work on it in the background. An agent can only act on what
is written in the issue — its title, description, labels, and project context. A
task captured as a bare title with an empty description is therefore close to
useless for automation, and the human ends up re-explaining it later anyway.

This skill's job is to spend ~20 seconds interviewing the user so that every issue
it creates is **self-contained**: someone (human or agent) reading only the issue
can understand the goal, know when it's done, and start work. Capture should feel
fast and conversational, not like filling out a form.

## Workspace conventions (ctxzz)

These reflect the operating doc in the `00-system` project. Honor them.

**Team:** `ctxzz`

**Projects** — pick the best fit, or propose a new goal-type project if none fits:

| Project | Use for |
| -- | -- |
| `00-system` | Operations, design, prompts, automation config |
| `01-misc` | Light, one-off tasks (swept every 1–2 weeks) |
| `02-sandbox` | Prototypes, PoCs, experiments |
| `03-idea-bin` | Ideas, someday/maybe, future wants |
| `<product>-<goal>` | Deliverable-oriented work, e.g. `dev-<app>`, `conf-<event>`, `paper-<topic>` |
| `learn-<topic>` | Learning |
| `research-<topic>` | Investigation |

**Type label — exactly one per issue** (this is the AI-routing key):

| Label | Meaning |
| -- | -- |
| `type/dev` | Coding, implementation, refactor, tests |
| `type/research` | Investigation, comparison, summarizing |
| `type/content` | Writing, docs, articles, translation |
| `type/automation` | Automation, CLI/CI setup, scripts |
| `type/review` | Retrospective, design review, improvement |

**AI labels:** add `agent/needed` when the issue is intended for an agent to execute.

**Priority labels (optional):** `p0`, `p1`, `p2`.

**Assignee = the runner.** The assignee field decides *who does the work*: the user
(`me`), or an agent (`Copilot`, `Devin`, `Claude`). Default to leaving it unset unless
the user signals intent.

## The capture flow

The goal is a complete issue with the *least* friction. Infer everything you can
from what the user already said and from existing workspace data; only ask about
what you genuinely can't determine.

1. **Infer first, ask second.** From the user's phrasing, propose: a title, the
   most likely project, the type label, and (if obvious) priority/assignee. Call
   the Linear MCP `list_projects` tool to ground your project suggestion in real
   project names rather than guessing.

2. **Ask only the gaps, batched.** Prefer a single grouped question over a slow
   back-and-forth. The fields that actually matter for an agent to act:
   - **Goal / what "done" looks like** (acceptance criteria) — the most important
     field and the one most often missing. Never skip this.
   - **Project** — confirm your inferred choice or correct it.
   - **Type** — confirm the single type label.
   - **References** — repo, URLs, related issues, files. For `type/dev`, the target
     repository matters most (agents need it).
   - **Priority / assignee** — only if the user hints at urgency or who should do it.

   If the user says something like "just make it, don't ask me", proceed with your
   best inference and clearly state the assumptions you made.

3. **Draft the description** using the template below, then show the user the full
   proposed issue (title, project, label, assignee, description) and get a yes
   before creating it. This confirmation step is cheap and prevents junk issues.

4. **Create it** with the Linear MCP `save_issue` tool (`team: ctxzz`, plus the
   chosen `project`, `title`, `description`, `labels`, and optionally `assignee`,
   `priority`, `dueDate`). Return the issue identifier and URL.

## Description template

Keep it tight — this is a task, not an essay. Omit a section only if it truly
doesn't apply. Write in the user's language (Japanese here unless they switch).

```markdown
## 目的
<one or two sentences: why this task exists / what outcome it produces>

## 完了条件
- <concrete, checkable acceptance criterion>
- <...>

## 参考
- <repo / URL / related issue / file paths>

## メモ
<constraints, context, assumptions, open questions — optional>
```

This mirrors the output shape used across the `agent_configs/*` docs (概要 → 成果 →
根拠 → 次のアクション), so an agent assigned to the issue produces results that slot
back into the same structure.

## Examples

These are illustrative only — adapt to whatever the user actually says.

**Example 1 (vague one-liner → ask the gaps)**
Input: "新しいライブラリの検証やりたい"
Action: a PoC could be `type/research` or `type/dev` (ask which), suggest project
`02-sandbox` (it's a PoC), ask what success looks like and any reference links,
then draft:

> Title: ○○ライブラリの検証
> Project: 02-sandbox · Label: type/research
> 目的: ○○が要件を満たせるか小規模に検証する。
> 完了条件: サンプルN件で評価し、採用可否の判断材料をまとめる。
> 参考: <ドキュメント/リポジトリのURL>

**Example 2 (setup/want → automation)**
Input: "新しいツールを常用環境に入れたい"
Action: infer `type/automation`, project `03-idea-bin` (it's a setup want),
confirm, draft 完了条件 like "インストールし、最低限の設定（設定ファイル・
キーバインド等）を済ませて常用に切り替える".

**Example 3 (explicit, low-friction)**
Input: "type/dev で、◯◯機能を追加する issue を <product>-<goal> に立てて。
リポジトリは <org>/<repo>。アサインは Copilot。"
Action: almost everything is specified — only ask for 完了条件 if missing, then
create with the given `project`, `labels: [type/dev, agent/needed]`, and
`assignee: Copilot`.

## Notes on robustness

- The Linear MCP tool names are environment-specific (they carry a connector ID
  prefix). Use whichever `list_projects` / `list_issues` / `save_issue` tools are
  available; don't hardcode a prefix.
- If a referenced project doesn't exist yet, surface that and offer to create the
  issue in `01-misc` or to use a new `<product>-<goal>` name following the naming
  rule — don't silently dump it somewhere arbitrary.
- One type label per issue. If the work spans two types, that's a signal it should
  be two issues; suggest splitting rather than stacking labels.
