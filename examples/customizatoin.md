# Customization Guide

Learn how to modify existing commands and create new ones to fit your specific workflow needs.

## Command Structure

Each command follows a consistent markdown structure:

```markdown
# Command Name

Brief description of what the command does.

## Instructions

Detailed step-by-step workflow that Claude Code will follow when executing the command.

1. **Step Category**
   - Specific action items
   - Tool usage recommendations
   - Quality checkpoints

2. **Next Step Category**
   - Additional actions
   - Validation steps
   - Output requirements
```

## Modifying Existing Commands

### Basic Modifications

To customize a command for your needs:

1. **Find the Command File:**
   ```bash
   # Commands are located in:
   .claude/commands/command-name.md
   ```

2. **Edit the Instructions:**
   ```bash
   # Open the command file in your editor
   code .claude/commands/code-review.md
   ```

3. **Modify the Workflow:**
   - Add project-specific steps
   - Remove unnecessary steps
   - Adjust tool preferences
   - Update quality criteria

### Example: Customizing Code Review

Original command might include generic steps. Customize for your stack:

```markdown
# Code Review

## Instructions

1. **Technology Stack Analysis**
   - Check React components for hooks usage patterns
   - Verify TypeScript strict mode compliance
   - Review Next.js routing conventions
   - Assess Tailwind CSS class organization

2. **Project-Specific Quality Checks**
   - Ensure all API calls use our custom `useAPI` hook
   - Verify component props match our TypeScript interfaces
   - Check that error boundaries are properly implemented
   - Review accessibility compliance with our WCAG standards
```

### Adding Project Context

Include project-specific information:

```markdown
## Instructions

1. **Pre-Analysis Setup**
   - Review project documentation in `/docs` folder
   - Check current sprint goals in SPRINT.md
   - Verify compliance with team coding standards in STANDARDS.md
   - Consider architectural decisions recorded in `/docs/adrs/`
```

## Creating New Commands

### Step 1: Create the Command File

```bash
# Create a new command file
touch .claude/commands/deploy-staging.md
```

### Step 2: Define the Command Structure

```markdown
# Deploy to Staging

Deploy the current branch to staging environment with pre-deployment checks.

## Instructions

1. **Pre-deployment Validation**
   - Run all tests and ensure they pass
   - Verify build process completes successfully
   - Check for any uncommitted changes
   - Validate environment variables are set

2. **Deployment Process**
   - Build the application for staging
   - Run database migrations if needed
   - Deploy to staging server
   - Verify deployment health checks

3. **Post-deployment Verification**
   - Run smoke tests against staging
   - Check application logs for errors
   - Verify critical user flows work
   - Update deployment tracking
```

### Step 3: Test Your Command

```bash
# Test the new command in Claude Code
claude code
/project:deploy-staging
```

## Advanced Customization

### Using Command Arguments

Commands can accept arguments via the `$ARGUMENTS` placeholder:

```markdown
# Create Feature

Create a new feature with the name provided in arguments.

## Instructions

1. **Feature Planning**
   - Create feature branch: `feature/$ARGUMENTS`
   - Generate feature specification for "$ARGUMENTS"
   - Plan component architecture for $ARGUMENTS feature

2. **Implementation**
   - Create base components for $ARGUMENTS
   - Implement core functionality
   - Add tests for $ARGUMENTS feature
```

### Conditional Logic

Add logic based on project characteristics:

```markdown
## Instructions

1. **Framework Detection**
   - If package.json contains "react": Use React-specific patterns
   - If package.json contains "vue": Use Vue-specific patterns  
   - If Cargo.toml exists: Use Rust-specific approaches
   - If requirements.txt exists: Use Python-specific tools

2. **Environment-Specific Steps**
   - Development: Include debugging tools and verbose logging
   - Production: Focus on performance and security
   - Testing: Emphasize test coverage and mocking
```

### Multi-Step Workflows

Create complex workflows that span multiple sessions:

```markdown
# Epic Implementation

Implement a large feature across multiple work sessions.

## Instructions

1. **Session 1: Planning and Architecture**
   - Break down epic into user stories
   - Design system architecture changes
   - Create technical specification
   - Set up project tracking

2. **Session 2-N: Implementation Phases**
   - Implement one user story at a time
   - Create tests for each component
   - Review and refactor after each story
   - Update documentation continuously

3. **Final Session: Integration and Deployment**
   - Integrate all components
   - Run comprehensive testing
   - Prepare deployment pipeline
   - Create deployment documentation
```

