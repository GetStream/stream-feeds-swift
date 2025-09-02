Guidance for AI coding agents (Copilot, Cursor, Aider, Claude, etc.) working in this repository. Human readers are welcome, but this file is written for tools.

### Repository purpose

This repo hosts Stream’s Swift SDK for Activity Feeds on Apple platforms. It exposes the client, models, and helpers needed to integrate Stream Feeds into Swift/iOS apps, and may include test fixtures and example code.

Agents should optimize for API stability, backwards compatibility, and high test coverage.

Tech & toolchain
  • Language: Swift
  • Primary distribution: Swift Package Manager (SPM)
  • Xcode: 15.x or newer (Apple Silicon supported)
  • Platforms / deployment targets: Use the values set in Package.swift/podspecs; do not lower targets without approval
  • CI: GitHub Actions (assume PR validation for build + tests + lint)
  • Linters & docs: SwiftLint via Mint

### Project layout (high level)

Package.swift
Sources/
  StreamFeeds/         # Core Feeds client, models, network, utilities
Tests/
  StreamFeedsTests/    # Unit tests for the SDK
DemoApp/               # The demo app for testing

Use the closest folder’s conventions when editing. Query actual target/product names from Package.swift before building.

Local setup (SPM)
  1.  Clone the repository and open it in Xcode (root contains Package.swift).
  2.  Resolve packages.
  3.  Choose an iOS Simulator (e.g., iPhone 15) and Build.

### Optional: sample/demo app

If a sample app target exists, run it to validate changes. Do not hardcode credentials; use placeholders like YOUR_STREAM_KEY and configure via environment or xcconfig.

### Schemes

Typical scheme names match the SPM product/target (e.g., the primary library target and its …Tests). Always query existing schemes before invoking xcodebuild.

### Build & test commands (CLI)

Prefer Xcode for day-to-day work; use CLI for CI parity & automation.

Build (Debug):

```
xcodebuild \
  -scheme <PrimarySchemeName> \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -configuration Debug build
```

Run tests:

```
xcodebuild \
  -scheme <PrimarySchemeName> \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -configuration Debug test
```

If a Makefile or scripts exist (e.g., make build, make test, ./scripts/lint.sh), prefer those to keep parity with CI. Discover with make help and ls scripts/.

### Linting & formatting
  • SwiftLint (strict) when configured:

swiftlint --strict

  • Respect .swiftlint.yml and repo-specific rules. Do not broadly disable rules; scope exceptions and justify in PRs.

### Public API & SemVer
  • Follow semantic versioning for the library.
  • Any public API change must include updated docs and migration notes.
  • Avoid source-breaking changes. If unavoidable, add deprecations first with a transition path.

### Networking & security
  • Never commit API keys or user/customer data.
  • Use secure defaults (TLS, pinned endpoints as appropriate).
  • When adding scripts, fail closed if required env vars are missing.
  • Ensure sensitive headers/tokens are redacted in logs.

### Testing policy
  • Add/extend tests under Tests/ for:
  • Model encoding/decoding and request/response mapping
  • Client behaviors (pagination, retries/backoff, rate-limit handling)
  • Error surfaces and edge cases
  • Prefer async/await where available; avoid flaky sleeps—use expectations/mocks/stubs.

### Performance & reliability
  • Keep heavy work off the main thread.
  • Be mindful of allocation/retain cycles; audit async capture lists.
  • Consider caching where appropriate and document invalidation strategies.

### Documentation & examples
  • Update inline /// docs and any examples when changing public APIs.
  • Keep example/snippet code compilable. Use // MARK: sections for structure.

### Compatibility & dependencies
  • Maintain compatibility with deployment targets set in Package.swift.
  • Avoid introducing new third-party dependencies without approval.
  • Validate SPM integration in a fresh sample app when changing module boundaries.

### PR checklist & conventions
  • Keep PRs small and focused; include tests.
  • Update CHANGELOG for user-visible changes.
  • Ensure zero new warnings.
  • If behavior is visible to developers (API/UX), include brief release-note text and, if applicable, screenshots/log excerpts.
  • Mention relevant CODEOWNERS for areas you touch.

### When in doubt
  • Mirror existing patterns in the nearest module/file.
  • Prefer additive changes; minimize churn in public APIs.
  • Ask maintainers through PR mentions when uncertain.

### Quick agent checklist (per commit/PR)
  • Build the library for iOS Simulator
  • Run tests and ensure green
  • Run swiftlint --strict (and vale . if docs changed)
  • Update docs/migration notes for any public API change
  • Update CHANGELOG for user-visible changes
  • No new warnings in build logs

End of machine guidance. Keep human-facing details in README.md/docs; refine agent behavior here over time.