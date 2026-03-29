# Recipe Manager & Meal Planner Non-Functional Requirements

## Document Control

| Field | Value |
| --- | --- |
| Document | `NFR.md` |
| Product | Recipe Manager & Meal Planner |
| Scope | Non-functional requirements only |
| Identifier Format | `NFR-XXX` |
| Primary Platforms | iOS and Android via React Native / Expo |
| Local Storage | SQLite |
| Monetization Dependency | RevenueCat-managed one-time purchase |
| Current Commercial Offer | $9.99 lifetime unlock |
| Status | Draft |
| Related Documents | `docs/SPEC.md`, `docs/REQUIREMENTS.md` |

## Purpose

This document defines the non-functional qualities the product must demonstrate in production. It describes how well the product must perform, how securely it must handle data, how reliably it must operate, and how consistently it must behave across supported devices and usage conditions.

The requirements in this document are intended to support:

- Engineering implementation quality targets
- QA validation and release gating
- Operational readiness
- Privacy and security review
- App store submission readiness
- Change management for future releases

## Scope

This document covers non-functional requirements for:

- Performance
- Responsiveness
- Resource usage
- Security
- Accessibility
- Reliability
- Resilience
- Offline capability
- Device compatibility
- Data privacy
- Scalability
- Observability
- Maintainability where required to protect product quality

This document does not redefine functional behavior already specified in `docs/REQUIREMENTS.md`.

## Requirement Conventions

- `Must` means required for production release.
- `Should` means strongly expected unless explicitly deferred.
- `Could` means optional enhancement that improves quality but is not required for launch.
- Every requirement is written to be testable by QA, engineering, or release operations.
- If a metric is expressed as a percentile, the percentile applies to production-like representative test runs unless otherwise stated.
- Unless a requirement explicitly states otherwise, targets apply to current supported app versions on supported devices.

## Measurement and Test Context

- Performance measurements shall be collected on at least one supported lower-mid-tier iPhone and one supported lower-mid-tier Android device representative of real user conditions.
- Network-based measurements shall be tested under stable Wi-Fi, typical 4G/5G mobile conditions, and offline mode where relevant.
- Cold start means app launch from a fully terminated state.
- Warm start means resuming an app process already resident in memory.
- Large library means at least 5,000 saved recipes, 250 meal plan entries, and 2,000 grocery list items in history or active datasets combined.
- Accessibility verification shall include VoiceOver on iOS and TalkBack on Android.
- Security and privacy verification shall include static review, runtime validation, and configuration review.

## Quality Principles

- The app shall feel immediate for routine cooking and planning tasks.
- The app shall prioritize local-first reliability over network dependence.
- The app shall protect user trust by minimizing data collection and safeguarding stored content.
- The app shall remain usable in kitchens, stores, and homes with intermittent connectivity and interrupted sessions.
- The app shall degrade gracefully when dependencies fail.

## Non-Functional Requirements

## 1. Performance and Responsiveness

### NFR-001 App Cold Start Time
- Category: Performance
- Priority: Must
- Requirement: On a supported lower-mid-tier device with a typical production dataset, the app shall reach an interactable primary screen within 3.0 seconds at the 95th percentile for cold starts.
- Verification: Timed launch profiling on representative iOS and Android devices.

### NFR-002 App Warm Start Time
- Category: Performance
- Priority: Must
- Requirement: On a supported lower-mid-tier device, the app shall resume to the last usable state within 1.5 seconds at the 95th percentile for warm starts.
- Verification: Timed resume profiling with app process retained in memory.

### NFR-003 Initial Navigation Readiness
- Category: Performance
- Priority: Must
- Requirement: Primary navigation controls shall become visibly available within 1.0 second after the first frame is rendered.
- Verification: Instrumented launch trace and manual validation.

### NFR-004 Home Screen Render
- Category: Performance
- Priority: Must
- Requirement: The default entry screen shall render meaningful content or a meaningful empty/loading state within 1.2 seconds after app start completes.
- Verification: Screen render instrumentation under typical dataset conditions.

### NFR-005 Recipe Library First Paint
- Category: Performance
- Priority: Must
- Requirement: The recipe library screen shall display its first visible list content within 1.5 seconds at the 95th percentile when the library contains up to 5,000 recipes.
- Verification: Screen-level render timing with seeded datasets.

### NFR-006 Recipe Detail Open Time
- Category: Performance
- Priority: Must
- Requirement: Opening a recipe detail screen from the recipe list shall complete within 700 milliseconds at the 95th percentile for locally stored recipes.
- Verification: Navigation timing traces over repeated test runs.

### NFR-007 Manual Recipe Save Time
- Category: Performance
- Priority: Must
- Requirement: Saving a manually created or edited recipe with standard text content and one local image shall complete and return control to the user within 1.0 seconds at the 95th percentile.
- Verification: Save action instrumentation with representative payloads.

### NFR-008 Recipe Duplicate Action Time
- Category: Performance
- Priority: Should
- Requirement: Duplicating an existing recipe shall complete within 800 milliseconds at the 95th percentile.
- Verification: Timed action profiling with representative recipe sizes.

### NFR-009 Recipe Delete Action Time
- Category: Performance
- Priority: Must
- Requirement: Deleting a recipe after confirmation shall update the visible library state within 600 milliseconds at the 95th percentile.
- Verification: Action-to-UI update timing in instrumented builds.

### NFR-010 Search Result Latency
- Category: Performance
- Priority: Must
- Requirement: Local recipe search queries shall show updated results within 300 milliseconds at the 95th percentile for a library of up to 5,000 recipes.
- Verification: Search latency measurement with seeded local database.

### NFR-011 Filter Application Latency
- Category: Performance
- Priority: Must
- Requirement: Applying or removing a recipe filter or sort option shall update the visible result set within 400 milliseconds at the 95th percentile.
- Verification: UI interaction timing with representative filter combinations.

### NFR-012 Meal Plan Week View Load Time
- Category: Performance
- Priority: Must
- Requirement: Opening the weekly meal planner shall display the selected week and planned meals within 800 milliseconds at the 95th percentile from local storage.
- Verification: Navigation profiling with populated plan history.

### NFR-013 Meal Assignment Time
- Category: Performance
- Priority: Must
- Requirement: Assigning a recipe to a day or meal slot shall persist locally and update the visible calendar within 500 milliseconds at the 95th percentile.
- Verification: Action timing in instrumented builds.

### NFR-014 Grocery List Generation Time
- Category: Performance
- Priority: Must
- Requirement: Generating or refreshing a grocery list from a weekly meal plan of up to 21 planned recipe instances shall complete within 2.0 seconds at the 95th percentile on supported lower-mid-tier devices.
- Verification: Timed list generation runs using representative recipe complexity.

