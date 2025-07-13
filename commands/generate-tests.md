# Generate Tests

Create comprehensive test cases to improve code coverage and reliability

## Instructions

Follow this systematic approach to generate tests: **$ARGUMENTS**

1. **Target Analysis and Scope Definition**
   - Determine test scope from $ARGUMENTS:
     - File path: Generate tests for specific file (e.g., `src/auth.js`)
     - Directory: Test all files in directory (e.g., `src/components/`)
     - Module/component: Locate and test specific component (e.g., `UserAuth`)
     - Feature: Test feature-related modules from `.claude-sdlc/features/$ARGUMENTS.md`
     - Issue reference: Generate tests for issue fix (e.g., `issue-123`)
   - If no $ARGUMENTS provided, focus on recently changed or critical code
   - Document the testing scope and objectives for $ARGUMENTS

2. **Environment Setup and Preparation**
   - Ensure you're on the correct branch (usually main/master): `git status`
   - Pull latest changes to stay current: `git pull origin main`
   - Create feature branch for test generation: `git checkout -b tests/$ARGUMENTS`
   - Verify project dependencies are installed: `npm install` or equivalent
   - Check current working directory and project structure
   - Stash any uncommitted changes if necessary: `git stash`

3. **Testing Framework Detection and Setup**
   - Scan project for existing testing setup:
     - Check for `tests/`, `test/`, `__tests__/`, `spec/` directories
     - Identify framework from config files (`jest.config.js`, `pytest.ini`, `vitest.config.js`, `karma.conf.js`, etc.)
     - Review package dependencies for testing libraries (`jest`, `pytest`, `mocha`, `junit`, `rspec`, etc.)
     - Look for existing test patterns, naming conventions, and helper utilities
     - Check for test scripts in `package.json` or build files

   - **Framework-Specific Setup:**
     - **JavaScript/TypeScript**: Jest, Vitest, Mocha, or Cypress for E2E
     - **Python**: PyTest, unittest, or nose2 with appropriate plugins
     - **Java**: JUnit 5, TestNG, or Mockito with Maven/Gradle
     - **C#**: NUnit, xUnit, or MSTest with .NET Core
     - **Go**: Built-in testing package with testify for assertions
     - **Rust**: Built-in test framework with cargo test

   - If no framework found, set up appropriate default with configuration:
     - Create test directory structure and config files
     - Install testing dependencies: `npm install --save-dev jest` or equivalent
     - Set up test scripts and CI integration

4. **Code Analysis and Context Gathering**
   - Read and analyze target code for $ARGUMENTS to understand:
     - Function signatures, parameters, and return types
     - Business logic and data flow
     - Dependencies and external integrations
     - Error conditions and edge cases
   - Review existing architecture documentation in `.claude-sdlc/architecture/`
   - Check for related features in `.claude-sdlc/features/` if applicable

5. **Test Coverage Analysis and Gap Assessment**
   - **Current Coverage Assessment:**
     - Run existing test coverage tools: `npm run test:coverage`, `pytest --cov`, or `go test -cover`
     - Generate coverage reports: `jest --coverage` or equivalent
     - Analyze coverage metrics (line, branch, function coverage)
     - Identify untested code paths and functions in $ARGUMENTS scope

   - **Gap Analysis for $ARGUMENTS:**
     - Compare existing tests against target code functionality
     - Identify missing test scenarios and uncovered edge cases
     - Check for outdated or obsolete tests that need updates
     - Assess test quality and effectiveness (not just coverage percentage)

   - **Comprehensive Test Scenario Mapping:**
     - **Happy Path Testing**: Normal usage flows and expected behaviors
     - **Edge Cases**: Boundary conditions, limits, and corner cases
     - **Error Handling**: Invalid inputs, exceptions, and failure scenarios
     - **Integration Testing**: Component interactions and data flow validation
     - **Security Testing**: Input validation, authentication, authorization
     - **Performance Considerations**: Load testing and scalability where applicable
     - **Regression Testing**: Ensure existing functionality remains intact

