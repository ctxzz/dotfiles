---
name: refactor
description: Refactor code for quality while preserving behavior — extract methods, simplify conditionals, remove duplication, improve naming. Use when the user asks to refactor or clean up code structure.
argument-hint: "[target] [strategy?]"
---

# Code Refactoring: $ARGUMENTS

## Analysis
1. Assess code quality: smells, complexity, duplication, maintainability.
2. Choose a strategy: extract functions, improve naming, simplify logic, strengthen types.

## Implementation
1. Preserve behavior: keep tests passing, maintain backward compatibility.
2. Improve structure: separation of concerns, cleaner abstractions, readability.

## Common Patterns
- Extract Method/Variable, Replace Magic Numbers, Consolidate Conditionals, Remove Dead Code.

## Validation
- Run the existing test suite, check performance impact, watch for breaking changes.

@$ARGUMENTS
