# Commit Help

Help craft a good commit message based on staged changes.

## Task

1. Review `git diff --staged` to understand changes
2. Analyze the nature of changes (feature, fix, refactor, docs, etc.)
3. Draft a commit message following best practices:
   - Clear, concise subject line (50 chars or less)
   - Imperative mood ("Add feature" not "Added feature")
   - Detailed body explaining what and why (if needed)
   - Reference issues/tickets if applicable
4. Present the suggested commit message for user approval

## Format

```
feat: Brief description (50 chars max)

Detailed explanation of what changed and why.
Include context and reasoning.

- Bullet points for multiple changes
- Related files or components affected
```

Types: feat, fix, refactor, docs, style, test, chore
