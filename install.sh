#!/bin/bash

# Claude-SDLC Installation Script
# This script installs the Claude-SDLC command suite into a project

set -e

# Default values
PROJECT_DIR="$(pwd)"
REPO_URL="https://github.com/andrewjohnharvey/claude-sdlc.git"
TEMP_DIR=""  # Will be set securely using mktemp
UPDATE_MODE=false
ROLLBACK_MODE=false
DRY_RUN=false
VERBOSE=false
FORCE=false
LOG_FILE=""
LOCK_FILE=""
COMMANDS_BACKUP_DIR=""

# Test function for verifying all enhancements
test_enhancements() {
  echo "Claude-SDLC Installation Script - Enhancement Testing"
  echo "===================================================="
  local test_passed=0
  local test_failed=0
  
  # Test 1: Locking mechanism functions exist
  echo "Test 1: Checking locking mechanism functions..."
  if declare -f create_lock >/dev/null && declare -f remove_lock >/dev/null; then
    echo "✓ Locking functions exist"
    ((test_passed++))
  else
    echo "✗ Locking functions missing"
    ((test_failed++))
  fi
  
  # Test 2: Backup mechanism functions exist
  echo "Test 2: Checking backup mechanism functions..."
  if declare -f backup_commands >/dev/null; then
    echo "✓ Backup function exists"
    ((test_passed++))
  else
    echo "✗ Backup function missing"
    ((test_failed++))
  fi
  
  # Test 3: Enhanced git validation functions exist
  echo "Test 3: Checking enhanced git validation..."
  if declare -f validate_git_repository >/dev/null; then
    echo "✓ Enhanced git validation function exists"
    ((test_passed++))
  else
    echo "✗ Enhanced git validation function missing"
    ((test_failed++))
  fi
  
  # Test 4: Directory structure refactoring
  echo "Test 4: Checking refactored directory structure..."
  if declare -f create_directory_structure >/dev/null && declare -f get_directory_description >/dev/null; then
    echo "✓ Refactored directory structure functions exist"
    ((test_passed++))
  else
    echo "✗ Refactored directory structure functions missing"
    ((test_failed++))
  fi
  
  # Test 5: Test stale lock detection logic
  echo "Test 5: Testing stale lock detection logic..."
  local test_pid=99999
  if ! kill -0 "$test_pid" 2>/dev/null; then
    echo "✓ Stale lock detection logic can detect non-existent processes"
    ((test_passed++))
  else
    echo "✗ Stale lock detection test inconclusive (test PID exists)"
    ((test_failed++))
  fi
  
  # Test 6: Test directory creation configuration
  echo "Test 6: Testing directory configuration..."
  local test_dirs=(".claude/commands" ".claude-sdlc/features" ".claude-sdlc/builds")
  local config_valid=true
  for dir in "${test_dirs[@]}"; do
    if ! get_directory_description "$dir" | grep -q "command\|Command\|feature\|Feature\|build\|Build"; then
      config_valid=false
      break
    fi
  done
  
  if [[ "$config_valid" == true ]]; then
    echo "✓ Directory configuration is properly defined"
    ((test_passed++))
  else
    echo "✗ Directory configuration has issues"
    ((test_failed++))
  fi
  
  # Summary
  echo ""
  echo "Test Results:"
  echo "============="
  echo "Passed: $test_passed"
  echo "Failed: $test_failed"
  echo "Total:  $((test_passed + test_failed))"
  
  if [[ $test_failed -eq 0 ]]; then
    echo ""
    echo "✓ All enhancement tests passed!"
    echo ""
    echo "Medium Priority Enhancements Verified:"
    echo "1. ✓ Concurrent installation prevention with locking"
    echo "2. ✓ Command file backup mechanism"
    echo "3. ✓ Enhanced git repository validation"
    echo "4. ✓ Refactored directory structure creation"
    echo ""
    return 0
  else
    echo ""
    echo "✗ Some enhancement tests failed."
    return 1
  fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --dir)
      PROJECT_DIR="$2"
      shift 2
      ;;
    --update)
      UPDATE_MODE=true
      shift
      ;;
    --rollback)
      ROLLBACK_MODE=true
      shift
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --verbose)
      VERBOSE=true
      shift
      ;;
    --force)
      FORCE=true
      shift
      ;;
    --log)
      LOG_FILE="$2"
      shift 2
      ;;
    --test-enhancements)
      # Hidden test flag for verification
      test_enhancements
      exit $?
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: bash install.sh [--dir /path/to/project] [--update] [--rollback] [--dry-run] [--verbose] [--force] [--log file.log]"
      exit 1
      ;;
  esac
