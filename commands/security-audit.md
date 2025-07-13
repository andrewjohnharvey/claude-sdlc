# Security Audit

Comprehensive security vulnerability assessment and analysis

## Instructions

Follow this systematic approach to perform security audit: **$ARGUMENTS**

1. **Scope Determination**
   - **Targeted Audit** (when $ARGUMENTS provided):
     - Focus on specific component, file, or directory
     - Audit recent changes: `git diff --name-only $ARGUMENTS`
     - Review specific security concern area
   
   - **Comprehensive Audit** (when no $ARGUMENTS):
     - Audit entire repository for security vulnerabilities
     - Scan all source code and configuration files
     - Use: `find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" -o -name "*.py" \) -not -path "./node_modules/*"`

2. **Context Analysis**
   - Check for security guidelines in `.claude-sdlc/architecture/`
   - Review existing security policies and threat models
   - Identify project-specific security requirements
   - Load security configuration and standards

3. **Parallel Security Analysis Coordination and Sub-Agent Spawning**
   - **Independent Security Analysis Categories**: Spawn sub-agents for parallel security analysis using the Task tool:
     - **Sub-Agent A**: "Perform code security analysis for $ARGUMENTS security audit"
     - **Sub-Agent B**: "Perform configuration security analysis for $ARGUMENTS security audit"
     - **Sub-Agent C**: "Perform dependency security analysis for $ARGUMENTS security audit"
     - **Sub-Agent D**: "Perform infrastructure security analysis for $ARGUMENTS security audit"

   - **Sub-Agent Coordination**:
     - Use multiple Task tool calls in a single message for parallel execution
     - Each sub-agent receives the scope and context from steps 1-2
     - Include security guidelines, threat models, and project requirements
     - Sub-agents focus on their specific security domain and report detailed findings
     - Main agent aggregates all security findings for comprehensive risk assessment

   - **Security Analysis Distribution**:
     - All sub-agents analyze the same target scope but focus on different security aspects
     - No conflicts since this is analysis-only (no code modifications)
     - Each sub-agent provides detailed vulnerability findings for their assigned category
     - **Quality Gate**: Verify all parallel security analysis tasks complete before risk assessment

4. **Security Vulnerability Assessment** *(This section now handled by Sub-Agents A-D in parallel)*
   - **Code Security Analysis**
     - Scan for hardcoded credentials and secrets
     - Check input validation and output encoding
     - Identify SQL injection and XSS vulnerabilities
     - Review authentication and authorization logic
     - Flag dangerous functions (eval, shell execution)

   - **Configuration Security**
     - Review environment and config files for exposed secrets
     - Check for insecure default settings
     - Verify security headers and CORS policies
     - Assess file upload and permission settings
     - Identify debug modes in production

   - **Dependency Security**
     - Scan dependency files for known vulnerabilities
     - Check for outdated packages with security advisories
     - Review dependency versions against CVE databases
     - Identify unused or redundant dependencies

   - **Infrastructure Security**
     - Review Docker and container configurations
     - Check Kubernetes and deployment security
     - Assess network security and firewall rules
     - Verify TLS/SSL configuration and certificates

5. **Risk Assessment and Classification**
   - Classify findings by severity (Critical, High, Medium, Low)
   - Assess potential impact and exploitability
   - Prioritize issues based on business risk
   - Document attack vectors and scenarios

6. **Report Generation**
   - Create timestamped report: `.claude-sdlc/builds/$(date +%Y-%m-%d-%H%M)-security-audit.md`
   - Structure findings by category and severity
   - Include specific file references and remediation steps
   - Provide executive summary with risk overview
   - Add compliance and regulatory considerations

7. **Remediation Guidance**
   - Provide specific fix recommendations for each issue
   - Suggest security best practices and tools
   - Recommend immediate actions for critical vulnerabilities
   - Plan follow-up security testing and validation

8. **Next Steps and Integration**
   - Recommend `/fix-issue` for critical vulnerabilities that need immediate attention
   - Suggest `/code-review` for areas with multiple security concerns
   - Propose follow-up `/security-audit` after remediation to verify fixes
   - Consider `/generate-tests` to create security-focused test cases

## Usage Examples

- `/security-audit` - Run a comprehensive security audit on the entire codebase
- `/security-audit src/auth/` - Audit security of authentication components
- `/security-audit HEAD~3..HEAD` - Review security of the last 3 commits
- `/security-audit --focus=injection` - Focus audit on injection vulnerabilities
- `/security-audit --severity=critical` - Only report critical security issues
- `/security-audit --auto-fix` - Attempt to automatically fix simple security issues

Remember to focus on actionable security improvements and provide clear guidance for addressing vulnerabilities systematically.
