# Claude-SDLC

A command suite for Claude Code that provides a complete software development lifecycle workflow.

## What is Claude-SDLC?

Claude-SDLC is an AI-powered toolkit for software developers who want to accelerate their development workflow. It automates repetitive SDLC tasks, enforces best practices, and improves development speed without sacrificing quality. Perfect for developers looking to:

- Plan and implement features faster with AI assistance
- Ensure consistent code quality through automated reviews
- Identify security vulnerabilities and performance bottlenecks
- Generate tests and fix issues with minimal manual effort

Claude-SDLC integrates seamlessly with Claude Code, allowing you to invoke powerful commands that handle complex tasks while you focus on creative problem-solving.

## Key Features

### 🎯 **Flexible Scope Targeting**
- **Targeted Analysis**: Focus reviews on specific files, directories, commits, or branches
- **Comprehensive Analysis**: Full codebase analysis when no arguments provided
- **Smart Context Awareness**: Commands adapt behavior based on provided arguments

### 🔄 **Systematic Quality Gates**
- Built-in quality checkpoints throughout all processes
- Automatic error detection and user notification
- Comprehensive reporting with actionable recommendations

### 🧪 **Advanced Testing Support**
- Multi-framework test generation (Jest, PyTest, JUnit, etc.)
- Coverage analysis and gap identification
- Special flags for automated test execution and coverage targets

### 🏗️ **Architecture-Aware Development**
- Consults existing architecture documentation
- Maintains design consistency across implementations
- Updates architectural documentation as projects evolve

### 📊 **Comprehensive Reporting**
- Timestamped reports for all operations
- Detailed build logs with task completion tracking
- Performance metrics and security vulnerability assessments

## Installation

### Prerequisites

Before installing Claude-SDLC, you need to:

