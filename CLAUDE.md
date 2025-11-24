# Project Context

[TODO: Brief project description - what does this project do?]

Example: "A web application for managing tasks and projects with real-time collaboration features."

## Tech Stack

[TODO: List your main technologies and versions]

Example:
- **Language**: TypeScript 5.x
- **Framework**: Next.js 14
- **Database**: PostgreSQL 15
- **Testing**: Jest, Playwright
- **Deployment**: Vercel

## Development Setup

```bash
# Install dependencies
[TODO: npm install / yarn install / pip install -r requirements.txt]

# Environment setup
[TODO: cp .env.example .env]
[TODO: List required environment variables]

# Database setup
[TODO: npm run db:migrate / python manage.py migrate]

# Start development server
[TODO: npm run dev / python manage.py runserver]
```

## Project Structure

```
[TODO: Describe your directory structure]

Example:
.
├── src/
│   ├── components/     # React components
│   ├── pages/         # Next.js pages
│   ├── lib/           # Utility functions
│   └── types/         # TypeScript types
├── tests/             # Test files
├── public/            # Static assets
└── docs/              # Documentation
```

## Code Conventions

### General Principles
- Write clear, self-documenting code
- Prefer composition over inheritance
- Keep functions small and focused
- Use meaningful variable and function names

### Naming Conventions
[TODO: Specify your naming conventions]

Example:
- **Files**: `kebab-case.ts` for components, `PascalCase.tsx` for React components
- **Variables**: `camelCase`
- **Constants**: `UPPER_SNAKE_CASE`
- **Classes**: `PascalCase`
- **Functions**: `camelCase`, verb-based names (`getUserData`, `calculateTotal`)

### Code Style
[TODO: Specify formatting rules]

Example:
- Use Prettier for formatting (config in `.prettierrc`)
- Use ESLint for linting (config in `.eslintrc`)
- Max line length: 100 characters
- Use single quotes for strings
- Always use semicolons

### Imports
[TODO: Specify import order and style]

Example:
```typescript
// 1. External libraries
import React from 'react'
import { useState } from 'react'

// 2. Internal modules
import { Button } from '@/components/Button'
import { useAuth } from '@/hooks/useAuth'

// 3. Types
import type { User } from '@/types'

// 4. Styles
import styles from './Component.module.css'
```

## Git Workflow

### Branch Naming
- `main` - Production-ready code
- `develop` - Development branch
- `feature/[description]` - New features
- `fix/[description]` - Bug fixes
- `refactor/[description]` - Code refactoring
- `docs/[description]` - Documentation updates

### Commit Messages
Use conventional commits format:
```
type(scope): subject

body (optional)

footer (optional)
```

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `perf`

**Examples**:
- `feat(auth): add password reset functionality`
- `fix(api): handle null response in user endpoint`
- `docs: update API documentation`

### Pull Request Process
1. Create feature branch from `develop`
2. Make changes and commit with clear messages
3. Write/update tests
4. Ensure all tests pass
5. Create PR with description
6. Request review from team
7. Address feedback
8. Merge after approval

## Testing

### Running Tests
```bash
[TODO: Add your test commands]

Example:
npm test              # Run all tests
npm run test:watch    # Run tests in watch mode
npm run test:coverage # Run tests with coverage
npm run test:e2e      # Run end-to-end tests
```

### Testing Conventions
[TODO: Specify testing patterns]

Example:
- Unit tests: `*.test.ts` or `*.spec.ts`
- Integration tests: `*.integration.test.ts`
- E2E tests: `tests/e2e/*.spec.ts`
- Test file location: Next to source file or in `__tests__` directory
- Aim for >80% code coverage

### Test Structure
```typescript
describe('ComponentName', () => {
  it('should do something specific', () => {
    // Arrange
    // Act
    // Assert
  })
})
```

## Security

### Never Commit
- API keys, tokens, secrets
- Database credentials
- Private keys (`.pem`, `.key`, `id_rsa*`)
- Environment files with real values (`.env`, `.env.local`)
- Personal information or credentials

### Use Environment Variables
All sensitive configuration should be in environment variables:
```bash
# .env.example (commit this)
DATABASE_URL=postgresql://localhost:5432/mydb
API_KEY=your_api_key_here

# .env (DO NOT commit this)
DATABASE_URL=postgresql://user:pass@prod-server/db
API_KEY=sk-real-api-key-123
```

### Security Checklist
- [ ] All secrets in environment variables
- [ ] `.env` in `.gitignore`
- [ ] Input validation on all user inputs
- [ ] SQL injection prevention (use parameterized queries)
- [ ] XSS prevention (escape user content)
- [ ] CSRF protection enabled
- [ ] Dependencies regularly updated
- [ ] Security headers configured

## Important Files

### Never Modify
- `.git/` - Git internals
- `node_modules/` or `venv/` - Dependencies
- `dist/` or `build/` - Build output
- Lock files (`package-lock.json`, `yarn.lock`, `poetry.lock`) - Use package manager

### Modify with Care
[TODO: List files that require careful consideration]

Example:
- `package.json` - Dependencies and scripts
- `.github/workflows/` - CI/CD pipelines
- Database migration files - Once applied, don't modify
- Configuration files (`.eslintrc`, `.prettierrc`, `tsconfig.json`)

### Generated Files
[TODO: List auto-generated files]

Example:
- `dist/`, `build/` - Build output (don't edit directly)
- `.next/` - Next.js cache
- `coverage/` - Test coverage reports
- API documentation generated from code

## Common Tasks

### Adding a New Feature
1. Create feature branch: `git checkout -b feature/new-feature`
2. Implement feature with tests
3. Update documentation if needed
4. Run tests: `npm test`
5. Commit changes: `git commit -m "feat: add new feature"`
6. Push and create PR

### Debugging
[TODO: Add debugging tips specific to your project]

Example:
- Use debugger in browser DevTools (place `debugger;` statement)
- Check logs: `npm run logs` or `docker logs [container]`
- Enable verbose logging: `DEBUG=* npm run dev`

### Database Changes
[TODO: Add database migration workflow]

Example:
```bash
# Create migration
npm run db:migration:create add_users_table

# Run migrations
npm run db:migrate

# Rollback
npm run db:migrate:rollback
```

## Development Workflow

### Daily Workflow
1. Pull latest changes: `git pull origin develop`
2. Install any new dependencies: `npm install`
3. Run migrations if needed: `npm run db:migrate`
4. Start dev server: `npm run dev`
5. Make changes and test
6. Commit with clear messages
7. Push and create PR when ready

### Code Review Guidelines
- Review for logic correctness
- Check test coverage
- Verify naming conventions
- Look for security issues
- Ensure documentation is updated
- Check for performance issues

## Claude Code Integration

### Custom Commands
Available slash commands for this project:
- `/review` - Review staged changes for quality and security
- `/lint` - Run linters on modified files
- `/commit-help` - Get help writing good commit messages

### Using Claude Code Effectively
- Reference specific files when asking questions
- Ask for tests when implementing new features
- Request code reviews before committing
- Use `/lint` before pushing changes

---

**Note**: This CLAUDE.md should be updated as the project evolves. Keep it concise and focused on information that helps understand and work with the codebase effectively.
