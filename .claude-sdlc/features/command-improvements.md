# Command-Improvements Feature

## Feature Summary
Enhance all claude-sdlc command .md files with three key improvements to make them more effective and user-friendly.

## Goals
- Add MCP integration awareness reminders to all commands
- Implement automatic file saving for all generated content
- Add CLAUDE.md referencing where most beneficial
- Maintain existing command structure while adding enhancements

## User Stories

### Story 1: MCP Integration Awareness
**As a** developer using claude-sdlc commands  
**I want** the AI to be reminded to check for available MCP servers  
**So that** I can leverage enhanced capabilities when available without making it mandatory

**Acceptance Criteria:**
- [x] All command .md files include MCP availability check reminders at command start
- [x] Reminders are optional suggestions, not requirements
- [x] Commands work seamlessly whether MCP servers are available or not

### Story 2: Automatic File Saving
**As a** developer using claude-sdlc commands  
**I want** all generated files to be automatically saved  
**So that** I don't lose work and have persistent access to generated content

**Acceptance Criteria:**
- [x] All commands that generate files include automatic saving instructions
- [x] Saving occurs after file work is completed
- [x] No manual intervention required for file persistence

### Story 3: CLAUDE.md Integration
**As a** developer using claude-sdlc commands  
**I want** commands to reference my project's CLAUDE.md file when relevant  
**So that** the AI follows my project-specific preferences and guidelines

**Acceptance Criteria:**
- [x] Key commands (build, architecture-review, generate-tests) check for CLAUDE.md
- [x] Commands prompt user to initialize CLAUDE.md if missing
- [x] CLAUDE.md content is referenced during command execution

## Development Tasks

### Phase 1: Analysis and Planning
- [x] Review all 8 command .md files to understand current structure
- [x] Identify optimal placement for MCP reminder sections
- [x] Determine which commands benefit most from CLAUDE.md referencing
- [x] Map out file saving touchpoints across all commands

### Phase 2: MCP Integration Reminders
- [x] Add MCP availability check section to /create-feature.md
- [x] Add MCP availability check section to /build.md
- [x] Add MCP availability check section to /code-review.md
- [x] Add MCP availability check section to /security-audit.md
- [x] Add MCP availability check section to /architecture-review.md
- [x] Add MCP availability check section to /performance-review.md
- [x] Add MCP availability check section to /generate-tests.md
- [x] Add MCP availability check section to /fix-issues.md

### Phase 3: Automatic File Saving
- [x] Update /create-feature.md with auto-save instructions for feature plans
- [x] Update /build.md with auto-save instructions for implementation files
- [x] Update /code-review.md with auto-save instructions for review reports
- [x] Update /security-audit.md with auto-save instructions for audit reports
- [x] Update /architecture-review.md with auto-save instructions for architecture docs
- [x] Update /performance-review.md with auto-save instructions for performance reports
- [x] Update /generate-tests.md with auto-save instructions for test files
- [x] Update /fix-issues.md with auto-save instructions for fix documentation

### Phase 4: CLAUDE.md Referencing
- [x] Add CLAUDE.md check to /build.md (high priority - implementation guidance)
- [x] Add CLAUDE.md check to /architecture-review.md (high priority - architectural patterns)
- [x] Add CLAUDE.md check to /generate-tests.md (high priority - testing preferences)
- [x] Add CLAUDE.md check to /code-review.md (medium priority - coding standards)
- [x] Add CLAUDE.md check to /create-feature.md (medium priority - planning preferences)
- [x] Add CLAUDE.md initialization prompts where missing

### Phase 5: Validation and Testing
- [x] Review updated command files for consistency
- [x] Test command execution flow with all improvements
- [x] Verify MCP reminders don't block command execution
- [x] Confirm file saving works across different command scenarios
- [x] Validate CLAUDE.md referencing enhances command effectiveness

## Implementation Notes

### MCP Integration Pattern
```markdown
## MCP Server Integration Check
Before proceeding, check if any MCP servers are available that could enhance this command:
- Context7: For documentation lookup and best practices
- Sequential Thinking: For complex problem-solving
- Convex: For database operations and real-time features  
- Playwright: For UI testing and automation
- Shadcn UI: For component standards and examples
- Other custom MCP servers

Use available MCP capabilities throughout the command execution when beneficial.
```

### File Saving Pattern
```markdown
## File Persistence
After completing work on any files:
- Automatically save all generated/modified files
- Confirm file locations with user
- No manual saving steps required
```

### CLAUDE.md Reference Pattern
```markdown
## Project Context Check
- Check if CLAUDE.md exists in project root
- If missing, prompt: "No CLAUDE.md found. Run `claude init` to create project-specific guidelines?"
- If present, reference for: [specific guidance needed for this command]
```

## Success Metrics
- All 8 command files updated with enhancements
- Commands maintain existing functionality while adding new capabilities
- No breaking changes to current command workflows
- Enhanced user experience through better AI awareness and automation

## Priority
High - Core infrastructure improvement affecting all claude-sdlc functionality