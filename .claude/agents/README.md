# Claude Code Agents

This directory contains reusable agents for Claude Code that can help with various development tasks.

## What are Agents?

Agents are specialized AI assistants with specific expertise and workflows. Each agent has:
- A defined role and expertise area
- Systematic processes and checklists
- Structured output formats
- Best practices and guidelines

## Available Agents

### 🔍 [code-reviewer.md](./code-reviewer.md)
Expert code reviewer focused on quality, security, and best practices.

**Use when:**
- Reviewing pull requests
- Checking code before commit
- Getting a second opinion on implementation

**Key features:**
- Identifies bugs and security issues
- Suggests improvements
- Provides constructive feedback
- Includes code examples

### 🧪 [test-writer.md](./test-writer.md)
Expert in writing comprehensive unit, integration, and property-based tests.

**Use when:**
- Need to write tests for new code
- Improving test coverage
- Testing edge cases

**Key features:**
- Follows AAA pattern (Arrange-Act-Assert)
- Covers edge cases
- Clear, descriptive test names
- Multiple testing strategies

### ♻️ [refactoring.md](./refactoring.md)
Expert in code refactoring and improving code quality.

**Use when:**
- Code is difficult to understand
- Reducing complexity
- Eliminating code smells
- Improving maintainability

**Key features:**
- Identifies code smells
- Applies refactoring patterns
- Preserves functionality
- Improves readability

### 📚 [documentation-writer.md](./documentation-writer.md)
Expert technical writer for API docs, READMEs, and code comments.

**Use when:**
- Writing API documentation
- Creating README files
- Adding code comments
- Documenting complex logic

**Key features:**
- Clear, concise writing
- Practical examples
- Consistent format
- Comprehensive coverage

### 🐛 [bug-finder.md](./bug-finder.md)
Expert at finding bugs, edge cases, and potential issues.

**Use when:**
- Debugging issues
- Finding edge cases
- Security review
- Pre-deployment checks

**Key features:**
- Systematic analysis
- Common bug patterns
- Security vulnerability detection
- Prioritized findings

### ⚡ [performance-optimizer.md](./performance-optimizer.md)
Expert in analyzing and optimizing code performance.

**Use when:**
- Performance issues
- Optimizing algorithms
- Reducing memory usage
- Improving response times

**Key features:**
- Algorithm complexity analysis
- Optimization techniques
- Before/after benchmarks
- Measurable improvements

## How to Use

### Method 1: Via Claude Code Chat (Recommended)

In Claude Code, you can invoke agents in chat:

```
@code-reviewer Review the changes in src/auth.ts
```

### Method 2: Direct Reference

Copy the agent content and paste it as a system prompt or context.

### Method 3: Project-Specific

Copy agents you need to your project's `.claude/agents/` directory:

```bash
cp ~/.dotfiles/.claude/agents/code-reviewer.md ./.claude/agents/
```

## Creating Custom Agents

### Agent Structure

```markdown
# Agent Name

Brief description of the agent's role.

## Role
Define the agent's expertise and focus areas.

## Process
Step-by-step workflow the agent follows.

## Output Format
Structured format for agent responses.

## Guidelines
Best practices and considerations.
```

### Best Practices

1. **Single Responsibility**: Each agent should focus on one task
2. **Clear Instructions**: Provide specific, actionable guidance
3. **Structured Output**: Define consistent output format
4. **Include Examples**: Show concrete examples of input/output
5. **Checklists**: Use checklists for systematic analysis
6. **Prioritization**: Help agent prioritize findings/suggestions

### Example Custom Agent

```markdown
# Security Auditor Agent

You are an expert security auditor focused on finding vulnerabilities.

## Role
Identify security vulnerabilities in code:
- OWASP Top 10 issues
- Authentication/authorization flaws
- Data exposure risks
- etc.

## Process
1. Check input validation
2. Review authentication logic
3. Analyze data handling
4. etc.

## Output Format
### 🔒 Critical Vulnerabilities
[List with severity and fix suggestions]

### 🔍 Security Concerns
[Medium-risk issues]

### 💡 Security Recommendations
[General improvements]
```

## Agent Tips

### For Better Results

1. **Be Specific**: Give agents clear, focused tasks
   - ✅ "Review authentication logic for security issues"
   - ❌ "Check the code"

2. **Provide Context**: Share relevant information
   - Project requirements
   - Constraints or limitations
   - Existing patterns to follow

3. **Iterate**: Use agents in sequence
   - First: Bug Finder → find issues
   - Then: Refactoring → improve code
   - Finally: Test Writer → add tests
   - Last: Code Reviewer → final check

4. **Customize**: Modify agents for your needs
   - Add project-specific guidelines
   - Include team coding standards
   - Add language-specific patterns

### Agent Combinations

**Pre-Commit Workflow:**
1. Bug Finder → Find issues
2. Performance Optimizer → Check performance
3. Test Writer → Ensure coverage
4. Code Reviewer → Final review

**New Feature Workflow:**
1. Documentation Writer → Plan and document
2. Test Writer → Write tests first (TDD)
3. [Implement feature]
4. Bug Finder → Check for issues
5. Performance Optimizer → Optimize if needed
6. Code Reviewer → Review implementation

**Legacy Code Improvement:**
1. Code Reviewer → Assess current state
2. Bug Finder → Identify existing issues
3. Refactoring → Improve structure
4. Test Writer → Add test coverage
5. Documentation Writer → Document changes

## Contributing

To add new agents to this collection:

1. Create a new `.md` file in `.claude/agents/`
2. Follow the standard agent structure
3. Test the agent with various inputs
4. Update this README with agent description
5. Commit and push

## Resources

- [Claude Code Documentation](https://docs.anthropic.com/claude/docs)
- [GitHub Copilot Agents Best Practices](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/)
- [Effective Prompting Guide](https://docs.anthropic.com/claude/docs/prompt-engineering)

## License

These agents are part of the dotfiles repository and follow the same license.
