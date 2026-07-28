---
name: clean-branches
description: Safely prune local git branches that are already merged or whose remote has been deleted. Use when the local branch list has grown stale after merging PRs.
disable-model-invocation: true
---

# Clean merged branches

## Context
- Current branch: !`git branch --show-current`
- Local branches: !`git branch -vv`

## Task
1. `git fetch --prune` to drop stale remote-tracking refs.
2. Identify candidates:
   - Merged into the default branch: `git branch --merged <default>`
   - Whose upstream is gone: branches marked `[gone]` in `git branch -vv`.
3. Show the candidate list and ask for confirmation.
4. Delete confirmed branches with `git branch -d` (use `-D` only when the user explicitly accepts an unmerged delete).

## Guidelines
- NEVER delete the current branch, `master`/`main`, or any branch with unpushed commits without explicit confirmation.
- Prefer `-d` (safe, merged-only) over `-D` (force).
- This only touches local branches; it never deletes remote branches.