### NFR-015 Grocery List Toggle Latency
- Category: Performance
- Priority: Must
- Requirement: Checking or unchecking a grocery list item shall update the UI within 150 milliseconds at the 95th percentile.
- Verification: Interaction latency measurement on populated lists.

### NFR-016 Collection Browse Time
- Category: Performance
- Priority: Should
- Requirement: Opening a collection or folder view with up to 1,000 associated recipes shall render the first visible results within 800 milliseconds at the 95th percentile.
- Verification: Screen render timing with seeded collection data.

### NFR-017 Cooking Mode Start Time
- Category: Performance
- Priority: Must
- Requirement: Entering cooking mode from a saved recipe shall complete within 700 milliseconds at the 95th percentile.
- Verification: Navigation profiling with recipes containing long instructions.

### NFR-018 Step Navigation Latency
- Category: Performance
- Priority: Must
- Requirement: Moving between steps in cooking mode shall update the visible step within 100 milliseconds at the 95th percentile.
- Verification: UI interaction timing during active cooking mode sessions.

### NFR-019 Timer Creation Latency
- Category: Performance
- Priority: Must
- Requirement: Starting a timer from a cooking step shall acknowledge the action and show timer state within 200 milliseconds at the 95th percentile.
- Verification: Interaction trace capture on both supported platforms.

### NFR-020 Recipe Scaling Time
- Category: Performance
- Priority: Must
- Requirement: Adjusting recipe servings and recalculating displayed ingredient quantities shall complete within 250 milliseconds at the 95th percentile for recipes with up to 50 ingredients.
- Verification: Scaling interaction benchmarks.

### NFR-021 Nutrition Display Load Time
- Category: Performance
- Priority: Should
- Requirement: Displaying existing nutrition information on a recipe detail screen shall not add more than 150 milliseconds to screen render time at the 95th percentile.
- Verification: Comparative render profiling with and without nutrition fields present.

### NFR-022 Photo Attach Time
- Category: Performance
- Priority: Must
- Requirement: Attaching a captured or selected photo to a recipe shall show a successful local preview within 1.5 seconds at the 95th percentile for images within supported size limits.
- Verification: End-to-end image attachment timing on representative devices.

### NFR-023 URL Import Start Feedback
- Category: Performance
- Priority: Must
- Requirement: After the user submits a recipe URL for import, the app shall present visible progress, queued status, or failure feedback within 500 milliseconds at the 95th percentile.
- Verification: Interaction timing against network-mocked and live network-backed import flows under representative Wi-Fi and mobile conditions.

### NFR-024 URL Import Completion Time
- Category: Performance
- Priority: Should
- Requirement: Under normal network conditions, AI-assisted import of a typical recipe page shall complete within 12 seconds at the 90th percentile.
- Verification: Timed import runs across network-mocked and live network environments using representative recipe websites under Wi-Fi and mobile conditions.

### NFR-025 Settings Screen Load Time
- Category: Performance
- Priority: Must
- Requirement: The settings screen shall render interactive content within 700 milliseconds at the 95th percentile.
- Verification: Screen load profiling.

### NFR-026 Paywall Presentation Time
- Category: Performance
- Priority: Must
- Requirement: Presenting the paywall from an in-app trigger shall display a usable paywall within 1.0 seconds at the 95th percentile, excluding external store confirmation UI.
- Verification: UI trace measurement with RevenueCat-integrated staging configuration.

### NFR-027 Entitlement Refresh Time
- Category: Performance
- Priority: Must
- Requirement: After a successful purchase or restore flow returns control to the app, entitlement state reflected in the UI shall update within 2.0 seconds at the 95th percentile when network connectivity is available.
- Verification: Purchase flow instrumentation in sandbox environments.

### NFR-028 Background Resume Stability
- Category: Performance
- Priority: Must
- Requirement: Resuming the app from the background shall not trigger full app reinitialization unless the operating system has terminated the process.
- Verification: Lifecycle trace review and manual validation.

### NFR-029 Perceived Smoothness
- Category: Performance
- Priority: Must
- Requirement: Core scrolling interactions in recipe lists, collections, grocery lists, and meal planner views shall maintain a smooth experience without sustained visible jank during normal use on supported devices.
- Verification: Manual UX review supported by frame rendering metrics.

### NFR-030 Scroll Frame Performance
- Category: Performance
- Priority: Must
- Requirement: On supported devices, list-heavy screens shall maintain at least 50 FPS during typical scroll operations and shall not drop below 40 FPS for more than 500 milliseconds during continuous scrolling.
- Verification: Frame rendering instrumentation on iOS and Android.

### NFR-031 Animation Responsiveness
- Category: Performance
- Priority: Should
- Requirement: Meaningful transitions and animations shall begin within 100 milliseconds of user input and shall not block user interaction longer than necessary.
- Verification: Interaction trace review and manual UX assessment.

### NFR-032 Main Thread Blocking
- Category: Performance
- Priority: Must
- Requirement: No routine UI interaction on core screens shall block the main thread for longer than 100 milliseconds during normal operation.
- Verification: Runtime profiling and flame chart analysis.

### NFR-033 Database Query Efficiency
- Category: Performance
- Priority: Must
- Requirement: Frequently used local read queries for recipe lists, recipe detail, meal plan retrieval, and grocery list retrieval shall complete within 150 milliseconds at the 95th percentile on representative large datasets.
- Verification: Query instrumentation in production-like seeded databases.

### NFR-034 Database Write Efficiency
- Category: Performance
- Priority: Must
- Requirement: Frequently used local write operations for recipe save, meal assignment, grocery item toggle, and settings updates shall complete within 200 milliseconds at the 95th percentile.
- Verification: Local database timing in automated benchmarks.

### NFR-035 Import Failure Recovery Time
- Category: Performance
- Priority: Should
- Requirement: When URL import fails, the app shall return the user to a stable editable state or error state within 2.0 seconds at the 95th percentile after failure is known.
- Verification: Negative-path import testing under forced failures.

### NFR-036 Memory Usage Baseline
- Category: Performance
- Priority: Must
- Requirement: During routine navigation across recipes, meal plan, grocery list, and cooking mode, steady-state memory usage shall remain within limits that do not cause abnormal OS pressure or repeatable forced termination on supported lower-mid-tier devices.
- Verification: Device memory profiling during multi-screen usage sessions.

### NFR-037 Memory Leak Prevention
- Category: Performance
- Priority: Must
- Requirement: Repeated entry and exit from recipe detail, cooking mode, and meal planner screens shall not show unbounded memory growth across a 30-minute stress session.
- Verification: Leak detection and repeated navigation profiling.

### NFR-038 Battery Impact
- Category: Performance
- Priority: Must
- Requirement: Typical usage consisting of browsing recipes, planning meals, and using grocery lists for 30 minutes shall not cause battery drain materially above comparable content-heavy utility apps on the same device class.
- Verification: Comparative battery profiling under controlled conditions.

