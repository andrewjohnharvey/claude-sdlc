# Architecture Review

Analyze project architecture and design patterns for scalability, maintainability, and alignment with specifications

## Instructions

Follow this systematic approach to review architecture: **$ARGUMENTS**

1. **Context Analysis**
   - Determine review scope: if $ARGUMENTS provided, focus on that specific component/area
   - List architecture documentation: `ls .claude-sdlc/architecture/`
   - Review existing design documents and specifications
   - Map project structure: `find . -maxdepth 2 -type d`
   - Identify architectural patterns and technology stack

2. **Parallel Architecture Analysis Coordination and Sub-Agent Spawning**
   - **Independent Architecture Analysis Categories**: Spawn sub-agents for parallel analysis using the Task tool:
     - **Sub-Agent A**: "Perform modularity analysis for $ARGUMENTS architecture review"
     - **Sub-Agent B**: "Perform scalability evaluation for $ARGUMENTS architecture review"
     - **Sub-Agent C**: "Perform design consistency analysis for $ARGUMENTS architecture review"
     - **Sub-Agent D**: "Perform documentation review for $ARGUMENTS architecture review"

   - **Sub-Agent Coordination**:
     - Use multiple Task tool calls in a single message for parallel execution
     - Each sub-agent receives the context and scope from step 1
     - Include project structure, technology stack, and architectural patterns
     - Sub-agents focus on their specific architectural domain and report detailed findings
     - Main agent aggregates all architectural findings for comprehensive report generation

   - **Architecture Analysis Distribution**:
     - All sub-agents analyze the same project scope but focus on different architectural aspects
     - No conflicts since this is analysis-only (no code modifications)
     - Each sub-agent provides detailed findings for their assigned architectural category
     - **Quality Gate**: Verify all parallel architecture analysis tasks complete before report generation

3. **Architecture Assessment** *(This section now handled by Sub-Agents A-C in parallel)*
   - **Modularity Analysis**
     - Examine separation of concerns across modules
     - Identify tightly coupled components
     - Check for clear layer boundaries (presentation, business, data)
     - Assess component responsibilities and interfaces
   
   - **Scalability Evaluation**
     - Identify potential bottlenecks and single points of failure
     - Review load balancing and distribution strategies
     - Assess caching, queuing, and async processing patterns
     - Check database design and query optimization opportunities
   
   - **Design Consistency**
     - Verify adherence to declared architectural patterns
     - Check naming conventions and code organization
     - Review API design and interface consistency
     - Assess error handling and logging patterns

4. **Documentation Review** *(This section now handled by Sub-Agent D in parallel)*
   - Compare documented architecture with actual implementation
   - Identify gaps between design specs and code reality
   - Check for outdated or missing architectural documentation
   - Verify that major architectural decisions are documented

5. **Report Generation**
   - Create timestamped report: `.claude-sdlc/arhitecture-review/$(date +%Y-%m-%d-%H%M)-architecture-review.md`
   - Structure findings by category (Modularity, Scalability, Consistency, Documentation)
   - Include specific examples and code references for each issue
   - Provide actionable recommendations for improvements
   - Add executive summary highlighting key findings and priorities

6. **Improvement Planning**
   - Identify critical issues requiring immediate attention
   - Suggest feature plans for major architectural improvements
   - Recommend follow-up actions and next steps
   - Consider creating feature plans for significant refactoring needs

7. **Quality Validation**
   - Ensure all findings are backed by specific evidence
   - Verify recommendations align with project goals and constraints
   - Check that report is actionable and prioritized
   - Confirm no direct code changes were made during review

Remember to focus on architectural concerns rather than code-level issues, and provide constructive recommendations that improve system design and maintainability.
