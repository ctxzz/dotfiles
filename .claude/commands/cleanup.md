---
description: Clean up codebase and remove unused code
---

# Codebase Cleanup

## Dependency Cleanup
1. **Unused Dependencies**
   - Find unused packages
   - Remove unused devDependencies
   - Update outdated packages
   - Clean and reinstall dependencies

2. **Code Cleanup**
   - Find unused imports
   - Remove dead code paths
   - Eliminate unused variables
   - Clean up console.logs and debug statements

## File Organization
1. **Unused Files**
   - Identify orphaned files
   - Remove old test fixtures
   - Clean up temporary files
   - Archive deprecated modules

2. **Code Quality**
   - Remove commented code
   - Fix TODO items
   - Update outdated comments
   - Improve variable naming

## Git Cleanup
- Remove untracked files: !`git clean -fd --dry-run`
- Prune deleted branches: !`git remote prune origin`
- Review .gitignore coverage

## Safety Measures
- Always run with --dry-run first
- Review changes before executing
- Ensure backups exist
- Verify tests still pass after cleanup
