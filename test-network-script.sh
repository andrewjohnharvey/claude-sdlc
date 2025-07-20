#!/bin/bash

# Test script to simulate network failure by modifying the repository URL
sed 's|https://github.com/andrewjohnharvey/claude-sdlc.git|https://github.com/invalid/nonexistent-repo.git|' /Users/andrewharvey/dev/claude-sdlc/install.sh > /Users/andrewharvey/dev/claude-sdlc/test-network-install.sh
chmod +x /Users/andrewharvey/dev/claude-sdlc/test-network-install.sh

echo "Testing network failure handling..."
mkdir -p test-network-fail-2 && cd test-network-fail-2 && git init

# Run with invalid URL to test retry logic
bash /Users/andrewharvey/dev/claude-sdlc/test-network-install.sh --dry-run --verbose --dir "$(pwd)"