### NFR-039 Cooking Mode Battery Efficiency
- Category: Performance
- Priority: Should
- Requirement: A 60-minute cooking mode session with active screen wake, occasional step navigation, and timers shall avoid unnecessary background processing and excessive battery consumption beyond the screen-on baseline.
- Verification: Long-session battery and CPU profiling.

### NFR-040 Storage Growth Efficiency
- Category: Performance
- Priority: Should
- Requirement: Local storage size per typical text-only recipe shall remain efficient enough to support libraries of at least 5,000 recipes without unreasonable device storage consumption.
- Verification: Database and media storage analysis on seeded datasets.

## 2. Reliability, Resilience, and Data Integrity

### NFR-041 Crash-Free Sessions
- Category: Reliability
- Priority: Must
- Requirement: Production releases shall achieve at least 99.5 percent crash-free user sessions over a rolling 30-day period after stabilization.
- Verification: Crash analytics monitoring in production.

### NFR-042 Crash-Free Users
- Category: Reliability
- Priority: Must
- Requirement: Production releases shall achieve at least 99.0 percent crash-free users over a rolling 30-day period after stabilization.
- Verification: Crash analytics monitoring in production.

### NFR-043 No Data Loss on Routine App Closure
- Category: Reliability
- Priority: Must
- Requirement: Saved recipes, meal plan entries, grocery state changes, settings changes, and entitlement state already persisted locally shall survive routine app closure and device restart without corruption.
- Verification: Repeated persistence validation and restart testing.

### NFR-044 Draft Preservation on Interruption
- Category: Reliability
- Priority: Must
- Requirement: If editing is interrupted by app backgrounding, a call, low-memory pause, or brief OS interruption, unsaved user-entered recipe content shall be recoverable unless the user explicitly discards it.
- Verification: Lifecycle interruption tests during editing flows.

### NFR-045 Atomic Recipe Save
- Category: Reliability
- Priority: Must
- Requirement: A recipe save operation shall be atomic such that partial or malformed records are not left visible after failed local persistence.
- Verification: Fault injection during write operations and database inspection.

### NFR-046 Atomic Meal Plan Update
- Category: Reliability
- Priority: Must
- Requirement: Changes to a meal plan slot shall either fully apply or leave the prior stable state intact if the write fails.
- Verification: Injected write-failure tests and state validation.

### NFR-047 Atomic Grocery Generation
- Category: Reliability
- Priority: Must
- Requirement: Grocery list regeneration from a meal plan shall not leave the active grocery list in a partially regenerated state if the operation fails before completion.
- Verification: Failure injection during generation workflows.

### NFR-048 SQLite Integrity
- Category: Reliability
- Priority: Must
- Requirement: The app shall validate database integrity during development, test, and migration workflows and shall avoid shipping migrations that can create orphaned or unreadable records.
- Verification: Migration tests and integrity-check automation.

### NFR-049 Migration Safety
- Category: Reliability
- Priority: Must
- Requirement: Schema migrations between supported app versions shall preserve existing user recipes, meal plans, grocery data, collections, photos, and entitlement-related local state.
- Verification: Automated upgrade tests from prior supported versions.

### NFR-050 Idempotent Resume Behavior
- Category: Reliability
- Priority: Must
- Requirement: Reopening the app after interruption shall not duplicate meal plan entries, grocery items, recipe records, or timer state due to repeated lifecycle events.
- Verification: Lifecycle stress testing with repeated pause and resume transitions.

### NFR-051 URL Import Failure Isolation
- Category: Reliability
- Priority: Must
- Requirement: A failed URL import shall not corrupt existing recipe data, block app navigation, or degrade unrelated screens.
- Verification: Negative-path testing with malformed URLs, timeouts, and parser errors.

### NFR-052 Purchase Failure Isolation
- Category: Reliability
- Priority: Must
- Requirement: A failed or cancelled purchase flow shall not leave the app in an inconsistent entitlement state or block access to non-premium areas.
- Verification: Sandbox purchase failure tests and state inspection.

### NFR-053 Restore Failure Isolation
- Category: Reliability
- Priority: Must
- Requirement: A failed restore attempt shall preserve the last known locally valid entitlement state until new valid information is received.
- Verification: Network interruption and service failure tests during restore.

### NFR-054 Timer Reliability
- Category: Reliability
- Priority: Must
- Requirement: Active cooking timers shall continue to track remaining time accurately across app backgrounding and foregrounding within the limits of the mobile operating system.
- Verification: Background timer lifecycle tests on iOS and Android.

### NFR-055 Notification Reliability for Timers
- Category: Reliability
- Priority: Should
- Requirement: When notification permission is granted and the OS allows delivery, cooking timer completion notifications shall be delivered reliably and without duplicate alerts.
- Verification: Device tests with multiple overlapping timers and varied app states.

### NFR-056 Corrupt Record Handling
- Category: Reliability
- Priority: Must
- Requirement: If the app encounters a corrupt or unreadable record, it shall fail gracefully, isolate the bad record where possible, and keep the rest of the app usable.
- Verification: Fault injection with malformed local data.

### NFR-057 Error State Recovery
- Category: Reliability
- Priority: Must
- Requirement: Recoverable operational errors shall provide a user path to retry, dismiss, or continue safely without requiring force quit or reinstall.
- Verification: Negative-path UX testing across core workflows.

### NFR-058 Stable Empty States
- Category: Reliability
- Priority: Must
- Requirement: Empty libraries, empty meal plans, empty grocery lists, and missing photos shall be handled as first-class states rather than error conditions.
- Verification: Manual and automated tests with zero-data datasets.

### NFR-059 Long Session Stability
- Category: Reliability
- Priority: Must
- Requirement: The app shall remain stable through at least a 60-minute continuous usage session covering recipe browsing, editing, planning, grocery interaction, and cooking mode.
- Verification: Endurance testing on representative devices.

### NFR-060 Concurrent Input Safety
- Category: Reliability
- Priority: Should
- Requirement: Rapid repeated taps, repeated save attempts, and quick navigation transitions shall not create duplicate records or inconsistent UI state.
- Verification: UI stress and monkey testing on critical actions.

### NFR-061 Back Navigation Safety
- Category: Reliability
- Priority: Must
- Requirement: System back gestures, navigation back actions, and modal dismissals shall preserve the correct screen stack and shall not bypass unsaved-change protections.
- Verification: Navigation lifecycle and manual regression testing.

### NFR-062 Upgrade Compatibility Window
- Category: Reliability
- Priority: Must
- Requirement: The current release shall correctly upgrade user data created by at least the previous two supported production schema versions.
- Verification: Automated migration matrix tests.

