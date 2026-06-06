# Claude Code Agents

This directory contains reusable agents for Claude Code that help with both coding and general development tasks.

## What are Agents?

Agents are specialized AI assistants with specific expertise and workflows. Each agent has:
- A defined role and expertise area
- Systematic processes and checklists
- Structured output formats
- Best practices and guidelines

## Available Agents

### 📋 General & Planning

#### 📊 [project-manager.md](./project-manager.md)
Expert project manager for planning, task breakdown, and execution strategy.

**Use when:**
- Starting a new project
- Breaking down complex work
- Estimating effort and timelines
- Managing priorities

**Key features:**
- Task decomposition
- Dependency mapping
- Risk assessment
- Timeline planning

#### 🔬 [research-assistant.md](./research-assistant.md)
Expert research assistant for investigating technologies and comparing options.

**Use when:**
- Evaluating technologies or tools
- Comparing alternatives
- Making technology decisions
- Investigating best practices

**Key features:**
- Systematic research process
- Comparison matrices
- Trade-off analysis
- Sourced recommendations

#### 🎯 [decision-maker.md](./decision-maker.md)
Expert at analyzing options and making well-informed decisions.

**Use when:**
- Choosing between alternatives
- Evaluating trade-offs
- Making architectural decisions
- Risk assessment

**Key features:**
- Decision frameworks (SWOT, decision matrices)
- Risk analysis
- Bias awareness
- Confidence levels

#### 🏗️ [system-design.md](./system-design.md)
Expert system architect for designing scalable and reliable systems.

**Use when:**
- Designing new systems
- Architecture planning
- Scalability considerations
- System documentation

**Key features:**
- Architecture patterns
- Scalability strategies
- Reliability patterns
- Design documentation

### 💻 Code-Specific

#### 🔍 [code-reviewer.md](./code-reviewer.md)
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

#### 🧪 [test-writer.md](./test-writer.md)
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

#### ♻️ [refactoring.md](./refactoring.md)
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

#### 📚 [documentation-writer.md](./documentation-writer.md)
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

#### 🐛 [bug-finder.md](./bug-finder.md)
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

#### ⚡ [performance-optimizer.md](./performance-optimizer.md)
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

Each agent is a subagent: a Markdown file with YAML frontmatter (`name`,
`description`, optional `tools`/`model`) whose body is the system prompt.
Claude Code discovers any `*.md` file in `.claude/agents/` automatically.

### Method 1: Automatic delegation (Recommended)

Claude reads each agent's `description` and delegates matching tasks to it
on its own. Write clear descriptions so this works well — just describe
your task naturally:

```
Review the changes in src/auth.ts
Break this feature down into tasks
Compare React vs Vue for this project
```

### Method 2: Explicit request

Ask Claude to use a specific agent by name:

```
Use the code-reviewer agent on the staged diff
Have the system-design agent draft the architecture
```

### Method 3: Project-Specific

Copy agents you need to a project's `.claude/agents/` directory (project
agents override user-level ones with the same name):

```bash
cp ~/.dotfiles/.claude/agents/project-manager.md ./.claude/agents/
```

## Agent Workflows

### Starting a New Project

1. **Project Manager** → Define scope and break into tasks
2. **Research Assistant** → Evaluate technology options
3. **Decision Maker** → Choose technologies
4. **System Design** → Design architecture

### Feature Development

1. **Project Manager** → Break down feature into tasks
2. **System Design** → Design component architecture
3. **Documentation Writer** → Document API design
4. **Test Writer** → Write tests first (TDD)
5. [Implement feature]
6. **Code Reviewer** → Review implementation
7. **Bug Finder** → Check for issues
8. **Performance Optimizer** → Optimize if needed

### Code Improvement

1. **Code Reviewer** → Assess current state
2. **Bug Finder** → Identify existing issues
3. **Decision Maker** → Prioritize improvements
4. **Refactoring** → Improve code structure
5. **Test Writer** → Add test coverage
6. **Documentation Writer** → Update docs

### Learning & Research

1. **Research Assistant** → Research best practices and technologies
2. [Practice and experiment]
3. **Decision Maker** → Evaluate what to adopt
4. **Project Manager** → Plan integration
5. **Documentation Writer** → Document learnings

### Problem Solving

1. **Research Assistant** → Research problem and solutions
2. **Decision Maker** → Evaluate options
3. **System Design** → Design solution architecture
4. **Project Manager** → Plan implementation
5. **Bug Finder** → Review for issues

## Creating Custom Agents

### Agent Structure

A subagent needs YAML frontmatter. Only `name` and `description` are
required; `tools` and `model` are optional (tools are inherited if omitted,
model defaults to `inherit`):

```markdown
---
name: agent-name
description: Use this agent when ... (this is how Claude decides to delegate)
tools: Read, Grep, Glob, Bash
model: sonnet
---

# Agent Name

System prompt: define the agent's role, process, output format, and guidelines.
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
---
name: security-auditor
description: Use this agent to audit code for vulnerabilities (OWASP Top 10, auth flaws, data exposure).
tools: Read, Grep, Glob, Bash
model: sonnet
---

# Security Auditor Agent

You are an expert security auditor focused on finding vulnerabilities.

## Role
Identify security vulnerabilities in code:
- OWASP Top 10 issues
- Authentication/authorization flaws
- Data exposure risks

## Process
1. Check input validation
2. Review authentication logic
3. Analyze data handling

## Output Format
### 🔒 Critical Vulnerabilities
[List with severity and fix suggestions]
```

## Agent Tips

### For Better Results

1. **Be Specific**: Give agents clear, focused tasks
   - ✅ "Compare GraphQL vs REST for our mobile app backend"
   - ❌ "What should I use?"

2. **Provide Context**: Share relevant information
   - Project requirements
   - Constraints or limitations
   - Existing patterns to follow

3. **Iterate**: Use agents in sequence
   - Research → Decide → Design → Implement → Review

4. **Customize**: Modify agents for your needs
   - Add project-specific guidelines
   - Include team coding standards
   - Add language-specific patterns

### Quick Reference

**Planning Phase:**
- Project Manager
- Research Assistant
- Decision Maker
- System Design

**Implementation Phase:**
- Test Writer (TDD)
- Code Reviewer
- Bug Finder
- Performance Optimizer

**Learning Phase:**
- Research Assistant
- Documentation Writer

**Improvement Phase:**
- Code Reviewer
- Refactoring
- Bug Finder
- Documentation Writer

## Contributing

To add new agents to this collection:

1. Create a new `.md` file in `.claude/agents/`
2. Follow the standard agent structure
3. Test the agent with various inputs
4. Update this README with agent description
5. Commit and push

## Resources

- [Claude Code: Subagents](https://code.claude.com/docs/en/sub-agents)
- [Claude Code: Skills](https://code.claude.com/docs/en/skills)
- [Claude Code Documentation](https://code.claude.com/docs)
- [wshobson/agents](https://github.com/wshobson/agents) - Inspiration for this collection

## License

These agents are part of the dotfiles repository and follow the same license.
