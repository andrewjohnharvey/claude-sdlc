#!/bin/bash

# Claude-SDLC Installation Script
# This script installs the Claude-SDLC command suite into a project

set -e

# Default values
PROJECT_DIR="$(pwd)"
REPO_URL="https://github.com/invalid/nonexistent-repo.git"
TEMP_DIR=""  # Will be set securely using mktemp
UPDATE_MODE=false
DRY_RUN=false
VERBOSE=false
FORCE=false
LOG_FILE=""

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
    *)
      echo "Unknown option: $1"
      echo "Usage: bash install.sh [--dir /path/to/project] [--update] [--dry-run] [--verbose] [--force] [--log file.log]"
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
  if [[ -n "$TEMP_DIR" ]] && [[ -d "$TEMP_DIR" ]]; then
    log "Cleaning up temporary directory: $TEMP_DIR"
    rm -rf "$TEMP_DIR"
  fi
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

# Run comprehensive pre-flight validation
if ! run_preflight_checks "$PROJECT_DIR"; then
  log "Pre-flight validation failed. Installation aborted."
  exit 1
fi

# Check if this is a git repository
if [[ ! -d "$PROJECT_DIR/.git" ]] && [[ "$FORCE" == false ]]; then
  log "Warning: '$PROJECT_DIR' does not appear to be a git repository."
  read -p "Continue anyway? (y/n): " confirm
  if [[ "$confirm" != "y" ]]; then
    log "Installation aborted."
    exit 1
  fi
fi

# Check for existing installation
if [[ -d "$PROJECT_DIR/.claude/commands" ]] && [[ "$UPDATE_MODE" == false ]] && [[ "$FORCE" == false ]]; then
  log "Claude-SDLC commands directory already exists."
  read -p "Update existing installation? (y/n): " confirm
  if [[ "$confirm" != "y" ]]; then
    log "Installation aborted."
    exit 1
  fi
  UPDATE_MODE=true
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

# Create directory structure
log "Creating directory structure..."
execute mkdir -p "$PROJECT_DIR/.claude/commands"
execute mkdir -p "$PROJECT_DIR/.claude-sdlc/features"
execute mkdir -p "$PROJECT_DIR/.claude-sdlc/architecture"
execute mkdir -p "$PROJECT_DIR/.claude-sdlc/builds"
execute mkdir -p "$PROJECT_DIR/.claude-sdlc/reviews"
execute mkdir -p "$PROJECT_DIR/.claude-sdlc/performance"
execute mkdir -p "$PROJECT_DIR/.claude-sdlc/fixes"
execute mkdir -p "$PROJECT_DIR/.claude-sdlc/ideas"

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

# Initialize README files in each directory
if [[ "$DRY_RUN" == false ]]; then
  # Create README for features directory
  if [[ ! -f "$PROJECT_DIR/.claude-sdlc/features/README.md" ]]; then
    cat > "$PROJECT_DIR/.claude-sdlc/features/README.md" << EOF
# Features

This directory contains feature task lists created by the \`/create-feature\` command.
Each feature is defined in its own Markdown file with an atomic task list.
EOF
  fi

  # Create README for architecture directory
  if [[ ! -f "$PROJECT_DIR/.claude-sdlc/architecture/README.md" ]]; then
    cat > "$PROJECT_DIR/.claude-sdlc/architecture/README.md" << EOF
# Architecture

This directory contains architecture and design documentation for the project.
Place design specs, API contracts, ERDs, and other architectural documents here.
EOF
  fi

  # Create README for builds directory
  if [[ ! -f "$PROJECT_DIR/.claude-sdlc/builds/README.md" ]]; then
    cat > "$PROJECT_DIR/.claude-sdlc/builds/README.md" << EOF
# Builds

This directory stores build reports and logs generated by the \`/build\` command.
Each report includes summaries of tasks completed, changes made, and test results.
EOF
  fi

  # Create README for reviews directory
  if [[ ! -f "$PROJECT_DIR/.claude-sdlc/reviews/README.md" ]]; then
    cat > "$PROJECT_DIR/.claude-sdlc/reviews/README.md" << EOF
# Reviews

This directory contains code review reports generated by the \`/code-review\` command.
Each report includes analysis of code quality, security, and performance.
EOF
  fi

  # Create README for performance directory
  if [[ ! -f "$PROJECT_DIR/.claude-sdlc/performance/README.md" ]]; then
    cat > "$PROJECT_DIR/.claude-sdlc/performance/README.md" << EOF
# Performance

This directory contains performance review reports generated by the \`/performance-review\` command.
Each report includes analysis of performance bottlenecks and optimization opportunities.
EOF
  fi

  # Create README for fixes directory
  if [[ ! -f "$PROJECT_DIR/.claude-sdlc/fixes/README.md" ]]; then
    cat > "$PROJECT_DIR/.claude-sdlc/fixes/README.md" << EOF
# Fixes

This directory contains issue fix reports generated by the \`/fix-issues\` command.
Each report documents the issue, root cause analysis, and solution implemented.
EOF
  fi

  # Create README for ideas directory
  if [[ ! -f "$PROJECT_DIR/.claude-sdlc/ideas/README.md" ]]; then
    cat > "$PROJECT_DIR/.claude-sdlc/ideas/README.md" << EOF
# Ideas

This directory contains idea documentation generated by the \`/idea\` command.
Each idea includes intent, problem statement, and target beneficiaries for future development.
EOF
  fi
fi

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
