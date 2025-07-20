# Feature: Critical Security Fixes for install.sh

**Priority:** Critical  
**Status:** Planned  
**Created:** July 15, 2025  

## Feature Summary

Implement critical security fixes for the install.sh script to protect non-technical users' work during tool updates. This addresses code injection vulnerabilities, race conditions, and improves update robustness with backup/rollback capabilities.

## Goals

- **Primary:** Fix critical security vulnerabilities that could compromise user systems
- **Secondary:** Preserve all user work during updates (features, builds, reviews, etc.)
- **Tertiary:** Provide rollback capability for failed updates
- **Constraint:** Must be completed before any tool updates can be released

## User Stories

### As a non-technical product builder using claude-sdlc
- I want my work to be preserved when I update the tool
- I want the update process to be reliable and not fail halfway through
- I want to be able to rollback if an update goes wrong
- I want my custom MCP configurations to be backed up before changes

### As a claude-sdlc maintainer
- I want the installation script to be secure against code injection attacks
- I want concurrent installations to work without conflicts
- I want proper error handling and cleanup on failures
- I want the update mechanism to be robust and maintainable

## Acceptance Criteria

- [ ] Code injection vulnerability (eval usage) is eliminated
- [ ] Race conditions in temporary directory creation are fixed
- [ ] Proper error handling with cleanup on failures is implemented
- [ ] MCP configuration files are backed up before overwriting
- [ ] Custom command files are backed up before overwriting
- [ ] Network failure handling with retry logic is implemented
- [ ] Pre-flight validation prevents common installation failures
- [ ] Concurrent installation prevention is implemented
- [ ] Rollback capability is available for failed installations
- [ ] Directory structure creation is more maintainable and extensible
- [ ] All user work in .claude-sdlc/ directories is preserved during updates

## Implementation Tasks

### Critical Security Fixes (Priority 1)

- [ ] Fix code injection vulnerability in execute() function
  - Replace `eval "$@"` with direct command execution `"$@"`
  - Test that all existing functionality still works
  - Verify no command injection is possible

- [ ] Implement proper error handling with trap handlers
  - Add cleanup() function that runs on EXIT/ERR/INT/TERM/HUP
  - Ensure temporary directories are always cleaned up
  - Test script interruption scenarios (Ctrl+C, kill signals)

- [ ] Fix race condition in temporary directory creation
  - Replace `$(date +%s)` with `mktemp -d` for atomic creation
  - Test concurrent installation scenarios
  - Verify unique directory creation under load

### High Priority Robustness Improvements (Priority 2)

- [ ] Add MCP configuration backup mechanism
  - Backup .mcp.json before overwriting in UPDATE_MODE
  - Create .mcp.json.backup with timestamp
  - Log backup creation for user awareness
  - Test backup/restore functionality

- [ ] Implement network failure handling for git clone
  - Add timeout (30s) and retry logic (3 attempts)
  - Add repository integrity validation after clone
  - Handle network timeouts gracefully
  - Test with poor network conditions

- [ ] Add comprehensive pre-flight validation
  - Check write permissions to target directory
  - Validate minimum disk space requirements (10MB)
  - Verify required commands are available (git, date, mkdir, cp, rm)
  - Test validation failure scenarios

### Medium Priority Enhancements (Priority 3)

- [ ] Implement concurrent installation prevention
  - Add project-level locking mechanism (.claude-sdlc.lock)
  - Handle stale lock files from crashed installations
  - Test concurrent installation attempts
  - Provide clear error messages for locked installations

- [ ] Add command file backup mechanism
  - Backup .claude/commands/ directory before overwriting
  - Create timestamped backup directory
  - Log backup creation for user awareness
  - Test backup/restore functionality

- [ ] Improve repository validation
  - Validate git repository health with `git status`
  - Handle corrupted git repositories gracefully
  - Test with various git repository states
  - Provide clear error messages for git issues

- [ ] Refactor directory structure creation for maintainability
  - Create configuration-driven directory creation
  - Use associative arrays for directory definitions
  - Generate README files dynamically
  - Test directory creation with new structure

### Rollback Implementation (Priority 4)

- [ ] Design rollback mechanism
  - Create installation state tracking
  - Implement rollback function that restores backups
  - Add rollback command-line option (--rollback)
  - Test rollback scenarios after failed installations

- [ ] Add installation state tracking
  - Track installation progress in .claude-sdlc/.install-state
  - Detect partial installations on startup
  - Offer cleanup/retry options for partial installations
  - Test partial installation recovery

### Testing and Validation (Priority 5)

- [ ] Create comprehensive test scenarios
  - Test concurrent installation handling
  - Test network failure scenarios
  - Test partial failure recovery
  - Test update from various previous versions
  - Test permission and disk space edge cases

- [ ] Add enhanced logging and debugging
  - Add system information logging in verbose mode
  - Improve error messages with actionable guidance
  - Add security audit trail logging
  - Test logging in various scenarios

- [ ] Validate all security fixes
  - Run security-focused tests on fixed code
  - Verify no new vulnerabilities introduced
  - Test edge cases and error conditions
  - Perform code review of all changes

## Technical Notes

### Files to Modify
- `install.sh` - Main installation script requiring security fixes

### Key Security Fixes
1. **Code Injection (Line 69):** Replace `eval "$@"` with `"$@"`
2. **Race Condition (Line 11):** Replace `$(date +%s)` with `mktemp -d`
3. **Error Handling (Line 6):** Add trap handlers for proper cleanup
4. **MCP Backup (Lines 144-145):** Backup before overwriting
5. **Network Handling (Line 102):** Add timeout and retry logic

### Backup Strategy
- MCP configs: Create .mcp.json.backup before overwriting
- Command files: Create timestamped backup of .claude/commands/
- State tracking: Use .claude-sdlc/.install-state for partial installations

### Rollback Strategy
- Restore from backup files if installation fails
- Clean up partial installations and retry
- Provide --rollback option for manual recovery

## Definition of Done

- [ ] All critical security vulnerabilities are fixed
- [ ] All user work is preserved during updates
- [ ] Backup and rollback mechanisms are implemented and tested
- [ ] Installation script passes all security and robustness tests
- [ ] Code review confirms no new vulnerabilities introduced
- [ ] Documentation updated to reflect security improvements
- [ ] Ready for deployment to protect users during tool updates

## Dependencies

- Access to install.sh source code
- Test environment for concurrent installation testing
- Network simulation for failure testing
- Git repository for testing various repository states

## Risk Mitigation

- **Risk:** Breaking existing functionality while fixing security issues
  - **Mitigation:** Comprehensive testing of all existing workflows
- **Risk:** Backup mechanism consuming too much disk space
  - **Mitigation:** Implement cleanup of old backups after successful installations
- **Risk:** Rollback mechanism being too complex for users
  - **Mitigation:** Automatic rollback on failure, manual rollback as fallback option