### NFR-063 Failed Image Processing Handling
- Category: Reliability
- Priority: Must
- Requirement: A photo processing or compression failure shall not block recipe creation if the user chooses to continue without the image.
- Verification: Forced image processing failure tests.

### NFR-064 Safe Default State on Dependency Failure
- Category: Reliability
- Priority: Must
- Requirement: If non-core remote services are unavailable, the app shall default to a safe local state rather than freeze or crash.
- Verification: Service outage simulation for RevenueCat and import-related services.

### NFR-065 Data Consistency After Kill-and-Relaunch
- Category: Reliability
- Priority: Must
- Requirement: Force-killing the app during common local write operations shall not produce duplicated or structurally invalid records upon relaunch.
- Verification: Kill-and-relaunch fault tests during save and update operations.

### NFR-066 History and Metadata Consistency
- Category: Reliability
- Priority: Should
- Requirement: Timestamps such as created date, updated date, planned date, and grocery modification date shall remain internally consistent after edits, moves, and deletions.
- Verification: Automated data integrity assertions.

### NFR-067 Deterministic Regeneration
- Category: Reliability
- Priority: Should
- Requirement: Rebuilding a grocery list from the same meal plan and same ingredient normalization rules shall produce functionally consistent results.
- Verification: Repeated generation tests with fixed seeded data.

### NFR-068 Safe Handling of Large Text Content
- Category: Reliability
- Priority: Must
- Requirement: Very long recipe notes, instructions, or ingredient lists within supported limits shall not crash the app or make the record unreadable.
- Verification: Boundary tests with maximum-length content.

### NFR-069 Graceful Low-Storage Behavior
- Category: Reliability
- Priority: Must
- Requirement: If device storage is low, the app shall fail gracefully during photo capture, import, or save operations and clearly communicate the problem without corrupting existing data.
- Verification: Low-storage device simulation and manual validation.

### NFR-070 Clock Change Tolerance
- Category: Reliability
- Priority: Should
- Requirement: Manual device clock changes and time zone shifts shall not corrupt meal plan dates, timer completion state, or record ordering beyond expected date-display adjustments.
- Verification: Time zone and system clock manipulation tests.

## 3. Offline Support and Sync Independence

### NFR-071 Local-First Core Usage
- Category: Offline
- Priority: Must
- Requirement: Previously saved recipes, collections, meal plans, grocery lists, cooking mode, recipe scaling, and existing nutrition displays shall be fully usable offline.
- Verification: Airplane-mode end-to-end tests across core workflows.

### NFR-072 No Mandatory Account Dependency
- Category: Offline
- Priority: Must
- Requirement: Core product use shall not depend on user account creation or active authentication.
- Verification: Functional validation on clean installs with no account flows.

### NFR-073 Offline Launch Support
- Category: Offline
- Priority: Must
- Requirement: The app shall be launchable offline and shall present previously stored local content without requiring remote initialization success.
- Verification: Cold-start tests in airplane mode.

### NFR-074 Offline Recipe Viewing
- Category: Offline
- Priority: Must
- Requirement: Any recipe previously imported or created on-device shall remain viewable offline with all locally stored fields and photos.
- Verification: Airplane-mode tests after content creation and import.

### NFR-075 Offline Recipe Editing
- Category: Offline
- Priority: Must
- Requirement: Manual edits to existing locally stored recipes shall be possible offline and shall persist locally without deferred network dependency.
- Verification: Offline edit-save-relaunch tests.

### NFR-076 Offline Meal Planning
- Category: Offline
- Priority: Must
- Requirement: Users shall be able to create, edit, move, and delete meal plan entries offline when using locally stored recipes.
- Verification: Offline meal planner workflow tests.

### NFR-077 Offline Grocery Usage
- Category: Offline
- Priority: Must
- Requirement: Users shall be able to view, check, uncheck, edit, and organize locally available grocery list items offline.
- Verification: Airplane-mode grocery interaction tests.

### NFR-078 Offline Cooking Mode
- Category: Offline
- Priority: Must
- Requirement: Cooking mode, step navigation, locally scheduled timers, and recipe scaling shall function offline for locally stored recipes.
- Verification: Offline cooking session tests.

### NFR-079 Offline Entitlement Continuity
- Category: Offline
- Priority: Must
- Requirement: A user whose premium entitlement has been recognized locally shall retain premium access offline for a reasonable continuity window without forced revalidation.
- Verification: Offline premium usage tests after prior successful entitlement recognition.

### NFR-080 Offline Failure Clarity
- Category: Offline
- Priority: Must
- Requirement: Features that require connectivity, such as URL import initiation or live purchase/restore operations, shall clearly indicate that network access is unavailable instead of failing silently.
- Verification: Airplane-mode negative-path testing.

### NFR-081 Offline Queue Safety
- Category: Offline
- Priority: Should
- Requirement: If a network-dependent action is initiated while connectivity is unstable, the app shall either queue the action safely for explicit retry or fail cleanly without duplicating work.
- Verification: Network drop tests on import and restore flows.

### NFR-082 Reconnect Recovery
- Category: Offline
- Priority: Should
- Requirement: When connectivity returns, the app shall recover remote-dependent capabilities without requiring a full app restart.
- Verification: Network toggle tests on active sessions.

### NFR-083 Offline Messaging Consistency
- Category: Offline
- Priority: Must
- Requirement: Offline indicators and messages shall use consistent language across screens so users understand whether the issue is temporary connectivity loss, a service outage, or a local validation problem.
- Verification: UX copy review and scenario-based QA tests.

### NFR-084 Local Data Authority
- Category: Offline
- Priority: Must
- Requirement: The app shall treat the on-device structured data store as the primary source of truth for user-created and user-edited content.
- Verification: Architecture review and functional validation.

### NFR-085 No Hidden Connectivity Requirement for Reading
- Category: Offline
- Priority: Must
- Requirement: Reading previously loaded content shall not require background calls to succeed before content is shown.
- Verification: Network-blocked tests on detail screens and lists.

### NFR-086 Offline Resilience for Store Aisle Use
- Category: Offline
- Priority: Must
- Requirement: Grocery list use in poor-signal retail environments shall remain responsive and fully functional using local state only.
- Verification: Simulated poor-connectivity tests and long offline grocery sessions.

## 4. Security

### NFR-087 Secure Transport
- Category: Security
- Priority: Must
- Requirement: All network communication involving recipe import services, RevenueCat, analytics, crash reporting, or other remote dependencies shall use modern TLS over HTTPS.
- Verification: Network inspection and configuration review.

### NFR-088 No Plaintext Sensitive Transit
- Category: Security
- Priority: Must
- Requirement: The app shall not transmit entitlements, user-generated content submitted to remote services, or service credentials over insecure transport.
- Verification: Proxy inspection and code review.