6. **Test Case Design and Planning**
   - Create test plan document for $ARGUMENTS with:
     - Test objectives and success criteria
     - Test scenarios and expected outcomes
     - Required test data and fixtures
     - Mock and stub requirements

   - **Unit Tests for $ARGUMENTS**
     - Test individual functions and methods in isolation
     - Cover all logical branches and conditional paths
     - Include boundary value testing (min/max values, limits)
     - Test error conditions and exception handling
     - Verify input validation and sanitization

   - **Integration Tests for $ARGUMENTS**
     - Test component interactions and data flow
     - Verify API endpoints and request/response handling
     - Test database operations, queries, and transactions
     - Check external service integrations and API calls
     - Validate authentication and authorization flows

   - **Edge Case and Stress Testing**
     - Null/undefined/empty inputs and edge values
     - Empty collections, arrays, and strings
     - Maximum/minimum values and overflow conditions
     - Concurrent access and race condition scenarios
     - Network failures and timeout handling

7. **Test Implementation and Code Generation**
   - Create or update test files following project conventions:
     - Use appropriate naming: `test_$ARGUMENTS.py`, `$ARGUMENTS.test.js`, etc.
     - Place in correct directory structure (`tests/`, `__tests__/`, `test/`)
     - Follow project-specific patterns and organization
   - Generate comprehensive test code including:
     - Necessary imports and setup/teardown code
     - Test fixtures, mocks, and test data factories
     - Helper functions and utilities for test setup
     - Proper test isolation and cleanup procedures
   - Ensure tests are independent and can run in any order
   - **Quality Gate**: Verify all generated tests compile/parse correctly

8. **Test Execution and Validation**
   - **Initial Test Run**: Execute generated tests to verify they pass
     - Run specific tests: `npm test tests/$ARGUMENTS` or `pytest tests/test_$ARGUMENTS.py`
     - Check for syntax errors, import issues, or configuration problems
     - **Quality Gate**: All new tests must compile and execute without errors

   - **Regression Testing**: Execute full test suite to check for regressions
     - Run complete test suite: `npm run test:all` or `pytest`
     - Monitor for any existing tests that now fail
     - **Quality Gate**: No existing functionality should be broken by new tests

   - **Coverage Validation**: Analyze test coverage improvements
     - Generate coverage report: `npm run test:coverage` or `pytest --cov`
     - Verify coverage increase for $ARGUMENTS target code
     - **Quality Gate**: Coverage should improve without significant gaps

   - **Test Quality Assessment**:
     - Validate test assertions and expectations are meaningful
     - Ensure tests fail appropriately for invalid scenarios
     - Check that tests are deterministic and not flaky
     - Verify proper cleanup and resource management
     - **Quality Gate**: Tests must be reliable and maintainable

9. **Code Quality and Standards Compliance**
   - **Linting and Formatting**: Run code quality tools on test code
     - Execute linting: `npm run lint` or `flake8 tests/`
     - Apply formatting: `npm run format` or `black tests/`
     - **Quality Gate**: All linting errors must be resolved

   - **Standards Compliance**: Ensure tests follow project conventions
     - Verify test naming follows project patterns
     - Check proper test organization and file structure
     - Validate import statements and dependency usage
     - **Quality Gate**: Tests must adhere to project coding standards

   - **Test Code Quality**: Review test implementation quality
     - Validate mock usage and test data management practices
     - Check for proper setup/teardown and resource cleanup
     - Review test documentation and inline comments for clarity
     - Ensure tests are readable and maintainable
     - **Quality Gate**: Test code quality must meet production standards

