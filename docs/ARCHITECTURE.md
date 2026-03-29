# Recipe Manager & Meal Planner Architecture
## Document Control

| Field | Value |
| --- | --- |
| Document | `ARCHITECTURE.md` |
| Product | Recipe Manager & Meal Planner |
| Scope | System architecture, tech stack, module structure, navigation, state management, API integrations, offline-first strategy, RevenueCat integration |
| Primary Platforms | iOS and Android via React Native / Expo |
| Local Source of Truth | SQLite |
| Premium Platform Dependency | RevenueCat |
| Commercial Offer | $9.99 one-time purchase |
| Status | Draft |
| Related Documents | `docs/SPEC.md`, `docs/REQUIREMENTS.md`, `docs/NFR.md`, `docs/DATA-MODEL.md` |
## Purpose

This document defines the production architecture for the Recipe Manager & Meal Planner app. It explains how the application is composed, how major subsystems interact, what technical choices are required for launch, and how the app should preserve reliability under mobile constraints such as intermittent connectivity, process death, limited memory, and interrupted user sessions.

This document is intended to support:

- implementation planning,
- engineering consistency across modules,
- QA understanding of architectural assumptions,
- performance and reliability validation,
- security and privacy review,
- release-readiness decisions,
- and future evolution without eroding the launch architecture.
## Scope

This document covers:

- system context and architectural goals,
- client runtime architecture,
- recommended production tech stack,
- application module structure,
- navigation architecture,
- state management strategy,
- persistence and repository boundaries,
- AI recipe import integration architecture,
- RevenueCat purchase and entitlement architecture,
- photo, timer, notification, and file-system integration,
- offline-first rules,
- synchronization and refresh policies,
- error handling and resilience patterns,
- observability and logging boundaries,
- and security-sensitive architectural decisions.

This document does not redefine:

- detailed product vision from `docs/SPEC.md`,
- line-by-line functional requirements from `docs/REQUIREMENTS.md`,
- non-functional quality targets from `docs/NFR.md`,
- or table-by-table schema definitions from `docs/DATA-MODEL.md`.
## Architecture Summary

The product is architected as a local-first mobile application built with React Native and Expo. SQLite is the authoritative on-device source of truth for recipes, meal plans, grocery lists, cooking sessions, and locally cached entitlement state. Most user workflows must remain usable without network access once relevant data has been stored locally.

The architecture deliberately avoids a heavy general-purpose backend for core user content at launch. There is no required user account system for everyday use. Remote dependencies are limited to:

- AI-assisted recipe import processing,
- RevenueCat entitlement and purchase orchestration,
- app store purchase infrastructure,
- and platform services such as image capture and local notifications.

The intended result is a product that behaves like durable personal kitchen software rather than a cloud-dependent content app.
## Architectural Goals

The architecture must satisfy the following goals:

- Keep the app fully functional for browsing saved content, planning meals, using grocery lists, and cooking while offline.
- Ensure user data remains locally available and understandable even when remote dependencies fail.
- Isolate external integrations so failures do not corrupt or block core workflows.
- Preserve fast UI performance for large local datasets.
- Make feature behavior deterministic through explicit data ownership and write boundaries.
- Allow safe recovery from app backgrounding, process death, and interrupted writes.
- Support a premium one-time purchase model without requiring constant online entitlement verification.
- Keep the codebase modular enough for a small product team to maintain.
- Minimize privacy exposure by transmitting only the data necessary for remote import and purchase services.
## Architectural Principles
### 1. Local Database First

SQLite is the primary source of truth for user content and durable app state. The UI reads from local state first and writes locally first. Remote operations produce inputs into local state rather than replacing local authority.
### 2. Remote Services Are Assistive, Not Authoritative

AI import helps transform URLs into structured recipes, and RevenueCat helps evaluate purchase state, but neither service owns the user’s saved recipe library, meal plan, or grocery list.
### 3. Explicit Layer Boundaries

The architecture separates:

- UI rendering,
- navigation and app-shell concerns,
- domain logic,
- application services,
- repositories and data access,
- and platform or external integrations.

This reduces coupling and makes test strategy clearer.
### 4. Stable Writes Over Clever State Mutation

All meaningful writes should flow through application services and repositories rather than ad hoc component-level persistence. This is especially important for recipe saves, grocery regeneration, meal planning, purchase-state updates, and cooking-session continuity.
### 5. Graceful Degradation

When the network, import service, store, RevenueCat, or notification permissions fail, the app must remain stable, must explain the issue, and must preserve the user’s local data.
### 6. Preserve User Intent

Architecture must protect:

- manual edits to imported recipes,
- manual grocery adjustments,
- planned scale context,
- current cooking step,
- active timers,
- and recognized local premium access.
### 7. Minimize Global Mutable State

Not all state should live in one store. Durable entities belong in SQLite-access layers. Screen-local draft state belongs in feature-local state. Cross-screen transient state belongs in narrowly scoped global stores only when necessary.
### 8. Production Over Prototype Convenience

The architecture should not rely on:

- brittle component-driven data writes,
- uncontrolled async side effects,
- giant untyped stores,
- permanent dependence on network reachability,
- or purchase gating that breaks offline continuity.
## System Context
### System Context Overview

The product consists of one mobile client application plus a small set of external service dependencies.
```text
+--------------------------------------------------------------+
|                  Mobile Client (Expo / React Native)         |
|                                                              |
|  UI + Navigation + Domain Services + SQLite + File Storage   |
+----------------------+-------------------+-------------------+
                       |                   |
                       | HTTPS             | SDK / Native APIs
                       |                   |
         +-------------+-----+      +------+------------------+
         | AI Import Service |      | Platform Services       |
         | URL -> structured |      | Camera, Photos, Files,  |
         | recipe extraction |      | Notifications, StoreKit |
         +-------------+-----+      +------+------------------+
                       |                   |
                       |                   |
                 +-----+-------------------+------+
                 | RevenueCat + App Stores        |
                 | Purchase and entitlement state |
                 +--------------------------------+
```
### High-Level Responsibilities

The mobile client is responsible for:

- rendering all product UX,
- persisting all local content,
- performing local search, filtering, planning, generation, and cooking workflows,
- initiating purchase and restore flows,
- caching recognized entitlement state locally,
- invoking remote import processing when needed,
- and gracefully continuing when remote systems are unavailable.

The AI import service is responsible for:

- fetching or accepting sanitized source page content,
- extracting structured recipe information,
- returning a normalized recipe draft payload,
- and failing safely when extraction confidence is insufficient.

RevenueCat and app stores are responsible for:

- initiating purchase transactions,
- resolving current customer entitlement information,
- supporting restore flows,
- and providing canonical purchase receipts and platform transaction authority.

Platform services are responsible for:

- local image capture or selection,
- filesystem storage,
- timer notifications,
- keeping the screen awake in cooking mode,
- share-intent delivery where supported,
- and native lifecycle behavior.
## Architectural Style

