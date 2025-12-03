---
description: Generate conventional commit message from staged changes and execute commit
---

# Smart Git Commit

## Context Analysis
- Current git status: !`git status --porcelain`
- Staged changes: !`git diff --cached --name-only`
- Recent commits: !`git log --oneline -5`

## Your Task
1. Analyze the staged changes to understand what was modified
2. Generate a conventional commit message following the format:
   - feat: New feature
   - fix: Bug fix
   - docs: Documentation changes
   - refactor: Code refactoring
   - test: Test additions or modifications
   - chore: Other changes (build, CI, etc.)
3. Make the message descriptive but concise
4. Execute the commit with the generated message
5. Show the commit hash and summary

## Guidelines
- Follow project's commit message conventions if they exist
- Keep subject line under 72 characters
- Use imperative mood ("add" not "added")
- Include scope when relevant (e.g., "feat(api): add endpoint")
