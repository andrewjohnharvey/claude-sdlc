#!/bin/bash

# Simple test script for install.sh
# Focuses on basic functionality only - keeping it simple

set -e

# Test configuration
TEST_DIR="/tmp/claude-sdlc-test-$$"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_SCRIPT="$SCRIPT_DIR/install.sh"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Helper functions
pass() {
  echo -e "${GREEN}✓ $1${NC}"
  ((TESTS_PASSED++))
}

fail() {
  echo -e "${RED}✗ $1${NC}"
  ((TESTS_FAILED++))
}

# Cleanup function
cleanup() {
  rm -rf "$TEST_DIR"
}
trap cleanup EXIT

# Create test directory
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo "Running simple install.sh tests..."
echo "================================"

# Test 1: Basic installation
echo "Test 1: Basic installation"
mkdir -p test-project && cd test-project
git init -q

if bash "$INSTALL_SCRIPT" --force > install.log 2>&1; then
  # Check if directories were created
  if [[ -d ".claude/commands" ]] && [[ -d ".claude-sdlc/features" ]]; then
    pass "Basic installation creates required directories"
  else
    fail "Basic installation - directories missing"
  fi
  
  # Check if command files were copied
  if ls .claude/commands/*.md > /dev/null 2>&1; then
    pass "Command files copied successfully"
  else
    fail "Command files not copied"
  fi
  
  # Check if MCP config was copied
  if [[ -f ".mcp.json" ]]; then
    pass "MCP configuration copied"
  else
    fail "MCP configuration not copied"
  fi
else
  fail "Basic installation failed"
fi

cd "$TEST_DIR"

# Test 2: Update with backup
echo -e "\nTest 2: Update with backup"
cd test-project

# Modify a command file to simulate existing installation
echo "# Modified" >> .claude/commands/build.md

if bash "$INSTALL_SCRIPT" --update --force > update.log 2>&1; then
  # Check if backup was created
  if ls .claude/commands.backup.* > /dev/null 2>&1; then
    pass "Backup created during update"
  else
    fail "No backup created during update"
  fi
  
  # Check if MCP backup was created
  if ls .mcp.json.backup.* > /dev/null 2>&1; then
    pass "MCP configuration backup created"
  else
    fail "No MCP backup created"
  fi
else
  fail "Update installation failed"
fi

# Test 3: Rollback functionality
echo -e "\nTest 3: Rollback functionality"

# Add a marker to the current files
echo "# Current version" >> .claude/commands/build.md

if bash "$INSTALL_SCRIPT" --rollback > rollback.log 2>&1; then
  # Check if files were restored
  if grep -q "# Modified" .claude/commands/build.md && ! grep -q "# Current version" .claude/commands/build.md; then
    pass "Rollback restored previous version"
  else
    fail "Rollback did not restore correct version"
  fi
else
  fail "Rollback failed"
fi

cd "$TEST_DIR"

# Test 4: Dry run mode
echo -e "\nTest 4: Dry run mode"
mkdir -p test-dry-run && cd test-dry-run
git init -q

if bash "$INSTALL_SCRIPT" --dry-run > dryrun.log 2>&1; then
  # Check that no files were created
  if [[ ! -d ".claude" ]] && [[ ! -d ".claude-sdlc" ]]; then
    pass "Dry run mode doesn't create files"
  else
    fail "Dry run mode created files"
  fi
else
  fail "Dry run mode failed"
fi

# Summary
echo -e "\n================================"
echo "Test Summary:"
echo "Passed: $TESTS_PASSED"
echo "Failed: $TESTS_FAILED"

if [[ $TESTS_FAILED -eq 0 ]]; then
  echo -e "${GREEN}All tests passed!${NC}"
  exit 0
else
  echo -e "${RED}Some tests failed${NC}"
  exit 1
fi