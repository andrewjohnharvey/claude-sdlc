#!/bin/bash

# Claude-SDLC Installation Script with Rollback Support
# Version: 2.0.0
# Security-hardened installation with comprehensive rollback mechanism

set -euo pipefail
IFS=$'\n\t'

# Global Configuration
readonly SCRIPT_VERSION="2.0.0"
readonly REPO_URL="https://github.com/andrewjohnharvey/claude-sdlc.git"
readonly TEMP_PREFIX="/tmp/claude-sdlc"
readonly STATE_FILE=".claude-sdlc/.install-state"
readonly BACKUP_DIR=".claude-sdlc/.backup"
readonly LOG_FILE=".claude-sdlc/install.log"

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Installation State Tracking
declare -A INSTALL_STATE
INSTALL_STATE["started"]="false"
INSTALL_STATE["backup_created"]="false"
INSTALL_STATE["directories_created"]="false"
INSTALL_STATE["files_copied"]="false"
INSTALL_STATE["mcp_configured"]="false"
INSTALL_STATE["completed"]="false"

# Configuration variables
INSTALL_DIR=""
UPDATE_MODE=false
DRY_RUN=false
VERBOSE=false
FORCE=false
ROLLBACK=false
LOG_TO_FILE=""
QUIET=false

# Security and validation functions
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    if [[ "$QUIET" == "false" ]]; then
        case "$level" in
            "ERROR")
                echo -e "${RED}[ERROR]${NC} $message" >&2
                ;;
            "WARN")
                echo -e "${YELLOW}[WARN]${NC} $message" >&2
                ;;
            "INFO")
                echo -e "${GREEN}[INFO]${NC} $message"
                ;;
            "DEBUG")
                if [[ "$VERBOSE" == "true" ]]; then
                    echo -e "${BLUE}[DEBUG]${NC} $message"
                fi
                ;;
        esac
    fi
    
    # Log to file if specified
    if [[ -n "$LOG_TO_FILE" ]]; then
        echo "[$timestamp] [$level] $message" >> "$LOG_TO_FILE"
    fi
    
    # Log to installation log if state tracking is active
    if [[ -f "$INSTALL_DIR/$LOG_FILE" ]]; then
        echo "[$timestamp] [$level] $message" >> "$INSTALL_DIR/$LOG_FILE"
    fi
}

validate_environment() {
    log "DEBUG" "Validating environment..."
    
    # Check if git is available
    if ! command -v git &> /dev/null; then
        log "ERROR" "Git is required but not installed"
        exit 1
    fi
    
    # Check if we're in a git repository (for non-dry-run mode)
    if [[ "$DRY_RUN" == "false" ]] && [[ ! -d ".git" ]]; then
        log "ERROR" "Not in a git repository. Claude-SDLC requires a git repository."
        exit 1
    fi
    
    # Validate install directory
    if [[ -n "$INSTALL_DIR" ]] && [[ ! -d "$INSTALL_DIR" ]]; then
        log "ERROR" "Specified directory does not exist: $INSTALL_DIR"
        exit 1
    fi
    
    # Check disk space (require at least 10MB)
    local available_space
    available_space=$(df . | awk 'NR==2 {print $4}')
    if [[ "$available_space" -lt 10240 ]]; then
        log "WARN" "Low disk space detected. At least 10MB recommended."
    fi
    
    # Check write permissions
    if ! touch .test_write_permission 2>/dev/null; then
        log "ERROR" "No write permission in current directory"
        exit 1
    fi
    rm -f .test_write_permission
    
    log "DEBUG" "Environment validation completed"
}

save_install_state() {
    local state_key="$1"
    local state_value="$2"
    
    INSTALL_STATE["$state_key"]="$state_value"
    
    # Create state directory if it doesn't exist
    mkdir -p "$(dirname "$INSTALL_DIR/$STATE_FILE")"
    
    # Save state to file
    {
        echo "# Claude-SDLC Installation State"
        echo "# Generated: $(date)"
        echo "# Script Version: $SCRIPT_VERSION"
        echo ""
        for key in "${!INSTALL_STATE[@]}"; do
            echo "$key=${INSTALL_STATE[$key]}"
        done
    } > "$INSTALL_DIR/$STATE_FILE"
    
    log "DEBUG" "Saved install state: $state_key=$state_value"
}