The application uses a layered modular monolith architecture inside a single mobile client codebase.

This means:

- one deployable mobile app,
- clear internal module boundaries,
- no microservice fragmentation inside the client,
- feature-driven code organization,
- and a small number of external dependencies with explicit adapters.

The architecture is best described as:

- local-first,
- domain-driven at the module level,
- service-oriented inside the app,
- and integration-light at launch.
## Runtime Topology
### Major Runtime Layers

The client runtime is composed of the following layers.
#### Presentation Layer

Contains:

- screen components,
- reusable UI primitives,
- feature UI components,
- theme bindings,
- accessibility bindings,
- animation wrappers,
- and input handling.

Rules:

- presentation components do not issue raw SQL,
- presentation components do not call RevenueCat directly,
- presentation components do not encode grocery merge logic,
- and presentation components may hold local draft state but not durable cross-feature business rules.
#### Navigation Layer

Contains:

- route definitions,
- tab and stack composition,
- deep-link resolution,
- guarded premium route entry checks,
- draft-safe exit prompts,
- and restoration of last-known navigation context where appropriate.

Rules:

- navigation owns screen composition and transitions,
- domain services own business effects triggered by navigated actions,
- and navigation guards must remain shallow and side-effect-light.
#### Domain/Application Layer

Contains:

- use cases,
- orchestrators,
- validators,
- merge policies,
- scaling logic,
- grocery generation logic,
- cooking-session logic,
- import workflow coordination,
- and entitlement evaluation policy.

Rules:

- all non-trivial write operations pass through this layer,
- this layer is framework-light and test-heavy,
- and domain functions should be reusable from screens, background tasks, and command handlers.
#### Data Access Layer

Contains:

- SQLite connection management,
- migration runner,
- repository implementations,
- transaction helpers,
- full-text search query helpers,
- file metadata persistence,
- and mapping between rows and domain models.

Rules:

- repositories are the only layer allowed to know table details,
- raw SQL is centralized,
- transactional multi-entity writes are explicit,
- and repository outputs must be deterministic and typed.
#### Integration Layer

Contains:

- AI import API client,
- RevenueCat adapter,
- notifications adapter,
- image picker and camera adapter,
- file-system adapter,
- network reachability adapter,
- and clipboard or share-intent adapters when used.

Rules:

- SDKs are wrapped behind interfaces or thin service classes,
- external payloads are validated before entering domain logic,
- and integration errors are normalized into application-level error types.
#### Platform Bootstrap Layer

Contains:

- app startup orchestration,
- splash lifecycle control,
- database initialization,
- migration execution,
- theme bootstrap,
- RevenueCat SDK configuration,
- notification registration,
- and app-lifecycle subscriptions.

Rules:

- startup sequencing must be deterministic,
- no user-facing route should render before required bootstrap gates complete,
- and startup must remain bounded to preserve launch-time NFRs.
## Recommended Tech Stack
## Core Stack

| Concern | Recommended Technology | Notes |
| --- | --- | --- |
| Mobile framework | React Native via Expo | Managed workflow with prebuild support for native modules where required |
| Language | TypeScript | Strict mode enabled |
| Routing | Expo Router | Built on React Navigation and suitable for file-based route structure |
| Database | `expo-sqlite` | Local relational source of truth |
| SQL migration management | In-app migration runner | Explicit schema versioning aligned with `docs/DATA-MODEL.md` |
| Search | SQLite FTS5 | Local fast search without remote dependency |
| Global transient state | Zustand or equivalent lightweight store | For UI/session state, not as primary durable entity store |
| Async remote query coordination | TanStack Query or equivalent | Optional and limited to remote/import/entitlement queries, not source-of-truth recipe data |
| Validation | Zod or equivalent runtime schema validation | For inbound integration payloads and form parsing |
| Purchase SDK | `react-native-purchases` | RevenueCat official SDK |
| Notifications | `expo-notifications` | Local timer completion notifications |
| Image capture/picker | `expo-image-picker` and camera support | Subject to UX decisions and permission scope |
| Filesystem | `expo-file-system` | Persistent image storage and temporary import artifacts |
| Screen awake control | `expo-keep-awake` | Cooking mode continuity |
| Secure small secrets | `expo-secure-store` if needed | Not for recipe content, only tiny secrets/config if necessary |
| Error reporting | Sentry or equivalent | Production crash and exception capture |
| Analytics | Minimal privacy-conscious analytics SDK | Optional and event-scoped |
## Expo Workflow Position

The app should use Expo managed workflow as the default operational model, with prebuild and config plugins where native permissions or RevenueCat integration require native configuration. This keeps developer velocity high while still supporting production-native capabilities.

The architecture should avoid ejecting to a fully unmanaged workflow unless:

- a critical dependency cannot be supported through Expo prebuild,
- store-related native customization exceeds config-plugin support,
- or measurable production constraints justify the operational cost.
## TypeScript Standards

The app should enforce:

- strict null checks,
- no implicit any,
- typed repository and service outputs,
- typed route params,
- typed event payloads,
- and explicit domain models separate from raw database rows when useful.

Type safety is especially important for:

- recipe import payloads,
- grocery generation inputs,
- entitlement state transitions,
- timer scheduling,
- and navigation handoffs involving recipe, meal plan, or cooking context.
## Codebase Structure

The codebase should be organized by architectural boundary and feature ownership rather than by file type alone.
### Recommended Top-Level Structure
```text
src/
  app/
  bootstrap/
  core/
  db/
  features/
  integrations/
  navigation/
  services/
  stores/
  theme/
  types/
  utils/
```
### `src/app/`

Contains Expo Router route entries, layout files, screen wrappers, and route-specific composition code.

Rules:

- thin route files,
- feature screens imported from `src/features/*`,
- no direct SQL,
- no direct SDK orchestration beyond wiring.
### `src/bootstrap/`

Contains startup orchestration:

- environment config loading,
- migration gate,
- initial settings load,
- RevenueCat initialization,
- notification channel registration,
- theme bootstrapping,
- and startup error boundary wiring.
### `src/core/`

Contains cross-feature domain primitives:

- result and error types,
- shared validation helpers,
- time and date utilities,
- quantity and unit helpers,
- logging interfaces,
- and transaction utility abstractions.
### `src/db/`

Contains:

- schema version registry,
- migration scripts,
- SQLite client factory,
- repository implementations,
- SQL statements,
- row mappers,
- and FTS update utilities.

This folder owns persistence implementation, not product use cases.
### `src/features/`

Contains feature modules with their UI, use cases, services, selectors, and tests. Recommended features:

- `recipes`
- `recipe-import`
- `collections`
- `meal-planner`
- `grocery`
- `cooking`
- `settings`
- `paywall`
- `search`
- `photos`
- `nutrition`

Each feature should contain only what it owns and should depend on shared services through interfaces or clearly defined imports.
### `src/integrations/`

