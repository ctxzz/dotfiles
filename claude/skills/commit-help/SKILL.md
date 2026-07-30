---
name: commit-help
description: Draft a good commit message from staged changes for the user to review (without committing). Use when the user wants help wording a commit message.
---

# Commit Help

## Context
- Staged diff: !`git diff --staged --stat`

## Task
1. Review `git diff --staged` to understand the changes.
2. Classify the change (feat, fix, refactor, docs, style, test, chore).
3. Draft a message and present it for approval (do NOT commit):
   - Subject ≤ 50 chars, imperative mood.
   - Body explaining what and why when needed.
   - Reference issues/tickets if applicable.

## Format
```
feat: Brief description (50 chars max)

Detailed explanation of what changed and why.

- Bullet points for multiple changes
```