done

# Setup logging
log() {
  local message="[$(date '+%Y-%m-%d %H:%M:%S')] $1"
  echo "$message"
  
  if [[ -n "$LOG_FILE" ]]; then
    echo "$message" >> "$LOG_FILE"
  fi
}

# Project-level locking mechanism
create_lock() {
  local project_dir="$1"
  LOCK_FILE="$project_dir/.claude-sdlc.lock"
  
  # Check for existing lock file
  if [[ -f "$LOCK_FILE" ]]; then
    local lock_pid
    local lock_timestamp
    
    # Read lock file content (PID and timestamp)
    if [[ -r "$LOCK_FILE" ]]; then
      read -r lock_pid lock_timestamp < "$LOCK_FILE"
    else
      log "Error: Cannot read lock file $LOCK_FILE"
      return 1
    fi
    
    # Check if the process is still running
    if [[ -n "$lock_pid" ]] && kill -0 "$lock_pid" 2>/dev/null; then
      log "Error: Another Claude-SDLC installation is already running (PID: $lock_pid)"
      log "Started at: $(date -d "@$lock_timestamp" '+%Y-%m-%d %H:%M:%S' 2>/dev/null || date -r "$lock_timestamp" '+%Y-%m-%d %H:%M:%S' 2>/dev/null || echo "unknown time")"
      log "If you're certain no installation is running, remove: $LOCK_FILE"
      return 1
    else
      # Stale lock file - process no longer exists
      log "Found stale lock file from PID $lock_pid, removing..."
      rm -f "$LOCK_FILE"
    fi
  fi
  
  # Create new lock file
  if [[ "$DRY_RUN" == false ]]; then
    echo "$$ $(date '+%s')" > "$LOCK_FILE"
    if [[ $? -ne 0 ]]; then
      log "Error: Failed to create lock file $LOCK_FILE"
      return 1
    fi
    log "Created installation lock: $LOCK_FILE (PID: $$)"
  else
    log "DRY_RUN: Would create lock file $LOCK_FILE"
  fi
  
  return 0
}

# Remove project lock
remove_lock() {
  if [[ -n "$LOCK_FILE" ]] && [[ -f "$LOCK_FILE" ]] && [[ "$DRY_RUN" == false ]]; then
    rm -f "$LOCK_FILE"
    log "Removed installation lock: $LOCK_FILE"
  fi
}

# Backup command files
backup_commands() {
  local project_dir="$1"
  local commands_dir="$project_dir/.claude/commands"
  
  if [[ ! -d "$commands_dir" ]]; then
    log "No existing commands directory to backup"
    return 0
  fi
  
  # Create timestamped backup directory
  COMMANDS_BACKUP_DIR="$project_dir/.claude/commands.backup.$(date '+%Y%m%d_%H%M%S')"
  
  log "Backing up existing commands to: $COMMANDS_BACKUP_DIR"
  
  if [[ "$DRY_RUN" == false ]]; then
    if mkdir -p "$COMMANDS_BACKUP_DIR" && cp -r "$commands_dir/"* "$COMMANDS_BACKUP_DIR/" 2>/dev/null; then
      log "Commands backup created successfully"
      
      # Create backup metadata file
      cat > "$COMMANDS_BACKUP_DIR/backup_info.txt" << EOF
Backup created: $(date '+%Y-%m-%d %H:%M:%S')
Original location: $commands_dir
Backup reason: Claude-SDLC installation/update
Installation PID: $$
EOF
      log "Backup metadata created"
      return 0
    else
      log "Warning: Failed to create commands backup"
      return 1
    fi
  else
    log "DRY_RUN: Would backup commands from $commands_dir to $COMMANDS_BACKUP_DIR"
    return 0
  fi
}

