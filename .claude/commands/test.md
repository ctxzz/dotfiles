---
description: Generate comprehensive test suite for code
argument-hint: [file-or-function]
---

# Test Generator: $ARGUMENTS

Create a comprehensive test suite:

## Test Types
1. **Unit Tests**
   - Happy path scenarios
   - Edge cases and boundary conditions
   - Error handling
   - Mock dependencies

2. **Integration Tests**
   - Component interactions
   - API integrations
   - Database operations

## Test Organization
- Describe blocks for logical grouping
- Setup and teardown functions
- Test data factories
- Shared test utilities

## Coverage Goals
- Aim for 90%+ code coverage
- Focus on critical business logic
- Test error boundaries thoroughly

## Output Format
```javascript
describe('functionName', () => {
  // Happy path
  it('should return expected result for valid input', () => {});

  // Edge cases
  it('should handle empty input correctly', () => {});
  it('should handle null/undefined input', () => {});

  // Error cases
  it('should throw error for invalid input', () => {});
});
```

## Guidelines
- Test behavior, not implementation
- Use meaningful test data (avoid magic numbers)
- Keep tests simple and readable
- Each test should verify a single behavior

@$ARGUMENTS
