# Create Feature

Scaffold new feature with boilerplate code

## Instructions

Follow this systematic approach to create a new feature: **$ARGUMENTS**

1. **Feature Planning**
   - Define the feature requirements and acceptance criteria for: `$ARGUMENTS`
   - Break down the feature into smaller, manageable tasks
   - Identify affected components and potential impact areas
   - Plan the API/interface design before implementation

2. **Research and Analysis**
   - Study existing codebase patterns and conventions
   - Identify similar features for consistency
   - Research external dependencies or libraries needed
   - Review any relevant documentation or specifications

3. **Architecture Design**
   - Design the feature architecture and data flow for $ARGUMENTS
   - Plan database schema changes if needed
   - Define API endpoints and contracts
   - Consider scalability and performance implications

4. **Environment Setup**
   - Create a new feature branch: `git checkout -b feature/$ARGUMENTS`
   - Ensure development environment is up to date
   - Install any new dependencies required
   - Set up feature flags if applicable

5. **Consult Architecture Documentation**
   - Check the `.claude-sdlc/architecture/` directory for relevant design documentation
   - Use **!**`ls .claude-sdlc/architecture` to list available files
   - Search for related content: **!**`grep -i "$ARGUMENTS" .claude-sdlc/architecture/*`
   - Review architecture files to understand system constraints and design patterns for $ARGUMENTS
   - Incorporate guidelines from architecture docs into the $ARGUMENTS feature plan

6. **Implementation Strategy**
   - Start with core $ARGUMENTS functionality and build incrementally
   - Follow the project's coding standards and patterns
   - Implement proper error handling and validation
   - Use dependency injection and maintain loose coupling

7. **Database Changes (if applicable)**
   - Create migration scripts for schema changes
   - Ensure backward compatibility
   - Plan for rollback scenarios
   - Test migrations on sample data

8. **API Development**
   - Implement API endpoints with proper HTTP status codes
   - Add request/response validation
   - Implement proper authentication and authorization
   - Document API contracts and examples

9. **Frontend Implementation (if applicable)**
   - Create reusable components following project patterns
   - Implement responsive design and accessibility
   - Add proper state management
   - Handle loading and error states

10. **Testing Implementation**
    - Write unit tests for core business logic
    - Create integration tests for API endpoints
    - Add end-to-end tests for user workflows
    - Test error scenarios and edge cases

11. **Security Considerations**
    - Implement proper input validation and sanitization
    - Add authorization checks for sensitive operations
    - Review for common security vulnerabilities
    - Ensure data protection and privacy compliance

12. **Performance Optimization**
    - Optimize database queries and indexes
    - Implement caching where appropriate
    - Monitor memory usage and optimize algorithms
    - Consider lazy loading and pagination

13. **Documentation**
    - Add inline code documentation and comments
    - Update API documentation
    - Create user documentation if needed
    - Update project README if applicable

14. **Create Feature Task List**
    - Derive a concise feature identifier from $ARGUMENTS for file naming
    - Create a new Markdown file in `.claude-sdlc/features/` named `<feature-identifier>.md`
    - Break down the $ARGUMENTS feature into atomic development tasks
    - Write tasks as a checklist using format `- [ ] Task description`
    - Order tasks logically: setup → implementation → testing → documentation
    - Ensure all aspects are covered: code, tests, docs, configuration

15. **Code Review Preparation**
    - Run all tests and ensure they pass
    - Run linting and formatting tools
    - Check for code coverage and quality metrics
    - Perform self-review of the changes

16. **Integration Testing**
    - Test feature integration with existing functionality
    - Verify feature flags work correctly
    - Test deployment and rollback procedures
    - Validate monitoring and logging

17. **Commit and Push**
    - Create atomic commits with descriptive messages
    - Follow conventional commit format if project uses it
    - Push feature branch: `git push origin feature/$ARGUMENTS`

18. **Optional Scaffolding**
    - Create minimal boilerplate or stub code if beneficial
    - Generate empty source files with basic outlines
    - Add TODO comments as placeholders
    - Keep scaffolding simple and clearly marked

19. **Summarize and Guide**
    - Output a summary confirming the feature name and goals
    - Present the task checklist for developer review
    - Mention the saved file path (`.claude-sdlc/features/<feature-identifier>.md`)
    - Provide next steps: suggest running `/build <feature-identifier>` to implement

Remember to maintain code quality, follow project conventions, and prioritize user experience throughout the development process.