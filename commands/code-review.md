# Code Review

Comprehensive code quality analysis and review with flexible scope targeting

## Instructions

Follow this systematic approach to review code: **$ARGUMENTS**

1. **Scope Determination and Target Identification**
   - **Targeted Review** (when $ARGUMENTS provided):
     - **Commit Hash**: Use `git diff --name-only $ARGUMENTS` to identify changed files
     - **Branch Name**: Use `git diff --name-only main..$ARGUMENTS` to compare with main branch
     - **Pull Request**: Use `gh pr diff $ARGUMENTS` to get PR changes
     - **File Path**: Review specific file directly (e.g., `src/main.py`)
     - **Directory Path**: Use `find $ARGUMENTS -type f \( -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" \)` for recursive analysis

   - **Comprehensive Review** (when no $ARGUMENTS):
     - Review entire codebase excluding build artifacts and dependencies
     - Use: `find . -type f \( -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" \) -not -path "./node_modules/*" -not -path "./.git/*" -not -path "./build/*" -not -path "./dist/*" -not -path "./.next/*"`
     - Focus on source code, configuration files, and documentation

2. **Environment and Context Setup**
   - Check current git status: `git status` to understand working directory state
   - Identify project type and technology stack from configuration files
   - Load project-specific configuration from `.claude-sdlc/config/` if available
   - Review existing architecture documentation in `.claude-sdlc/architecture/`
   - Check for coding standards and style guides in project root or docs

3. **Pre-Analysis Repository State**
   - Verify repository is in clean state or document uncommitted changes
   - Check current branch: `git branch --show-current`
   - Identify main/master branch: `git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'`
   - Document any build artifacts or generated files to exclude from review

4. **File Discovery and Categorization**
   - Execute appropriate discovery command based on scope from Step 1
   - Categorize files by type (source code, tests, configuration, documentation)
   - Prioritize files based on:
     - Recent changes (if reviewing commits/PRs)
     - Critical business logic components
     - Security-sensitive areas (authentication, data handling)
     - Performance-critical paths

5. **Style and Formatting Analysis**
   - **Naming Conventions**
     - Verify consistent variable, function, and class naming
     - Check for meaningful and descriptive names
     - Identify abbreviations or unclear naming patterns
     - Ensure naming follows language and framework conventions

   - **Code Organization and Structure**
     - Check file and directory organization
     - Verify proper import/export patterns
     - Identify dead code and unused imports
     - Flag commented-out code blocks for removal
     - Assess code formatting consistency

6. **Correctness and Logic Review**
   - **Algorithm and Logic Analysis**
     - Analyze control flow and conditional logic
     - Check for off-by-one errors and boundary conditions
     - Verify loop termination conditions
     - Identify potential race conditions in concurrent code

   - **Error Handling Assessment**
     - Verify proper exception handling and error propagation
     - Check for appropriate error messages and logging
     - Ensure graceful degradation for failure scenarios
     - Review input validation and sanitization

7. **Security Assessment and Vulnerability Scan**
   - **Common Vulnerability Patterns**
     - Scan for SQL injection risks in database queries
     - Check for XSS vulnerabilities in user input handling
     - Identify potential CSRF vulnerabilities
     - Review authentication and authorization logic

   - **Secrets and Sensitive Data**
     - Check for hard-coded passwords, API keys, or tokens
     - Verify proper environment variable usage
     - Review data encryption and hashing implementations
     - Assess logging practices for sensitive information leakage

8. **Performance Analysis and Optimization**
   - **Algorithm Efficiency**
     - Identify potential bottlenecks and inefficient algorithms
     - Check for N+1 query patterns in database operations
     - Review memory usage patterns and potential leaks
     - Assess computational complexity of critical functions

   - **Resource Usage**
     - Check for excessive memory allocations
     - Identify blocking operations that could be asynchronous
     - Review caching strategies and opportunities
     - Assess database query optimization needs

9. **Maintainability and Code Quality Evaluation**
   - **Code Complexity Assessment**
     - Flag overly complex or long functions (>50 lines)
     - Identify deeply nested code structures
     - Check for code duplication and refactoring opportunities
     - Assess adherence to SOLID principles

   - **Documentation and Comments**
     - Verify adequate inline documentation
     - Check for outdated or misleading comments
     - Assess API documentation completeness
     - Review README and setup instructions

10. **Testing Coverage and Quality Analysis**
    - **Test Presence and Coverage**
      - Identify components lacking unit tests
      - Check for integration and end-to-end test coverage
      - Verify test quality and meaningful assertions
      - Assess test maintainability and clarity

    - **Test Strategy Evaluation**
      - Review test organization and structure
      - Check for proper mocking and test isolation
      - Verify edge case and error condition testing
      - Assess test performance and execution time

11. **Dependency and Configuration Review**
    - **Dependency Management**
      - Check for outdated or vulnerable dependencies using package files
      - Identify unused or redundant dependencies
      - Verify proper version pinning and lock files
      - Review license compatibility for dependencies

    - **Configuration Security**
      - Review configuration files for security issues
      - Check environment-specific configurations
      - Verify proper secrets management
      - Assess deployment and build configurations

12. **Report Generation and Documentation**
    - Create comprehensive timestamped report: `.claude-sdlc/reviews/$(date +%Y-%m-%dT%H%M%S)-code-review.md`
    - **Report Structure**:
      - Executive summary with scope and key findings
      - Detailed findings by category (Critical, High, Medium, Low priority)
      - Specific file references with line numbers for each issue
      - Code examples and suggested improvements
      - Actionable recommendations with implementation guidance
    - **Do not modify source code** - only analyze and report findings

13. **Priority Assessment and Categorization**
    - **Critical Issues** (immediate attention required):
      - Security vulnerabilities
      - Logic errors that could cause data loss
      - Performance issues affecting user experience

    - **High Priority** (address soon):
      - Code quality issues affecting maintainability
      - Missing test coverage for critical functionality
      - Dependency vulnerabilities with available fixes

    - **Medium/Low Priority** (address in next iteration):
      - Style inconsistencies
      - Documentation improvements
      - Refactoring opportunities

14. **Integration with Development Workflow**
    - Reference related issues or tickets if reviewing specific changes
    - Suggest appropriate branch protection rules or CI/CD improvements
    - Recommend code review checklist items for future reviews
    - Document patterns and anti-patterns discovered for team knowledge

15. **Next Steps and Actionable Guidance**
    - **Immediate Actions** for critical issues:
      - Run `/fix-issue <issue-number>` for specific bugs
      - Use project linting tools: `npm run lint` or `flake8` or equivalent
      - Run `/security-audit` if security vulnerabilities found
      - Address dependency vulnerabilities: `npm audit fix` or equivalent

    - **Follow-up Recommendations**:
      - Run `/generate-tests` for components lacking test coverage
      - Consider `/performance-audit` if performance concerns identified
      - Update documentation if maintainability issues found
      - Re-run `/code-review $ARGUMENTS` after fixes to verify improvements

    - **Long-term Improvements**:
      - Establish coding standards if not present
      - Set up automated code quality tools (linters, formatters)
      - Implement pre-commit hooks for quality gates
      - Schedule regular code review sessions for knowledge sharing

Remember to maintain high standards for code quality while providing constructive, actionable feedback. Focus on teaching and improving the codebase systematically rather than just identifying problems.