Contains external adapters:

- `revenuecat`
- `ai-import-api`
- `notifications`
- `file-system`
- `image-picker`
- `network`
- `share`

This layer isolates third-party SDK semantics from domain logic.
### `src/navigation/`

Contains:

- shared route constants,
- deep-link mapping,
- premium guard helpers,
- unsaved-changes guard helpers,
- navigation analytics hooks if used.
### `src/services/`

Contains app-wide orchestration services that span multiple features, for example:

- `grocery-generation-service`
- `recipe-save-service`
- `entitlement-service`
- `cooking-session-service`
- `import-orchestrator`

These are domain/application services, not network service wrappers.
### `src/stores/`

Contains global transient stores only. Examples:

- active theme preference already loaded from persistence,
- currently visible timer overlay state,
- network reachability signal,
- ephemeral paywall presentation state,
- current recipe editor draft state if it must survive route transitions.

Durable entities should not be mirrored permanently here.
### `src/theme/`

Contains design tokens, semantic color mappings, typography choices, spacing scales, dark-mode mappings, and theme selectors.
### `src/types/`

Contains shared public TypeScript types that are stable across module boundaries.
### `src/utils/`

Contains low-level utilities with no feature ownership.
## Feature Module Boundaries
## Recipes Module

Owns:

- recipe library browsing,
- recipe detail display,
- manual recipe creation and edit,
- recipe duplication and deletion,
- ingredient and step editing,
- recipe metadata and notes,
- collection assignment integration,
- and recipe-level actions into meal planning, grocery, and cooking workflows.

Does not own:

- import network transport,
- grocery generation policy,
- purchase state,
- or timer scheduling infrastructure.
## Recipe Import Module

Owns:

- import entry flows,
- URL validation,
- import-job lifecycle UX,
- review and correction of parsed recipe drafts,
- duplicate warning heuristics,
- and save-from-import orchestration.

Depends on:

- AI import integration adapter,
- recipe save service,
- local draft persistence,
- and entitlement checks.
## Collections Module

Owns:

- collections and folder hierarchy UI,
- assignment and removal workflows,
- collection ordering,
- and collection-based browsing entry points.
## Meal Planner Module

Owns:

- weekly calendar rendering,
- meal slot display,
- assignment flows,
- scaling context per planned entry,
- entry duplication or removal,
- and calendar-local navigation state.
## Grocery Module

Owns:

- grocery list display and editing,
- grouping and sorting,
- completion state changes,
- manual item management,
- generation and refresh entry points,
- source traceability display,
- and clear/merge confirmation UX.

The grocery module depends on the grocery generation service but owns the user-facing list workflow.
## Cooking Module

Owns:

- cooking mode presentation,
- current-step navigation,
- ingredient quick reference,
- active-session restoration,
- timer launch UI,
- and cooking-mode keep-awake behavior.

The cooking module depends on notification and timer integration adapters for background continuity.
## Settings Module

Owns:

- theme mode setting,
- premium state display,
- restore purchase action,
- permission explanations where needed,
- and educational/help links if implemented.
## Paywall Module

Owns:

- premium value presentation,
- lock messaging,
- purchase initiation UI,
- restore entry points,
- purchase success confirmation,
- and lock-state explanation by attempted feature.

It does not own canonical entitlement persistence logic; that belongs to the entitlement service.
## Search Module

Owns:

- search input UX,
- filter state controls,
- sort choices,
- saved local result context restoration within the library session,
- and mapping search queries to repository queries.
## Cross-Feature Shared Services

The following services are cross-feature and should be designed as stable application services.
### Recipe Save Service

Responsibilities:

- validate recipe payload shape,
- normalize fields for persistence,
- orchestrate transactional writes across recipe and child tables,
- queue old image cleanup if needed,
- update FTS indexes,
- and emit success/failure results suitable for UI.
### Grocery Generation Service

Responsibilities:

- load meal plan entries for selected scope,
- expand recipe ingredient sets using planned scale context,
- merge grocery lines according to product rules,
- preserve traceability records,
- protect manual edits,
- write generation runs and item changes transactionally,
- and return clear user-facing summary information.
### Entitlement Service

Responsibilities:

- initialize RevenueCat client,
- load cached local entitlement state,
- refresh remote customer info when possible,
- evaluate feature access decisions,
- persist recognized entitlement timestamps,
- and surface normalized purchase or restore outcomes.
### Import Orchestrator

Responsibilities:

- validate URL input,
- create local import-job records,
- call the AI import adapter,
- map remote payloads into local draft schema,
- persist import history and draft data,
- and transition to review or recovery states.
### Cooking Session Service

Responsibilities:

- create or resume cooking sessions,
- persist current step and last-seen state,
- create and manage timer records,
- compute timer display state from authoritative timestamps,
- and coordinate local notifications.
### Media Service

Responsibilities:

- accept image capture or selection results,
- normalize file handling,
- generate stable app-local file names,
- record metadata rows,
- and safely replace or delete images using deferred cleanup when necessary.
## Dependency Direction Rules

Allowed dependency direction:

- UI -> feature hooks/use cases -> application services -> repositories/integrations
- UI -> theme/navigation/shared primitives
- application services -> repositories + integrations + core helpers
- repositories -> SQLite client + mappers
- integrations -> third-party SDKs/native APIs

Not allowed:

- repositories importing UI modules,
- integrations mutating UI state directly,
- route files embedding SQL,
- components calling external SDKs directly for business-critical flows,
- feature modules writing other feature tables without going through shared services where cross-feature invariants exist.
## Startup Architecture
## Startup Goals

Startup must:

- initialize the minimum required infrastructure,
- preserve app responsiveness,
- avoid rendering broken or partially gated premium states,
- and avoid long blocking operations on the critical first frame.
## Startup Sequence

Recommended startup sequence:

1. Launch native shell and keep splash visible.
2. Initialize runtime configuration and error reporting.
3. Open SQLite connection.
4. Enable required SQLite pragmas such as foreign keys and WAL mode.
5. Run pending schema migrations.
6. Load critical local settings such as theme mode and cached entitlement state.
7. Initialize RevenueCat SDK.
8. Register notification categories/channels if required.
9. Initialize lightweight network reachability observer.
10. Hydrate minimal transient stores from local persisted values.
11. Hide splash and render app shell.
12. Trigger non-blocking background refresh actions:
    theme confirmation if needed,
    entitlement refresh,
    stale import-job cleanup,
    deferred file cleanup,
    expired cooking-session reconciliation.
## Startup Blocking Rules

The following are blocking for initial route render:

- database open failure handling,
- migration completion,
- minimal settings read,
- and initialization of core error boundaries.

The following should be non-blocking whenever possible:

- RevenueCat remote customer-info refresh,
- analytics initialization,
- network-based educational content,
- import-job history cleanup,
- and deferred image-file deletion.
## Startup Failure Modes