### NFR-089 Principle of Least Privilege
- Category: Security
- Priority: Must
- Requirement: The app shall request only the minimum OS permissions required for shipped features, including camera, photo library, and notifications where applicable.
- Verification: Manifest review and permission-flow testing.

### NFR-090 Permission Justification
- Category: Security
- Priority: Must
- Requirement: Each runtime permission request shall be preceded by user-facing context explaining why the permission is needed.
- Verification: Manual UX validation and permission flow review.

### NFR-091 Secure Local Secret Storage
- Category: Security
- Priority: Must
- Requirement: API keys, tokens, and other secrets that must exist on-device shall be stored and accessed using platform-appropriate secure mechanisms rather than hardcoded plaintext in app code or logs.
- Verification: Static code review and runtime configuration review.

### NFR-092 No Hardcoded Production Secrets in Client Source
- Category: Security
- Priority: Must
- Requirement: The shipped mobile client shall not contain unrestricted secrets that would allow unauthorized backend or third-party service use if extracted from the app bundle.
- Verification: Build artifact review and security review.

### NFR-093 Secure Build Configuration Separation
- Category: Security
- Priority: Must
- Requirement: Development, staging, and production configurations shall be separated so that non-production endpoints and credentials cannot be accidentally shipped in production builds.
- Verification: Build pipeline review and release checklist validation.

### NFR-094 Input Validation for URLs
- Category: Security
- Priority: Must
- Requirement: User-submitted URLs for recipe import shall be validated before processing to reduce malformed input handling risk and abuse vectors.
- Verification: Static review and malformed-input testing.

### NFR-095 Input Sanitization for Imported Content
- Category: Security
- Priority: Must
- Requirement: Imported recipe titles, notes, ingredients, instructions, and metadata shall be sanitized before rendering or storage to prevent script injection, unsafe markup rendering, or layout-breaking content.
- Verification: Fuzz tests with malicious and malformed imported content.

### NFR-096 Safe Rich Text Rendering
- Category: Security
- Priority: Must
- Requirement: The app shall not execute arbitrary HTML, JavaScript, or embedded active content from imported recipe sources.
- Verification: Security test cases with hostile HTML payloads.

### NFR-097 SQL Injection Resistance
- Category: Security
- Priority: Must
- Requirement: All database operations shall use parameterized queries, query builders, or equivalent safe mechanisms that prevent injection through user-controlled input.
- Verification: Code review and negative-path input tests.

### NFR-098 Log Redaction
- Category: Security
- Priority: Must
- Requirement: Application logs, analytics payloads, and crash reports shall not include raw recipe content, full grocery lists, access tokens, purchase transaction payloads, or other sensitive user data unless explicitly required and redacted.
- Verification: Logging review in debug and release-like environments.

### NFR-099 No Sensitive Data in Analytics by Default
- Category: Security
- Priority: Must
- Requirement: Analytics events shall avoid sending full recipe text, user notes, ingredient lists, or personal meal planning details by default.
- Verification: Event schema review and runtime network inspection.

### NFR-100 Clipboard Safety
- Category: Security
- Priority: Should
- Requirement: Any clipboard access used to assist URL import shall be limited, transparent, and compliant with platform privacy expectations.
- Verification: Platform behavior review and manual validation.

### NFR-101 Screenshot and Background Privacy
- Category: Security
- Priority: Could
- Requirement: Sensitive screens involving purchase restoration or debugging tools may obscure especially sensitive transient tokens in app switcher screenshots where platform capabilities allow.
- Verification: Platform-specific validation if implemented.

### NFR-102 File Access Restriction
- Category: Security
- Priority: Must
- Requirement: Photo and media handling shall access only user-selected or feature-required files and shall not scan unrelated user media without explicit action.
- Verification: Permission and file-access review.

### NFR-103 Dependency Security Hygiene
- Category: Security
- Priority: Must
- Requirement: Third-party libraries and SDKs shall be reviewed for known critical vulnerabilities before release, and critical advisories shall block production release until mitigated or formally accepted.
- Verification: Dependency scanning and release checklist review.

### NFR-104 Secure Crash Reporting Configuration
- Category: Security
- Priority: Must
- Requirement: Crash reporting tools shall be configured to avoid collecting unnecessary personal data and to respect disabled analytics or privacy controls where applicable.
- Verification: SDK configuration review.

### NFR-105 Tamper Resistance Baseline
- Category: Security
- Priority: Should
- Requirement: The app shall make reasonable effort to reduce trivial entitlement bypass or configuration tampering, recognizing that client-only protection is not absolute.
- Verification: Security review and threat model validation.

### NFR-106 Jailbreak and Root Risk Tolerance
- Category: Security
- Priority: Should
- Requirement: The app may continue operating on jailbroken or rooted devices, but security-sensitive assumptions shall not rely on those devices being trustworthy.
- Verification: Threat model and implementation review.

### NFR-107 Safe Error Messages
- Category: Security
- Priority: Must
- Requirement: Production error messages shown to users shall not expose stack traces, raw SQL, internal endpoints, or secret-bearing diagnostic details.
- Verification: Negative-path UI review and log inspection.

### NFR-108 Authentication Surface Minimization
- Category: Security
- Priority: Must
- Requirement: Because the product does not require user accounts for core use, the app shall avoid introducing unnecessary authentication surfaces that expand security risk without product value.
- Verification: Product surface review and implementation audit.

### NFR-109 RevenueCat Integration Safety
- Category: Security
- Priority: Must
- Requirement: RevenueCat SDK integration shall use approved entitlement APIs and shall not store sensitive transaction details in insecure local locations.
- Verification: SDK integration review and runtime inspection.

### NFR-110 Photo Metadata Handling
- Category: Security
- Priority: Should
- Requirement: If photo metadata such as EXIF location is not needed for product functionality, it should be stripped or ignored during storage where feasible.
- Verification: Sample image metadata validation.

### NFR-111 Denial-of-Service Tolerance for Import Requests
- Category: Security
- Priority: Should
- Requirement: The app and any supporting import workflow shall limit accidental rapid repeated submissions that could create abusive request patterns or duplicate imports.
- Verification: Rapid-tap testing and backend-facing request review.

### NFR-112 Security Review Before Release
- Category: Security
- Priority: Must
- Requirement: Major releases shall complete a documented security review covering dependencies, permissions, secrets, logging, remote endpoints, and entitlement handling.
- Verification: Release process audit.

## 5. Data Privacy

### NFR-113 Privacy by Default
- Category: Privacy
- Priority: Must
- Requirement: The product shall minimize collection, retention, and transmission of user data beyond what is necessary to provide the shipped functionality.
- Verification: Data flow review and privacy checklist validation.

### NFR-114 Minimal Personal Data Collection
- Category: Privacy
- Priority: Must
- Requirement: The app shall not require name, email address, home address, phone number, age, gender, or other direct personal identifiers for core product use.
- Verification: Functional review and signup surface audit.

