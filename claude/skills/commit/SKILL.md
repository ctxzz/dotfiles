---
name: commit
description: Generate a conventional commit message from staged changes and execute the commit. Use when the user asks to commit staged work.
disable-model-invocation: true
---

# Smart Git Commit

## Context
- Status: !`git status --porcelain`
- Staged files: !`git diff --cached --name-only`
- Recent commits: !`git log --oneline -5`

## Task
1. Analyze the staged changes to understand what was modified.
2. Generate a conventional commit message: `feat` / `fix` / `docs` / `refactor` / `test` / `chore`.
3. Keep the subject under 72 chars, imperative mood ("add" not "added"), scope when relevant (`feat(api): ...`).
4. Execute the commit with the generated message.
5. Show the commit hash and summary.

## Guidelines
- Follow the project's existing commit conventions if they differ.
- Commit only staged changes; do not stage extra files without asking.
