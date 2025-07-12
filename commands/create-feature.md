# Create Feature
Scaffolds a new feature plan by analyzing the requested feature and generating an implementation task checklist aligned with the project's architecture.

## Instructions
1. **Analyze Requirements**
    - Use the provided feature name or description (passed as `$ARGUMENTS`) to understand the feature request and its goals.
    - Derive a concise feature identifier from the argument for use in file names (e.g. if the feature is "User Profile Page", use `user-profile-page` as the identifier).
    - Gather any relevant context from the project (existing code, documentation, etc.) to clarify requirements or identify related components.
        
2. **Consult Architecture Docs**
    - Check the `.claude-sdlc/architecture/` directory for any relevant design documentation. Use shell commands if needed to find pertinent files (for example, run **!**`ls .claude-sdlc/architecture` to list files or **!**`grep -i "profile" .claude-sdlc/architecture/*` to search contents for a keyword).
    - Open and review any architecture files related to this feature’s domain to understand system constraints, data models, or design patterns that should be followed. 
    - Incorporate guidelines from the architecture docs into the feature plan, ensuring the plan aligns with existing architectural decisions and standards.
        
3. **Outline Feature Plan**
    - Break down the feature into a list of atomic development tasks required to implement it from start to finish. 
    - Each task should be a clear, self-contained action (for example: _"Create database migration for new `profiles` table"_, _"Implement `/api/profile` endpoint"_, _"Add frontend form for profile editing"_, _"Write unit tests for profile service"_).
    - Order the tasks in a logical sequence – foundational setup and design steps first, then implementation, followed by testing and documentation.  
    - Ensure the list covers all necessary aspects of the feature: code changes, tests, documentation updates, configuration/deployment steps, etc., so nothing important is missed.
        
4. **Create Feature File**
    - Create a new Markdown file in `.claude-sdlc/features/` for this feature, named `<feature-identifier>.md` (using the identifier derived in step 1).  
    - Write the feature plan into this file as a checklist. Each task becomes an unchecked item using the format `- [ ] Task description` (one task per line). 
    - Verify that all planned tasks are included and that the checklist formatting is correct (each task on its own line, prefixed with `- [ ]`).
        
5. **Optional Scaffolding**
    - If certain tasks in the plan would benefit from initial boilerplate or stub code, scaffold minimal supporting files or placeholders. For example, if the feature requires a new module or component, create an empty source file or class with a basic outline or TODO comments as a starting point.
    - Only create scaffolding that adds clarity or saves time during the build process. Keep any generated stubs simple and clearly marked so developers know they are placeholders to be filled in during implementation.
        
6. **Summarize and Guide**
    - After saving the plan, output a summary in the chat. Begin by confirming the feature name and briefly describing its goal, then present the checklist of tasks so the developer can review the plan.
    - Highlight that the full plan is saved in the project (mention the file path, e.g. `.claude-sdlc/features/user-profile-page.md`) for reference. 
    - Provide guidance on next steps: typically instruct the developer to run the `/build <feature-identifier>` command to start implementing the feature. For example, you might say, _“Now run `/build user-profile-page` to execute this feature plan.”_
        

**Example:** For instance, if a developer runs `/create-feature "User Profile Page"`, the command will create a file `.claude-sdlc/features/user-profile-page.md` with a checklist of tasks (such as _Set up database table for user profiles_, _Implement profile API endpoint_, _Add profile page UI_, _Write profile feature tests_). It will then output this checklist in the chat and suggest using `/build user-profile-page` to proceed with development.