# Real-World Custom Claude Code Slash Command Examples

Below we explore real examples of custom **Claude Code** slash commands from two open-source repositories – **Claude-Command-Suite** (by qdhenry) and **SuperClaude** (by NomenAK). Each example highlights the command’s name, purpose, and how it is defined using Anthropic’s slash command format (with `$ARGUMENTS`, optional frontmatter/includes, and embedded shell actions). These examples demonstrate advanced patterns like dynamic argument substitution, shell pipelines, and modular command definitions.

## /project:create-feature – Scaffold New Feature

**Purpose:** _“Scaffold new feature with boilerplate code”_[raw.githubusercontent.com](https://raw.githubusercontent.com/qdhenry/Claude-Command-Suite/main/.claude/commands/project/create-feature.md#:~:text=Create%20Feature%20Command%20Scaffold%20new,Define%20the%20feature%20requirements%20and). This command from **Claude-Command-Suite** automates the workflow of planning and implementing a new feature in a project.

 

**Definition (excerpt):** The command file breaks the task into sequential steps (Planning, Design, Implementation, etc.). It uses `$ARGUMENTS` to capture the feature name provided by the user, and includes shell steps for Git operations (branching and pushing). For example, it creates a new Git branch named after the feature and later pushes it:

`` # Create Feature Command Scaffold new feature with boilerplate code  ## Instructions  Follow this systematic approach to create a new feature: **$ARGUMENTS**  4. **Environment Setup**    - Create a new feature branch: `git checkout -b feature/$ARGUMENTS`    - Ensure the dev environment is up to date (pull latest changes)   - Install any new dependencies required   - Set up feature flags if applicable  15. **Commit and Push**    - ... Push feature branch: `git push origin feature/$ARGUMENTS` ``

[raw.githubusercontent.com](https://raw.githubusercontent.com/qdhenry/Claude-Command-Suite/main/.claude/commands/project/create-feature.md#:~:text=endpoints%20and%20contracts%20,Implement)[raw.githubusercontent.com](https://raw.githubusercontent.com/qdhenry/Claude-Command-Suite/main/.claude/commands/project/create-feature.md#:~:text=%2A%2ACommit%20and%20Push%2A%2A%20,any%20related%20issues%20or%20specifications)

 

**Key Patterns:**

- _Dynamic arguments:_ The placeholder `$ARGUMENTS` is used in branch names and elsewhere, so invoking `/project:create-feature **UserAuth**` will substitute “UserAuth” in the branch name (`feature/UserAuth`)[raw.githubusercontent.com](https://raw.githubusercontent.com/qdhenry/Claude-Command-Suite/main/.claude/commands/project/create-feature.md#:~:text=endpoints%20and%20contracts%20,feature%20flags%20if%20applicable%205).
    
- _Shell command usage:_ Instructions explicitly include Git commands (in backticks) like `git checkout -b ...` and `git push ...` to be executed in sequence[raw.githubusercontent.com](https://raw.githubusercontent.com/qdhenry/Claude-Command-Suite/main/.claude/commands/project/create-feature.md#:~:text=endpoints%20and%20contracts%20,Implement)[raw.githubusercontent.com](https://raw.githubusercontent.com/qdhenry/Claude-Command-Suite/main/.claude/commands/project/create-feature.md#:~:text=%2A%2ACommit%20and%20Push%2A%2A%20,any%20related%20issues%20or%20specifications).
    
- _Structured steps:_ The markdown is organized into numbered steps (1 through 18) guiding the AI through feature planning, coding, testing, and deployment preparation, ensuring nothing is overlooked.
    

## /dev:fix-issue – Guided Bug Fix Workflow

**Purpose:** _“Identify and resolve code issues”_[raw.githubusercontent.com](https://raw.githubusercontent.com/qdhenry/Claude-Command-Suite/main/.claude/commands/dev/fix-issue.md#:~:text=Fix%20Issue%20Command%20Identify%20and,Read). Another command from **Claude-Command-Suite**, `/dev:fix-issue` streamlines the process of fixing a bug or issue (often linked to an issue tracker ID).

 

**Definition (excerpt):** This command accepts an issue number as an argument and uses it throughout the workflow. It integrates with GitHub’s CLI (`gh`) and git commands to retrieve issue details, create a branch, and reference the issue in commits/PRs:

``# Fix Issue Command Identify and resolve code issues  ## Instructions  Follow this structured approach to analyze and fix issues: **$ARGUMENTS**  1. **Issue Analysis**    - Use `gh issue view $ARGUMENTS` to get complete issue details   - Read the issue description, comments, etc.   - Identify the issue type and expected vs actual behavior  2. **Environment Setup**    - Ensure you're on the main branch and up-to-date (`git pull origin main`)    - Create a new feature branch: `git checkout -b fix/issue-$ARGUMENTS`    ... 10. **Commit and Push**    - Stage changes and create a descriptive commit (e.g. `fix: resolve issue with ... (#$ARGUMENTS)`)    - Push the branch: `git push origin fix/issue-$ARGUMENTS`  11. **Create Pull Request**    - Use `gh pr create` to open a PR (reference "Fixes #$ARGUMENTS" in description)``

[raw.githubusercontent.com](https://raw.githubusercontent.com/qdhenry/Claude-Command-Suite/main/.claude/commands/dev/fix-issue.md#:~:text=structured%20approach%20to%20analyze%20and,Run%20the%20application%2Ftests%20to)[raw.githubusercontent.com](https://raw.githubusercontent.com/qdhenry/Claude-Command-Suite/main/.claude/commands/dev/fix-issue.md#:~:text=changelog%20if%20the%20project%20maintains,Update%20the%20issue)

 

**Key Patterns:**

- _Argument substitution:_ The `$ARGUMENTS` token is used to inject the issue number into commands and text. For example, running `/dev:fix-issue 123` will cause `gh issue view 123` to run and create a branch `fix/issue-123`[raw.githubusercontent.com](https://raw.githubusercontent.com/qdhenry/Claude-Command-Suite/main/.claude/commands/dev/fix-issue.md#:~:text=structured%20approach%20to%20analyze%20and,Run%20the%20application%2Ftests%20to).
    
- _External tool integration:_ The instructions leverage CLI tools – `gh issue view` fetches the issue details from GitHub, and `gh pr create` opens a pull request, demonstrating integration with GitHub workflows[raw.githubusercontent.com](https://raw.githubusercontent.com/qdhenry/Claude-Command-Suite/main/.claude/commands/dev/fix-issue.md#:~:text=structured%20approach%20to%20analyze%20and,Run%20the%20application%2Ftests%20to)[raw.githubusercontent.com](https://raw.githubusercontent.com/qdhenry/Claude-Command-Suite/main/.claude/commands/dev/fix-issue.md#:~:text=changelog%20if%20the%20project%20maintains,Monitor%20the%20PR%20for%20feedback).
    
- _Dynamic naming:_ The issue number is incorporated into branch names and commit messages (e.g. `(#123)` in the commit) to link the fix to the issue tracker[raw.githubusercontent.com](https://raw.githubusercontent.com/qdhenry/Claude-Command-Suite/main/.claude/commands/dev/fix-issue.md#:~:text=changelog%20if%20the%20project%20maintains,Monitor%20the%20PR%20for%20feedback).
    
- _Thorough workflow:_ The command ensures a complete cycle: reproducing the bug, analyzing root cause, implementing a fix, testing it, and then committing and creating a PR with references to the issue.
    

## /dev:clean-branches – Automated Git Branch Cleanup

**Purpose:** _“Clean up merged and stale git branches”_[raw.githubusercontent.com](https://raw.githubusercontent.com/qdhenry/Claude-Command-Suite/main/.claude/commands/dev/clean-branches.md#:~:text=Clean%20Branches%20Command%20Clean%20up,branch%20and%20uncommitted%20changes). This advanced command from **Claude-Command-Suite** shows a maintenance task, using shell pipelines and even scripts to automate branch cleanup.

 

**Definition (excerpt):** The command’s instructions include multiple embedded shell blocks to list branches, filter them, and remove those safe to delete. It uses pipelines (`|`, `grep`, `xargs`, etc.) and even provides a shell script for automation:

`## Instructions  1. **Repository State Analysis**    - Check current branch and list all local/remote branches   - Identify the main branch name      ```bash    git status     git branch -a     git remote -v     # Determine main branch name:    git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'`

3. **Identify Merged Branches**
    
    - List branches merged into main (excluding protected branches)
        
    
    `git branch --merged main | grep -v "main\|master\|develop\|\\*" git branch -r --merged main | grep -v "main\|master\|develop\|HEAD"`
    
4. **Automated Cleanup Script**
    
    `#!/bin/bash  PROTECTED_BRANCHES=("main" "master" "develop" ...) # Switch to main and pull latest git checkout $MAIN_BRANCH && git pull origin $MAIN_BRANCH # Delete merged local branches except protected: merged_branches=$(git branch --merged $MAIN_BRANCH | grep -v "\\*\\|$MAIN_BRANCH") for branch in $merged_branches; do      if ! is_protected "$branch"; then          git branch -d "$branch"      fi  done  # Prune remote tracking branches and delete remote branches...`
    

``:contentReference[oaicite:14]{index=14}:contentReference[oaicite:15]{index=15}  **Key Patterns:**  - *Embedded shell commands:* The command definition uses fenced code blocks with `bash` commands that Claude will execute. For example, it runs `git branch --merged main | grep ...` to find merged branches and uses `git branch -d` to delete them, piped through `xargs` for batch deletion:contentReference[oaicite:16]{index=16}:contentReference[oaicite:17]{index=17}. - *Shell pipelines:* Complex shell pipelines are present (using `grep`, `awk`, `sed`, `xargs`). For instance, one snippet filters out protected branch names and then uses `xargs` to delete each merged branch:contentReference[oaicite:18]{index=18}:contentReference[oaicite:19]{index=19}. This shows Claude can follow multi-step shell pipelines in a command. - *Branching logic in scripts:* The example includes a mini shell script with an `if` check (`if ! is_protected "$branch"` ...) to avoid deleting protected branches:contentReference[oaicite:20]{index=20}. This demonstrates that custom commands can incorporate conditional logic by embedding script code. - *No arguments needed:* `$ARGUMENTS` is shown (bolded at the top of the instructions:contentReference[oaicite:21]{index=21}) but in this case the cleanup operates on the repository as a whole. The steps ensure safety (stashing changes, switching to main) and require user confirmation (`-p` flag in `xargs`) for each branch deletion, making it an interactive but automated workflow.  ## /dev:directory-deep-dive – Document Architecture of a Directory  **Purpose:** *“Analyze directory structure and purpose”*:contentReference[oaicite:22]{index=22}. This command (from **Claude-Command-Suite**) performs a static analysis of a given directory’s code and produces documentation about it.  **Definition (excerpt):** The command can take an optional directory path as an argument. It instructs Claude to examine that directory’s design patterns and then create or update a `CLAUDE.md` documentation file capturing the findings:  ```markdown # Directory Deep Dive  Analyze directory structure and purpose  ## Instructions  1. **Target Directory**    - Focus on the specified directory `$ARGUMENTS` or the current working directory  2. **Investigate Architecture**    - Analyze the design patterns, dependencies, key abstractions, and code organization in this directory and its subdirectories  3. **Create or Update Documentation**    - Create a `CLAUDE.md` file capturing this knowledge     - If one already exists, update it with newly discovered information     - Include:      - Purpose and responsibility of this module      - Key architectural decisions and implementation details      - Any gotchas or non-obvious behaviors  4. **Ensure Proper Placement**    - Place the `CLAUDE.md` file in the directory being analyzed (so it loads as context when working in that area)``

[raw.githubusercontent.com](https://raw.githubusercontent.com/qdhenry/Claude-Command-Suite/main/.claude/commands/dev/directory-deep-dive.md#:~:text=Directory%20Deep%20Dive%20Analyze%20directory,Common%20patterns)[raw.githubusercontent.com](https://raw.githubusercontent.com/qdhenry/Claude-Command-Suite/main/.claude/commands/dev/directory-deep-dive.md#:~:text=organization%203.%20,with)

 

**Key Patterns:**

- _Optional arguments:_ The command uses `$ARGUMENTS` to allow specifying a target directory. If the user calls `/dev:directory-deep-dive src/utils`, the analysis will focus there; if no argument is given, it defaults to the current directory[raw.githubusercontent.com](https://raw.githubusercontent.com/qdhenry/Claude-Command-Suite/main/.claude/commands/dev/directory-deep-dive.md#:~:text=Directory%20Deep%20Dive%20Analyze%20directory,in%20this%20directory%20and%20its).
    
- _Knowledge capture:_ The instructions explicitly guide Claude to generate a documentation file (`CLAUDE.md`) summarizing the architecture of the directory[raw.githubusercontent.com](https://raw.githubusercontent.com/qdhenry/Claude-Command-Suite/main/.claude/commands/dev/directory-deep-dive.md#:~:text=organization%203.%20,with). This is a dynamic report-generation pattern – the AI will likely output the documentation content as a result of the command.
    
- _Static analysis workflow:_ The steps cover understanding design patterns, checking for certain architecture aspects, and documenting them. It’s a specialized analysis command that doesn’t run shell commands, but rather uses Claude’s reading of the code to produce insights.
    

## /build – Project Builder with Stack Templates (SuperClaude)

**Purpose:** _“Universal project builder with stack templates”_[raw.githubusercontent.com](https://raw.githubusercontent.com/NomenAK/SuperClaude/master/.claude/commands/build.md#:~:text=,Build%20project%2Ffeature%20based). The **SuperClaude** framework defines `/build` as a high-level command to create or extend a project, with various configuration flags for different tech stacks and methodologies.

 

**Definition (structure):** Unlike simpler commands, SuperClaude commands use a **modular frontmatter** approach with `@include` directives and flag handling. The top of the `build.md` file establishes common context and merges in shared configuration, then lists examples and mode flags:

``**Purpose**: Universal project builder with stack templates   --- @include shared/universal-constants.yml#Universal_Legend  ## Command Execution Execute: immediate. `--plan` → show plan first  Purpose: "[Action][Subject] in $ARGUMENTS"   Build project/feature based on requirements in $ARGUMENTS.  @include shared/flag-inheritance.yml#Universal_Always  Examples:  - `/build --react --magic` – React app with UI generation   - `/build --api --c7` – API with documentation   - `/build --react --magic --pup` – Build & test UI ... (pre-build checks and build mode flags below) ...``

[raw.githubusercontent.com](https://raw.githubusercontent.com/NomenAK/SuperClaude/master/.claude/commands/build.md#:~:text=,build)

 

Following the examples, the file defines **build modes** and flags (e.g. `--init`, `--feature`, `--tdd`) that alter the behavior:

`Build modes: **--init:** New project with chosen stack (React, API, Fullstack, etc.) – includes testing setup and git workflow   **--feature:** Implement a feature in an existing project (maintain consistency and include tests)   **--tdd:** Use test-driven development (write failing tests, then code to pass, then refactor)   ...   **--watch:** Continuous build with live reload   **--interactive:** Step-by-step configuration with interactive prompts`

[raw.githubusercontent.com](https://raw.githubusercontent.com/NomenAK/SuperClaude/master/.claude/commands/build.md#:~:text=Remove%20artifacts%20%28dist%2F%2C%20build%2F%2C%20,Live%20reload)

 

**Key Patterns:**

- _Frontmatter includes:_ The command file uses `@include` statements to pull in shared YAML configurations. For example, `shared/universal-constants.yml` might define common prompt elements (like legends or templates), and `flag-inheritance.yml` likely handles global flags that apply to all commands[raw.githubusercontent.com](https://raw.githubusercontent.com/NomenAK/SuperClaude/master/.claude/commands/build.md#:~:text=,inheritance.yml%23Universal_Always). This modular design means the command inherits standard behaviors (e.g. always allow a `--plan` flag to preview steps).
    
- _Flags and modes:_ The `/build` command heavily relies on **flags** (`--react`, `--api`, `--tdd`, `--interactive`, etc.) to adjust its operation[raw.githubusercontent.com](https://raw.githubusercontent.com/NomenAK/SuperClaude/master/.claude/commands/build.md#:~:text=Examples%3A%20,%2A%2AFullstack%3A%2A%2A%20React%2BNode.js%2BDocker). This allows one command to cover many scenarios (new project vs. new feature, different tech stacks, etc.) by toggling flags. The command definition explicitly documents what each flag does, as seen in the **Build modes** snippet above.
    
- _Dynamic arguments:_ `$ARGUMENTS` here would represent the project or feature description to build. The “Purpose” line constructs a dynamic phrase with the action and subject in that argument[raw.githubusercontent.com](https://raw.githubusercontent.com/NomenAK/SuperClaude/master/.claude/commands/build.md#:~:text=immediate.%20,inheritance.yml%23Universal_Always) (e.g. if you run `/build *Shopping Cart*`, it will interpret it as “Build project/feature based on requirements in _Shopping Cart_”).
    
- _Plan vs. immediate execution:_ A special `--plan` flag is supported (noted in “Execute: immediate. `--plan`→show plan first”[raw.githubusercontent.com](https://raw.githubusercontent.com/NomenAK/SuperClaude/master/.claude/commands/build.md#:~:text=,Build%20project%2Ffeature%20based)). This indicates the command can either execute immediately or, if `--plan` is provided, output a plan (steps) first. This kind of branching logic is handled through the command’s configuration, showing an advanced usage where the slash command can either act in planning mode or action mode based on flags.
    

## /review – Comprehensive Code Review with Personas (SuperClaude)

**Purpose:** _“AI-powered code review and quality analysis”_[raw.githubusercontent.com](https://raw.githubusercontent.com/NomenAK/SuperClaude/master/.claude/commands/review.md#:~:text=%2A%2APurpose%2A%2A%3A%20AI,or%20pull%20requests%20specified%20in). The SuperClaude `/review` command performs a thorough code review, with optional flags to focus on certain areas (security, performance, etc.) and the ability to apply **cognitive personas** for specialized insight.

 

**Definition (structure):** The command definition outlines how to use various flags to specify what to review (files, commits, PRs) and what focus to apply. It also pulls in shared best-practice checklists via includes. Key sections from `review.md`:

- **Examples and $ARGUMENTS:** The usage examples show how the command can be invoked with different flags. For instance: `/review --files src/auth.ts --persona-security` for a security-focused review of a file, or `/review --commit HEAD --quality --evidence` for analyzing the latest commit with quality checks and requiring evidence citations[raw.githubusercontent.com](https://raw.githubusercontent.com/NomenAK/SuperClaude/master/.claude/commands/review.md#:~:text=review%20and%20quality%20analysis%20on,Command). The `$ARGUMENTS` in this command would typically be used to specify the target (file path, commit hash, or PR number).


[raw.githubusercontent.com](https://raw.githubusercontent.com/NomenAK/SuperClaude/master/.claude/commands/review.md#:~:text=Specific%20Flags%20,%40include%20shared%2Fquality)

- **Process and Criteria:** The instructions then outline a multi-step **review process** (context analysis, multi-dimensional scan, evidence collection, prioritized findings, and recommendations) ensuring the review is comprehensive[raw.githubusercontent.com](https://raw.githubusercontent.com/NomenAK/SuperClaude/master/.claude/commands/review.md#:~:text=patterns.yml,All%20suggestions%20must%20cite). They also include sections enforcing _evidence-based analysis_ (requiring the AI to cite sources) and _persona specialization_ guidelines[raw.githubusercontent.com](https://raw.githubusercontent.com/NomenAK/SuperClaude/master/.claude/commands/review.md#:~:text=Specific%20fix%20suggestions%20,QA%E2%86%92Coverage%2Bvalidation%20%40include%20shared%2Fresearch).
    


**Key Patterns:**

    
- _Modular includes:_ Similar to `/build`, the `/review` command file uses `@include` directives to insert standardized content. It includes templates for quality metrics, security checks (like OWASP Top 10), performance baselines, and architectural principles[raw.githubusercontent.com](https://raw.githubusercontent.com/NomenAK/SuperClaude/master/.claude/commands/review.md#:~:text=,3.%20Evidence%20Collection), as well as research and execution patterns. This means the command is assembling a prompt that contains general best-practice checks from those included files, combined with the specific instructions. This modular design avoids repetition and ensures that, for example, the OWASP Top 10 checklist is consistently used anywhere a security review is done.
    
- _Evidence-based output:_ Notably, the command emphasizes evidence and sources. The **Evidence-Based Analysis** step enforce that the AI’s recommendations should cite documentation or authoritative references[raw.githubusercontent.com](https://raw.githubusercontent.com/NomenAK/SuperClaude/master/.claude/commands/review.md#:~:text=Scan%3A,reference). This pattern shows how you can instruct Claude to perform additional research (possibly via tools like Context7 as hinted in the text) and back up its suggestions, which is useful for generating dynamic reports (e.g., a review report that includes quotes from docs or standards).
