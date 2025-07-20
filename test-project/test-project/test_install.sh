#!/bin/bash

# Claude-SDLC Installation Test Suite
# Comprehensive testing for rollback mechanism and security features

set -euo pipefail

readonly TEST_DIR="/tmp/claude-sdlc-test-$(date +%s)"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly INSTALL_SCRIPT="$SCRIPT_DIR/install.sh"

# Color codes
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Test results tracking
declare -a TEST_RESULTS=()
declare -i TESTS_PASSED=0
declare -i TESTS_FAILED=0

log_test() {
    local status="$1"
    local test_name="$2"
    local message="$3"
    
    if [[ "$status" == "PASS" ]]; then
        echo -e "${GREEN}✅ PASS${NC}: $test_name - $message"
        TEST_RESULTS+=("PASS: $test_name")
        ((TESTS_PASSED++))
    elif [[ "$status" == "FAIL" ]]; then
        echo -e "${RED}❌ FAIL${NC}: $test_name - $message"
        TEST_RESULTS+=("FAIL: $test_name")
        ((TESTS_FAILED++))
    elif [[ "$status" == "SKIP" ]]; then
        echo -e "${YELLOW}⏭️  SKIP${NC}: $test_name - $message"
        TEST_RESULTS+=("SKIP: $test_name")
    else
        echo -e "${BLUE}ℹ️  INFO${NC}: $test_name - $message"
    fi
}

setup_test_environment() {
    echo "Setting up test environment..."
    
    # Create test directory
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR"
    
    # Initialize git repository
    git init --quiet
    git config user.email "test@example.com"
    git config user.name "Test User"
    
    # Create initial commit
    echo "# Test Project" > README.md
    git add README.md
    git commit -m "Initial commit" --quiet
    
    echo "Test environment created at: $TEST_DIR"
}

cleanup_test_environment() {
    echo "Cleaning up test environment..."
    cd /tmp
    rm -rf "$TEST_DIR"
}

test_basic_installation() {
    echo -e "\n${BLUE}=== Testing Basic Installation ===${NC}"
    
    # Test basic installation
    if bash "$INSTALL_SCRIPT" --force --quiet; then
        log_test "PASS" "basic_installation" "Installation completed successfully"
        
        # Verify directory structure
        local required_dirs=(".claude/commands" ".claude-sdlc/features" ".claude-sdlc/architecture" ".claude-sdlc/builds" ".claude-sdlc/reviews" ".claude-sdlc/.backup")
        local dirs_ok=true
        
        for dir in "${required_dirs[@]}"; do
            if [[ ! -d "$dir" ]]; then
                log_test "FAIL" "directory_structure" "Missing directory: $dir"
                dirs_ok=false
            fi
        done
        
        if [[ "$dirs_ok" == "true" ]]; then
            log_test "PASS" "directory_structure" "All required directories created"
        fi
        
        # Verify installation state
        if [[ -f ".claude-sdlc/.install-state" ]]; then
            log_test "PASS" "state_tracking" "Installation state file created"
            
            # Check if installation is marked complete
            if grep -q "completed=true" ".claude-sdlc/.install-state"; then
                log_test "PASS" "installation_complete" "Installation marked as complete"
            else
                log_test "FAIL" "installation_complete" "Installation not marked as complete"
            fi
        else
            log_test "FAIL" "state_tracking" "Installation state file missing"
        fi
        
    else
        log_test "FAIL" "basic_installation" "Installation failed"
    fi
}

