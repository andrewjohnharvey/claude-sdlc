# Build Command

Automates the execution of a planned feature by running through its checklist of development tasks.

## Instructions

Follow this systematic approach to build feature: **$ARGUMENTS**

1. **Load Feature Plan**
   - Use the provided feature identifier **$ARGUMENTS** to locate `.claude-sdlc/features/$ARGUMENTS.md`
   - If no feature name is given or the file does not exist, inform the user and halt
   - The feature may need to be planned with `/create-feature` first
   - Read the Markdown checklist to retrieve the ordered task list for implementation

2. **Load Architecture Context**
   - Search: `grep -i "$ARGUMENTS" .claude-sdlc/architecture/*`
   - Check `.claude-sdlc/architecture/` directory for design documentation related to this feature
   - Review relevant architecture files (design specs, data models, interface definitions)
   - Incorporate guidelines from these docs into the implementation approach
   - **Quality Gate**: Ensure understanding of system constraints and patterns
   - If no specific architecture doc is found, ask if you want to build one for this feature

3. **Execute Feature Tasks**
   - Iterate through each task in the feature's checklist sequentially
   - For independent tasks, consider parallel execution using Claude sub-agents
   - Perform necessary code or configuration changes for each task
   - Use tool capabilities to verify each task's outcome (compilation, tests, etc.)
   - **Quality Gate**: Run `npm run build` or `pytest` as appropriate after each task
   - Mark completed tasks as done by updating checkbox from `[ ]` to `[x]`
   - Save progress to `.claude-sdlc/features/$ARGUMENTS.md` in real-time

4. **Handle Errors and Clarifications**
   - **Pause immediately** if any task fails or encounters an error
   - Present error details (compiler output, test failures, stack traces) to user
   - Ask for guidance before making further changes
   - Wait for user confirmation or instructions before resuming
   - Re-run necessary checks after fixes to ensure problems are resolved
   - **Quality Gate**: Verify all tests pass before proceeding to next task

5. **Parallel Task Coordination and Sub-Agent Spawning**
   - **Identify Independent Tasks**: Review the feature checklist and group tasks that:
     - Operate on different files or components
     - Have no dependencies on each other's completion
     - Can be executed simultaneously without conflicts
   
   - **Automatic Sub-Agent Spawning**: For independent task groups, use the Task tool to spawn sub-agents:
     - Use multiple Task tool calls in a single message for parallel execution
     - Each sub-agent receives specific tasks: "Implement task X from feature $ARGUMENTS checklist"
     - Include relevant context: feature requirements, architecture constraints, coding standards
     - Ensure each sub-agent knows to report back with implementation status and any issues
   
   - **Task Distribution Examples**:
     - Frontend components → Sub-agent A
     - Backend API endpoints → Sub-agent B  
     - Database migrations → Sub-agent C
     - Configuration files → Sub-agent D
   
   - **Coordination Guidelines**:
     - No file conflicts: Assign different files/directories to different sub-agents
     - Each sub-agent updates progress in `.claude-sdlc/features/$ARGUMENTS.md`
     - Sub-agents report completion status, files modified, and any errors encountered
     - Main agent aggregates results and handles integration between completed tasks
   
   - **Quality Gate**: Verify all parallel tasks complete successfully and integrate properly before proceeding

6. **Generate Build Report**
   - Create comprehensive build report upon completion or failure
   - Save as `.claude-sdlc/builds/$(date +%Y-%m-%d-%H%M)-$ARGUMENTS.md`
   - Include final task checklist with completion status
   - Document actions taken for each task (files created/modified, functions implemented)
   - Record any errors encountered and their resolutions
   - Note outcome: "Build successful" or "Build paused due to errors"
   - **Quality Gate**: Ensure report includes all necessary details for audit trail
   - Update relevant documents in `.claude-sdlc/builds/` folder

7. **Summarize and Guide**
   - Output concise summary confirming feature build status
   - Provide path to detailed build report file
   - Suggest next steps (typically `/code-review` for successful builds)
   - For paused builds, advise on how to continue after fixes
   - Emphasize reliability and transparency of the automated process

**Example Usage:**
Running `/build user-authentication` will:
- Load `.claude-sdlc/features/user-authentication.md`
- Execute each task (database migration, API endpoints, frontend UI)
- Work on backend and frontend tasks in parallel when possible
- Pause if unit tests fail and present error to user
- Generate `.claude-sdlc/builds/user-authentication-2025-07-12T15-18-31.md`
- Suggest running `/code-review` to verify the changes

Remember to maintain code quality, follow project conventions, and prioritize user experience throughout the development process.
