# Fix Issue Command

Identify and resolve code issues

## Instructions

Follow this structured approach to analyze and fix issues: **$ARGUMENTS**

1. **Issue Analysis**
   - Use `gh issue view $ARGUMENTS` to get complete issue details
   - Read the issue description, comments, and any attached logs/screenshots
   - Identify the type of issue (bug, feature request, enhancement, etc.)
   - Understand the expected vs actual behavior

2. **Environment Setup**
   - Ensure you're on the correct branch (usually main/master)
   - Pull latest changes: `git pull origin main`
   - Create a new feature branch: `git checkout -b fix/issue-$ARGUMENTS`

3. **Reproduce the Issue**
   - Follow the steps to reproduce described in the issue
   - Set up the development environment if needed
   - Run the application/tests to confirm the issue exists
   - Document the current behavior

4. **Root Cause Analysis**
   - Search the codebase for relevant files and functions
   - Use grep/search tools to locate the problematic code
   - Analyze the code logic and identify the root cause
   - Check for related issues or similar patterns

5. **Parallel Analysis Coordination and Sub-Agent Spawning** *(For multi-component or complex issues)*
   - **Multi-Component Issue Analysis**: When the issue spans multiple files, components, or systems, spawn sub-agents for parallel analysis:
     - **Sub-Agent A**: "Analyze component A for issue $ARGUMENTS root cause analysis"
     - **Sub-Agent B**: "Analyze component B for issue $ARGUMENTS root cause analysis"
     - **Sub-Agent C**: "Analyze component C for issue $ARGUMENTS root cause analysis"
     - *(Continue pattern based on affected components)*

   - **Complex Issue Investigation**: For issues with multiple potential causes, spawn sub-agents by investigation area:
     - **Sub-Agent A**: "Investigate frontend/UI aspects of issue $ARGUMENTS"
     - **Sub-Agent B**: "Investigate backend/API aspects of issue $ARGUMENTS"
     - **Sub-Agent C**: "Investigate database/persistence aspects of issue $ARGUMENTS"
     - **Sub-Agent D**: "Investigate configuration/environment aspects of issue $ARGUMENTS"

   - **Sub-Agent Coordination**:
     - Use multiple Task tool calls in a single message for parallel execution
     - Each sub-agent receives issue context from steps 1-4 and focuses on their assigned scope
     - Include reproduction steps, expected behavior, and initial analysis findings
     - Sub-agents report their analysis findings, potential causes, and suggested solutions
     - Main agent aggregates all findings to create comprehensive solution design

   - **Analysis Distribution Guidelines**:
     - Assign different files/components to different sub-agents to avoid overlap
     - For single-component issues, use traditional sequential approach (skip this step)
     - Each sub-agent provides detailed analysis for their assigned scope
     - No file conflicts during analysis since this is investigation-only
     - **Quality Gate**: Verify all parallel analysis tasks complete before solution design

6. **Solution Design** *(Integrates findings from parallel analysis when applicable)*
   - Design a fix that addresses the root cause, not just symptoms
   - Consider edge cases and potential side effects
   - Ensure the solution follows project conventions and patterns
   - Plan for backward compatibility if needed

7. **Implementation**
   - Implement the fix with clean, readable code
   - Follow the project's coding standards and style
   - Add appropriate error handling and logging
   - Keep changes minimal and focused

8. **Testing Strategy**
   - Write or update tests to cover the fix
   - Ensure existing tests still pass
   - Test edge cases and error conditions
   - Run the full test suite to check for regressions

9. **Code Quality Checks**
   - Run linting and formatting tools
   - Perform static analysis if available
   - Check for security implications
   - Ensure performance isn't negatively impacted

10. **Documentation Updates**
   - Create fix report: `.claude-sdlc/fixes/$(date +%Y-%m-%d)-issue-$ARGUMENTS.md`
   - Document the issue, root cause, and solution
   - Include before/after code examples
   - Update relevant documentation if needed
   - Add or update code comments for clarity
   - Update changelog if the project maintains one
   - Document any breaking changes

11. **Commit and Push**
    - Stage the changes: `git add .`
    - Create a descriptive commit message following project conventions
    - Example commit: `fix: resolve issue with user authentication timeout (#$ARGUMENTS)`
    - Push the branch: `git push origin fix/issue-$ARGUMENTS`

12. **Create Pull Request**
    - Use `gh pr create` to create a pull request
    - Reference the issue in the PR description: "Fixes #$ARGUMENTS"
    - Provide a clear description of the changes and testing performed
    - Add appropriate labels and reviewers

13. **Follow-up**
    - Monitor the PR for feedback and requested changes
    - Address any review comments promptly
    - Update the issue with progress and resolution
    - Ensure CI/CD checks pass
    - Suggest running `/code-review` on the changes

14. **Verification**
    - Once merged, verify the fix in the main branch
    - Close the issue if not automatically closed
    - Monitor for any related issues or regressions

Remember to communicate clearly in both code and comments, and always prioritize maintainable solutions over quick fixes.
