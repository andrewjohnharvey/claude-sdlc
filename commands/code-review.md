# Code Review

Comprehensive code quality analysis and review with flexible scope targeting using parallel sub-agent architecture

## Sub-Agent Architecture Overview

This code review process utilizes **7 specialized sub-agents** working in parallel to provide comprehensive analysis:
- **Sub-Agent A**: Style and Formatting Analysis
- **Sub-Agent B**: Correctness and Logic Review
- **Sub-Agent C**: Security Assessment and Vulnerability Scan
- **Sub-Agent D**: Performance Analysis and Optimization
- **Sub-Agent E**: Maintainability and Code Quality Evaluation
- **Sub-Agent F**: Testing Coverage and Quality Analysis
- **Sub-Agent G**: Dependency and Configuration Review

**Key Benefits**: Parallel execution reduces review time, specialized focus improves analysis depth, comprehensive coverage ensures no quality aspects are missed.

## Instructions

Follow this systematic approach to review code using sub-agent coordination: **$ARGUMENTS**

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

### Project Context and Standards Review

#### CLAUDE.md Integration
- Check if CLAUDE.md exists in project root directory
- If missing, prompt: "No CLAUDE.md found. Would you like to initialize project-specific code standards with `claude init`?"
- If present, reference CLAUDE.md for:
  - Code quality standards and TypeScript strict typing requirements
  - Architectural patterns and implementation preferences
  - Testing requirements and validation standards
  - Error handling and edge case testing approaches
- Apply CLAUDE.md standards throughout the code review process

### MCP-Enhanced Analysis

   - **Context7**: For documentation lookup and best practice validation during review
   - **Playwright**: For UI/UX testing validation and browser compatibility analysis
   - **Shadcn UI**: For component standards compliance and accessibility review
   - **Other custom MCP servers**: As available in your environment

   Use available MCP capabilities throughout the review process for:
   - Code quality validation against official documentation
   - Complex architectural analysis with structured thinking
   - Database performance and schema optimization review
   - UI/UX testing automation and validation
   - Component library compliance and accessibility standards

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

5. **Parallel Analysis Coordination and Sub-Agent Spawning**
   - **Independent Analysis Categories**: Spawn sub-agents for parallel analysis using the Task tool:
     - **Sub-Agent A**: "Perform comprehensive style and formatting analysis for $ARGUMENTS code review - analyze naming conventions, code organization, import patterns, dead code identification, and formatting consistency"
     - **Sub-Agent B**: "Perform detailed correctness and logic review for $ARGUMENTS code review - analyze algorithms, control flow, error handling, input validation, and boundary conditions"
     - **Sub-Agent C**: "Perform thorough security assessment and vulnerability scan for $ARGUMENTS code review - check for injection risks, XSS vulnerabilities, authentication issues, and secrets management"
     - **Sub-Agent D**: "Perform comprehensive performance analysis and optimization review for $ARGUMENTS code review - identify bottlenecks, memory usage patterns, database query optimization, and caching opportunities"
     - **Sub-Agent E**: "Perform maintainability and code quality evaluation for $ARGUMENTS code review - assess code complexity, documentation quality, SOLID principles adherence, and refactoring opportunities"
     - **Sub-Agent F**: "Perform testing coverage and quality analysis for $ARGUMENTS code review - evaluate test presence, coverage completeness, test quality, and testing strategy effectiveness"
     - **Sub-Agent G**: "Perform dependency and configuration review for $ARGUMENTS code review - check dependency management, version compatibility, configuration security, and deployment settings"

   - **Sub-Agent Coordination Protocol**:
     - **Parallel Execution**: Use multiple Task tool calls in a single message for concurrent analysis
     - **Context Sharing**: Each sub-agent receives:
       - Complete file list from step 4 with categorization
       - Project scope and technology stack from steps 1-3
       - Coding standards and CLAUDE.md requirements from step 2
       - MCP server capabilities available for enhanced analysis
     - **Reporting Standards**: Sub-agents must provide:
       - Detailed findings with specific file references and line numbers
       - Priority classification (Critical, High, Medium, Low)
       - Code examples and suggested improvements
       - Integration with available MCP tools for validation

   - **Analysis Distribution and Quality Gates**:
     - **Scope Coverage**: All sub-agents analyze the same file set but focus on different quality aspects
     - **Conflict Prevention**: Analysis-only approach ensures no file modification conflicts
     - **Completion Verification**: Main agent must verify all 7 sub-agent tasks complete before report generation
     - **Result Aggregation**: Consolidate findings from all sub-agents into comprehensive report structure

6. **Sub-Agent Analysis Execution** *(All analysis sections 6-12 are now executed in parallel by specialized sub-agents)*

   **Sub-Agent A: Style and Formatting Analysis**
   - Execute comprehensive style review covering:
     - Naming conventions (variables, functions, classes)
     - Code organization and file structure
     - Import/export patterns and dead code identification
     - Formatting consistency and commented-out code removal

   **Sub-Agent B: Correctness and Logic Review**
   - Execute detailed logic analysis covering:
     - Algorithm correctness and control flow validation
     - Boundary conditions and off-by-one error detection
     - Error handling and exception propagation assessment
     - Input validation and race condition identification

   **Sub-Agent C: Security Assessment and Vulnerability Scan**
   - Execute thorough security review covering:
     - Common vulnerability patterns (SQL injection, XSS, CSRF)
     - Authentication and authorization logic validation
     - Secrets management and sensitive data handling
     - Encryption implementation and logging security assessment

   **Sub-Agent D: Performance Analysis and Optimization**
   - Execute comprehensive performance review covering:
     - Algorithm efficiency and bottleneck identification
     - Database query optimization and N+1 pattern detection
     - Memory usage patterns and resource allocation analysis
     - Caching strategies and asynchronous operation opportunities

   **Sub-Agent E: Maintainability and Code Quality Evaluation**
   - Execute detailed maintainability assessment covering:
     - Code complexity metrics and SOLID principles adherence
     - Documentation quality and comment accuracy
     - Code duplication identification and refactoring opportunities
     - API documentation completeness and setup instruction clarity

   **Sub-Agent F: Testing Coverage and Quality Analysis**
   - Execute comprehensive testing review covering:
     - Test presence validation and coverage gap identification
     - Test quality assessment and assertion meaningfulness
     - Test strategy evaluation and organization structure
     - Edge case coverage and test performance analysis

   **Sub-Agent G: Dependency and Configuration Review**
   - Execute thorough dependency and config analysis covering:
     - Dependency management and vulnerability assessment
     - Version compatibility and license compliance review
     - Configuration security and environment-specific settings
     - Deployment configuration and secrets management validation

