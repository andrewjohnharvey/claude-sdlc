# Code Review

Performs a comprehensive code review on the specified scope of the project, analyzing code quality in strict mode and identifying issues in style, correctness, security, performance, and maintainability.

## Instructions

1. **Initialize Review Context**
    
    - Determine the review scope based on the command arguments. If the `/code-review` command is run **without arguments**, default to reviewing the entire repository. If an argument is provided, interpret it to set the scope:
        
        - **Directory** – Review all files within the given directory (and its subdirectories).
            
        - **File** – Review the single specified file.
            
        - **Commit/Diff** – If a commit hash, branch name, or PR reference is provided, identify the files changed in that diff (e.g., using **!**`git diff --name-only <commit>` or a relevant VCS command) and limit the review to those changes.
            
        - **Pull Request** – If integrated with a platform (like GitHub/GitLab), allow specifying a PR ID or branch to review the changes in that PR.
            
    - Use shell commands to gather the list of files to analyze within the chosen scope. For example, you might run **!**`ls -R <directory>` or **!**`find <directory> -type f` to list files in a directory, or **!**`git diff <commit> -U0` to retrieve a diff. Filter out non-code or irrelevant files as needed so that the review focuses on source code and configuration files.
        
    - Check for any project-specific configuration in `.claude-sdlc/config/`. If such config files or guidelines exist (e.g. lint rules, naming conventions, or a custom review checklist), load and apply them. This ensures the review considers project standards (for instance, specific style guides or excluded directories).
        
2. **Perform Code Review Analysis**
    
    - **Code Style & Formatting:** Examine the code for consistency with styling conventions. Ensure formatting is clean and uniform (naming conventions, indentation, spacing, etc.), and flag any deviations or clutter (like dead code or commented-out blocks that should be removed).
        
    - **Correctness & Logic:** Analyze the logic in each file for potential errors or bugs. Look out for things like incorrect calculations, off-by-one errors, improper conditionals, or any code that might not produce the intended result. Flag sections of code that seem buggy or fragile.
        
    - **Security:** Inspect the code for security vulnerabilities or bad practices. This includes checking for SQL injection risks, XSS vulnerabilities, use of hard-coded secrets or passwords, unsafe deserialization or file handling, lack of input validation, and any usage of deprecated or insecure functions. Note any places where security best practices (e.g. using parameterized queries, encoding outputs, proper authentication checks) are not followed.
        
    - **Performance:** Identify any inefficient code or potential performance bottlenecks. For example, look for N+1 database query patterns, heavy loops or recursive calls that could be optimized, large in-memory data structures that could cause high memory usage, or any operations that might slow down the system. Highlight sections where a more efficient approach is possible.
        
    - **Maintainability:** Assess the code’s maintainability and organization. Flag overly long or complex functions, duplicated code, unclear variable or function names, and lack of comments or documentation where it would be helpful. Check if the code adheres to the project’s structural patterns and if not, note where refactoring might improve clarity and maintainability.
        
    - **Testing Gaps:** If the project includes tests, verify the coverage for the reviewed components. Note any critical modules or functions that do not have corresponding tests. For example, if reviewing a feature’s code, check if there are unit or integration tests covering its behavior. If tests exist, quickly assess their adequacy (e.g., are they meaningful and covering edge cases). If tests are missing or insufficient, record this as an issue.
        
    - **Dependencies & Configuration:** Review dependency files (like `package.json`, `requirements.txt`, etc.) or configuration files for potential issues. Flag any dependencies that are outdated or known to have vulnerabilities (for instance, an older library version with security advisories). Also, check configuration for insecure settings (like debug mode enabled in production, or overly permissive CORS settings) and note them.
        
    - Throughout the analysis, apply the **strictest interpretation of best practices** by default. Assume a high standard for code quality and flag anything that doesn’t meet that bar. (If the project’s config or context indicates a different standard or specific exceptions, take those into account; otherwise, err on the side of caution when identifying issues.)
        
