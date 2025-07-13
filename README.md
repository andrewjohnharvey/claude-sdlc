# Claude-SDLC

A command suite for Claude Code that provides a complete software development lifecycle workflow.

## Installation

You can install Claude-SDLC with a single command:

```bash
curl -fsSL https://raw.githubusercontent.com/andrewjohnharvey/claude-sdlc/main/install.sh | bash
```

### Advanced Installation Options

### Advanced Installation Options

#### Install to a specific project directory
```bash
curl -fsSL https://raw.githubusercontent.com/NomenAK/SuperClaude/main/install.sh | bash -s -- --dir /path/to/project
```

#### Update an existing installation
```bash
curl -fsSL https://raw.githubusercontent.com/NomenAK/SuperClaude/main/install.sh | bash -s -- --update
```
#### Preview changes without making them
```bash
curl -fsSL https://raw.githubusercontent.com/NomenAK/SuperClaude/main/install.sh | bash -s -- --dry-run --verbose
```

#### Skip confirmations (for automation)
```bash
curl -fsSL https://raw.githubusercontent.com/NomenAK/SuperClaude/main/install.sh | bash -s -- --force
```

#### Log all operations to a file

```bash
curl -fsSL https://raw.githubusercontent.com/NomenAK/SuperClaude/main/install.sh | bash -s -- --log install.log
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