### NFR-115 User Content Ownership Respect
- Category: Privacy
- Priority: Must
- Requirement: User-created recipes, notes, meal plans, grocery items, and photos shall be treated as user content rather than marketing data assets.
- Verification: Product policy review and analytics schema review.

### NFR-116 Limited Remote Submission Scope
- Category: Privacy
- Priority: Must
- Requirement: If recipe content or source URLs are submitted to remote services for import assistance, only the minimum data necessary to complete that action shall be transmitted.
- Verification: Data flow review and network inspection.

### NFR-117 Explicit Privacy Disclosure
- Category: Privacy
- Priority: Must
- Requirement: The app shall provide accessible privacy disclosures describing what data is collected, why it is collected, and which third parties process it.
- Verification: In-app and store listing privacy review.

### NFR-118 Consent Alignment
- Category: Privacy
- Priority: Must
- Requirement: Analytics, diagnostics, and tracking-related behaviors shall comply with applicable platform and jurisdictional consent requirements.
- Verification: Consent flow testing and legal/privacy review.

### NFR-119 No Sale of Personal Data Positioning
- Category: Privacy
- Priority: Must
- Requirement: The product shall not position itself as selling user data or monetizing recipe libraries through unrelated advertising profiles.
- Verification: Policy review and third-party SDK review.

### NFR-120 Analytics Scope Limitation
- Category: Privacy
- Priority: Must
- Requirement: Product analytics shall focus on app usage patterns and shall avoid collecting unnecessary payload-level content details from recipes, grocery items, and meal plans.
- Verification: Event dictionary review.

### NFR-121 Privacy Control Discoverability
- Category: Privacy
- Priority: Should
- Requirement: Privacy-related settings and disclosures shall be easy to locate from settings.
- Verification: UX review and usability testing.

### NFR-122 Request-Based Data Export Readiness
- Category: Privacy
- Priority: Could
- Requirement: If a future export feature is implemented, the internal data model should remain structured enough to support user-requested export without bespoke data reconstruction.
- Verification: Data model review and implementation readiness assessment.

### NFR-123 Request-Based Data Deletion Readiness
- Category: Privacy
- Priority: Could
- Requirement: If a future cloud or account layer is introduced, the architecture should support deletion of remotely held user data without ambiguity.
- Verification: Forward-looking privacy design review.

### NFR-124 Sensitive Content Avoidance in Telemetry
- Category: Privacy
- Priority: Must
- Requirement: Telemetry shall avoid sending freeform notes, ingredient text, or recipe instructions unless the user explicitly opts into diagnostic sharing for a support case.
- Verification: Telemetry payload review.

### NFR-125 Third-Party Processor Transparency
- Category: Privacy
- Priority: Must
- Requirement: Third-party services involved in purchases, diagnostics, or import processing shall be documented in privacy disclosures.
- Verification: Documentation review against implementation.

### NFR-126 Data Retention Limits for Remote Logs
- Category: Privacy
- Priority: Should
- Requirement: Diagnostic and analytics systems shall use retention periods appropriate for product support and shall avoid indefinite storage of event-level data when not required.
- Verification: Vendor configuration review.

### NFR-127 Local Data Persistence Clarity
- Category: Privacy
- Priority: Must
- Requirement: The product shall make clear that recipe libraries and related content are primarily stored on-device unless a future cloud feature explicitly changes that model.
- Verification: Copy review in onboarding, settings, or help content.

### NFR-128 Photo Privacy Clarity
- Category: Privacy
- Priority: Must
- Requirement: When users attach or capture recipe photos, the app shall make it clear whether images remain local or are sent to any remote processor.
- Verification: Permission flow and feature copy review.

### NFR-129 Child Data Posture
- Category: Privacy
- Priority: Should
- Requirement: The product shall avoid intentionally collecting sensitive child data and shall not target children as a primary audience.
- Verification: Policy review and product positioning validation.

### NFR-130 Privacy Incident Response Readiness
- Category: Privacy
- Priority: Must
- Requirement: The team shall maintain an operational path to investigate and remediate privacy incidents involving remote services, logs, or SDKs.
- Verification: Operational checklist and incident process review.

## 6. Accessibility and Inclusive Design

### NFR-131 Screen Reader Compatibility
- Category: Accessibility
- Priority: Must
- Requirement: Core workflows including recipe browsing, recipe detail, recipe editing, meal planning, grocery list interaction, cooking mode, and purchase flows shall be operable with VoiceOver on iOS and TalkBack on Android.
- Verification: Manual screen reader audits on supported devices.

### NFR-132 Semantic Labels
- Category: Accessibility
- Priority: Must
- Requirement: Interactive controls shall expose accurate accessibility labels, roles, states, and hints where necessary.
- Verification: Accessibility tree inspection and manual assistive-tech testing.

### NFR-133 Focus Order
- Category: Accessibility
- Priority: Must
- Requirement: Keyboard and screen reader focus order shall follow a logical visual and task-based sequence on each screen.
- Verification: Focus navigation audits on iOS and Android.

### NFR-134 Touch Target Size
- Category: Accessibility
- Priority: Must
- Requirement: Interactive touch targets shall meet or exceed platform-recommended minimum hit areas for taps, especially in grocery list toggles, planner cells, timer actions, and back controls.
- Verification: UI measurement review and manual device testing.

### NFR-135 Color Contrast
- Category: Accessibility
- Priority: Must
- Requirement: Text and meaningful UI controls shall meet WCAG 2.1 AA contrast expectations for normal and large text in both light and dark modes.
- Verification: Contrast analysis and design review.

### NFR-136 Non-Color Cues
- Category: Accessibility
- Priority: Must
- Requirement: Status, selection, errors, checked states, and premium lock states shall not rely on color alone.
- Verification: UX review and accessibility audits.

### NFR-137 Dynamic Type Support
- Category: Accessibility
- Priority: Must
- Requirement: Core text content shall support system text scaling on supported platforms without truncating essential content or breaking primary tasks at common accessibility sizes.
- Verification: Dynamic type testing across size ranges.

### NFR-138 Large Text Usability
- Category: Accessibility
- Priority: Must
- Requirement: Recipe detail, cooking mode, grocery list, and settings screens shall remain usable at the largest commonly used accessibility text sizes supported by the app.
- Verification: Manual testing with maximum supported system font scales.

### NFR-139 Screen Reflow
- Category: Accessibility
- Priority: Must
- Requirement: Increased text size or display scaling shall not cause hidden controls, unreachable save actions, or unreadable overlapping content in core workflows.
- Verification: Responsive layout and accessibility size testing.

### NFR-140 Voice Control Compatibility
- Category: Accessibility
- Priority: Should
- Requirement: Important controls should be discoverable and actionable through platform voice control features when those features depend on accessible naming.
- Verification: Manual voice control spot checks.

