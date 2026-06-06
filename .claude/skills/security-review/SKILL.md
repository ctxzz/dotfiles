---
name: security-review
description: Analyze code for security vulnerabilities — injection, auth flaws, data exposure, unsafe execution, vulnerable dependencies. Use when the user wants a security review of a file or directory.
argument-hint: "[file-or-directory]"
---

# Security Review: $ARGUMENTS

Analyze the specified code for security vulnerabilities.

## Authentication & Authorization
- Authentication flows, authorization controls, privilege-escalation risks.

## Input Validation
- SQL injection, XSS, command injection, path traversal, unsafe deserialization.

## Data Protection
- Sensitive data exposure, encryption, secure storage, API key / credential handling.

## Code Execution
- `eval` / dynamic execution, unsafe file ops, shell command injection, env-var injection.

## Dependencies
- Known-vulnerable packages, outdated deps, suspicious imports.

## Output Format
For each finding: **Severity** (Critical/High/Medium/Low), **Location** (file:line), **Description**, **Impact**, **Recommendation**.

@$ARGUMENTS