## Language-Specific Commands

### JavaScript/TypeScript Projects

```markdown
# JS Code Review

## Instructions

1. **JavaScript-Specific Checks**
   - Verify ESLint configuration and compliance
   - Check TypeScript types and interfaces
   - Review package.json dependencies for security
   - Assess bundle size and optimization opportunities

2. **Framework-Specific Analysis**
   - React: Check hooks usage, component patterns, state management
   - Node.js: Review API design, middleware usage, error handling
   - Next.js: Assess routing, SSR/SSG usage, performance
```

### Python Projects

```markdown
# Python Code Review

## Instructions

1. **Python-Specific Analysis**
   - Check PEP 8 compliance
   - Review virtual environment setup
   - Assess requirements.txt/pyproject.toml
   - Verify type hints usage

2. **Framework-Specific Checks**
   - Django: Review models, views, URL patterns
   - Flask: Check route definitions, middleware
   - FastAPI: Verify async patterns, Pydantic models
```

## Best Practices for Custom Commands

### 1. Keep Commands Focused

Each command should have a single, clear purpose:

```markdown
# Good: Focused command
# Security Audit

# Avoid: Kitchen-sink command  
# Code Review and Security Audit and Performance Check
```

### 2. Use Clear Step Categories

Organize instructions with descriptive headings:

```markdown
1. **Pre-Analysis Setup**
2. **Core Analysis**  
3. **Report Generation**
4. **Follow-up Actions**
```

### 3. Include Quality Gates

Add validation steps throughout:

```markdown
2. **Implementation**
   - Create the feature component
   - **Quality Gate**: Ensure component passes TypeScript compilation
   - Add unit tests
   - **Quality Gate**: Verify test coverage above 80%
```

### 4. Make Commands Reusable

Avoid hardcoding specific values:

```markdown
# Good: Generic approach
- Review all API endpoints for security vulnerabilities

# Avoid: Hardcoded specifics
- Review the /api/users endpoint for SQL injection
```

### 5. Provide Context

Help Claude understand the project context:

```markdown
1. **Context Analysis**
   - Review project README for domain understanding
   - Check ARCHITECTURE.md for system design
   - Understand business requirements from requirements/
```

## Sharing Custom Commands

### Team Commands

Create a shared command set for your team:

```bash
# Create team-specific commands directory
mkdir team-commands/

# Copy base commands and customize
cp .claude/commands/*.md team-commands/
# Customize for team standards

# Share via git repository
git add team-commands/
git commit -m "Add team-specific Claude commands"
```

### Company Standards

Embed company standards into commands:

```markdown
## Instructions

1. **Company Standards Compliance**
   - Verify code follows CompanyName coding standards
   - Check that security review checklist is completed
   - Ensure accessibility standards (WCAG 2.1 AA) are met
   - Validate API design follows company REST guidelines
```

## Troubleshooting Custom Commands

### Command Not Working

1. **Check File Format:**
   ```bash
   # Ensure proper markdown format
   head -n 10 .claude/commands/your-command.md
   ```

2. **Validate Structure:**
   - First line must be `# Command Name`
   - Must have `## Instructions` section
   - Use consistent markdown formatting

3. **Test Incrementally:**
   - Start with simple commands
   - Add complexity gradually
   - Test each change

### Command Too Complex

If Claude struggles with complex commands:

1. **Break Into Smaller Commands:**
   ```bash
   # Instead of one large command
   /project:full-deployment

   # Create smaller, focused commands
   /project:pre-deploy-check
   /project:deploy-app
   /project:post-deploy-verify
   ```

2. **Simplify Instructions:**
   - Use clear, actionable language
   - Avoid ambiguous requirements
   - Provide specific examples

### Debugging Commands

Add debugging information to commands:

```markdown
## Instructions

1. **Debug Information**
   - Print current working directory
   - List relevant files in project
   - Show current git branch and status
   - Display environment variables (if safe)

2. **Validation Steps**
   - Confirm each step completion before proceeding
   - Log important decisions and findings
   - Save intermediate results for review
```

This customization guide should help you tailor the commands to your specific needs and create new workflows that match your development process.