If database open or migration fails:

- the app must not proceed into normal screens,
- the user must see a controlled fatal startup error screen,
- and logs must capture the failure context without exposing sensitive content.

If RevenueCat initialization fails:

- the app still launches,
- premium features stay governed by last-known local entitlement state,
- purchase and restore actions are disabled or retried with clear messaging,
- and the user can still use previously unlocked local workflows when policy allows.
## Navigation Architecture
## Navigation Goals

Navigation must:

- keep primary tasks reachable in one or two taps,
- preserve context between library, recipe detail, planner, grocery, and cooking flows,
- support interrupted sessions,
- and minimize accidental loss of in-progress edits.
## Recommended Navigation Model

Use a root stack with a persistent tab shell for primary product areas plus modal routes for workflows that are task-focused.
### Primary Tabs

Recommended primary tabs:

- Recipes
- Meal Plan
- Grocery
- Settings

A dedicated Home tab is optional. If a landing or dashboard screen is used, it should either:

- be the default screen inside the Recipes tab,
- or be a lightweight root route that still preserves fast access to the four primary areas.
### Stack and Modal Composition

Recommended route composition:
```text
RootStack
  TabsLayout
    RecipesTab
      RecipesIndex
      RecipeSearchResults
      RecipeDetail/[recipeId]
      Collection/[collectionId]
    MealPlanTab
      MealPlanWeek
      MealPlanAssignRecipe
    GroceryTab
      GroceryList
      GroceryGenerationReview
    SettingsTab
      SettingsIndex
      AppearanceSettings
      PurchaseStatus
  Modals
    RecipeEditor
    ImportRecipe
    ImportReview/[importJobId]
    Paywall
    NutritionEditor
    CollectionEditor
    TimerCenter
    PhotoViewer
    ConfirmDestructiveAction
  Fullscreen
    CookingMode/[recipeId]
```
### Navigation Rationale

- Tabs provide persistent access to the core mental model of the product.
- Recipe editor and import flows work well as modals because they are focused creation tasks.
- Cooking mode should be full-screen and immersive.
- Paywall should be modal so the user can clearly return to the blocked context.
- Timer center may be modal or bottom sheet depending on UI design, but its state should not depend on the current stack route.
## Route Ownership Rules

- Route params carry identifiers and lightweight display hints only.
- Full entity payloads should be loaded from repositories using IDs.
- Editing screens should read durable state at entry and maintain isolated draft state until save.
- Returning from recipe detail to search or filter contexts should restore prior list query state from local transient store or route-local state.
## Deep Linking

At launch, deep linking may be limited. Recommended supported links:

- open app root,
- open recipe by ID if internal route exists,
- open import flow from share target or app URL,
- open paywall directly for marketing or lock recovery if needed.

If deep links are supported:

- they must fail safely when the referenced record no longer exists,
- and they must never bypass entitlement checks for premium-only actions.
## Navigation Guards

Navigation guards should exist for:

- unsaved recipe draft exit,
- destructive clear or overwrite flows,
- cooking mode exit with active timers when confirmation is required,
- and feature lock interception for premium-only workflows.

Guard rules:

- premium guards should redirect to paywall with context,
- unsaved edit guards should offer save, discard, or cancel when feasible,
- and guards should not perform heavy async work before allowing navigation decisions.
## Navigation State Restoration

The app should restore:

- last-opened primary tab when appropriate,
- current search or filter context within the active library session,
- active cooking session route handoff,
- and timer overlay visibility if active timers exist.

The app should not aggressively restore:

- stale destructive modals,
- incomplete purchase screens,
- or remote-import loading screens that no longer map to active jobs.
## State Management Architecture
## State Classification

All app state must be classified into one of the following categories.
### Durable Domain State

Examples:

- recipes,
- ingredients,
- instructions,
- collections,
- meal plan entries,
- grocery items,
- cooking sessions,
- timers,
- settings,
- cached entitlement state.

Source of truth:

- SQLite

Access pattern:

- repositories,
- observable query hooks,
- explicit transactional writes.
### Remote-Derived Ephemeral State

Examples:

- current import request status before persistence finishes,
- RevenueCat refresh request in flight,
- restore purchase request result,
- reachability probe status.

Source of truth:

- integration layer or async query cache

Access pattern:

- feature-local hooks or limited query cache
### Cross-Screen Transient UI State

Examples:

- current search text before committed query,
- active filter chips,
- selected week in planner,
- current paywall presentation context,
- timer-center visibility,
- photo-upload temporary preview state.

Source of truth:

- global lightweight store when shared across routes,
- otherwise route-local state.
### Screen-Local Draft State

Examples:

- recipe form fields before save,
- import-review edits before confirm,
- manual grocery item editor draft,
- collection creation draft.

Source of truth:

- component or feature-local reducer/store

Rules:

- do not write every keystroke to SQLite unless draft persistence is an explicit requirement,
- support controlled draft preservation across route interruptions where needed,
- and save explicitly through services.
## State Management Rules

- SQLite owns durable product data.
- Global client stores own transient UI and workflow state only.
- Remote query caches must never become the durable source of truth for recipes or meal plans.
- Components should consume read models from hooks rather than issuing persistence calls directly.
- All complex writes should be isolated behind application services.
## Recommended Stores
### Entitlement UI Store

Contains:

- current evaluated premium-access snapshot,
- refresh-in-progress state,
- paywall context,
- and most recent purchase outcome message if still relevant.

Durable source:

- `entitlement_state` table
### Search UI Store

Contains:

- current query string,
- active filter selections,
- sort choice,
- and result-context restoration metadata.

Durable source:

- none by default, unless product later chooses persisted library preferences.
### Planner UI Store

Contains:

- selected week anchor,
- expanded day sections,
- visible meal slot focus,
- and current assignment-flow context.
### Cooking UI Store

Contains:

- currently highlighted timer,
- optional temporary step transition animation state,
- and whether the timer center overlay is visible.

Durable source for session continuity remains SQLite.
### App Shell Store

Contains:

- bootstrap completion state,
- current theme mode after initial load,
- reachability snapshot,
- and fatal startup error flags if the shell is still active.
## Data Access Architecture
## SQLite Connection Strategy

The app should maintain one primary writable SQLite connection in process, configured with:

- foreign keys enabled,
- WAL journal mode,
- appropriate busy timeout,
- and explicit transaction helpers.

Read patterns may still use the same underlying connection abstraction. The implementation should avoid opening many uncontrolled connections.
## Repository Pattern

Each aggregate or operational domain should have repositories that encapsulate queries and writes.

Recommended repositories:

- `RecipeRepository`
- `CollectionRepository`
- `MealPlanRepository`
- `GroceryRepository`
- `ImportRepository`
- `CookingRepository`
- `SettingsRepository`
- `EntitlementRepository`
- `SearchRepository`

Repository responsibilities:

