# Create Feature

🎯 **PLANNING PHASE ONLY** - Interactive feature requirements gathering and task planning

## Instructions

⚠️ **CRITICAL**: This command is EXCLUSIVELY for planning and requirements gathering for **$ARGUMENTS**. 
**DO NOT IMPLEMENT ANYTHING**. **DO NOT WRITE CODE**. **DO NOT MAKE FILE CHANGES**.
Implementation happens later with the `/build` command.

### Structured Requirements Interview

**Your role**: Act as a product manager conducting a structured requirements interview. Focus on understanding, not implementing.

#### Phase 1: Initial Discovery (Required)
Start with these core questions and **wait for user responses** before proceeding:

1. "Let's start by understanding the problem. What specific problem or need does **$ARGUMENTS** address?"
2. "Who are the primary users of this feature? What are their roles and typical workflows?"
3. "Can you walk me through 2-3 specific scenarios where users would interact with **$ARGUMENTS**?"

**STOP HERE** - Wait for user answers before continuing to Phase 2.

#### Phase 2: Functional Requirements (Required)
Based on their answers, ask follow-up questions:

4. "What are the core capabilities **$ARGUMENTS** must provide? What actions should users be able to perform?"
5. "Are there any specific business rules or constraints that **$ARGUMENTS** must follow?"
6. "How should **$ARGUMENTS** integrate with existing systems or workflows?"

**STOP HERE** - Wait for user answers before continuing to Phase 3.

#### Phase 3: Technical & Success Criteria (Required)
Complete the requirements gathering:

7. "Are there performance requirements? (response times, data volumes, concurrent users?)"
8. "What security or compliance requirements apply to **$ARGUMENTS**?"
9. "How will you measure if **$ARGUMENTS** is successful? What are the key metrics?"
10. "What's the priority level for **$ARGUMENTS**? (Critical/High/Medium/Low)"

**STOP HERE** - Wait for user answers before proceeding to planning.

#### Phase 4: Confirmation & Planning (Required)
11. "Let me summarize what I've understood..." (Provide detailed summary)
12. "Does this capture everything correctly? Any additions or corrections?"

**ONLY AFTER USER CONFIRMS** - Proceed to create the feature plan.

### Planning Documentation Process

#### Step 1: Architecture Context Review
- Check if `.claude-sdlc/architecture/` directory exists
- If it exists, review relevant architecture documentation
- Note any patterns, constraints, or guidelines that apply to **$ARGUMENTS**

#### Step 2: Create Feature Task List
- Derive a concise feature identifier from **$ARGUMENTS** (kebab-case, no spaces)
- Create `.claude-sdlc/features/<feature-identifier>.md` with:
  - Feature summary and goals
  - User stories and acceptance criteria  
  - Atomic development tasks as checkboxes: `- [ ] Task description`
  - Logical task ordering: planning → setup → implementation → testing → documentation

#### Step 3: Planning Complete - STOP HERE
- Present the feature summary and task list to user
- Confirm the saved file path: `.claude-sdlc/features/<feature-identifier>.md`
- **End with**: "Planning complete! Next step: Run `/build <feature-identifier>` to implement this feature."

### Critical Guidelines

🛑 **ABSOLUTE BOUNDARIES**:
- NO implementation steps
- NO code writing or file changes  
- NO technical research beyond architecture docs
- NO jumping ahead to build phase

✅ **FOCUS ON**:
- Understanding user needs through questions
- Documenting requirements clearly
- Creating actionable task lists
- Maintaining dialogue with user

**Remember**: You are planning WITH the user, not FOR the user. Keep the conversation interactive and collaborative.