10. **Documentation and Reporting**
    - **Create Build Report**: Generate comprehensive test report following PRD specifications
      - File path: `.claude-sdlc/builds/test-generation-$ARGUMENTS-$(date +%Y-%m-%d-%H-%M-%S).md`
      - Include timestamp and unique identifier for traceability

    - **Report Contents** (aligned with PRD build report requirements):
      - **Executive Summary**: Overview of test generation for $ARGUMENTS
      - **Scope and Objectives**: What was tested and why
      - **Test Files Created/Modified**: Complete list with file paths and purposes
      - **Test Cases Added**: Detailed breakdown by category (unit, integration, edge cases)
      - **Coverage Analysis**: Before/after metrics and improvement statistics
      - **Framework and Tools**: Testing framework, tools, and configuration used
      - **Quality Metrics**: Test execution results, performance, and reliability
      - **Issues and Resolutions**: Any problems encountered and how they were solved
      - **Testing Gaps**: Identified limitations and areas needing future attention
      - **Recommendations**: Suggestions for additional testing and improvements
      - **Next Steps**: Follow-up actions and maintenance requirements

    - **Update Project Documentation**:
      - Update README.md if testing setup changed
      - Modify contributing guidelines if new test patterns introduced
      - Update architecture docs in `.claude-sdlc/architecture/` if relevant
      - **Quality Gate**: All documentation must be current and accurate

11. **Git Integration and Version Control**
    - Stage test files and related changes: `git add tests/`
    - Create descriptive commit message: `test: add comprehensive tests for $ARGUMENTS`
    - Commit the changes: `git commit -m "test: add comprehensive tests for $ARGUMENTS"`
    - Push the test branch: `git push origin tests/$ARGUMENTS`
    - **Quality Gate**: Ensure all changes are properly committed and pushed

12. **Pull Request and Code Review Preparation**
    - Create pull request for test additions: `gh pr create --title "Add tests for $ARGUMENTS"`
    - Include in PR description:
      - Summary of tests added for $ARGUMENTS
      - Coverage improvements and metrics
      - Testing approach and methodology used
      - Any dependencies or setup requirements
    - Add appropriate labels and request reviewers
    - Link to related issues or features if applicable

13. **Continuous Integration and Monitoring**
    - Verify tests pass in CI/CD pipeline
    - Monitor test execution times and performance
    - Set up test result notifications and reporting
    - Plan for test maintenance and updates
    - **Quality Gate**: All CI checks must pass before merge

14. **Advanced Testing Considerations**
    - **Performance Testing**: If $ARGUMENTS involves performance-critical code
      - Add benchmark tests for key functions
      - Set up performance regression detection
      - Consider load testing for scalable components

    - **Security Testing**: For authentication, authorization, or data handling
      - Add input validation and sanitization tests
      - Test for common security vulnerabilities (SQL injection, XSS, etc.)
      - Verify proper error handling that doesn't leak sensitive information

    - **Integration with CI/CD**: Ensure tests work in automated environments
      - Verify tests run correctly in CI pipeline
      - Set up test result reporting and notifications
      - Configure test parallelization if supported

15. **Follow-up and Continuous Improvement**
    - **Immediate Actions**:
      - Run full test suite to verify integration: `npm run test:all`
      - Monitor test execution in CI/CD pipeline
      - Review test results and address any issues

    - **Long-term Recommendations**:
      - Set up regular code coverage analysis and monitoring
      - Plan for test maintenance and updates as code evolves
      - Consider automated test generation for future changes
      - Establish test review process for new features

    - **Additional Testing Needs Assessment**:
      - End-to-end testing for complete user workflows
      - Contract testing for API integrations
      - Accessibility testing for UI components
      - Cross-browser/platform testing where applicable

## Special Flags and Options

- **--run-tests**: Automatically execute generated tests after creation
  - When this flag is provided, steps 8-9 will be executed automatically
  - Test results will be included in the build report
  - Any failures will be reported and must be resolved before completion

- **--coverage-target**: Set minimum coverage threshold (e.g., --coverage-target=80)
  - Ensure generated tests meet specified coverage percentage
  - Report will include coverage achievement status

Remember to focus on creating meaningful tests that catch real issues and provide confidence in code reliability for $ARGUMENTS, not just achieving high coverage numbers. Prioritize test quality, maintainability, and practical value over quantity.
