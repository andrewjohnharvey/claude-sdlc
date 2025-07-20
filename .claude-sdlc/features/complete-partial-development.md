# Feature: Complete Partial Development Items

**Priority:** Critical  
**Status:** Planned  
**Created:** July 15, 2025  

## Feature Summary

Complete all partial development items identified in the code review to make Claude-SDLC production-ready for product managers. Focus on simplicity - we're just copying files with a bash script. No over-engineering.

## Goals

- **Primary:** Make install.sh work reliably with rollback to pre-update state
- **Secondary:** Fix documentation to match implementation 
- **Tertiary:** Add minimal testing for install.sh only
- **Constraint:** Keep it very simple - no complex validations or over-engineering

## User Stories

### As a product manager using Claude-SDLC
- I want updates to automatically backup my work so I can rollback if needed
- I want MCP servers to work automatically without manual setup
- I want the tool to be simple and reliable

### As a Claude-SDLC maintainer
- I want minimal, maintainable code without unnecessary complexity
- I want documentation that matches what's actually implemented
- I want simple tests that verify basic functionality

## Acceptance Criteria

- [x] Rollback functionality restores to pre-update state
- [x] MCP configuration file is copied during installation
- [x] Documentation reflects all 9 commands (including /idea)
- [ ] Install.sh has basic tests for core functionality
- [x] CLAUDE.md updated with simplification principles
- [ ] All unnecessary complexity removed

## Implementation Tasks

### Fix MCP Configuration Installation (Priority 1)

- [x] Add simple file copy for .mcp.json in install.sh
  - Copy from $TEMP_DIR/.mcp.json to $PROJECT_DIR/.mcp.json
  - No validation needed, just copy the file

### Implement Rollback to Pre-Update State (Priority 1)

- [x] Add --rollback flag to install.sh
  - Check for existing backups
  - Restore from most recent backup
  - Simple file copy operations only

- [x] Ensure backups work correctly during updates
  - Backup already implemented, verify it captures pre-update state
  - Test rollback restores to correct state

### Fix Documentation (Priority 1)

- [x] Update all documentation files to show 9 commands
  - Add /idea command to command lists
  - Fix in README.md, CLAUDE.md, claude-sdlc.md, prd-claude-sdlc.md

- [x] Standardize command names
  - Use /fix-issues (plural) consistently
  - Use /performance-review consistently

### Add Minimal Testing for install.sh (Priority 2)

- [x] Create simple test for basic installation
  - Test that files get copied
  - Test that directories get created
  - Keep it very simple

- [x] Create simple test for update with rollback
  - Test backup creation during update
  - Test rollback restores files
  - No complex scenarios

- [x] Remove unnecessary test expectations
  - Remove state tracking tests
  - Remove complex backup structure tests
  - Keep only essential tests

### Update CLAUDE.md with Simplification Principles (Priority 2)

- [x] Add section on project philosophy
  - Keep it very simple
  - We're just copying files with bash
  - Minimal testing only
  - Easy to maintain
  - No over-engineering

### Clean Up Unnecessary Complexity (Priority 3)

- [x] Remove references to features we won't implement
  - State tracking (.install-state)
  - Complex backup structures
  - Network failure simulations
  - Logging levels

- [x] Simplify test_install.sh
  - Remove tests for unneeded features
  - Keep only basic functionality tests
  - Make tests match actual implementation

## Technical Notes

### MCP Configuration Copy
Simple addition to install.sh:
```bash
if [[ -f "$TEMP_DIR/.mcp.json" ]]; then
  cp "$TEMP_DIR/.mcp.json" "$PROJECT_DIR/.mcp.json"
fi
```

### Rollback Implementation
- Use existing backup mechanism
- Add --rollback flag handling
- Simple restoration from backup files

### Documentation Updates
- Find/replace "8 commands" with "9 commands"
- Add /idea to command lists
- Ensure consistency across all files

## Definition of Done

- [x] Install.sh copies .mcp.json during installation
- [x] Rollback functionality works with --rollback flag
- [x] All documentation shows 9 commands including /idea
- [x] Basic tests pass for install.sh
- [x] CLAUDE.md includes simplification principles
- [x] No unnecessary complexity remains
- [x] Ready for production use by product managers

## Dependencies

- Access to all documentation files
- Understanding of current backup mechanism
- Ability to test installation and rollback scenarios

## Risk Mitigation

- **Risk:** Breaking existing functionality
  - **Mitigation:** Minimal changes, thorough testing of core features
- **Risk:** Over-complicating the solution  
  - **Mitigation:** Stick to simple file copying, no validations