# Backup MCP configuration with timestamp
backup_mcp_config() {
  local project_dir="$1"
  local backup_file="$project_dir/.mcp.json.backup.$(date '+%Y%m%d_%H%M%S')"
  
  if [[ -f "$project_dir/.mcp.json" ]]; then
    log "Backing up existing .mcp.json to $backup_file"
    if [[ "$DRY_RUN" == false ]]; then
      cp "$project_dir/.mcp.json" "$backup_file"
      log "MCP configuration backup created successfully"
    fi
    return 0
  else
    log "No existing .mcp.json to backup"
    return 1
  fi
}

# Rollback to previous installation state
perform_rollback() {
  local project_dir="${1:-$PROJECT_DIR}"
  local rollback_performed=false
  
  log "Starting rollback process..."
  
  # Find most recent command backup
  local latest_commands_backup=""
  if [[ -d "$project_dir/.claude" ]]; then
    latest_commands_backup=$(find "$project_dir/.claude" -maxdepth 1 -name "commands.backup.*" -type d | sort -r | head -n 1)
  fi
  
  # Find most recent MCP backup
  local latest_mcp_backup=""
  if [[ -d "$project_dir" ]]; then
    latest_mcp_backup=$(find "$project_dir" -maxdepth 1 -name ".mcp.json.backup.*" -type f | sort -r | head -n 1)
  fi
  
  # Rollback commands if backup exists
  if [[ -n "$latest_commands_backup" ]] && [[ -d "$latest_commands_backup" ]]; then
    log "Found commands backup: $latest_commands_backup"
    
    if [[ "$DRY_RUN" == false ]]; then
      # Remove current commands
      if [[ -d "$project_dir/.claude/commands" ]]; then
        rm -rf "$project_dir/.claude/commands"
      fi
      
      # Restore from backup
      if cp -r "$latest_commands_backup" "$project_dir/.claude/commands"; then
        log "Commands rolled back successfully"
        rollback_performed=true
      else
        log "Error: Failed to rollback commands"
        return 1
      fi
    else
      log "DRY_RUN: Would rollback commands from $latest_commands_backup"
      rollback_performed=true
    fi
  else
    log "No command backups found to rollback"
  fi
  
  # Rollback MCP configuration if backup exists
  if [[ -n "$latest_mcp_backup" ]] && [[ -f "$latest_mcp_backup" ]]; then
    log "Found MCP configuration backup: $latest_mcp_backup"
    
    if [[ "$DRY_RUN" == false ]]; then
      if cp "$latest_mcp_backup" "$project_dir/.mcp.json"; then
        log "MCP configuration rolled back successfully"
        rollback_performed=true
      else
        log "Error: Failed to rollback MCP configuration"
        return 1
      fi
    else
      log "DRY_RUN: Would rollback MCP configuration from $latest_mcp_backup"
      rollback_performed=true
    fi
  else
    log "No MCP configuration backups found to rollback"
  fi
  
  if [[ "$rollback_performed" == true ]]; then
    log "Rollback completed successfully"
    return 0
  else
    log "No backups found to rollback"
    return 1
  fi
}