- map between rows and domain objects,
- expose stable query methods,
- encapsulate SQL and joins,
- enforce transactional boundaries where needed,
- and remain free of UI concerns.
## Transaction Strategy

Transactions are required for:

- save recipe and all child rows,
- duplicate recipe,
- delete recipe and linked cleanup actions,
- assign meal plan entry with related derived state updates if any,
- grocery generation run write set,
- import draft finalization,
- purchase entitlement state update,
- cooking timer create or stop flows where session state also changes,
- and image replacement metadata updates plus cleanup queue insertion.

The architecture should prefer explicit write transactions rather than eventual consistency for single-user on-device flows when all required data is local.
## Read Model Strategy

The UI should consume read models tailored to screens rather than exposing raw tables. Examples:

- recipe list item model,
- recipe detail aggregate,
- planner week view model,
- grocery grouped list view model,
- cooking session view model,
- settings purchase summary model.

This reduces screen complexity and centralizes query optimization.
## FTS Search Strategy

Search should be fully local using SQLite FTS5. The search architecture should:

- index relevant recipe text fields,
- update index entries whenever recipes change,
- allow prefix and token search behavior appropriate for mobile UX,
- combine FTS result IDs with filter and sort criteria in repository queries,
- and keep result ranking deterministic enough for user trust.

The UI should debounce text input slightly, but the database remains the engine of truth for results.
## File Storage Architecture

Recipe images should be stored as files in the app sandbox with metadata rows in SQLite. The file strategy should:

- generate stable canonical app-managed file names,
- avoid keeping critical images only in temporary cache paths,
- downscale or compress excessively large inputs as part of import,
- preserve an original or processed canonical version per image policy,
- and defer deletion of replaced files through a cleanup queue when direct deletion is risky.

The database must never store recipe images as BLOBs for launch scope.
## Domain Flow Architecture
## Recipe Creation and Edit Flow

High-level sequence:

1. User opens recipe editor.
2. Screen initializes with existing recipe data or empty draft.
3. Draft state is edited locally in the UI layer.
4. Save action invokes recipe save service.
5. Service validates and normalizes payload.
6. Service writes recipe and child entities transactionally.
7. Service updates FTS and image metadata as required.
8. UI receives success result and navigates to detail or prior context.

Architectural rules:

- draft state stays isolated until save,
- form helpers may parse ingredient and step inputs locally,
- and repository writes remain centralized.
## AI Recipe Import Flow

High-level sequence:

1. User initiates import from a URL.
2. Entitlement service checks access.
3. Import orchestrator validates and normalizes URL.
4. Local `import_jobs` row is created with `queued` or equivalent status.
5. Import adapter sends request to AI import service.
6. Response payload is validated against runtime schema.
7. Local import draft is persisted.
8. Import job status transitions to review-ready or failed.
9. User reviews, edits, and saves through recipe save service.
10. Final recipe record is linked back to import job for traceability.

Architectural implications:

- import status must be locally persisted to survive interruption,
- remote payloads must not be trusted without validation,
- and imported drafts must remain editable before becoming durable recipes.
## Meal Planning Flow

High-level sequence:

1. User opens week view.
2. Planner repository loads week slots and entries from SQLite.
3. User assigns recipe through planner assignment flow.
4. Assignment service validates slot and recipe existence.
5. Meal plan entry is written transactionally.
6. Planner read model updates locally.
7. Grocery data is not silently regenerated unless explicitly designed and communicated.

Architectural implications:

- planner performance depends on efficient local queries by local-date ranges,
- scale context per planned recipe must persist with the entry,
- and recipe deletion must be handled safely to avoid orphaned planner references.
## Grocery Generation Flow

High-level sequence:

1. User starts grocery generation for a date scope.
2. Entitlement service checks access.
3. Grocery generation service loads planner entries and linked recipe ingredient data.
4. Service expands quantities using planned scaling context.
5. Service categorizes and proposes merge groups.
6. Service applies merge and preservation rules.
7. Service writes generation run, grocery items, and item-source rows transactionally.
8. UI shows completion summary and updated list.

Architectural implications:

- grocery generation is a domain service, not a screen helper,
- manual edits must be preserved or explicitly handled by policy,
- and generation results must remain traceable.
## Cooking Flow

High-level sequence:

1. User opens cooking mode from recipe detail or planner context.
2. Cooking session service creates or resumes session.
3. Current step and scaled ingredient context are loaded.
4. Screen is placed in immersive mode and keep-awake is enabled.
5. User navigates steps and may start timers.
6. Timer records are persisted locally and notifications scheduled.
7. On app background or resume, session state is restored from SQLite.

Architectural implications:

- active session continuity cannot depend solely on in-memory component state,
- timer completion logic must be derived from timestamps, not only interval loops,
- and cooking mode should work offline after recipe data exists locally.
## RevenueCat and Purchase Flow

High-level sequence:

1. User attempts premium feature or opens paywall.
2. Paywall module requests current evaluated entitlement snapshot.
3. Purchase action invokes RevenueCat adapter.
4. Store transaction completes or fails.
5. RevenueCat customer info is received and normalized.
6. Entitlement state is written locally with timestamps and status.
7. Access gates re-evaluate and UI unlocks immediately if entitled.
8. Restore follows the same normalization and persistence path.

Architectural implications:

- the app should continue using last-known recognized entitlement when offline,
- local entitlement state must be explicit and timestamped,
- and UI should not couple itself directly to raw SDK callbacks.
## AI Import Service Architecture
## Launch Position

The app should treat AI recipe import as a remote assistive service reachable over HTTPS. It should not embed long-lived API provider secrets in the mobile client.

Therefore, the production architecture requires a backend integration layer outside the app for import processing, even if the overall product is otherwise client-heavy.
## Import Service Responsibilities

The import service should:

- accept a URL submission from the mobile client,
- fetch or otherwise obtain recipe page content safely,
- sanitize content,
- extract candidate recipe structure using deterministic parsing plus AI assistance,
- return a normalized draft payload with confidence and warnings,
- and decline non-recipe or low-confidence pages cleanly.
## Import Client Adapter Responsibilities

The mobile import adapter should:

- submit only necessary fields,
- include app version and platform metadata if operationally useful,
- enforce timeouts,
- normalize transport and validation failures,
- map response bodies into internal import result types,
- and never expose provider-specific model details to UI components.
## Import Payload Guidelines

Client request should include only what is needed:

- source URL,
- optional locale hints,
- optional user-initiated title or note only if explicitly part of UX,
- and app/platform metadata.

The client should not transmit:

- local recipe library contents,
- meal plan history,
- purchase records,
- or unrelated personal content.
## Import Response Shape

The response should support:

- normalized source URL,
- extracted title,
- ingredient lines with structured fields where available,
- step groups and steps,
- servings or yield,
- prep, cook, and total time,
- nutrition when available,
- source image URL if available,
- extraction warnings,
- confidence metadata,
- and failure reason when extraction is not viable.

