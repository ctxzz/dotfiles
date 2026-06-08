---
name: deploy
description: Deploy these dotfiles to the home directory and run setup via the repo Makefile (symlinks, init scripts, tests). Use after adding or changing dotfiles, or when setting up a new machine.
disable-model-invocation: true
---

# Deploy dotfiles

This repo manages dotfiles through its Makefile (symlink-based deploy).

## Targets
- `make list`   — show the dotfiles this repo manages
- `make deploy` — create symlinks into `$HOME` (safe to re-run; `ln -sfnv`)
- `make init`   — run environment setup scripts (`etc/init/init.sh`)
- `make test`   — run dotfiles + init tests (`etc/test/test.sh`)
- `make test-container OS=ubuntu` — test in a Podman container (ubuntu/fedora/arch/macos/windows)
- `make update` — git pull + update submodules
- `make install`— update + deploy + init (full setup)

## Task
1. Confirm what the user wants: a new file deployed (`make deploy`), full setup (`make install`), or a test run.
2. Note that `make deploy` also symlinks selected `.claude` config (`CLAUDE.md`, `settings.json`, `ai.env`, and each skill under `skills/`) into `~/.claude` directly from the Makefile, using the same `ln -sfnv` convention; Claude Code's runtime state under `~/.claude` is left untouched. `.config` is not symlinked.
3. Prefer `make deploy` for day-to-day changes; reserve `make install` for new machines (it also runs `init` and pulls).
4. Run the chosen target and report the symlinks created / output.

## Guidelines
- `make clean` removes the deployed symlinks AND this repo — never run it without explicit confirmation.
- `init` may install packages; confirm before running on an unfamiliar machine.
