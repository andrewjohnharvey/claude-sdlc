# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Claude-SDLC is an AI-powered Software Development Life Cycle (SDLC) command suite designed for Claude Code. It provides 8 custom slash commands that automate and streamline common development workflows through structured, repeatable processes.

**Core Purpose**: Transform ad-hoc development prompts into systematic, well-defined workflows that ensure consistent best practices and improve development speed without sacrificing quality.

## Available Commands

The project provides 8 main slash commands that work together to form a complete SDLC workflow:

- `/create-feature` - Plan and define new features with atomic task breakdowns
- `/build` - Implement planned features automatically with AI assistance  
- `/code-review` - Perform comprehensive code quality, security, and performance reviews
- `/security-audit` - Deep security vulnerability analysis and hardening recommendations
- `/architecture-review` - High-level architectural analysis and design review
- `/performance-review` - Performance bottleneck identification and optimization suggestions
- `/generate-tests` - Automated test case generation for improved coverage
- `/fix-issues` - Targeted bug fixing and issue resolution workflow

## Installation and Setup

### Installation Method
Claude-SDLC uses a shell-based installation system rather than traditional package management:

```bash
# Basic installation
curl -fsSL https://raw.githubusercontent.com/andrewjohnharvey/claude-sdlc/main/install.sh | bash

# Install to specific directory
curl -fsSL https://raw.githubusercontent.com/andrewjohnharvey/claude-sdlc/main/install.sh | bash -s -- --dir /path/to/project

# Update existing installation
curl -fsSL https://raw.githubusercontent.com/andrewjohnharvey/claude-sdlc/main/install.sh | bash -s -- --update
```

### Directory Structure Created
The installation creates this structure in target projects:
```
project-root/
├── .claude/
│   └── commands/           # Command files copied here
└── .claude-sdlc/
    ├── features/           # Feature task lists
    ├── architecture/       # Architecture documentation  
    ├── builds/             # Build reports
    └── reviews/            # Code review reports
```

## Command Architecture

### Command Structure
- Each command is a Markdown file with structured instructions
- Uses `$ARGUMENTS` for dynamic parameter substitution
- Follows systematic step-by-step approaches
- Integrates shell commands via `!` prefix for git operations, testing, and builds
- Supports embedded shell scripts and complex pipelines

### Key Design Patterns
- **Idempotent operations** - Commands can be re-run safely
- **Context-aware execution** - Commands read project-specific docs from `.claude-sdlc/`
- **State persistence** - Progress tracked in Markdown checklists
- **Tool integration** - Leverages git, gh CLI, test runners, and build tools
- **Sub-agent parallelism** - Supports concurrent task execution

### Example Command Usage
```bash
# Plan a new feature
/create-feature user-authentication

# Implement the planned feature
/build user-authentication

# Review the implementation
/code-review

# Check for security issues
/security-audit
```

## Development Workflow

### Typical Development Cycle
1. Use `/create-feature` to plan new features (creates task lists in `.claude-sdlc/features/`)
2. Use `/build` to implement planned features (reads task lists, executes systematically)
3. Use review commands (`/code-review`, `/security-audit`, etc.) for quality assurance
4. Use `/fix-issues` for targeted bug resolution

### State Management
- **Feature Progress**: Tracked in Markdown checklists (`.claude-sdlc/features/*.md`)
- **Architecture Context**: Stored in `.claude-sdlc/architecture/*.md`
- **Build History**: Recorded in `.claude-sdlc/builds/*.md` with timestamps
- **Review Reports**: Saved in `.claude-sdlc/reviews/*.md`

## Important Implementation Details

### Command Execution Context
- Commands run within Claude Code's project slash command system
- Each command has access to the full project workspace
- Can execute shell commands and read command output
- Supports file operations (read, write, edit) across the project

### Error Handling and Safety
- Commands pause execution on errors and alert users
- Build process includes validation steps (compilation, tests)
- All operations are designed to be resumable after fixes
- Comprehensive logging in build and review reports

### Customization
- Commands can be customized by editing Markdown files in `.claude/commands/`
- Project-specific adaptations via `.claude-sdlc/architecture/` documentation
- No global installation - each project maintains its own command suite

## File Structure

```
claude-sdlc/
├── README.md                    # Installation and usage guide
├── prd-claude-sdlc.md          # Detailed product requirements
├── install.sh                  # Installation script
├── commands/                   # Source command definitions
│   ├── create-feature.md
│   ├── build.md
│   ├── code-review.md
│   ├── security-audit.md
│   ├── architecture-review.md
│   ├── performance-review.md
│   ├── generate-tests.md
│   └── fix-issues.md
└── examples/                   # Usage examples and guides
    ├── Real-World-Examples.md
    ├── customization.md
    └── [other example files]
```

## Key Insights for Development

1. **No Traditional Build System**: This is not a compiled project - the "build" refers to the `/build` command that implements features in target projects
2. **Command-Driven Architecture**: The core product is the command workflow definitions, not traditional application code
3. **Context-Aware AI**: Commands leverage project-specific context from `.claude-sdlc/` directories to make informed decisions
4. **Safety-First Design**: Includes validation steps, error handling, and human oversight checkpoints
5. **Parallel Execution**: Supports spawning sub-agents for concurrent task processing when appropriate

## Testing and Validation

Commands include built-in validation through:
- Test execution as part of workflows
- Code compilation checks
- Git operations for change tracking
- Quality assurance through automated reviews

No separate test framework is needed - validation is embedded within the command workflows themselves.

## Development Commands

### Installing Commands to Target Projects
```bash
# Basic installation
curl -fsSL https://raw.githubusercontent.com/andrewjohnharvey/claude-sdlc/main/install.sh | bash

# Test installation with dry run
curl -fsSL https://raw.githubusercontent.com/andrewjohnharvey/claude-sdlc/main/install.sh | bash -s -- --dry-run --verbose
```

### Modifying Commands
Commands are Markdown files in `commands/` directory. When editing:
- Maintain the `$ARGUMENTS` parameter substitution pattern
- Follow systematic step-by-step instruction format
- Include quality gates and error handling checkpoints
- Use `!` prefix for shell command execution examples

### Command Installation Process
The `install.sh` script:
1. Clones the repository to a temporary directory
2. Creates `.claude/commands/` and `.claude-sdlc/` structure in target project
3. Copies all `.md` files from `commands/` to target's `.claude/commands/`
4. Creates README files in each `.claude-sdlc/` subdirectory
5. Supports update mode, dry-run, and logging options