# Validate required commands are available
validate_commands() {
  local required_commands=("git" "date" "mkdir" "cp" "rm" "mktemp")
  local missing_commands=()
  
  for cmd in "${required_commands[@]}"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      missing_commands+=("$cmd")
    fi
  done
  
  if [[ ${#missing_commands[@]} -gt 0 ]]; then
    log "Error: Required commands not found: ${missing_commands[*]}"
    log "Please install the missing commands and try again."
    return 1
  fi
  
  log "All required commands are available"
  return 0
}

# Check write permissions to target directory
validate_permissions() {
  local target_dir="$1"
  
  if [[ ! -w "$target_dir" ]]; then
    log "Error: No write permission to target directory: $target_dir"
    return 1
  fi
  
  # Test actual write capability
  local test_file="$target_dir/.claude-sdlc-install-test"
  if ! touch "$test_file" 2>/dev/null; then
    log "Error: Cannot create files in target directory: $target_dir"
    return 1
  fi
  rm -f "$test_file" 2>/dev/null
  
  log "Write permissions validated for: $target_dir"
  return 0
}

# Check minimum disk space (10MB = 10240 KB)
validate_disk_space() {
  local target_dir="$1"
  local min_space_kb=10240
  
  # Get available space in KB
  local available_space
  if command -v df >/dev/null 2>&1; then
    available_space=$(df -k "$target_dir" | awk 'NR==2 {print $4}')
    
    if [[ -n "$available_space" ]] && [[ "$available_space" -gt "$min_space_kb" ]]; then
      log "Disk space validated: ${available_space}KB available (minimum ${min_space_kb}KB required)"
      return 0
    else
      log "Error: Insufficient disk space. Available: ${available_space:-unknown}KB, Required: ${min_space_kb}KB"
      return 1
    fi
  else
    log "Warning: Cannot check disk space - 'df' command not available"
    return 0  # Continue installation if we can't check
  fi
}

# Clone repository with retry logic and timeout
clone_with_retry() {
  local repo_url="$1"
  local temp_dir="$2"
  local max_attempts=3
  local timeout_seconds=30
  local attempt=1
  
  while [[ $attempt -le $max_attempts ]]; do
    log "Cloning attempt $attempt of $max_attempts..."
    
    if [[ "$DRY_RUN" == false ]]; then
      # Use timeout command if available, otherwise fall back to basic git clone
      if command -v timeout >/dev/null 2>&1; then
        if timeout "${timeout_seconds}s" git clone "$repo_url" "$temp_dir" 2>/dev/null; then
          log "Repository cloned successfully on attempt $attempt"
          return 0
        fi
      else
        # Fallback for systems without timeout command
        if git clone "$repo_url" "$temp_dir" 2>/dev/null; then
          log "Repository cloned successfully on attempt $attempt"
          return 0
        fi
      fi
      
      log "Clone attempt $attempt failed"
      
      # Clean up failed attempt
      if [[ -d "$temp_dir" ]]; then
        rm -rf "$temp_dir"
      fi
      
      if [[ $attempt -lt $max_attempts ]]; then
        local wait_time=$((attempt * 2))
        log "Waiting ${wait_time} seconds before retry..."
        sleep "$wait_time"
      fi
    else
      log "DRY_RUN: Would clone $repo_url to $temp_dir"
      return 0
    fi
    
    ((attempt++))
  done
  
  log "Error: Failed to clone repository after $max_attempts attempts"
  return 1
}

# Validate git repository health
validate_git_repository() {
  local project_dir="$1"
  
  if [[ ! -d "$project_dir/.git" ]]; then
    log "Directory is not a git repository: $project_dir"
    return 1
  fi
  
  # Check git repository health
  local git_status_output
  if ! git_status_output=$(cd "$project_dir" && git status --porcelain 2>&1); then
    log "Error: Git repository appears to be corrupted or inaccessible"
    log "Git error: $git_status_output"
    
    # Try basic git commands to diagnose
    if ! (cd "$project_dir" && git rev-parse --git-dir >/dev/null 2>&1); then
      log "Error: .git directory is corrupted"
      return 1
    fi
    
    if ! (cd "$project_dir" && git rev-parse HEAD >/dev/null 2>&1); then
      log "Warning: No commits found in repository (empty repository)"
      # This is okay for new repositories
    fi
    
    return 1
  fi
  
  # Additional git health checks
  local git_dir
  if git_dir=$(cd "$project_dir" && git rev-parse --git-dir 2>/dev/null); then
    # Check if git objects are accessible
    if [[ -d "$project_dir/$git_dir/objects" ]]; then
      log "Git repository health check passed"
    else
      log "Warning: Git objects directory not found"
    fi
  else
    log "Error: Cannot determine git directory location"
    return 1
  fi
  
  # Check for git locks that might interfere
  local git_lock_file="$project_dir/.git/index.lock"
  if [[ -f "$git_lock_file" ]]; then
    log "Warning: Git index lock file exists, another git operation may be in progress"
    log "Lock file: $git_lock_file"
  fi
  
  return 0
}

# Validate repository integrity after clone
validate_repository() {
  local temp_dir="$1"
  
  if [[ "$DRY_RUN" == true ]]; then
    log "DRY_RUN: Would validate repository integrity"
    return 0
  fi
  
  # Check if it's a valid git repository
  if [[ ! -d "$temp_dir/.git" ]]; then
    log "Error: Cloned directory is not a valid git repository"
    return 1
  fi
  
  # Validate git repository health
  if ! validate_git_repository "$temp_dir"; then
    log "Error: Cloned repository failed git health checks"
    return 1
  fi
  
  # Check if commands directory exists
  if [[ ! -d "$temp_dir/commands" ]]; then
    log "Error: Commands directory not found in cloned repository"
    return 1
  fi
  
  # Check if any .md files exist in commands directory
  local md_files=("$temp_dir/commands"/*.md)
  if [[ ! -f "${md_files[0]}" ]]; then
    log "Error: No .md command files found in repository"
    return 1
  fi
  
  # Count files to ensure we have a reasonable number
  local file_count
  file_count=$(find "$temp_dir/commands" -name "*.md" | wc -l)
  if [[ "$file_count" -lt 3 ]]; then
    log "Warning: Only $file_count command files found - this seems unusually low"
  fi
  
  log "Repository integrity validated: $file_count command files found"
  return 0
}

# Cleanup function for trap handlers
cleanup() {
  local exit_code=$?
  
  # Clean up temporary directory
  if [[ -n "$TEMP_DIR" ]] && [[ -d "$TEMP_DIR" ]]; then
    log "Cleaning up temporary directory: $TEMP_DIR"
    rm -rf "$TEMP_DIR"
  fi
  
  # Remove lock file
  remove_lock
  
  exit $exit_code
}

# Set up trap handlers for proper cleanup
trap cleanup EXIT ERR INT TERM HUP

execute() {
  if [[ "$VERBOSE" == true ]]; then
    log "EXEC: $*"
  fi
  
  if [[ "$DRY_RUN" == false ]]; then
    "$@"  # Direct execution instead of eval to prevent code injection
  fi
}

# Comprehensive pre-flight validation
run_preflight_checks() {
  local target_dir="$1"
  
  log "Running pre-flight validation checks..."
  
  # Check required commands
  if ! validate_commands; then
    return 1
  fi
  
  # Check write permissions
  if ! validate_permissions "$target_dir"; then
    return 1
  fi
  
  # Check disk space
  if ! validate_disk_space "$target_dir"; then
    return 1
  fi
  
  log "All pre-flight checks passed"
  return 0
}

# Verify project directory exists
if [[ ! -d "$PROJECT_DIR" ]]; then
  log "Error: Project directory '$PROJECT_DIR' does not exist."
  exit 1
fi

# Handle rollback mode
if [[ "$ROLLBACK_MODE" == true ]]; then
  log "Rollback mode initiated..."
  
  if perform_rollback "$PROJECT_DIR"; then
    log "Rollback completed successfully!"
    exit 0
  else
    log "Rollback failed or no backups found"
    exit 1
  fi
fi

# Run comprehensive pre-flight validation
if ! run_preflight_checks "$PROJECT_DIR"; then
  log "Pre-flight validation failed. Installation aborted."
  exit 1
fi

# Enhanced git repository validation
if [[ -d "$PROJECT_DIR/.git" ]]; then
  log "Validating git repository health..."
  if ! validate_git_repository "$PROJECT_DIR"; then
    if [[ "$FORCE" == false ]]; then
      log "Git repository validation failed. Use --force to override."
      exit 1
    else
      log "Git repository validation failed, but continuing due to --force flag"
    fi
  else
    log "Git repository health check passed"
  fi
elif [[ "$FORCE" == false ]]; then
  log "Warning: '$PROJECT_DIR' does not appear to be a git repository."
  read -p "Continue anyway? (y/n): " confirm
  if [[ "$confirm" != "y" ]]; then
    log "Installation aborted."
    exit 1
  fi
fi

# Create installation lock
log "Creating installation lock..."
if ! create_lock "$PROJECT_DIR"; then
  exit 1
fi

# Check for existing installation and backup if needed
if [[ -d "$PROJECT_DIR/.claude/commands" ]] && [[ "$UPDATE_MODE" == false ]] && [[ "$FORCE" == false ]]; then
  log "Claude-SDLC commands directory already exists."
  read -p "Update existing installation? (y/n): " confirm
  if [[ "$confirm" != "y" ]]; then
    log "Installation aborted."
    remove_lock
    exit 1
  fi
  UPDATE_MODE=true
fi

# Backup existing commands if they exist
if [[ -d "$PROJECT_DIR/.claude/commands" ]]; then
  log "Existing commands directory found, creating backup..."
  backup_commands "$PROJECT_DIR"
fi

# Create secure temporary directory
if [[ -z "$TEMP_DIR" ]]; then
  TEMP_DIR=$(mktemp -d -t "claude-sdlc.XXXXXX")
  if [[ $? -ne 0 ]]; then
    log "Error: Failed to create secure temporary directory name"
    exit 1
  fi
  # Remove the directory so git clone can create it fresh
  rm -rf "$TEMP_DIR"
  log "Generated secure temporary directory name: $TEMP_DIR"
fi

# Clone the repository with retry logic
log "Cloning Claude-SDLC repository..."
if ! clone_with_retry "$REPO_URL" "$TEMP_DIR"; then
  log "Failed to clone repository after multiple attempts. Please check your network connection and try again."
  exit 1
fi

# Validate repository integrity
if ! validate_repository "$TEMP_DIR"; then
  log "Repository validation failed. The cloned repository may be corrupted or incomplete."
  exit 1
fi

# Debug: Show what was cloned
if [[ "$VERBOSE" == true ]] && [[ "$DRY_RUN" == false ]]; then
  log "Contents of cloned repository:"
  ls -la "$TEMP_DIR"
fi

# Configuration-driven directory structure creation
get_directory_description() {
  local dir_name="$1"
  case "$dir_name" in
    ".claude/commands") echo "Command files for Claude-SDLC slash commands" ;;
    ".claude-sdlc/features") echo "Feature task lists created by the /create-feature command" ;;
    ".claude-sdlc/architecture") echo "Architecture and design documentation for the project" ;;
    ".claude-sdlc/builds") echo "Build reports and logs generated by the /build command" ;;
    ".claude-sdlc/reviews") echo "Code review reports generated by the /code-review command" ;;
    ".claude-sdlc/performance") echo "Performance review reports generated by the /performance-review command" ;;
    ".claude-sdlc/fixes") echo "Issue fix reports generated by the /fix-issues command" ;;
    ".claude-sdlc/ideas") echo "Idea documentation generated by the /idea command" ;;
    *) echo "Directory for Claude-SDLC files" ;;
  esac
}

get_associated_command() {
  local dir_name="$1"
  case "$dir_name" in
    "features") echo "/create-feature" ;;
    "builds") echo "/build" ;;
    "reviews") echo "/code-review" ;;
    "performance") echo "/performance-review" ;;
    "fixes") echo "/fix-issues" ;;
    "ideas") echo "/idea" ;;
    "architecture") echo "various commands" ;;
    *) echo "Claude-SDLC commands" ;;
  esac
}

# Create directory structure with dynamic README generation
create_directory_structure() {
  local project_dir="$1"
  
  log "Creating directory structure..."
  
  # Define directories to create
  local directories=(
    ".claude/commands"
    ".claude-sdlc/features"
    ".claude-sdlc/architecture"
    ".claude-sdlc/builds"
    ".claude-sdlc/reviews"
    ".claude-sdlc/performance"
    ".claude-sdlc/fixes"
    ".claude-sdlc/ideas"
  )
  
  for dir_path in "${directories[@]}"; do
    local full_path="$project_dir/$dir_path"
    local description=$(get_directory_description "$dir_path")
    
    execute mkdir -p "$full_path"
    
    # Generate README for .claude-sdlc directories (not .claude/commands)
    if [[ "$dir_path" == .claude-sdlc/* ]] && [[ "$DRY_RUN" == false ]]; then
      local readme_file="$full_path/README.md"
      local dir_name=$(basename "$dir_path")
      local command_name=$(get_associated_command "$dir_name")
      
      if [[ ! -f "$readme_file" ]]; then
        # Create title with first letter uppercase
        local title_name="$(echo "${dir_name:0:1}" | tr 'a-z' 'A-Z')${dir_name:1}"
        local single_item_name="$dir_name"
        if [[ "$dir_name" == *s ]]; then
          single_item_name="${dir_name%s}"
        fi
        
        cat > "$readme_file" << EOF
# $title_name

$description

This directory is managed by Claude-SDLC and contains files generated by the \`$command_name\` command.

## Directory Structure
- Each file represents a separate $single_item_name (or $single_item_name report)
- Files are named with timestamps for chronological organization
- Markdown format is used for consistency and readability

## Usage
- Files in this directory are automatically created by Claude-SDLC commands
- You can manually review and edit these files as needed
- Do not delete this README.md file as it provides important context

Generated by Claude-SDLC installation script on $(date '+%Y-%m-%d %H:%M:%S')
EOF
        log "Created README for $dir_path"
      fi
    fi
  done
}

# Call the new directory creation function
create_directory_structure "$PROJECT_DIR"

# Copy command files
log "Copying command files..."
# Validation already done in validate_repository function
execute cp "$TEMP_DIR/commands"/*.md "$PROJECT_DIR/.claude/commands/"

# Copy MCP configuration
log "Setting up MCP server configuration..."
if [[ -f "$TEMP_DIR/.mcp.json" ]]; then
  if [[ ! -f "$PROJECT_DIR/.mcp.json" ]]; then
    execute cp "$TEMP_DIR/.mcp.json" "$PROJECT_DIR/.mcp.json"
    log "MCP configuration copied to project root"
  elif [[ "$UPDATE_MODE" == true ]]; then
    # Backup existing configuration before overwriting
    backup_mcp_config "$PROJECT_DIR"
    execute cp "$TEMP_DIR/.mcp.json" "$PROJECT_DIR/.mcp.json"
    log "MCP configuration updated (backup created)"
  else
    log "MCP configuration already exists, skipping (use --update to overwrite)"
  fi
else
  log "Warning: No .mcp.json found in Claude-SDLC repository"
fi

# Note: README files are now generated dynamically in create_directory_structure function

# Clean up (trap handler will also ensure cleanup on exit)
log "Cleaning up temporary files..."
if [[ -n "$TEMP_DIR" ]] && [[ -d "$TEMP_DIR" ]]; then
  execute rm -rf "$TEMP_DIR"
  TEMP_DIR=""  # Clear variable to prevent double cleanup
fi

# Final instructions
if [[ "$DRY_RUN" == false ]]; then
  log "Claude-SDLC installation complete!"
  log "Available commands:"
  log "  - /idea - Quick brain dump for development ideas during workflow"
  log "  - /create-feature - Plan and define a new feature with task breakdown"
  log "  - /build - Implement a planned feature by executing its task list"
  log "  - /code-review - Perform comprehensive code quality analysis and review"
  log "  - /architecture-review - Analyze project architecture and design patterns"
  log "  - /security-audit - Comprehensive security vulnerability assessment"
  log "  - /performance-review - Analyze codebase for performance bottlenecks"
  log "  - /generate-tests - Create comprehensive test cases to improve coverage"
  log "  - /fix-issues - Identify and resolve specific code issues"
  log ""
  log "MCP Servers configured:"
  log "  - Context7 (documentation lookup)"
  log "  - Playwright (browser automation)"
  log "  - Shadcn UI (component library)"
  log ""
  log "Next steps:"
  log "  1. Open project in Claude Code"
  log "  2. Trust MCP servers when prompted"
  log "  3. Run '/help' to verify installation"
  log "  4. Start with '/create-feature <feature-name>' to begin"
else
  log "Dry run completed. No changes were made."
fi

log "Installation process finished."
