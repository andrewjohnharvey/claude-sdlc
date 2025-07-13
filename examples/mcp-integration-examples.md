# MCP Integration Examples

This document provides examples of how Claude-SDLC commands leverage MCP (Model Context Protocol) servers to enhance development workflows.

## MCP Servers Overview

Claude-SDLC integrates with five key MCP servers:

### 1. Context7 - Documentation Lookup
**Purpose**: Provides access to official documentation for libraries and frameworks
**Used in**: `/code-review`, `/architecture-review`, `/generate-tests`

**Example Usage**:
```
When reviewing React code, Context7 automatically references:
- React official documentation for best practices
- API documentation for proper hook usage
- Performance optimization guidelines
```

### 2. Playwright - Browser Automation
**Purpose**: UI testing and browser automation
**Used in**: `/generate-tests`, `/code-review` (for web apps)

**Example Usage**:
```
Generates comprehensive web application tests:
- User journey automation
- Cross-browser compatibility tests
- Visual regression testing
- Performance monitoring tests
```

### 3. Shadcn UI - Component Library
**Purpose**: UI component standards and examples
**Used in**: `/code-review`, `/generate-tests`, `/architecture-review`

**Example Usage**:
```
Component review and validation:
- Design system compliance checking
- Accessibility standards validation
- Component usage pattern analysis
- Consistent styling verification
```

## Integration Workflow Examples

### Code Review with MCP Enhancement

```bash
/code-review src/components/
```

**MCP Integration Flow**:
1. **Context7**: Looks up React documentation for detected components
2. **Shadcn UI**: Validates component library usage patterns

### Feature Creation with Complex Planning

```bash
/create-feature user-authentication-system
```

**MCP Integration Flow**:
1. **Context7**: References authentication best practices documentation

### Test Generation for Web Applications

```bash
/generate-tests src/auth-flow --run-tests
```

**MCP Integration Flow**:
1. **Playwright**: Generates browser automation tests for auth flow
2. **Context7**: References testing framework documentation
3. **Shadcn UI**: Validates component testing approaches

## Configuration Management

### Project-Level MCP Configuration
The `.mcp.json` file in the project root configures all MCP servers:

```json
{
  "mcpServers": {
    "Context7": { "type": "stdio", "command": "npx", "args": ["-y", "@upstash/context7-mcp@latest"] },
    "Playwright": { "type": "stdio", "command": "npx", "args": ["-y", "@playwright/mcp@latest"] },
    "Shadcn UI": { "type": "stdio", "command": "npx", "args": ["-y", "shadcn-ui-mcp-server"] }
  }
}
```

### Team Consistency
- Include `.mcp.json` in version control
- All team members get identical MCP configuration
- Commands behave consistently across development environments

## Troubleshooting MCP Issues

### Common Issues and Solutions

**MCP Servers Not Loading**:
```bash
# Check MCP server status
claude mcp list

# Restart MCP servers  
claude mcp restart
```

**Node.js Requirements**:
```bash
# Verify Node.js installation
node --version  # Should be v16+ 
npm --version
```

**Performance Optimization**:
- MCP servers run as separate processes
- Consider disabling unused servers for better performance
- Monitor system resources during complex operations

## Best Practices

1. **Selective Usage**: Only enable MCP servers relevant to your project type
2. **Resource Monitoring**: MCP servers consume CPU/memory; monitor usage
3. **Version Control**: Always include `.mcp.json` in your repository
4. **Team Training**: Ensure team understands MCP-enhanced command capabilities
5. **Regular Updates**: Keep MCP servers updated for latest features and fixes

## Advanced Usage

### Custom MCP Server Configuration
You can modify `.mcp.json` to:
- Add project-specific environment variables
- Configure timeout settings
- Add additional MCP servers for specialized workflows

### Command Customization
Edit command files in `.claude/commands/` to:
- Add project-specific MCP integration points
- Customize MCP usage patterns
- Integrate with additional tools and services