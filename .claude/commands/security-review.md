---
description: Comprehensive security analysis of code
argument-hint: [file-or-directory]
---

# Security Review: $ARGUMENTS

Analyze the specified code for security vulnerabilities:

## Authentication & Authorization
- Check for proper authentication flows
- Verify authorization controls
- Look for privilege escalation risks

## Input Validation
- SQL injection vulnerabilities
- XSS attack vectors
- Command injection risks
- Path traversal issues
- Unsafe deserialization

## Data Protection
- Sensitive data exposure
- Encryption implementation
- Secure storage practices
- API key and credential handling

## Code Execution
- Eval and dynamic code execution risks
- Unsafe file operations
- Shell command injection
- Environment variable injection

## Dependencies
- Known vulnerable packages
- Outdated dependencies
- Suspicious imports

## Output Format
For each finding, provide:
- **Severity**: Critical / High / Medium / Low
- **Location**: File and line number
- **Description**: What the vulnerability is
- **Impact**: What could happen if exploited
- **Recommendation**: How to fix it

@$ARGUMENTS
