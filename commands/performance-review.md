# Performance Review

Analyze codebase for performance bottlenecks and optimization opportunities

## Instructions

Follow this systematic approach to review performance: **$ARGUMENTS**

1. **Scope Determination and Environment Setup**
   - **Targeted Review** (when $ARGUMENTS provided):
     - Focus on specific file, directory, or component: $ARGUMENTS
     - Analyze recent changes: `git diff --name-only $ARGUMENTS`
     - Review performance-critical areas related to $ARGUMENTS
     - Create targeted analysis branch: `git checkout -b performance-review-$ARGUMENTS`

   - **Comprehensive Review** (when no $ARGUMENTS):
     - Analyze entire codebase for performance issues
     - Scan all source code excluding build artifacts
     - Use: `find . -type f \( -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" \) -not -path "./node_modules/*" -not -path "./.git/*" -not -path "./build/*" -not -path "./dist/*" -not -path "./.next/*"`
     - Create comprehensive review branch: `git checkout -b performance-review-comprehensive`

2. **Context Analysis and Project Understanding**
   - Check for performance guidelines in `.claude-sdlc/architecture/`
   - Review existing performance benchmarks and standards
   - Load previous performance reports from `.claude-sdlc/performance/`
   - Identify performance-critical components and workflows
   - Load project-specific optimization requirements and constraints
   - **Quality Gate**: Confirm understanding of project architecture and performance requirements

3. **Technology Stack Detection and Framework Analysis**
   - Identify project technology stack from configuration files
   - Detect framework-specific performance patterns and anti-patterns
   - Load framework-specific optimization guidelines
   - **Quality Gate**: Confirm technology stack understanding before proceeding

4. **Comprehensive Performance Analysis**
   - **Algorithmic Efficiency Analysis**
     - Identify inefficient loops and nested iterations (O(n²) or worse)
     - Check for unnecessary recursion and excessive complexity
     - Review algorithm choices and data structure usage patterns
     - Flag performance-critical code paths with poor time complexity
     - Analyze sorting, searching, and data processing algorithms
     - **Quality Gate**: Document all algorithmic inefficiencies found

   - **Database and I/O Performance Review**
     - Scan for N+1 query patterns and inefficient database access
     - Check for large result sets without pagination or streaming
     - Review file I/O operations and excessive memory loading
     - Identify missing database indexes and query optimization opportunities
     - Analyze connection pooling and transaction management
     - Review caching strategies and cache invalidation patterns
     - **Quality Gate**: Verify all database performance issues are documented

   - **Memory Usage and Resource Optimization**
     - Check for excessive memory allocation patterns and memory leaks
     - Identify large in-memory data structures and collections
     - Review object lifecycle and garbage collection impact
     - Flag inefficient caching implementations and memory bloat
     - Analyze resource cleanup and disposal patterns
     - Check for memory-intensive operations in hot paths
     - **Quality Gate**: Confirm memory usage analysis is complete

   - **Frontend Performance Analysis** (if applicable)
     - Analyze bundle sizes and asset optimization opportunities
     - Check for inefficient DOM manipulation and excessive re-renders
     - Review React/Vue component rendering performance patterns
     - Assess lazy loading, code splitting, and dynamic import usage
     - Analyze CSS performance and unused styles
     - Review image optimization and asset loading strategies
     - Check for performance-impacting third-party libraries
     - **Quality Gate**: Ensure frontend performance review covers all critical areas

   - **Build and Configuration Performance**
     - Review build process efficiency and caching strategies
     - Check for unnecessary compilation steps and redundant processes
     - Analyze CI/CD pipeline performance and optimization opportunities
     - Identify missing optimization flags and configuration settings
     - Review dependency management and package optimization
     - **Quality Gate**: Validate build performance analysis completeness

