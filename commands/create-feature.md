# Create Feature

Interactive feature planning and requirements gathering (PRD creation)

## Instructions

This command is ONLY for planning and creating a Product Requirements Document (PRD) for **$ARGUMENTS**. No implementation will be done at this stage. Implementation will be handled separately by the `/build` command.

### Interactive Planning Workflow

1. **Initial Engagement**
   - Begin by asking the user specific questions about the $ARGUMENTS feature
   - Establish a back-and-forth dialogue to fully understand requirements
   - Continue asking questions until you have comprehensive understanding
   - Only proceed to creating the task list after sufficient information gathering

2. **Required Information Gathering**
   - Feature purpose and goals: "What specific problem does $ARGUMENTS solve?"
   - Target users: "Who will be using this feature? What are their roles/needs?"
   - Use cases: "What are the primary scenarios where users will use $ARGUMENTS?"
   - Required functionality: "What specific capabilities must $ARGUMENTS provide?"
   - Technical constraints: "Are there performance, security, or compatibility requirements?"
   - Integration points: "How will $ARGUMENTS connect with existing systems?"
   - Success criteria: "How will we measure if $ARGUMENTS is successful?"
   - Priority level: "Is this a core, high, medium, or low priority feature?"

3. **Feature Planning**
   - Define the feature requirements and acceptance criteria for: `$ARGUMENTS`
   - Break down the feature into smaller, manageable tasks
   - Identify affected components and potential impact areas
   - Plan the API/interface design before implementation

4. **Research and Analysis**
   - Study existing codebase patterns and conventions
   - Identify similar features for consistency
   - Research external dependencies or libraries needed
   - Review any relevant documentation or specifications

5. **Architecture Design**
   - Design the feature architecture and data flow for $ARGUMENTS
   - Plan database schema changes if needed
   - Define API endpoints and contracts
   - Consider scalability and performance implications

6. **Consult Architecture Documentation**
   - Check the `.claude-sdlc/architecture/` directory for relevant design documentation
   - Use **!**`ls .claude-sdlc/architecture` to list available files
   - Search for related content: **!**`grep -i "$ARGUMENTS" .claude-sdlc/architecture/*`
   - Review architecture files to understand system constraints and design patterns for $ARGUMENTS
   - Incorporate guidelines from architecture docs into the $ARGUMENTS feature plan

7. **Create Feature Task List**
   - Derive a concise feature identifier from $ARGUMENTS for file naming
   - Create a new Markdown file in `.claude-sdlc/features/` named `<feature-identifier>.md`
   - Break down the $ARGUMENTS feature into atomic development tasks
   - Write tasks as a checklist using format `- [ ] Task description`
   - Order tasks logically: setup → implementation → testing → documentation
   - Ensure all aspects are covered: code, tests, docs, configuration

8. **Summarize and Guide**
   - Output a summary confirming the feature name and goals
   - Present the task checklist for developer review
   - Mention the saved file path (`.claude-sdlc/features/<feature-identifier>.md`)
   - Provide next steps: suggest running `/build <feature-identifier>` to implement

Remember to maintain an interactive dialogue throughout the planning process. Do not proceed to creating the task list until you have gathered comprehensive information about the feature requirements.