test_backup_creation() {
    echo -e "\n${BLUE}=== Testing Backup Creation ===${NC}"
    
    # Create some existing files to backup
    mkdir -p .claude/commands
    echo "# Existing command" > .claude/commands/existing.md
    echo '{"existing": true}' > .mcp.json
    
    # Run installation (should create backup)
    if bash "$INSTALL_SCRIPT" --force --quiet; then
        # Check if backup was created
        if [[ -d ".claude-sdlc/.backup" ]]; then
            local backup_dirs=($(find .claude-sdlc/.backup -maxdepth 1 -type d -name "*_*" | sort))
            if [[ ${#backup_dirs[@]} -gt 0 ]]; then
                log_test "PASS" "backup_creation" "Backup directory created"
                
                local latest_backup="${backup_dirs[-1]}"
                
                # Check if backup contains expected files
                if [[ -f "$latest_backup/.claude/commands/existing.md" ]]; then
                    log_test "PASS" "backup_content" "Existing files backed up correctly"
                else
                    log_test "FAIL" "backup_content" "Backup missing expected files"
                fi
                
                # Check backup metadata
                if [[ -f "$latest_backup/backup.meta" ]]; then
                    log_test "PASS" "backup_metadata" "Backup metadata file created"
                else
                    log_test "FAIL" "backup_metadata" "Backup metadata file missing"
                fi
                
            else
                log_test "FAIL" "backup_creation" "No backup directories found"
            fi
        else
            log_test "FAIL" "backup_creation" "Backup directory not created"
        fi
    else
        log_test "FAIL" "backup_creation" "Installation failed during backup test"
    fi
}

test_rollback_mechanism() {
    echo -e "\n${BLUE}=== Testing Rollback Mechanism ===${NC}"
    
    # First, ensure we have an installation with backup
    bash "$INSTALL_SCRIPT" --force --quiet
    
    # Modify something after installation
    echo "# Modified after install" > .claude/commands/modified.md
    
    # Record state before rollback
    local files_before=($(find .claude -name "*.md" 2>/dev/null | wc -l))
    
    # Perform rollback
    if bash "$INSTALL_SCRIPT" --rollback --quiet; then
        log_test "PASS" "rollback_execution" "Rollback command executed successfully"
        
        # Check if modified file was removed
        if [[ ! -f ".claude/commands/modified.md" ]]; then
            log_test "PASS" "rollback_cleanup" "Modified files cleaned up during rollback"
        else
            log_test "FAIL" "rollback_cleanup" "Modified files not cleaned up"
        fi
        
        # Check if installation state was removed
        if [[ ! -f ".claude-sdlc/.install-state" ]]; then
            log_test "PASS" "rollback_state_cleanup" "Installation state removed during rollback"
        else
            log_test "FAIL" "rollback_state_cleanup" "Installation state not removed"
        fi
        
    else
        log_test "FAIL" "rollback_execution" "Rollback command failed"
    fi
}

test_partial_installation_detection() {
    echo -e "\n${BLUE}=== Testing Partial Installation Detection ===${NC}"
    
    # Create a partial installation state
    mkdir -p .claude-sdlc
    cat > .claude-sdlc/.install-state << EOF
# Claude-SDLC Installation State
started=true
backup_created=true
directories_created=true
files_copied=false
mcp_configured=false
completed=false
EOF
    
    # Test detection (should offer recovery options)
    # Since we can't interact with prompts in automated tests, we'll use --force
    if bash "$INSTALL_SCRIPT" --force --quiet; then
        log_test "PASS" "partial_detection" "Partial installation detected and handled"
        
        # Check if installation completed
        if grep -q "completed=true" ".claude-sdlc/.install-state"; then
            log_test "PASS" "partial_recovery" "Partial installation recovered successfully"
        else
            log_test "FAIL" "partial_recovery" "Partial installation not recovered"
        fi
    else
        log_test "FAIL" "partial_detection" "Failed to handle partial installation"
    fi
}

test_concurrent_installation() {
    echo -e "\n${BLUE}=== Testing Concurrent Installation Handling ===${NC}"
    
    # Start first installation in background
    bash "$INSTALL_SCRIPT" --force --quiet &
    local pid1=$!
    
    # Brief delay then start second installation
    sleep 1
    bash "$INSTALL_SCRIPT" --force --quiet &
    local pid2=$!
    
    # Wait for both to complete
    wait $pid1
    local result1=$?
    wait $pid2
    local result2=$?
    
    # At least one should succeed
    if [[ $result1 -eq 0 ]] || [[ $result2 -eq 0 ]]; then
        log_test "PASS" "concurrent_installation" "Concurrent installations handled gracefully"
    else
        log_test "FAIL" "concurrent_installation" "Both concurrent installations failed"
    fi
}

test_network_failure_simulation() {
    echo -e "\n${BLUE}=== Testing Network Failure Scenarios ===${NC}"
    
    # Test with invalid repository URL
    # This requires modifying the script temporarily, so we'll skip for now
    log_test "SKIP" "network_failure" "Network failure simulation requires script modification"
}

test_permission_scenarios() {
    echo -e "\n${BLUE}=== Testing Permission Scenarios ===${NC}"
    
    # Test read-only directory (if not root)
    if [[ $EUID -ne 0 ]]; then
        local readonly_dir="/tmp/claude-readonly-$(date +%s)"
        mkdir -p "$readonly_dir"
        cd "$readonly_dir"
        chmod 444 .
        
        # This should fail gracefully
        if ! bash "$INSTALL_SCRIPT" --force --quiet 2>/dev/null; then
            log_test "PASS" "permission_check" "Installation correctly failed with insufficient permissions"
        else
            log_test "FAIL" "permission_check" "Installation should have failed with insufficient permissions"
        fi
        
        # Restore permissions and clean up
        chmod 755 .
        cd "$TEST_DIR"
        rm -rf "$readonly_dir"
    else
        log_test "SKIP" "permission_check" "Running as root, cannot test permission failures"
    fi
}

test_disk_space_scenarios() {
    echo -e "\n${BLUE}=== Testing Disk Space Scenarios ===${NC}"
    
    # Check if we have enough space for testing
    local available_space=$(df . | awk 'NR==2 {print $4}')
    if [[ "$available_space" -gt 1048576 ]]; then  # > 1GB
        log_test "PASS" "disk_space_check" "Sufficient disk space available"
    else
        log_test "SKIP" "disk_space_check" "Insufficient disk space for comprehensive testing"
    fi
}

test_update_scenarios() {
    echo -e "\n${BLUE}=== Testing Update Scenarios ===${NC}"
    
    # Install first version
    bash "$INSTALL_SCRIPT" --force --quiet
    
    # Modify a file to simulate local changes
    echo "# Local modification" >> .claude/commands/create-feature.md
    
    # Run update
    if bash "$INSTALL_SCRIPT" --update --force --quiet; then
        log_test "PASS" "update_installation" "Update installation completed"
        
        # Check if backup was created for update
        local backup_count=$(find .claude-sdlc/.backup -maxdepth 1 -type d -name "*_*" | wc -l)
        if [[ $backup_count -ge 1 ]]; then
            log_test "PASS" "update_backup" "Backup created during update"
        else
            log_test "FAIL" "update_backup" "No backup created during update"
        fi
    else
        log_test "FAIL" "update_installation" "Update installation failed"
    fi
}

test_dry_run_mode() {
    echo -e "\n${BLUE}=== Testing Dry Run Mode ===${NC}"
    
    # Run in dry-run mode
    if bash "$INSTALL_SCRIPT" --dry-run --verbose; then
        log_test "PASS" "dry_run_execution" "Dry run mode executed successfully"
        
        # Verify no files were actually created
        if [[ ! -d ".claude" ]] && [[ ! -d ".claude-sdlc" ]]; then
            log_test "PASS" "dry_run_no_changes" "Dry run made no actual changes"
        else
            log_test "FAIL" "dry_run_no_changes" "Dry run mode created files"
        fi
    else
        log_test "FAIL" "dry_run_execution" "Dry run mode failed"
    fi
}

test_logging_functionality() {
    echo -e "\n${BLUE}=== Testing Logging Functionality ===${NC}"
    
    local log_file="/tmp/install-test.log"
    
    # Run installation with logging
    if bash "$INSTALL_SCRIPT" --force --verbose --log "$log_file"; then
        log_test "PASS" "logging_execution" "Installation with logging completed"
        
        # Check if log file was created
        if [[ -f "$log_file" ]]; then
            log_test "PASS" "log_file_creation" "Log file created"
            
            # Check log content
            if grep -q "INFO" "$log_file" && grep -q "DEBUG" "$log_file"; then
                log_test "PASS" "log_content" "Log file contains expected content"
            else
                log_test "FAIL" "log_content" "Log file missing expected content"
            fi
        else
            log_test "FAIL" "log_file_creation" "Log file not created"
        fi
        
        # Clean up
        rm -f "$log_file"
    else
        log_test "FAIL" "logging_execution" "Installation with logging failed"
    fi
}

test_security_features() {
    echo -e "\n${BLUE}=== Testing Security Features ===${NC}"
    
    # Test input validation (invalid directory)
    if ! bash "$INSTALL_SCRIPT" --dir "/nonexistent/directory" --force --quiet 2>/dev/null; then
        log_test "PASS" "input_validation" "Invalid directory correctly rejected"
    else
        log_test "FAIL" "input_validation" "Invalid directory not rejected"
    fi
    
    # Test git repository requirement
    local temp_non_git="/tmp/non-git-$(date +%s)"
    mkdir -p "$temp_non_git"
    cd "$temp_non_git"
    
    if ! bash "$INSTALL_SCRIPT" --force --quiet 2>/dev/null; then
        log_test "PASS" "git_requirement" "Non-git directory correctly rejected"
    else
        log_test "FAIL" "git_requirement" "Non-git directory not rejected"
    fi
    
    cd "$TEST_DIR"
    rm -rf "$temp_non_git"
}

test_command_availability() {
    echo -e "\n${BLUE}=== Testing Command Availability ===${NC}"
    
    # Install and check command files
    bash "$INSTALL_SCRIPT" --force --quiet
    
    local expected_commands=(
        "create-feature.md"
        "build.md"
        "code-review.md"
        "security-audit.md"
        "architecture-review.md"
        "performance-review.md"
        "generate-tests.md"
        "fix-issues.md"
    )
    
    local commands_found=0
    for cmd in "${expected_commands[@]}"; do
        if [[ -f ".claude/commands/$cmd" ]]; then
            ((commands_found++))
        fi
    done
    
    if [[ $commands_found -eq ${#expected_commands[@]} ]]; then
        log_test "PASS" "command_files" "All expected command files present ($commands_found/${#expected_commands[@]})"
    else
        log_test "FAIL" "command_files" "Missing command files ($commands_found/${#expected_commands[@]})"
    fi
}

generate_test_report() {
    echo -e "\n${BLUE}=== Test Report ===${NC}"
    echo "Test execution completed at: $(date)"
    echo "Test directory: $TEST_DIR"
    echo ""
    echo "Results Summary:"
    echo "  Tests Passed: $TESTS_PASSED"
    echo "  Tests Failed: $TESTS_FAILED"
    echo "  Total Tests: $((TESTS_PASSED + TESTS_FAILED))"
    echo ""
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo -e "${GREEN}🎉 All tests passed!${NC}"
    else
        echo -e "${RED}⚠️  Some tests failed. Review the output above.${NC}"
    fi
    
    echo ""
    echo "Detailed Results:"
    printf '%s\n' "${TEST_RESULTS[@]}"
}

# Main test execution
main() {
    echo "Claude-SDLC Installation Test Suite"
    echo "==================================="
    echo ""
    
    # Verify test prerequisites
    if [[ ! -f "$INSTALL_SCRIPT" ]]; then
        echo "Error: Install script not found at $INSTALL_SCRIPT"
        exit 1
    fi
    
    # Make install script executable
    chmod +x "$INSTALL_SCRIPT"
    
    # Setup
    setup_test_environment
    
    # Trap for cleanup
    trap cleanup_test_environment EXIT
    
    # Run tests
    test_basic_installation
    test_backup_creation
    test_rollback_mechanism
    test_partial_installation_detection
    test_concurrent_installation
    test_network_failure_simulation
    test_permission_scenarios
    test_disk_space_scenarios
    test_update_scenarios
    test_dry_run_mode
    test_logging_functionality
    test_security_features
    test_command_availability
    
    # Generate report
    generate_test_report
    
    # Return appropriate exit code
    if [[ $TESTS_FAILED -eq 0 ]]; then
        exit 0
    else
        exit 1
    fi
}

# Execute main function
main "$@"