The app should validate every response with runtime schemas before persistence.
## Import Failure Handling

Failure classes should include:

- invalid input URL,
- unsupported or inaccessible page,
- network timeout,
- remote service unavailable,
- non-recipe content,
- extraction low confidence,
- and malformed response payload.

The import module should map these into recoverable UX paths, including:

- retry,
- edit URL,
- continue with manual recipe creation,
- or save partial draft if useful.
## RevenueCat Integration Architecture
## RevenueCat Design Goals

The RevenueCat architecture must:

- support a one-time lifetime purchase model,
- unlock premium features immediately after successful purchase,
- persist recognized entitlement locally,
- support restore purchases,
- continue honoring recognized entitlements offline,
- and fail safely when store or network services are unavailable.
## RevenueCat Integration Boundaries

The RevenueCat SDK should be wrapped by an integration adapter. The rest of the app should consume a normalized entitlement API, not raw SDK objects.

Recommended adapter responsibilities:

- initialize SDK with platform keys,
- fetch current customer info,
- initiate purchase for the configured package,
- initiate restore purchases,
- map platform/store errors to app errors,
- normalize entitlement snapshots,
- and emit logging-safe diagnostics.
## Entitlement Domain Model

The app should define an internal entitlement model separate from RevenueCat types. Fields should include:

- entitlement status,
- product/entitlement identifier,
- recognized source,
- last validated at,
- last successful sync at,
- purchase state message,
- environment if needed for debugging,
- and stale-state indicators.

The canonical local persistence target is the `entitlement_state` table described in `docs/DATA-MODEL.md`.
## Entitlement Evaluation Policy

Feature access should be determined by a single service that evaluates:

- local cached entitlement state,
- recent successful remote validation if available,
- current operation type,
- and any grace policy for previously recognized lifetime access.

At launch, policy should be simple:

- if local entitlement indicates active lifetime unlock, premium features remain available,
- if no active entitlement is recognized, premium features remain locked,
- if remote refresh fails, the last-known active local entitlement remains honored,
- and if the user has never been recognized as entitled, offline access must not unlock features.
## Purchase Offer Configuration

The paywall should not hardcode multiple ambiguous products. The architecture should expect one primary offer for launch:

- lifetime unlock priced at $9.99

RevenueCat offering configuration should still be abstracted so the app can:

- fetch current package identifiers,
- display localized store pricing if required,
- and tolerate operational changes without rewriting the paywall feature.
## Purchase Flow State Machine

Recommended normalized states:

- `unknown`
- `loading`
- `not_entitled`
- `entitled`
- `purchase_in_progress`
- `restore_in_progress`
- `purchase_failed`
- `restore_failed`

The UI may collapse these for display, but the architecture should preserve them internally for clean transitions and testing.
## Purchase Completion Rules

After purchase completion:

- entitlement state should be refreshed from RevenueCat customer info,
- the local entitlement table should be updated transactionally,
- UI gates should re-render immediately,
- the current blocked action should be resumable without app restart when feasible,
- and success messaging should be concise and non-blocking.
## Restore Flow Rules

Restore purchases should:

- be explicitly user-initiated,
- show progress and result states,
- update local entitlement state only after normalized verification,
- and never falsely claim success on transport failure or empty result.
## Offline Entitlement Strategy

The app is offline-first for usage, but not for first-time purchase recognition.

Rules:

- a user must complete purchase recognition online at least once,
- after a successful entitlement sync, local premium access may continue offline,
- offline mode must not erase or downgrade a valid recognized entitlement,
- the app should record last sync timestamp for troubleshooting,
- and the UI should explain when restore or purchase actions require connectivity.
## Premium Gate Architecture

Premium checks should happen at the action or route-entry level, not only by hiding buttons.

Gate types:

- action gate for import, planner assignment, grocery generation, and cooking mode if premium,
- modal paywall interception for blocked flows,
- passive badge or status display in settings.

The app should avoid scattering lock logic across many components. Use a shared `requirePremium` utility or hook that delegates to entitlement service policy.
## Offline-First Strategy
## Offline-First Goals

The offline-first architecture must ensure that users can:

- browse saved recipes,
- search their library,
- edit existing or new recipes,
- view and modify collections,
- view and adjust meal plans,
- use existing grocery lists,
- view generated grocery traceability already stored locally,
- and use cooking mode with timers,

without active network access after the relevant data has been stored locally.
## Local-First Rules

- Every durable user action writes to local persistence first or locally only.
- Remote integrations are opt-in workflow steps, not prerequisites for app usability.
- The app must surface stale or unavailable remote states without breaking local workflows.
- No core screen should require a network fetch to become useful.
## Connectivity Classification

The app should classify connectivity into:

- online,
- constrained/unstable,
- offline,
- unknown.

This signal is advisory and should not be treated as perfect truth. Remote actions should still handle real request failures independently.
## Offline Behavior by Feature
### Recipe Library

- fully available offline after local storage,
- search and filters remain local,
- image display uses local file copies,
- source URLs may be visible but opening them depends on external connectivity.
### Manual Recipe Creation

- fully available offline,
- all validation except remote-specific checks remains local,
- photos can still be attached if platform services are available.
### Recipe Import

- requires network,
- should fail fast with a clear explanation when offline,
- and should offer manual recipe creation as fallback.
### Meal Planning

- fully available offline for stored recipes and local planner data,
- adding a recipe from local library remains available offline.
### Grocery List

- viewing and editing existing lists remains available offline,
- generation from local meal plan and recipes remains available offline,
- no server is required for generation logic.
### Cooking Mode and Timers

- fully available offline for locally stored recipes,
- local notifications continue subject to OS behavior and user permissions.
### Purchases and Restore

- require online access to store and RevenueCat services,
- but previously recognized entitlement remains effective offline.
## Staleness and Refresh Policy

Remote-backed states should use a stale-while-usable approach.

Examples:

- entitlement state is usable from local cache and refreshed opportunistically,
- import history remains visible locally even if remote service is down,
- offering metadata may be stale briefly without blocking display of a known paywall if local fallback text exists.
## Conflict Model

At launch there is no multi-device content sync, so the dominant conflict class is local interruption rather than concurrent remote edits.

Therefore, architecture should optimize for:

- transaction safety,
- idempotent retries where possible,
- and draft preservation,

rather than distributed merge complexity.
## Error Handling Architecture
## Error Taxonomy

Errors should be normalized into stable categories:

- validation error,
- permission error,
- network error,
- timeout error,
- remote service error,
- integration configuration error,
- persistence error,
- not found error,
- conflict or stale-state error,
- and unknown unexpected error.

Each application service should return normalized result types that UI can map to clear user messaging.
## User-Visible Error Rules

- errors must preserve user context,
- errors should not drop users at dead ends,
- destructive partial writes must be prevented via transaction boundaries,
- and technical jargon should not leak into the user-facing copy.
## Logging Rules

