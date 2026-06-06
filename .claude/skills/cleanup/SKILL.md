---
name: cleanup
description: Clean up a codebase — remove unused dependencies, dead code, unused imports, and orphaned files. Use when the user explicitly asks to clean up or prune the codebase.
disable-model-invocation: true
---

# Codebase Cleanup

## Dependency Cleanup
- Find and remove unused packages / devDependencies; update outdated ones.

## Code Cleanup
- Remove unused imports, dead code paths, unused variables, leftover debug/console statements, commented-out code.

## File Organization
- Identify orphaned files, old fixtures, temporary files; archive deprecated modules.

## Git Cleanup
- Untracked files: !`git clean -fd --dry-run`
- Prune deleted remotes: !`git remote prune origin --dry-run`
- Review .gitignore coverage.

## Safety
- Always preview with `--dry-run` first; ensure tests pass before and after; confirm before deleting anything not created in this session.
