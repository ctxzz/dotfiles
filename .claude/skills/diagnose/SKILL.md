---
name: diagnose
description: Debug a bug or failing test methodically instead of guessing — reproduce, minimize, form a hypothesis, instrument, fix, then verify. Use when a bug is non-obvious or a fix attempt already failed.
---

# Diagnose

A disciplined loop for non-obvious bugs. Do not jump to a fix before the cause is proven.

## Steps
1. **Reproduce** — find the smallest reliable command/input that triggers the bug. If you cannot reproduce it, stop and gather more information.
2. **Minimize** — strip away unrelated code/inputs until only the failing path remains.
3. **Hypothesize** — state one specific, falsifiable cause ("X is null because Y runs before Z").
4. **Instrument** — add logging/asserts/a breakpoint to confirm or kill the hypothesis. Let evidence decide; if wrong, return to step 3.
5. **Fix** — change only what the proven cause requires. No drive-by edits.
6. **Verify** — re-run the reproduction; it must now pass. Add a regression test that fails without the fix.

## Guidelines
- One hypothesis at a time. Change one variable per experiment.
- Trust observations over assumptions — print the actual value.
- If three hypotheses fail, zoom out: question the layer below (framework, env, data).
