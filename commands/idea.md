# Idea

🧠 **IDEA CAPTURE PHASE** - Quick brain dump for development ideas during workflow

## Instructions

⚠️ **FOCUS**: This command is EXCLUSIVELY for capturing and documenting ideas about **$ARGUMENTS**. 
**DO NOT IMPLEMENT ANYTHING**. **DO NOT WRITE CODE**. **DO NOT MAKE FILE CHANGES**.
Implementation planning happens later with the `/create-feature` command.

### Quick Idea Capture Process

**Your role**: Act as a collaborative brainstorming partner, helping capture and structure the user's idea quickly without breaking their development flow.

#### Idea Capture Interview (Single Round)

Start with these focused questions and **wait for user responses** before proceeding:

1. "What's the core intent or goal of **$ARGUMENTS**? What are you trying to achieve?"
2. "What specific problem does **$ARGUMENTS** solve? What pain point or need does it address?"
3. "Who would benefit most from **$ARGUMENTS**? Who are the primary users or stakeholders?"

**STOP HERE** - Wait for user answers before proceeding to idea documentation.

#### Confirmation & Documentation

4. "Let me summarize what I've captured..." (Provide clear summary)
5. "Does this capture your idea correctly? Any additions or quick clarifications?"

**ONLY AFTER USER CONFIRMS** - Proceed to create the idea documentation.

### MCP-Enhanced Idea Capture

Before proceeding with idea documentation, leverage available MCP servers for enhanced capture:

- **Context7**: For quick documentation lookup and idea validation against existing libraries
- **Sequential Thinking**: For structured idea analysis and refinement
- **Shadcn UI**: For component-related ideas and design system alignment
- **Other custom MCP servers**: As available in your environment

Use available MCP capabilities throughout the idea capture process for:
- Rapid idea validation and feasibility assessment
- Connection to existing patterns and libraries
- Initial technical consideration without full implementation planning
- Enhanced idea structuring and categorization

### Idea Documentation Process

#### Step 1: CLAUDE.md Integration

- Check if CLAUDE.md exists in project root directory
- If missing, note for later: "No CLAUDE.md found - consider initializing project-specific idea capture guidelines"
- If present, reference CLAUDE.md for:
  - Development workflow preferences and idea capture patterns
  - Technology stack preferences for idea evaluation
  - Feature development and implementation approaches
  - Quality standards and validation preferences for new ideas
- Apply CLAUDE.md preferences to idea structure and next steps recommendations

#### Step 2: Create Idea Documentation

- Derive a concise idea identifier from **$ARGUMENTS** (kebab-case, no spaces)
- Create `.claude-sdlc/ideas/$(date +%Y-%m-%d-%H%M)-<idea-identifier>.md` with:
  - Idea summary and captured responses
  - Intent, problem, and beneficiaries from user responses
  - Timestamp and identifier for tracking
  - Clear next steps for feature development

#### File Persistence Guidelines

- Automatically save the idea documentation immediately after creation
- Save with timestamp to avoid conflicts during rapid idea capture
- Confirm file location with user for reference
- No manual saving steps required from user
- Verify file was successfully written to `.claude-sdlc/ideas/` directory

#### Step 3: Idea Capture Complete - STOP HERE

- Present the idea summary to user
- Confirm the saved file path: `.claude-sdlc/ideas/$(date +%Y-%m-%d-%H%M)-<idea-identifier>.md`
- **End with**: "Idea captured! Next step: Run `/create-feature <idea-identifier>` to begin structured feature planning."

### Critical Guidelines

🛑 **ABSOLUTE BOUNDARIES**:
- NO implementation steps
- NO code writing or file changes
- NO detailed technical research
- NO feature planning beyond basic idea capture
- NO jumping ahead to create-feature phase

✅ **FOCUS ON**:
- Quick idea capture without workflow disruption
- Structured documentation for future reference
- Clear connection to next steps in development process
- Maintaining development flow and minimizing cognitive load

### Next Steps and Follow-up

- **Immediate Next Step**: Run `/create-feature <idea-identifier>` to begin structured feature planning
- **Idea Review**: Browse captured ideas in `.claude-sdlc/ideas/` directory
- **Batch Processing**: Multiple ideas can be captured quickly during active development sessions
- **Integration**: Ideas serve as structured input for the complete claude-sdlc workflow

**Remember**: You are capturing ideas WITH the user, not FOR the user. Keep the interaction fast, focused, and minimally disruptive to their development workflow.