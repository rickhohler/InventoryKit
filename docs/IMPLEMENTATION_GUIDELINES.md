# Implementation Guidelines

All implementations must adhere to the following standards:

## Design Patterns & Architecture

- **MUST** use DesignAlgorithmsKit (DAK) for design patterns and algorithms whenever an equivalent exists
- **MUST** use a composite component design pattern
- **MUST** apply SOLID principles
- **MUST** use approved DAK patterns for singletons and registries (do not implement custom patterns) and algorithms. Identify any missing design patterns and/or or algorithms create a github issue in the DAK project using gh command with user rickhohler. If urgent, clone DAK locally, work github issue on working branch, then create a PR.

## Swift Standards

- **MUST** use Apple Swift idioms and conventions
- **MUST** follow [Apple Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- **SHOULD** prefer clarity at the point of use for public APIs
- **SHOULD** avoid abbreviations unless universally established (e.g., `UI`)

## Testing Requirements

- **MUST** write detailed unit tests with code coverage above 90%
- **MUST** maintain strict separation between:
  - `*Tests` (logic/unit tests)
  - `*IntegrationTests` (I/O + fixtures)
- Integration test fixtures (e.g., `*.gz`) **MUST** live in the repo that owns the integration tests

## Issue Tracking

- **MUST** use GitHub issues for all issue tracking
- **MUST** use `gh` command with user `rickhohler` for all GitHub operations
- **MUST** verify existing implementations before creating new code (many features may already exist but need modernization)

## Concurrency & Safety

- Shared registries/singletons **MUST** be safe under parallel tests
- **MUST** use DAK patterns for all concurrency-sensitive code

## Documentation

- New implementations **MUST** cite at least one technical reference (when applicable)
- **MUST** link references from the relevant references index