### NFR-141 Reduced Motion Respect
- Category: Accessibility
- Priority: Must
- Requirement: If the operating system requests reduced motion, non-essential motion effects shall be reduced or removed while preserving clarity of state changes.
- Verification: OS reduced-motion testing on both platforms.

### NFR-142 Motion Safety
- Category: Accessibility
- Priority: Must
- Requirement: The app shall avoid flashing, pulsing, or rapid animated effects that could create discomfort or seizure risk.
- Verification: Design and implementation review.

### NFR-143 Accessible Error Messages
- Category: Accessibility
- Priority: Must
- Requirement: Validation and operational error messages shall be announced to assistive technologies and presented in plain, actionable language.
- Verification: Screen reader error-flow testing.

### NFR-144 Form Field Accessibility
- Category: Accessibility
- Priority: Must
- Requirement: Recipe creation and editing fields shall expose clear labels, expected input types, and validation feedback to assistive technologies.
- Verification: Manual form accessibility audit.

### NFR-145 Accessible Timer Status
- Category: Accessibility
- Priority: Should
- Requirement: Timer creation, running state, and completion shall be understandable through accessible labels and announcements where platform patterns allow.
- Verification: Assistive-technology testing during cooking mode.

### NFR-146 Accessible Grocery Interaction
- Category: Accessibility
- Priority: Must
- Requirement: Grocery list items shall communicate checked state, quantity, grouping, and edit actions accessibly without requiring precise gestures.
- Verification: Screen reader and switch-access style testing.

### NFR-147 Accessible Meal Planner Semantics
- Category: Accessibility
- Priority: Must
- Requirement: Weekly meal planner cells shall communicate day, slot, and assigned recipe clearly to assistive technologies.
- Verification: Accessibility tree review and manual screen reader testing.

### NFR-148 Orientation and Layout Support
- Category: Accessibility
- Priority: Should
- Requirement: The app shall remain usable in supported orientations and shall not depend on a single orientation where platform or feature context reasonably permits alternatives.
- Verification: Rotation testing on representative devices.

### NFR-149 External Keyboard Navigation
- Category: Accessibility
- Priority: Could
- Requirement: Where platform support makes it practical, major flows should remain navigable with external keyboard focus controls.
- Verification: Optional keyboard navigation spot checks.

### NFR-150 Plain Language
- Category: Accessibility
- Priority: Must
- Requirement: UI text, permission explanations, purchase messaging, and error messages shall use plain language appropriate for a broad consumer audience.
- Verification: UX copy review.

### NFR-151 Dark Mode Accessibility
- Category: Accessibility
- Priority: Must
- Requirement: Dark mode shall preserve contrast, readability, and control visibility at the same accessibility standard required for light mode.
- Verification: Contrast and manual usability testing in dark mode.

### NFR-152 State Announcement on Navigation
- Category: Accessibility
- Priority: Should
- Requirement: Major screen transitions such as opening recipe detail, entering cooking mode, or presenting a paywall should move accessibility focus to the new context in a predictable way.
- Verification: Screen reader navigation testing.

## 7. Device Compatibility and Platform Quality

### NFR-153 Supported Mobile Platforms
- Category: Compatibility
- Priority: Must
- Requirement: The app shall ship and operate on current supported iOS and Android versions defined by the release policy.
- Verification: Release matrix validation.

### NFR-154 Backward OS Support Policy
- Category: Compatibility
- Priority: Must
- Requirement: Minimum supported OS versions shall be explicitly defined before release and shall be reflected in testing, store metadata, and dependency choices.
- Verification: Release checklist and store configuration review.

### NFR-155 Phone Form Factor Support
- Category: Compatibility
- Priority: Must
- Requirement: The app shall remain usable on supported small, medium, and large phone screens without clipping essential controls.
- Verification: Device matrix testing across representative screen sizes.

### NFR-156 Tablet Adaptation
- Category: Compatibility
- Priority: Should
- Requirement: On supported tablets, the app should use available space effectively while preserving the same task completion capabilities as phones.
- Verification: Tablet layout review and functional regression testing.

### NFR-157 Safe Area Compliance
- Category: Compatibility
- Priority: Must
- Requirement: Layouts shall respect notches, dynamic islands, rounded corners, navigation bars, home indicators, and other safe area constraints.
- Verification: Device-specific manual testing.

### NFR-158 Gesture Navigation Compatibility
- Category: Compatibility
- Priority: Must
- Requirement: System gestures and in-app gestures shall coexist without obscuring critical controls or causing accidental destructive actions.
- Verification: Manual testing on gesture-based devices.

### NFR-159 Camera Capability Degradation
- Category: Compatibility
- Priority: Must
- Requirement: On devices with limited or unavailable camera capability, the app shall degrade gracefully and still allow recipe creation without photo capture.
- Verification: Testing on simulator or device states with denied or absent camera support.

### NFR-160 Photo Library Capability Degradation
- Category: Compatibility
- Priority: Must
- Requirement: Denied photo library access shall not break recipe editing or other unrelated workflows.
- Verification: Permission-denied testing.

### NFR-161 Keyboard Behavior Consistency
- Category: Compatibility
- Priority: Must
- Requirement: Text inputs shall remain visible and usable when the on-screen keyboard is present across supported devices and orientations.
- Verification: Form testing across devices and keyboard types.

### NFR-162 Time Zone Compatibility
- Category: Compatibility
- Priority: Must
- Requirement: Meal planning dates and displayed times shall behave correctly across user time zones and daylight saving transitions.
- Verification: Time zone and locale testing.

### NFR-163 Locale-Aware Formatting
- Category: Compatibility
- Priority: Should
- Requirement: Dates, times, units, decimal separators, and lists should render in a way consistent with platform locale settings where practical.
- Verification: Locale testing across representative regions.

### NFR-164 Unit System Compatibility
- Category: Compatibility
- Priority: Should
- Requirement: The app should support both imperial and metric display conventions where feature behavior depends on unit presentation.
- Verification: Settings and display validation under different locale preferences.

### NFR-165 OS Theme Integration
- Category: Compatibility
- Priority: Must
- Requirement: The app shall support light mode and dark mode and shall respond correctly to system appearance changes where configured to follow the system theme.
- Verification: Theme-switch tests on iOS and Android.

### NFR-166 Notification Compatibility
- Category: Compatibility
- Priority: Should
- Requirement: Timer-related notifications should function within platform-specific notification models and permission rules on supported OS versions.
- Verification: Notification testing across supported versions.

### NFR-167 Deep Link and Share Entry Stability
- Category: Compatibility
- Priority: Should
- Requirement: If platform share or deep-link entry points are supported, they should open the correct import context without breaking normal navigation.
- Verification: Share-sheet and deep-link tests.

