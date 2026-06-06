---
name: test
description: Generate a comprehensive test suite for a file or function, covering happy paths, edge cases, and errors. Use when the user wants tests written for code.
argument-hint: "[file-or-function]"
---

# Test Generator: $ARGUMENTS

Create a comprehensive test suite.

## Test Types
1. **Unit**: happy path, edge/boundary cases, error handling, mocked dependencies.
2. **Integration**: component interactions, API calls, database operations.

## Organization
- Logical grouping (describe blocks), setup/teardown, test data factories, shared utilities.

## Coverage
- Aim for 90%+ on critical business logic; test error boundaries thoroughly.

## Guidelines
- Test behavior, not implementation.
- Meaningful test data (avoid magic numbers).
- Each test verifies a single behavior with a descriptive name.

@$ARGUMENTS
