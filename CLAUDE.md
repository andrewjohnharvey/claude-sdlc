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

### Prerequisites
Before installing Claude-SDLC, ensure you have:
- Claude Code v1.0+ installed and configured
- Node.js installed (required for MCP servers)
- Git repository initialized in your project

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

### MCP Server Configuration
Claude-SDLC includes integrated MCP (Model Context Protocol) servers that enhance command capabilities:

#### Included MCP Servers
- **Context7**: Documentation lookup and library information
- **Playwright**: Browser automation and UI testing
- **Shadcn UI**: Component library integration and examples

#### Installation Process
1. **Automatic Setup**: The `.mcp.json` file is included in the repository for project-level MCP configuration
2. **Claude Code Integration**: MCP servers are automatically discovered when opening the project in Claude Code
3. **First-Time Setup**: Claude Code will prompt to install and trust the MCP servers on first use

#### Manual MCP Server Installation
If needed, install MCP servers manually:
```bash
# Install all required MCP servers
npx -y @upstash/context7-mcp@latest &
npx -y @playwright/mcp@latest &
npx -y shadcn-ui-mcp-server &
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

### Testing Command Installation
```bash
# Test the installation script locally
bash install.sh --dry-run --verbose

# Install to a test directory
bash install.sh --dir /tmp/test-project --force

# Update existing installation in current directory
bash install.sh --update
```

### Command Development Workflow
1. **Edit commands**: Modify `.md` files in `commands/` directory
2. **Test locally**: Use `--dry-run` to preview changes before installation
3. **Validate**: Test command functionality in a sample project
4. **Version**: Commit changes to ensure consistency across installations

### Modifying Commands
Commands are Markdown files in `commands/` directory. When editing:
- Maintain the `$ARGUMENTS` parameter substitution pattern
- Follow systematic step-by-step instruction format
- Include quality gates and error handling checkpoints
- Use `!` prefix for shell command execution examples
- Test command behavior with various argument patterns

### Command Installation Process
The `install.sh` script:
1. Clones the repository to a temporary directory (`/tmp/claude-sdlc-{timestamp}`)
2. Creates `.claude/commands/` and `.claude-sdlc/` structure in target project
3. Copies all `.md` files from `commands/` to target's `.claude/commands/`
4. Creates README files in each `.claude-sdlc/` subdirectory
5. Supports update mode, dry-run, logging, and force options
6. Validates git repository and handles existing installations gracefully

### Installation Script Options
- `--dir /path` - Install to specific directory
- `--update` - Update existing installation
- `--dry-run` - Preview changes without making them
- `--verbose` - Detailed logging output
- `--force` - Skip confirmations
- `--log file.log` - Log operations to file

## MCP Integration and Enhanced Capabilities

### MCP-Enhanced Command Features

The Claude-SDLC commands leverage MCP servers to provide enhanced functionality:

#### `/code-review` with Context7
- **Documentation Lookup**: Automatically references official documentation for libraries and frameworks
- **Best Practices**: Compares code against documented best practices
- **API Validation**: Verifies API usage against current documentation

#### `/generate-tests` with Playwright
- **UI Testing**: Generates browser automation tests for web applications
- **End-to-End Testing**: Creates comprehensive user journey tests
- **Visual Testing**: Includes screenshot and visual regression testing

#### All Commands with Shadcn UI
- **Component Standards**: Ensures consistent UI component usage
- **Design System Compliance**: Validates against design system patterns
- **Accessibility**: Checks component accessibility standards

### MCP Configuration Management

#### Project-Level Configuration (`.mcp.json`)
The project includes a standardized MCP configuration:
```json
{
  "mcpServers": {
    "Context7": { "type": "stdio", "command": "npx", "args": ["-y", "@upstash/context7-mcp@latest"] },
    "Playwright": { "type": "stdio", "command": "npx", "args": ["-y", "@playwright/mcp@latest"] },
    "Shadcn UI": { "type": "stdio", "command": "npx", "args": ["-y", "shadcn-ui-mcp-server"] }
  }
}
```

#### Troubleshooting MCP Issues

**MCP Servers Not Loading**:
```bash
# Check MCP server status
claude mcp list

# Restart MCP servers
claude mcp restart

# Verify Node.js installation
node --version
npm --version
```

**Permission Issues**:
- Ensure MCP servers are trusted in Claude Code settings
- Check that `.mcp.json` is in the project root
- Verify network access for MCP server downloads

**Performance Issues**:
- MCP servers run as separate processes
- Large projects may need increased timeout settings
- Consider disabling unused MCP servers for better performance

### Best Practices for MCP Integration

1. **Selective Usage**: Enable only MCP servers relevant to your project type
2. **Resource Management**: MCP servers consume system resources; monitor usage
3. **Version Control**: Include `.mcp.json` in version control for team consistency
4. **Documentation**: Document project-specific MCP server configurations
5. **Testing**: Verify MCP functionality after Claude Code updates