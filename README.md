# Claude-SDLC

A command suite for Claude Code that provides a complete software development lifecycle workflow.

## What is Claude-SDLC?

Claude-SDLC is an AI-powered toolkit for software developers who want to accelerate their development workflow. It automates repetitive SDLC tasks, enforces best practices, and improves development speed without sacrificing quality. Perfect for developers looking to:

- Plan and implement features faster with AI assistance
- Ensure consistent code quality through automated reviews
- Identify security vulnerabilities and performance bottlenecks
- Generate tests and fix issues with minimal manual effort

Claude-SDLC integrates seamlessly with Claude Code, allowing you to invoke powerful commands that handle complex tasks while you focus on creative problem-solving.

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

- `/create-feature` - Plan and define a new feature
- `/build` - Implement a planned feature
- `/code-review` - Perform a comprehensive code review
- `/security-audit` - Analyze code for security vulnerabilities
- `/architecture-review` - Review project architecture
- `/performance-audit` - Identify performance bottlenecks
- `/generate-tests` - Create tests for existing code
- `/fix-issue` - Fix a specific issue or bug

## Directory Structure

Claude-SDLC creates the following directory structure in your project:

```
.claude/
  commands/           # Command files for Claude Code
.claude-sdlc/
  features/           # Feature task lists
  architecture/       # Architecture documentation
  builds/             # Build reports
  reviews/            # Code review reports
```

## Customization

You can customize any command by editing the corresponding Markdown file in the `.claude/commands/` directory. See the [Customization Guide](examples/customization.md) for more details.

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

### Example: Adding a User Profile Feature

Let's say you want to add a user profile feature to your TypeScript application:

1. Run `/create-feature user-profile`
2. Claude-SDLC will generate a plan with tasks like:
   - Create user profile interface
   - Implement profile service
   - Add profile component
   - Create API endpoints
   - Write unit tests
3. Run `/build user-profile` to implement the feature
4. Review and test the generated code

That's it! You've successfully added a new feature to your TypeScript project using Claude-SDLC.

## Acknowledgments

This project was heavily inspired by the following repositories:

- [AI-SDLC](https://github.com/joinvai/ai-sdlc)
- [Claude-Command-Suite](https://github.com/qdhenry/Claude-Command-Suite)
- [SuperClaude](https://github.com/NomenAK/SuperClaude)

We're grateful to these projects for pioneering AI-assisted software development workflows and providing valuable insights for Claude-SDLC.