7. **Sub-Agent Results Aggregation and Report Generation**
    - **Results Collection**: Gather completed analysis from all 7 sub-agents
    - **Cross-Reference Validation**: Identify overlapping findings and consolidate duplicates
    - **Priority Synthesis**: Merge priority classifications from all sub-agents using highest severity rule
    - **Comprehensive Report Creation**: Generate timestamped report: `.claude-sdlc/reviews/$(date +%Y-%m-%d-%H%M)-code-review.md`

    - **Enhanced Report Structure**:
      - **Executive Summary**: Scope definition, sub-agent coordination summary, and critical findings overview
      - **Sub-Agent Analysis Results**: Dedicated section for each sub-agent's findings with:
        - Analysis category and scope covered
        - Key findings summary with priority breakdown
        - Specific file references with line numbers
        - Code examples and improvement recommendations
      - **Consolidated Findings Matrix**: Cross-referenced issues by priority (Critical, High, Medium, Low)
      - **Actionable Recommendations**: Implementation guidance prioritized by impact and effort
      - **Sub-Agent Performance Metrics**: Analysis completion status and coverage verification

    - **File Persistence and Quality Assurance**:
      - Automatically save all review reports and sub-agent analysis files immediately after generation
      - Save intermediate sub-agent results to prevent work loss during long reviews
      - Create individual sub-agent report files: `.claude-sdlc/reviews/$(date +%Y-%m-%d-%H%M)-subreport-[A-G].md`
      - Confirm file locations with user for all generated review content
      - Verify all review files are properly persisted in `.claude-sdlc/reviews/` directory
      - **Code Modification Restriction**: Sub-agents and main agent only analyze and report - no source code modifications

8. **Sub-Agent Priority Assessment and Categorization**
    - **Cross-Agent Priority Synthesis**: Consolidate priority classifications from all sub-agents
    - **Critical Issues** (immediate attention required - flagged by any sub-agent):
      - Security vulnerabilities (Sub-Agent C findings)
      - Logic errors that could cause data loss (Sub-Agent B findings)
      - Performance issues affecting user experience (Sub-Agent D findings)
      - Critical dependency vulnerabilities (Sub-Agent G findings)

    - **High Priority** (address soon - multiple sub-agent consensus):
      - Code quality issues affecting maintainability (Sub-Agent E findings)
      - Missing test coverage for critical functionality (Sub-Agent F findings)
      - Authentication/authorization flaws (Sub-Agent C findings)
      - Significant performance bottlenecks (Sub-Agent D findings)

    - **Medium/Low Priority** (address in next iteration - single sub-agent findings):
      - Style inconsistencies (Sub-Agent A findings)
      - Documentation improvements (Sub-Agent E findings)
      - Refactoring opportunities (Sub-Agent E findings)
      - Minor configuration optimizations (Sub-Agent G findings)

9. **Integration with Development Workflow and Sub-Agent Coordination**
    - **Sub-Agent Workflow Integration**: Each sub-agent provides workflow-specific recommendations
    - Reference related issues or tickets if reviewing specific changes
    - Suggest appropriate branch protection rules or CI/CD improvements based on sub-agent findings
    - Recommend code review checklist items derived from sub-agent analysis patterns
    - Document patterns and anti-patterns discovered across all sub-agent categories for team knowledge

10. **Next Steps and Actionable Guidance from Sub-Agent Analysis**
    - **Immediate Actions** prioritized by sub-agent findings:
      - **Security (Sub-Agent C)**: Run `/security-audit` if vulnerabilities found
      - **Logic (Sub-Agent B)**: Run `/fix-issue <issue-number>` for specific bugs
      - **Style (Sub-Agent A)**: Use project linting tools: `npm run lint` or `flake8` or equivalent
      - **Dependencies (Sub-Agent G)**: Address vulnerabilities: `npm audit fix` or equivalent

    - **Follow-up Recommendations** based on sub-agent analysis:
      - **Testing (Sub-Agent F)**: Run `/generate-tests` for components lacking coverage
      - **Performance (Sub-Agent D)**: Consider `/performance-audit` if concerns identified
      - **Maintainability (Sub-Agent E)**: Update documentation if issues found
      - **Comprehensive**: Re-run `/code-review $ARGUMENTS` after fixes to verify improvements

    - **Long-term Improvements** informed by sub-agent patterns:
      - Establish coding standards based on Sub-Agent A style analysis
      - Set up automated quality tools recommended by Sub-Agent E
      - Implement security practices suggested by Sub-Agent C
      - Schedule regular reviews incorporating sub-agent methodology for knowledge sharing

Remember to maintain high standards for code quality while providing constructive, actionable feedback. Focus on teaching and improving the codebase systematically rather than just identifying problems.