5. **Critical Bottleneck Identification and Prioritization**
   - Prioritize issues by potential performance impact and severity
   - Identify critical path performance problems affecting user experience
   - Assess scalability limitations and architectural constraints
   - Document performance anti-patterns and code smells with examples
   - Map performance issues to business impact and user workflows
   - **Quality Gate**: Ensure all critical bottlenecks are properly categorized

6. **Performance Metrics and Baseline Analysis**
   - Analyze existing performance metrics and benchmarks
   - Review monitoring and profiling data if available
   - Identify performance regression patterns from git history
   - Document current performance baseline for comparison
   - **Quality Gate**: Confirm baseline understanding before recommendations

7. **Comprehensive Report Generation**
   - Create timestamped report: `.claude-sdlc/performance/$(date +%Y-%m-%d-%H%M)-performance-review.md`
   - Structure findings by category, severity, and impact level
   - Include specific file references with line numbers and code examples
   - Provide detailed performance improvement recommendations
   - Add benchmarking and monitoring implementation suggestions
   - Document quick wins vs. long-term optimization strategies
   - Include estimated effort and impact for each recommendation
   - **Quality Gate**: Verify report completeness and actionability

8. **Optimization Strategy and Implementation Guidance**
   - Suggest specific performance improvements for each identified issue
   - Recommend appropriate tools and techniques for optimization
   - Provide step-by-step implementation guidance and best practices
   - Plan follow-up performance testing and validation procedures
   - Create performance improvement roadmap with priorities
   - Document performance monitoring and alerting recommendations
   - **Quality Gate**: Ensure all recommendations are actionable and measurable

9. **Architecture Documentation Updates**
   - Update `.claude-sdlc/architecture/` with performance findings
   - Document performance constraints and optimization decisions
   - Create or update performance architecture guidelines
   - Record performance-related architectural decisions
   - **Quality Gate**: Confirm architecture documentation is updated

10. **Follow-up Planning and Next Steps**
    - Create action items for immediate performance improvements
    - Plan performance optimization sprint or iteration
    - Schedule follow-up performance reviews and monitoring
    - Recommend performance testing and validation procedures
    - Document performance improvement tracking methodology
    - **Quality Gate**: Ensure clear next steps are defined

11. **Testing and Validation Recommendations**
    - Recommend performance testing strategies for identified issues
    - Suggest load testing and stress testing approaches
    - Plan performance regression testing procedures
    - Document performance monitoring and alerting setup
    - **Quality Gate**: Ensure testing recommendations are comprehensive

12. **Documentation and Knowledge Sharing**
    - Update project documentation with performance findings
    - Create performance optimization guidelines for the team
    - Document performance best practices specific to the project
    - Share findings with relevant stakeholders
    - **Quality Gate**: Confirm all documentation is updated

13. **Commit and Branch Management**
    - Stage performance review documentation: `git add .claude-sdlc/performance/`
    - Commit with descriptive message: `git commit -m "performance: comprehensive performance review $(date +%Y-%m-%d)"`
    - Push performance review branch: `git push origin performance-review-$ARGUMENTS` (or performance-review-comprehensive)
    - **Quality Gate**: Ensure all changes are properly committed

14. **Quality Assurance and Final Validation**
    - Review all findings for accuracy and completeness
    - Validate recommendations against project constraints and feasibility
    - Ensure all performance issues are properly categorized and documented
    - Confirm report meets project performance review standards
    - Verify all quality gates have been satisfied
    - **Final Quality Gate**: Complete performance review validation

15. **Follow-up and Continuous Improvement**
    - Schedule implementation of high-priority performance improvements
    - Plan regular performance review cycles
    - Set up performance monitoring and alerting
    - Create performance improvement tracking dashboard
    - **Quality Gate**: Ensure continuous improvement process is established

Remember to focus on static analysis without executing code, provide actionable recommendations for improving application performance and scalability, maintain consistency with project architecture and development practices, and ensure all findings are properly documented in the `.claude-sdlc/` folder structure for future reference.