3. **Report Results**
    
    - Compile the findings into a Markdown report. Create a new file under `.claude-sdlc/reviews/` to save the review results. Use a timestamp or unique identifier in the filename (for example, `.claude-sdlc/reviews/2025-07-12T152200-review.md`) so that each review is recorded separately and chronologically.
        
    - In the review file, **organize the issues by category** for clarity. For instance, use section headings or bullet lists for **Style**, **Correctness**, **Security**, **Performance**, **Maintainability**, **Testing**, etc. Under each category, list the specific issues found:
        
        - Describe each issue briefly but clearly, possibly referencing file names and line numbers (if available) so the developer knows where to look. For example: “`utils/data_parser.py:45` – **Performance:** Uses an O(n^2) loop, which may slow down for large inputs; consider optimizing with a set for O(n) lookups.”
            
        - Provide a suggestion or best practice for each issue. Keep the tone factual and helpful, e.g., “Avoid constructing SQL with string concatenation to prevent SQL injection; use prepared statements instead.”
            
    - Begin the review file with a **high-level summary**. This summary should give an overview of the code health in that scope, such as: “Reviewed 10 files – found 2 potential bugs, 1 security concern, and several style inconsistencies.” Mention any overall strengths or positive observations as well (e.g., “Code is well-organized into modules” or “Follows naming conventions consistently”) to give balance.
        
    - **Do not modify any source code** as part of this review process. The report should only describe issues and recommendations. Ensure the language is clear that these are findings for the developer to address. After writing all findings, save the Markdown file to disk (creating the `reviews/` folder if it doesn’t exist).
        
4. **Developer Guidance**
    
    - After saving the detailed review file, provide a concise summary of the results in the chat to guide the developer. This output should mention the key findings and direct the user to the full report. For example, the assistant might say: “Code review completed. Found 1 critical bug and 2 security issues (see `.claude-sdlc/reviews/2025-07-12T152200-review.md` for details). Overall, 15 items were noted across style, performance, and maintainability.”
        
    - Include the path to the review file in the summary so the developer can easily open it for full details. Make it clear that the full report contains categorized lists of issues and suggestions.
        
    - Suggest **next steps** based on the findings, to help the developer proceed. For instance:
        
        - If serious issues were found, recommend addressing them promptly. You might suggest running `/fix-issue` on specific problems if an automated fix command exists, or simply advise the developer to manually fix the highlighted sections.
            
        - If numerous style issues were found, suggest running a linter or formatter tool (or a dedicated command, if available, to auto-fix style problems).
            
        - If there are gaps in testing, recommend writing new tests for critical functionality, potentially using a command like `/generate-tests` to jump-start that process.
            
        - Encourage the developer to run `/code-review` again on the updated code or specific files after fixes, to verify that all issues have been resolved.
            
    - The overall guidance should be constructive and action-oriented, making it clear how the developer can improve the code. The goal is to use the review results to enhance code quality step by step, integrating with the Claude-SDLC workflow for any follow-up automation.
        

**Example:** If a developer runs `/code-review` with no arguments, the assistant will review the entire repository in strict mode. It will generate a report file (e.g., `.claude-sdlc/reviews/2025-07-12T152200-review.md`) summarizing everything from minor style nitpicks to critical bugs. The chat output might be: “✅ Code review complete. Found 3 potential bugs, 2 security issues, and 8 style or maintainability suggestions. See `.claude-sdlc/reviews/2025-07-12T152200-review.md` for details. Consider running `/fix-issue` on critical findings or addressing the suggestions, then `/code-review` again to verify.” If the developer instead runs `/code-review utils/` targeting a specific directory (or points to a specific commit like `/code-review HEAD~1`), the command will focus only on that scope – e.g., reviewing files under `utils/` or the files changed in the latest commit. The resulting report and summary will then pertain just to that scope, allowing for focused code health checks on recent changes or particular areas of the codebase.