Logs may include:

- operation type,
- module name,
- identifiers safe for troubleshooting,
- timing data,
- error category,
- and coarse environment details.

Logs must not include:

- full recipe contents unnecessarily,
- private notes unless explicitly redacted and approved,
- store secrets,
- raw purchase tokens,
- or arbitrary remote page content from imports beyond what is operationally necessary.
## Retry Rules

Automatic retries are appropriate for:

- transient entitlement refresh failures,
- delayed import polling if polling is used,
- deferred file cleanup,
- and notification rescheduling on app resume if state reconciliation is needed.

Automatic retries are not appropriate for:

- purchase flow repetition,
- destructive list clearing,
- or repeated import submission without user confirmation.
## Resilience Patterns
## Idempotency Considerations

The app should strive for idempotent behavior in operations that may repeat after interruption.

Examples:

- re-running startup cleanup jobs,
- reconciling active timers from persisted timestamps,
- re-reading entitlement state after purchase callback,
- and resuming import review from persisted local draft.
## Crash Recovery

After unexpected termination:

- the app should reopen with stable local content,
- incomplete drafts may be restored only if draft persistence exists,
- cooking sessions should be restorable from local state,
- active timers should compute remaining or completed state from timestamps,
- and partially written multi-table operations should not exist if transaction boundaries were respected.
## Background and Foreground Lifecycle Handling

On background:

- persist current cooking-session position if changed,
- ensure timers have scheduled notifications,
- flush pending lightweight store state only if required,
- and avoid long synchronous work.

On foreground:

- re-evaluate timer completion from timestamps,
- refresh entitlement state opportunistically if stale and online,
- reload transient reachability,
- and reconcile any import jobs left in non-terminal states if the workflow design requires it.
## Security and Privacy Architecture
## Security Boundaries

The launch architecture has a relatively small security surface because:

- there is no mandatory user account system,
- recipe content is primarily local,
- purchase flows are delegated to store infrastructure and RevenueCat,
- and AI import is the only substantial custom network data path.

Still, the architecture must protect:

- local recipe content from accidental exposure through logs,
- entitlement state from tampering assumptions in app logic,
- network traffic with HTTPS,
- and secrets by keeping provider keys out of the client where possible.
## Secrets Handling

The mobile client may contain:

- public SDK configuration keys appropriate for client use,
- RevenueCat public SDK key,
- environment flags.

The mobile client must not contain:

- private AI provider API keys,
- backend signing secrets,
- or store backend credentials.
## Data Minimization

Only send remote services the minimum data needed for the operation. For import this generally means:

- the URL,
- or sanitized source content if architecture evolves,
- and operational metadata required for service function.

The app should not build hidden cross-feature profiles of cooking behavior for remote analytics without explicit product and privacy approval.
## Storage Sensitivity

Local recipe data resides in SQLite and app sandbox files. This is acceptable for launch scope, but architecture should still:

- avoid storing unnecessary raw remote payloads,
- avoid long retention of failed import artifacts,
- and use OS sandbox protections appropriately.
## Observability Architecture
## Production Monitoring Goals

Observability should answer:

- did the app start successfully,
- are migrations safe,
- are imports succeeding,
- are purchase and restore flows succeeding,
- are grocery generation operations failing,
- are timer notifications reliable enough,
- and are performance targets holding on representative devices.
## Instrumentation Boundaries

Recommended event families:

- app startup milestones,
- database migration results,
- recipe save success/failure,
- import start/success/failure,
- paywall shown,
- purchase start/success/failure,
- restore start/success/failure,
- meal plan assignment,
- grocery generation start/success/failure,
- cooking mode start/resume,
- timer created/completed/cancelled.

Observability should remain privacy-conscious. Avoid content-heavy payload logging.
## Performance Instrumentation

Measure:

- cold and warm start timing,
- screen open durations,
- search latency,
- recipe save duration,
- grocery generation duration,
- timer creation latency,
- import request duration,
- and purchase completion latency where possible.

These measurements support `docs/NFR.md`.
## Testing Architecture Support

The architecture should be testable at multiple levels.
### Unit Test Targets

- ingredient scaling logic,
- grocery merge logic,
- entitlement evaluation policy,
- import payload validation,
- timer state calculations,
- and route guard decisions.
### Integration Test Targets

- repository queries against SQLite test database,
- migration execution,
- recipe save transactions,
- grocery generation transactions,
- purchase-state persistence after mocked RevenueCat responses,
- and cooking session restoration.
### End-to-End Test Targets

- create and edit recipe,
- import URL to saved recipe flow,
- plan meals and generate grocery list,
- launch cooking mode and timer behavior,
- purchase and restore paywall flow with test store environments,
- and offline relaunch behavior after local data exists.

Architecture choices should make these test levels straightforward by keeping core logic outside UI components.
## Detailed Module Responsibilities
## `features/recipes`

Public responsibilities:

- list recipes,
- open detail,
- create, edit, duplicate, delete,
- attach photo,
- scale recipe for display,
- and route into planner/grocery/cooking actions.

Core collaborators:

- `RecipeRepository`
- `RecipeSaveService`
- `SearchRepository`
- `MediaService`
- `EntitlementService` only for premium-gated related actions, not basic viewing
## `features/recipe-import`

Public responsibilities:

- submit URL,
- show import progress,
- render extracted draft for review,
- warn on likely duplicates,
- and finalize save.

Core collaborators:

- `ImportOrchestrator`
- `ImportRepository`
- `RecipeSaveService`
- `EntitlementService`
## `features/meal-planner`

Public responsibilities:

- week navigation,
- day and slot display,
- assignment and edit,
- and recipe-to-plan workflows.

Core collaborators:

- `MealPlanRepository`
- `RecipeRepository`
- `EntitlementService`
## `features/grocery`

Public responsibilities:

- grouped list rendering,
- item edit and completion,
- generation and refresh actions,
- and traceability views.

Core collaborators:

- `GroceryRepository`
- `GroceryGenerationService`
- `EntitlementService`
## `features/cooking`

Public responsibilities:

- immersive cooking mode,
- current-step navigation,
- active timer display,
- and resume experience.

Core collaborators:

- `CookingSessionService`
- `CookingRepository`
- `NotificationAdapter`
- `KeepAwakeAdapter`
- `EntitlementService`
## `features/settings`

Public responsibilities:

- appearance controls,
- premium status,
- restore purchase,
- and operational settings/help surfaces.

Core collaborators:

- `SettingsRepository`
- `EntitlementService`
## Data Synchronization Boundaries

At launch the app does not implement a user-account-backed multi-device sync architecture. This is an explicit architectural choice.

Consequences:

- no remote recipe library authority,
- no merge engine for multi-device content conflicts,
- no cloud planner reconciliation,
- and no background sync dependency for app usefulness.