1. Have Claude Code installed and configured
2. Initialize Claude Code in your project by running the `/init` command in Claude Code
   - This creates a `CLAUDE.md` file that stores project memory
   - For more details, see [Claude Code documentation](https://docs.anthropic.com/en/docs/claude-code/memory#set-up-project-memory)

### Install Claude-SDLC

You can install Claude-SDLC with a single command:

```bash
curl -fsSL https://raw.githubusercontent.com/andrewjohnharvey/claude-sdlc/main/install.sh | bash
```

If you encounter caching issues, try:

```bash
curl -H "Cache-Control: no-cache" -fsSL https://raw.githubusercontent.com/andrewjohnharvey/claude-sdlc/main/install.sh | bash
```

### Advanced Installation Options
You can customize the installation with various options:

#### Install to a specific project directory
```bash
curl -fsSL https://raw.githubusercontent.com/andrewjohnharvey/claude-sdlc/main/install.sh | bash -s -- --dir /path/to/project
```

#### Update an existing installation
```bash
curl -fsSL https://raw.githubusercontent.com/andrewjohnharvey/claude-sdlc/main/install.sh | bash -s -- --update
```
#### Preview changes without making them
```bash
curl -fsSL https://raw.githubusercontent.com/andrewjohnharvey/claude-sdlc/main/install.sh | bash -s -- --dry-run --verbose
```

#### Skip confirmations (for automation)
```bash
curl -fsSL https://raw.githubusercontent.com/andrewjohnharvey/claude-sdlc/main/install.sh | bash -s -- --force
```

#### Log all operations to a file

```bash
curl -fsSL https://raw.githubusercontent.com/andrewjohnharvey/claude-sdlc/main/install.sh | bash -s -- --log install.log
```

## Available Commands

After installation, the following commands will be available in Claude Code:

### Core Development Commands

- **`/create-feature`** - Plan and define a new feature with comprehensive task breakdown
  - Analyzes requirements and creates atomic task lists
  - Consults architecture documentation for design alignment
  - Generates feature files in `.claude-sdlc/features/`
  - Supports optional scaffolding of boilerplate code

- **`/build`** - Implement a planned feature by executing its task checklist
  - Loads feature plans from `.claude-sdlc/features/`
  - Executes tasks sequentially with quality gates
  - Supports parallel execution for independent tasks
  - Pauses on errors for user guidance
  - Generates comprehensive build reports

### Quality Assurance Commands

- **`/code-review`** - Comprehensive code quality analysis and review with flexible scope targeting
  - **Targeted Review**: `--args commit-hash`, `--args branch-name`, `--args file-path`, `--args directory-path`
  - **Comprehensive Review**: Reviews entire codebase when no arguments provided
  - Analyzes style, correctness, security, performance, and maintainability
  - Generates timestamped reports in `.claude-sdlc/reviews/`
  - Supports JSX/TSX files for React codebases

- **`/architecture-review`** - Analyze project architecture and design patterns for scalability
  - Evaluates modularity, scalability, and design consistency
  - Compares implementation with documented architecture
  - Identifies architectural debt and improvement opportunities
  - Creates reports in `.claude-sdlc/architecture-review/`

- **`/security-audit`** - Comprehensive security vulnerability assessment and analysis
  - Scans for hardcoded credentials, injection vulnerabilities, and insecure configurations
  - Analyzes dependencies for known vulnerabilities
  - Provides risk assessment and remediation guidance
  - Supports targeted audits with `--args` parameter

- **`/performance-review`** - Analyze codebase for performance bottlenecks and optimization opportunities
  - Identifies algorithmic inefficiencies and resource usage issues
  - Analyzes database queries, memory usage, and frontend performance
  - Supports targeted performance analysis with `--args` parameter
  - Generates reports in `.claude-sdlc/performance/`

### Testing and Issue Resolution Commands

- **`/generate-tests`** - Create comprehensive test cases to improve code coverage and reliability
  - Supports multiple testing frameworks (Jest, PyTest, JUnit, etc.)
  - Generates unit, integration, and edge case tests
  - **Special flags**: `--run-tests` (execute tests after generation), `--coverage-target=N`
  - Analyzes existing coverage and fills gaps

- **`/fix-issues`** - Identify and resolve specific code issues
  - Integrates with GitHub Issues via `gh` CLI
  - Performs root cause analysis and implements fixes
  - Creates fix reports in `.claude-sdlc/fixes/`
  - Supports automated testing of fixes

## Directory Structure

Claude-SDLC creates the following directory structure in your project:

```
.claude/
  commands/           # Command files for Claude Code
.claude-sdlc/
  features/           # Feature task lists created by /create-feature
  architecture/       # Architecture documentation and design specs
  builds/             # Build reports from /build and /generate-tests
  reviews/            # Code review reports from /code-review
  performance/        # Performance analysis reports from /performance-review
  fixes/              # Issue fix reports from /fix-issues
```

## Command Usage Examples

### Code Review Examples
```bash
# Comprehensive codebase review
/code-review

# Review specific file or directory
/code-review src/auth.js
/code-review src/components/

# Review specific commit or branch
/code-review HEAD~3
/code-review feature/user-auth

# Review pull request changes
/code-review PR#123
```

### Security Audit Examples
```bash
# Full security audit
/security-audit

# Audit specific component
/security-audit src/auth/

# Audit recent changes
/security-audit HEAD~3..HEAD
```

### Performance Review Examples
```bash
# Comprehensive performance review
/performance-review

# Review specific component
/performance-review src/api/

# Review recent changes for performance impact
/performance-review feature/optimization
```

### Test Generation Examples
```bash
# Generate tests for specific file
/generate-tests src/utils.js

# Generate tests with automatic execution
/generate-tests src/auth.js --run-tests

# Generate tests with coverage target
/generate-tests src/components/ --coverage-target=80
```

### Issue Resolution Examples
```bash
# Fix specific GitHub issue
/fix-issues 123

# Fix issue by description
/fix-issues login-error
```

## Customization

You can customize any command by editing the corresponding Markdown file in the `.claude/commands/` directory. All commands support the `$ARGUMENTS` parameter for flexible targeting and can be modified to fit your project's specific needs and conventions.

## Getting Started

This guide will walk you through using Claude-SDLC to add a feature to an existing TypeScript project.

### Prerequisites

- An existing TypeScript project
- Claude Code installed and configured
- Claude-SDLC installed (see installation instructions above)

### Adding a New Feature

1. **Plan your feature** using the `/create-feature` command:

#### In Claude Code, run:
```bash
/create-feature user-authentication
```

This will:
- Analyze your project structure
- Create a detailed task list for implementing user authentication
- Save the plan to `.claude-sdlc/features/user-authentication.md`

2. **Review the generated plan** in `.claude-sdlc/features/user-authentication.md`

3. **Implement the feature** using the `/build` command:

#### In Claude Code, run:
```bash
/build user-authentication
```

This will:
- Execute each task in the feature plan
- Generate TypeScript code following project conventions
- Create necessary components, services, and tests
- Mark tasks as completed as they're finished

4. **Review the implementation** and make any necessary adjustments

5. **Verify quality** with built-in review commands:

##### Run a comprehensive code review
```bash
/code-review
```

##### Check for security issues
```bash
/security-audit
```

##### Analyze performance
```bash
/performance-review
```

##### Generate additional tests if needed
```bash
/generate-tests user-authentication --run-tests
```

### Example: Adding a User Profile Feature

Let's say you want to add a user profile feature to your TypeScript application:

1. **Plan the feature**: Run `/create-feature user-profile`
   - Claude-SDLC will generate a comprehensive plan with tasks like:
     - Create user profile interface and types
     - Implement profile service with API integration
     - Add profile component with form validation
     - Create API endpoints with proper authentication
     - Write unit and integration tests
     - Update documentation

2. **Implement the feature**: Run `/build user-profile`
   - Executes each task in the checklist
   - Pauses if any errors occur for your review
   - Generates a detailed build report

3. **Quality assurance**: Run comprehensive reviews
   ```bash
   /code-review src/profile/          # Review the new profile code
   /security-audit src/profile/       # Check for security issues
   /performance-review src/profile/   # Analyze performance impact
   ```

4. **Generate additional tests if needed**:
   ```bash
   /generate-tests src/profile/ --run-tests --coverage-target=90
   ```

5. **Fix any issues found**:
   ```bash
   /fix-issues profile-validation-bug
   ```

That's it! You've successfully added a new feature to your TypeScript project using Claude-SDLC with comprehensive quality assurance.

## Acknowledgments

This project was heavily inspired by the following repositories:

- [AI-SDLC](https://github.com/joinvai/ai-sdlc)
- [Claude-Command-Suite](https://github.com/qdhenry/Claude-Command-Suite)
- [SuperClaude](https://github.com/NomenAK/SuperClaude)

We're grateful to these projects for pioneering AI-assisted software development workflows and providing valuable insights for Claude-SDLC.