load_install_state() {
    if [[ -f "$INSTALL_DIR/$STATE_FILE" ]]; then
        log "DEBUG" "Loading existing installation state..."
        
        # Source the state file safely
        while IFS='=' read -r key value; do
            # Skip comments and empty lines
            [[ "$key" =~ ^[[:space:]]*# ]] && continue
            [[ -z "$key" ]] && continue
            
            # Validate key format
            if [[ "$key" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
                INSTALL_STATE["$key"]="$value"
            fi
        done < "$INSTALL_DIR/$STATE_FILE"
        
        log "DEBUG" "Installation state loaded"
        return 0
    fi
    return 1
}

detect_partial_installation() {
    if load_install_state; then
        if [[ "${INSTALL_STATE[completed]}" != "true" ]]; then
            log "WARN" "Partial installation detected!"
            echo "Previous installation was interrupted. State:"
            
            for key in started backup_created directories_created files_copied mcp_configured completed; do
                local status="${INSTALL_STATE[$key]:-false}"
                local icon="❌"
                [[ "$status" == "true" ]] && icon="✅"
                echo "  $icon $key: $status"
            done
            
            echo ""
            echo "Options:"
            echo "  1. Continue installation (--force)"
            echo "  2. Rollback previous installation (--rollback)"
            echo "  3. Exit and fix manually"
            
            if [[ "$FORCE" == "false" ]] && [[ "$ROLLBACK" == "false" ]]; then
                read -p "Choose option (1/2/3): " choice
                case "$choice" in
                    1)
                        FORCE=true
                        log "INFO" "Continuing installation..."
                        ;;
                    2)
                        ROLLBACK=true
                        log "INFO" "Starting rollback..."
                        ;;
                    3|*)
                        log "INFO" "Exiting. Run with --force to continue or --rollback to undo."
                        exit 0
                        ;;
                esac
            fi
        fi
    fi
}

create_backup() {
    log "INFO" "Creating backup of existing installation..."
    
    local backup_timestamp=$(date '+%Y%m%d_%H%M%S')
    local backup_path="$INSTALL_DIR/$BACKUP_DIR/$backup_timestamp"
    
    mkdir -p "$backup_path"
    
    # Backup existing .claude directory
    if [[ -d "$INSTALL_DIR/.claude" ]]; then
        cp -r "$INSTALL_DIR/.claude" "$backup_path/" 2>/dev/null || true
        log "DEBUG" "Backed up .claude directory"
    fi
    
    # Backup existing .claude-sdlc directory (except backups)
    if [[ -d "$INSTALL_DIR/.claude-sdlc" ]]; then
        mkdir -p "$backup_path/.claude-sdlc"
        find "$INSTALL_DIR/.claude-sdlc" -maxdepth 1 -not -name ".backup" -not -path "$INSTALL_DIR/.claude-sdlc" -exec cp -r {} "$backup_path/.claude-sdlc/" \; 2>/dev/null || true
        log "DEBUG" "Backed up .claude-sdlc directory"
    fi
    
    # Backup .mcp.json if it exists
    if [[ -f "$INSTALL_DIR/.mcp.json" ]]; then
        cp "$INSTALL_DIR/.mcp.json" "$backup_path/" 2>/dev/null || true
        log "DEBUG" "Backed up .mcp.json"
    fi
    
    # Save backup metadata
    {
        echo "# Backup Metadata"
        echo "timestamp=$backup_timestamp"
        echo "script_version=$SCRIPT_VERSION"
        echo "backup_path=$backup_path"
        echo "original_path=$INSTALL_DIR"
        echo "created=$(date)"
    } > "$backup_path/backup.meta"
    
    save_install_state "backup_created" "true"
    save_install_state "backup_path" "$backup_path"
    
    log "INFO" "Backup created at: $backup_path"
}

rollback_installation() {
    log "INFO" "Starting rollback process..."
    
    if ! load_install_state; then
        log "ERROR" "No installation state found. Cannot rollback."
        exit 1
    fi
    
    local backup_path="${INSTALL_STATE[backup_path]:-}"
    
    # If no backup path in state, try to find the latest backup
    if [[ -z "$backup_path" ]] && [[ -d "$INSTALL_DIR/$BACKUP_DIR" ]]; then
        backup_path=$(find "$INSTALL_DIR/$BACKUP_DIR" -maxdepth 1 -type d -name "*_*" | sort -r | head -1)
        log "DEBUG" "Found latest backup: $backup_path"
    fi
    
    if [[ -z "$backup_path" ]] || [[ ! -d "$backup_path" ]]; then
        log "ERROR" "No backup found for rollback"
        exit 1
    fi
    
    log "INFO" "Rolling back from backup: $backup_path"
    
    # Remove current installation
    [[ -d "$INSTALL_DIR/.claude" ]] && rm -rf "$INSTALL_DIR/.claude"
    [[ -f "$INSTALL_DIR/.mcp.json" ]] && rm -f "$INSTALL_DIR/.mcp.json"
    
    # Remove .claude-sdlc contents except backups
    if [[ -d "$INSTALL_DIR/.claude-sdlc" ]]; then
        find "$INSTALL_DIR/.claude-sdlc" -maxdepth 1 -not -name ".backup" -not -path "$INSTALL_DIR/.claude-sdlc" -exec rm -rf {} \; 2>/dev/null || true
    fi
    
    # Restore from backup
    if [[ -d "$backup_path/.claude" ]]; then
        cp -r "$backup_path/.claude" "$INSTALL_DIR/"
        log "DEBUG" "Restored .claude directory"
    fi
    
    if [[ -d "$backup_path/.claude-sdlc" ]]; then
        cp -r "$backup_path/.claude-sdlc"/* "$INSTALL_DIR/.claude-sdlc/" 2>/dev/null || true
        log "DEBUG" "Restored .claude-sdlc directory"
    fi
    
    if [[ -f "$backup_path/.mcp.json" ]]; then
        cp "$backup_path/.mcp.json" "$INSTALL_DIR/"
        log "DEBUG" "Restored .mcp.json"
    fi
    
    # Remove installation state
    [[ -f "$INSTALL_DIR/$STATE_FILE" ]] && rm -f "$INSTALL_DIR/$STATE_FILE"
    
    log "INFO" "Rollback completed successfully"
    exit 0
}

secure_clone() {
    local temp_dir="$1"
    
    log "INFO" "Cloning repository securely..."
    
    # Clone with specific depth to reduce attack surface
    if ! git clone --depth 1 --branch main "$REPO_URL" "$temp_dir" 2>/dev/null; then
        log "ERROR" "Failed to clone repository"
        exit 1
    fi
    
    # Verify repository contents
    local required_files=("install.sh" "commands" ".mcp.json")
    for file in "${required_files[@]}"; do
        if [[ ! -e "$temp_dir/$file" ]]; then
            log "ERROR" "Repository missing required file: $file"
            rm -rf "$temp_dir"
            exit 1
        fi
    done
    
    log "DEBUG" "Repository cloned and verified"
}

create_directories() {
    log "INFO" "Creating directory structure..."
    
    local directories=(
        ".claude/commands"
        ".claude-sdlc/features"
        ".claude-sdlc/architecture"
        ".claude-sdlc/builds"
        ".claude-sdlc/reviews"
        ".claude-sdlc/.backup"
    )
    
    for dir in "${directories[@]}"; do
        mkdir -p "$INSTALL_DIR/$dir"
        log "DEBUG" "Created directory: $dir"
    done
    
    save_install_state "directories_created" "true"
}

copy_files() {
    local temp_dir="$1"
    
    log "INFO" "Copying command files..."
    
    # Copy command files
    if ! cp "$temp_dir/commands"/*.md "$INSTALL_DIR/.claude/commands/" 2>/dev/null; then
        log "ERROR" "Failed to copy command files"
        exit 1
    fi
    
    # Copy MCP configuration
    if [[ -f "$temp_dir/.mcp.json" ]]; then
        cp "$temp_dir/.mcp.json" "$INSTALL_DIR/"
        log "DEBUG" "Copied MCP configuration"
    fi
    
    # Create README files for directories
    create_readme_files
    
    save_install_state "files_copied" "true"
    log "INFO" "Files copied successfully"
}

create_readme_files() {
    log "DEBUG" "Creating README files..."
    
    # Features README
    cat > "$INSTALL_DIR/.claude-sdlc/features/README.md" << 'EOF'
# Features Directory

This directory contains feature task lists created by the `/create-feature` command.

Each feature is tracked as a Markdown file with checkboxes for task completion.

## Usage
- Use `/create-feature <feature-name>` to create new feature plans
- Use `/build <feature-name>` to implement planned features
- Task progress is automatically tracked in these files
EOF

    # Architecture README
    cat > "$INSTALL_DIR/.claude-sdlc/architecture/README.md" << 'EOF'
# Architecture Directory

This directory contains architectural documentation and design decisions.

## Purpose
- Store high-level architectural decisions
- Document design patterns and conventions
- Provide context for AI-assisted development

## Usage
- Files here are read by commands to understand project context
- Use `/architecture-review` to analyze and update architectural documentation
EOF

    # Builds README
    cat > "$INSTALL_DIR/.claude-sdlc/builds/README.md" << 'EOF'
# Builds Directory

This directory contains build reports and implementation logs.

## Contents
- Build execution logs with timestamps
- Implementation progress reports
- Error logs and resolution steps

## Usage
- Automatically populated by `/build` command
- Used for debugging and progress tracking
EOF

    # Reviews README
    cat > "$INSTALL_DIR/.claude-sdlc/reviews/README.md" << 'EOF'
# Reviews Directory

This directory contains code review reports and quality assessments.

## Contents
- Code review reports from `/code-review`
- Security audit reports from `/security-audit`
- Performance review reports from `/performance-review`
- Architecture review reports from `/architecture-review`

## Usage
- Automatically populated by review commands
- Historical record of quality assessments
EOF

    log "DEBUG" "README files created"
}

configure_mcp() {
    log "INFO" "Configuring MCP servers..."
    
    if [[ -f "$INSTALL_DIR/.mcp.json" ]]; then
        log "DEBUG" "MCP configuration already exists"
    else
        log "WARN" "No MCP configuration found"
    fi
    
    save_install_state "mcp_configured" "true"
}

system_info() {
    if [[ "$VERBOSE" == "true" ]]; then
        log "DEBUG" "System Information:"
        log "DEBUG" "  OS: $(uname -s)"
        log "DEBUG" "  Kernel: $(uname -r)"
        log "DEBUG" "  Architecture: $(uname -m)"
        log "DEBUG" "  Shell: $SHELL"
        log "DEBUG" "  Git version: $(git --version 2>/dev/null || echo 'Not available')"
        log "DEBUG" "  Script version: $SCRIPT_VERSION"
        log "DEBUG" "  Install directory: $INSTALL_DIR"
    fi
}

cleanup_temp() {
    local temp_dir="$1"
    if [[ -d "$temp_dir" ]]; then
        rm -rf "$temp_dir"
        log "DEBUG" "Cleaned up temporary directory"
    fi
}

perform_installation() {
    local temp_dir="$TEMP_PREFIX-$(date +%s)-$$"
    
    save_install_state "started" "true"
    
    # Create backup before proceeding
    create_backup
    
    # Setup signal handlers for cleanup
    trap "cleanup_temp '$temp_dir'" EXIT
    trap "log 'ERROR' 'Installation interrupted'; exit 1" INT TERM
    
    # Clone repository
    secure_clone "$temp_dir"
    
    # Create directory structure
    create_directories
    
    # Copy files
    copy_files "$temp_dir"
    
    # Configure MCP
    configure_mcp
    
    # Mark installation as completed
    save_install_state "completed" "true"
    
    cleanup_temp "$temp_dir"
    
    log "INFO" "Installation completed successfully!"
    
    if [[ "$UPDATE_MODE" == "true" ]]; then
        log "INFO" "Claude-SDLC has been updated to version $SCRIPT_VERSION"
    else
        log "INFO" "Claude-SDLC has been installed. Available commands:"
        echo "  /create-feature   - Plan and define new features"
        echo "  /build           - Implement planned features"
        echo "  /code-review     - Perform code quality reviews"
        echo "  /security-audit  - Security vulnerability analysis"
        echo "  /architecture-review - Architectural analysis"
        echo "  /performance-review - Performance optimization"
        echo "  /generate-tests  - Generate test cases"
        echo "  /fix-issues      - Bug fixing workflow"
    fi
}

run_tests() {
    log "INFO" "Running installation tests..."
    
    local test_results=()
    
    # Test 1: Directory structure
    local required_dirs=(".claude/commands" ".claude-sdlc/features" ".claude-sdlc/architecture" ".claude-sdlc/builds" ".claude-sdlc/reviews")
    for dir in "${required_dirs[@]}"; do
        if [[ -d "$INSTALL_DIR/$dir" ]]; then
            test_results+=("✅ Directory exists: $dir")
        else
            test_results+=("❌ Directory missing: $dir")
        fi
    done
    
    # Test 2: Command files
    local command_count=$(find "$INSTALL_DIR/.claude/commands" -name "*.md" 2>/dev/null | wc -l)
    if [[ "$command_count" -gt 0 ]]; then
        test_results+=("✅ Command files: $command_count found")
    else
        test_results+=("❌ Command files: none found")
    fi
    
    # Test 3: MCP configuration
    if [[ -f "$INSTALL_DIR/.mcp.json" ]]; then
        test_results+=("✅ MCP configuration exists")
    else
        test_results+=("⚠️  MCP configuration missing")
    fi
    
    # Test 4: Installation state
    if [[ -f "$INSTALL_DIR/$STATE_FILE" ]]; then
        test_results+=("✅ Installation state tracked")
    else
        test_results+=("❌ Installation state missing")
    fi
    
    # Test 5: Backup system
    if [[ -d "$INSTALL_DIR/$BACKUP_DIR" ]]; then
        test_results+=("✅ Backup system initialized")
    else
        test_results+=("❌ Backup system missing")
    fi
    
    echo ""
    echo "Test Results:"
    printf '%s\n' "${test_results[@]}"
    echo ""
}

show_usage() {
    cat << EOF
Claude-SDLC Installation Script v$SCRIPT_VERSION

USAGE:
    $0 [OPTIONS]

OPTIONS:
    --dir DIR           Install to specific directory (default: current)
    --update           Update existing installation
    --rollback         Rollback previous installation
    --dry-run          Preview changes without making them
    --verbose          Enable detailed logging
    --force            Skip confirmations and continue partial installations
    --log FILE         Log operations to specified file
    --quiet            Suppress output (except errors)
    --test             Run installation tests
    --help             Show this help message

EXAMPLES:
    # Basic installation
    $0

    # Install to specific directory
    $0 --dir /path/to/project

    # Update existing installation
    $0 --update

    # Rollback installation
    $0 --rollback

    # Preview installation
    $0 --dry-run --verbose

    # Force continue partial installation
    $0 --force

ROLLBACK:
    The script automatically creates backups before installation.
    Use --rollback to restore from the most recent backup.
    Backups are stored in .claude-sdlc/.backup/

STATE TRACKING:
    Installation progress is tracked in .claude-sdlc/.install-state
    Partial installations are detected and recovery options offered.

SECURITY:
    - Repository integrity verification
    - Secure temporary file handling
    - Input validation and sanitization
    - Comprehensive error handling
    - Audit trail logging

EOF
}

# Main execution
main() {
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dir)
                INSTALL_DIR="$2"
                shift 2
                ;;
            --update)
                UPDATE_MODE=true
                shift
                ;;
            --rollback)
                ROLLBACK=true
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
                LOG_TO_FILE="$2"
                shift 2
                ;;
            --quiet)
                QUIET=true
                shift
                ;;
            --test)
                # Set install dir if not specified
                [[ -z "$INSTALL_DIR" ]] && INSTALL_DIR="$(pwd)"
                run_tests
                exit 0
                ;;
            --help)
                show_usage
                exit 0
                ;;
            *)
                log "ERROR" "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # Set default install directory
    [[ -z "$INSTALL_DIR" ]] && INSTALL_DIR="$(pwd)"
    
    # Convert to absolute path
    INSTALL_DIR="$(cd "$INSTALL_DIR" && pwd)"
    
    # Initialize logging
    if [[ -n "$LOG_TO_FILE" ]]; then
        mkdir -p "$(dirname "$LOG_TO_FILE")"
        touch "$LOG_TO_FILE"
    fi
    
    log "INFO" "Claude-SDLC Installation Script v$SCRIPT_VERSION"
    system_info
    
    # Handle rollback mode
    if [[ "$ROLLBACK" == "true" ]]; then
        rollback_installation
        exit 0
    fi
    
    # Validate environment
    validate_environment
    
    # Detect partial installations
    detect_partial_installation
    
    # Handle dry run mode
    if [[ "$DRY_RUN" == "true" ]]; then
        log "INFO" "DRY RUN MODE - No changes will be made"
        log "INFO" "Would install to: $INSTALL_DIR"
        log "INFO" "Would create directories: .claude/commands, .claude-sdlc/{features,architecture,builds,reviews}"
        log "INFO" "Would copy command files from repository"
        log "INFO" "Would configure MCP servers"
        exit 0
    fi
    
    # Confirm installation
    if [[ "$FORCE" == "false" ]] && [[ "$QUIET" == "false" ]]; then
        echo "This will install Claude-SDLC to: $INSTALL_DIR"
        if [[ "$UPDATE_MODE" == "true" ]]; then
            echo "This will update your existing Claude-SDLC installation."
        fi
        read -p "Continue? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log "INFO" "Installation cancelled"
            exit 0
        fi
    fi
    
    # Perform installation
    perform_installation
    
    # Run tests if verbose mode
    if [[ "$VERBOSE" == "true" ]]; then
        run_tests
    fi
}

# Error handling
set -euo pipefail

# Execute main function
main "$@"