Benefits:

- simpler privacy posture,
- stronger offline behavior,
- smaller backend scope,
- and lower operational complexity.

Tradeoff:

- user data is local to the device unless future export/backup features are added.

The architecture should still leave room for future sync by:

- using stable client-generated IDs,
- centralizing repositories and services,
- and avoiding assumptions that row IDs are device-local integers.
## Background Work Architecture

The app should use background work sparingly.

Suitable background tasks:

- notification scheduling and response handling,
- deferred cleanup of replaced image files,
- stale import-job reconciliation if an import pattern requires it,
- opportunistic entitlement refresh when app becomes active,
- and non-blocking analytics flushes.

Unsuitable background tasks at launch:

- continuous remote sync,
- large remote crawling,
- hidden heavy recomputation of planner or grocery state without user action.
## Notification Architecture

Timer notifications are local notifications tied to persisted cooking timer records.

Architecture rules:

- create timer row before scheduling notification,
- store notification identifier if returned by platform adapter,
- compute timer completion from timestamps rather than trusting notification delivery alone,
- allow cancellation or stop to update both local row and scheduled notification,
- reconcile completed timers on resume in case notification delivery was delayed or permission was denied.

If notification permissions are unavailable:

- timers still exist,
- in-app timer state still works while app is active,
- and settings/help surfaces should explain the limitation.
## Theme and Dark Mode Architecture

Theme state should be persisted in settings and loaded during bootstrap. The theme subsystem should expose semantic tokens rather than raw hardcoded color usage.

Architecture rules:

- all feature screens consume semantic tokens,
- the theme mode switch must not reset navigation state,
- paywall, cooking mode, planner, grocery, and editor screens all use the same token system,
- and image overlays or contrast-dependent surfaces require theme-aware treatment.

Recommended theme modes:

- system,
- light,
- dark.
## Accessibility Architecture

Accessibility is a cross-cutting architecture concern rather than a post-processing UI task.

Architecture should support:

- semantic labeling for navigation controls,
- predictable focus order,
- voice-friendly step navigation in cooking mode,
- accessible timer announcements,
- sufficient contrast in both themes,
- and scalable text behavior without layout collapse.

Feature modules should not hide accessibility semantics inside low-level styling decisions. Shared UI primitives should carry the majority of reusable accessibility structure.
## Performance Architecture Considerations
## Render Performance

To support large libraries and long grocery lists:

- use virtualized lists,
- avoid full-screen rerenders from broad global store subscriptions,
- memoize expensive derived screen sections only when profiling justifies it,
- and keep route components thin.
## Database Performance

To support NFR targets:

- rely on indexed queries defined in `docs/DATA-MODEL.md`,
- keep list read models narrow,
- use FTS for search rather than JavaScript-side filtering over full datasets,
- and batch writes in transactions.
## Startup Performance

- keep bootstrap blocking work minimal,
- defer non-essential network calls,
- hydrate only critical settings before first route render,
- and do not compute large denormalized datasets during startup.
## Reliability Architecture Considerations
## Data Integrity

Integrity is protected through:

- foreign keys,
- transactional writes,
- explicit repository methods,
- durable local IDs,
- and cleanup queues for risky file deletion paths.
## Operational Recovery

Recovery is supported through:

- persisted import jobs,
- persisted cooking sessions and timers,
- cached entitlement state,
- and deterministic startup reconciliation steps.
## User Trust

Trust depends on architecture that avoids:

- silently losing manual edits,
- silently invalidating premium access already recognized locally,
- corrupting grocery lists during regeneration,
- or losing cooking context due to route transitions.
## Future Evolution Notes

The launch architecture should preserve space for future features without forcing a rewrite.

Likely future-compatible extensions:

- export and backup workflows,
- optional user accounts,
- cloud sync,
- collaborative household planning,
- richer grocery categorization,
- and additional monetization packaging if business strategy changes.

Preparation choices already included in this architecture:

- stable string identifiers,
- repository and service boundaries,
- explicit local entitlement model,
- external integration adapters,
- and feature-based modules.

These choices reduce coupling and keep future scope additions incremental rather than architectural resets.
## Architecture Decisions Summary
### Decision 1: Use Expo + React Native for a Single Cross-Platform Mobile Client

Reasoning:

- strong fit for iOS and Android launch,
- acceptable native capability access,
- faster iteration for a small product team,
- and compatible with RevenueCat, SQLite, notifications, and media handling.
### Decision 2: Use SQLite as the Primary Source of Truth

Reasoning:

- required for strong offline behavior,
- supports structured recipe, planner, and grocery data,
- enables fast local search via FTS,
- and minimizes cloud dependency.
### Decision 3: Keep Launch Architecture Local-First Without Mandatory Accounts

Reasoning:

- aligns with product positioning as a personal utility app,
- reduces privacy and backend burden,
- improves offline reliability,
- and avoids premature sync complexity.
### Decision 4: Isolate AI Import Behind a Remote Service Adapter

Reasoning:

- protects provider secrets,
- allows service evolution independent of app release cadence,
- centralizes parsing policy,
- and keeps client logic simpler and safer.
### Decision 5: Cache RevenueCat Entitlement Locally and Honor It Offline

Reasoning:

- matches purchase expectations for a lifetime unlock,
- supports offline use,
- avoids frustrating re-lock behavior,
- and aligns with core product trust principles.
### Decision 6: Use Layered Services and Repositories Rather Than Screen-Owned Business Logic

Reasoning:

- improves testability,
- protects invariants,
- reduces duplicated logic,
- and keeps feature growth manageable.
## Production Readiness Checklist

The architecture is production-ready only when all of the following are true:

- startup sequence is implemented and resilient to partial failures,
- migrations run safely and idempotently,
- repositories cover all durable entities,
- cross-feature write flows use services and transactions,
- RevenueCat integration is wrapped and local entitlement caching works,
- AI import requests and responses are validated and failure-safe,
- cooking sessions and timers restore correctly after interruption,
- local notifications are reconciled with persisted timer state,
- image storage is file-based with cleanup handling,
- premium gates are centralized and consistent,
- core screens remain useful offline,
- and observability exists for launch-critical flows.
## Final Architectural Position

The launch product should behave like premium personal software with modern assistive integrations rather than a cloud-first subscription platform. The architecture therefore centers on a durable local database, explicit application services, thin remote dependencies, and careful handling of interruptions.

React Native and Expo provide the mobile shell. SQLite provides the user’s durable kitchen system. RevenueCat provides purchase orchestration, but entitlement must remain understandable and locally resilient. AI import provides modern convenience, but imported data becomes valuable only after it is normalized into the same local recipe model as everything else.

If implemented according to this document, the app can deliver:

- fast local browsing and search,
- trustworthy meal planning and grocery generation,
- resilient cooking mode with timer continuity,
- simple but reliable premium access,
- and strong offline usability consistent with the product’s value proposition.