### NFR-168 Orientation Change Stability
- Category: Compatibility
- Priority: Must
- Requirement: If a supported device changes orientation during a non-destructive workflow, current visible state and unsaved content shall remain intact.
- Verification: Rotation tests while editing and browsing.

### NFR-169 Background App Lifecycle Compatibility
- Category: Compatibility
- Priority: Must
- Requirement: The app shall respect platform lifecycle expectations for suspension, resume, notification handling, and permission prompts.
- Verification: Lifecycle regression testing on both platforms.

### NFR-170 Store Compliance
- Category: Compatibility
- Priority: Must
- Requirement: The product shall comply with current Apple App Store and Google Play requirements relevant to privacy disclosures, in-app purchases, permissions, and metadata.
- Verification: Store submission checklist and policy review.

### NFR-171 RevenueCat SDK Compatibility
- Category: Compatibility
- Priority: Must
- Requirement: The RevenueCat integration shall use SDK versions and entitlement flows compatible with supported iOS and Android release targets.
- Verification: Dependency review and purchase-flow QA.

### NFR-172 Expo and Native Module Compatibility
- Category: Compatibility
- Priority: Must
- Requirement: Expo configuration, native modules, and build settings shall remain compatible with the supported mobile OS matrix for each release.
- Verification: CI build validation and device smoke tests.

## 8. Scalability, Maintainability, and Operational Quality

### NFR-173 Personal Library Scale
- Category: Scalability
- Priority: Must
- Requirement: The app shall remain functionally usable with at least 5,000 stored recipes, 500 collections or folders, and at least one year of meal planning history.
- Verification: Seeded large-dataset performance and usability tests.

### NFR-174 Ingredient Volume Scale
- Category: Scalability
- Priority: Should
- Requirement: Grocery generation and recipe display shall remain functional with recipes containing up to 100 ingredients and instructions containing up to 100 steps.
- Verification: Boundary dataset tests.

### NFR-175 Image Library Scale
- Category: Scalability
- Priority: Should
- Requirement: The app should remain stable when a significant portion of recipes contain local photos, subject to documented storage constraints.
- Verification: Media-heavy dataset testing.

### NFR-176 Large Grocery List Scale
- Category: Scalability
- Priority: Must
- Requirement: Active grocery lists of at least 500 items shall remain navigable, searchable if supported, and checkable without severe degradation.
- Verification: Large-list performance testing.

### NFR-177 Meal Plan History Scale
- Category: Scalability
- Priority: Should
- Requirement: Historical meal plan retrieval shall remain responsive across at least 24 months of locally stored weekly plans.
- Verification: Seeded historical dataset tests.

### NFR-178 Configuration Change Safety
- Category: Maintainability
- Priority: Must
- Requirement: Feature flags, pricing text, and environment-specific settings shall be changeable without introducing hidden behavioral drift in core local workflows.
- Verification: Configuration review and regression tests.

### NFR-179 Testability
- Category: Maintainability
- Priority: Must
- Requirement: Core app logic for recipe parsing results handling, scaling, grocery generation, entitlement state transitions, and persistence behavior shall be structured so that automated tests can validate it reliably.
- Verification: Code review and automated test coverage review.

### NFR-180 Release Regression Coverage
- Category: Maintainability
- Priority: Must
- Requirement: Every release candidate shall complete automated and manual regression coverage for recipe creation, import, meal planning, grocery list interaction, cooking mode, purchase, and restore flows.
- Verification: Release QA checklist and CI results.

### NFR-181 Migration Test Coverage
- Category: Maintainability
- Priority: Must
- Requirement: Database schema changes shall include migration tests covering forward upgrades from supported prior versions.
- Verification: CI migration test results.

### NFR-182 Observability for Critical Flows
- Category: Operational Quality
- Priority: Must
- Requirement: Production monitoring shall capture high-level success and failure rates for app launches, recipe import attempts, purchase attempts, restore attempts, and crash events without exposing sensitive content.
- Verification: Telemetry schema and dashboard review.

### NFR-183 Actionable Error Logging
- Category: Operational Quality
- Priority: Must
- Requirement: Operational logs and crash reports shall contain enough technical context to diagnose failures in import, purchase, persistence, and migration flows without requiring reproduction from scratch.
- Verification: Error event review in staging and production-like environments.

### NFR-184 Release Rollback Readiness
- Category: Operational Quality
- Priority: Should
- Requirement: The team should maintain the ability to halt rollout or roll back a problematic release based on monitored crash, purchase, or severe regression signals.
- Verification: Release operations review.

### NFR-185 Dependency Outage Tolerance
- Category: Scalability
- Priority: Must
- Requirement: Outage of a remote dependency shall not render previously saved local content unusable.
- Verification: Simulated dependency outage testing.

### NFR-186 Backward-Compatible Content Handling
- Category: Maintainability
- Priority: Should
- Requirement: New optional recipe fields introduced in future versions should not make existing records unreadable in current or near-current app versions where migration paths exist.
- Verification: Schema evolution review and compatibility tests.

### NFR-187 Modular Failure Containment
- Category: Maintainability
- Priority: Must
- Requirement: Failures in one feature area such as URL import, purchases, or notifications shall be contained so they do not cascade into recipe viewing, local planning, or grocery interactions.
- Verification: Fault-injection and module-boundary testing.

### NFR-188 Documentation Readiness
- Category: Operational Quality
- Priority: Should
- Requirement: Support and release teams should have concise operational documentation for entitlement issues, import failures, migration failures, and common user recovery steps.
- Verification: Operational documentation review.

### NFR-189 Support Diagnostics Path
- Category: Operational Quality
- Priority: Should
- Requirement: The app should provide or support a privacy-conscious diagnostic path for troubleshooting severe issues without exposing full user content by default.
- Verification: Support workflow review.

### NFR-190 Quality Gate for Launch
- Category: Operational Quality
- Priority: Must
- Requirement: A production release shall not ship if critical-severity defects exist in core flows, data loss risks remain unresolved, or performance, security, and crash thresholds in this document are materially unmet.
- Verification: Formal release sign-off against documented quality gates.

## Acceptance Summary

The product shall be considered non-functionally ready for production only when:

- Performance targets are met on representative supported devices
- Crash and data integrity thresholds are satisfied
- Offline use of core local workflows is proven
- Accessibility coverage is validated for the primary task flows
- Security and privacy reviews are completed with no unaccepted critical risks
- Device compatibility and store compliance are confirmed
- Operational monitoring is in place for critical production signals

## Traceability Notes

- Functional behaviors referenced by these quality requirements are defined in `docs/REQUIREMENTS.md`.
- Product goals and user-value context referenced by these quality requirements are defined in `docs/SPEC.md`.
- Test procedures and case mapping for these requirements shall be defined in future testing documents.
