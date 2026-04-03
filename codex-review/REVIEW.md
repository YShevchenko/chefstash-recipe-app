# Codex Review — ChefStash — 2026-04-03

## Documentation
- **Concept:** ChefStash is an offline-first recipe extraction and management app. Users paste a food blog URL, the app fetches the HTML and extracts `schema.org/Recipe` JSON-LD data locally, and stores the cleaned recipe (title, ingredients, instructions, image) in a local SQLite database. A dedicated "Cooking Mode" keeps the screen awake and displays large-format text with tappable ingredient checkoffs.
- **Spec:** `docs/SPEC.md` clearly defines the core flow (URL paste, local HTML parse, SQLite save, Cooking Mode), the freemium gate (10 free recipes, $19.99 one-time unlock), and the zero-backend privacy model. The spec is accurate and matches the implemented code.
- **Supporting docs:** The project has thorough documentation: `REQUIREMENTS.md` (41 functional requirements across 5 categories), `ARCHITECTURE.md` (system context diagram, component model, RevenueCat integration spec), `UI-UX-SPEC.md` (brutalist design philosophy, 5 screens, error/edge states), `NON-FUNCTIONAL-REQUIREMENTS.md` (privacy, performance, reliability), `TEST-PLAN.md` (3-tier strategy: unit, integration, E2E), and `TEST-CASES.md` (18 detailed test cases covering extraction, Cooking Mode, organization, premium gating, data management, and offline).
- **Marketing:** `docs/MARKETING.md` is minimal — it classifies the app as Tier 4 Niche, identifies Pinterest as the primary UA channel, and states the $19.99 price point, but does not include budgets, CPI/LTV targets, creative test hypotheses, or retention benchmarks.

## Code & Monetization
- **Framework:** Flutter (Dart), not React Native as originally spec'd in `SPEC.md` and `ARCHITECTURE.md`. The `pubspec.yaml` targets SDK `^3.11.3` and uses `sqflite` for local storage, `html` for DOM parsing, `wakelock_plus` for Cooking Mode, and `provider` for state management.
- **Code structure:** Clean feature-based architecture under `lib/`:
  - `core/database/database_helper.dart` — SQLite with 4 tables: `recipes`, `tags`, `recipe_tags`, `step_photos`. Schema versioning with `onUpgrade` for DB migrations.
  - `core/services/recipe_extractor.dart` — On-device HTML parser that extracts `schema.org/Recipe` JSON-LD from `<script type="application/ld+json">` blocks, with microdata fallback and `@graph` traversal. Handles arrays, nested objects, and multiple `@type` formats.
  - `core/services/iap_service.dart` — Singleton using Flutter's `in_app_purchase` package (not RevenueCat as spec'd in `ARCHITECTURE.md`). Handles non-consumable purchase of `chefstash_premium`, restore, and price querying. Includes a debug-mode bypass for testing.
  - `core/services/step_photo_service.dart` — Compresses user-taken photos to max 800px/JPEG-80 for per-step attachments (FR-033).
  - `data/repositories/recipe_repository.dart` — Repository layer wrapping `DatabaseHelper` with image downloading, tag management, JSON export/import, and step photo lifecycle.
  - `domain/models/recipe.dart` — Domain model with `fromMap`/`toMap` conversions, JSON and newline-split parsing for ingredients/instructions.
- **Screens (4 implemented):**
  1. `VaultScreen` — Home grid/list of saved recipes with search, grid/list toggle, long-press context menu (Cook Now, Manage Tags, Delete), FAB for adding recipes, and 10-recipe premium gate enforcement.
  2. `ManualRecipeEntryScreen` — Doubles as both manual entry and URL-extraction review/edit screen. Per-step instruction fields with optional photo attachments. Premium-gated tag input.
  3. `CookingModeScreen` — Dark background (slate `#2C3E50`), wakelock enabled, tabbed Ingredients/Instructions view, tap-to-strikethrough on ingredients, numbered steps with step photos rendered inline.
  4. `SettingsScreen` — Premium upsell banner, restore purchases, export/import (premium-gated), app version, publisher, privacy info.
- **IAP implementation:** `iap_service.dart` exists and is fully wired — initialized in `main.dart`, checked in `VaultScreen` (recipe count gate), `ManualRecipeEntryScreen` (save gate), and `SettingsScreen` (export/import gate). The product ID `chefstash_premium` is correctly configured as a non-consumable. Purchase, restore, and price-fetch flows are all implemented.
- **Localization:** English ARB file at `lib/l10n/app_en.arb` with 26 keyed strings, but the UI widgets hardcode English strings rather than using the generated `AppLocalizations`. The ARB file is effectively dead code.
- **Spec drift — RevenueCat vs in_app_purchase:** `ARCHITECTURE.md` specifies RevenueCat (`react-native-purchases`) with anonymous user IDs, cached entitlements, and a 25-hour cache TTL. The actual code uses Flutter's `in_app_purchase` directly, which means no server-side receipt validation, no cross-platform entitlement sync, and no offline entitlement caching beyond what the OS provides. The `purchases_flutter` pod exists in `ios/Pods/` (likely from an earlier iteration) but is not imported anywhere in `lib/`.
- **Spec drift — React Native vs Flutter:** Both `SPEC.md` and `ARCHITECTURE.md` describe the app as React Native + Expo with Zustand state management and Cheerio for HTML parsing. The actual implementation is Flutter with `provider` and Dart's `html` package. The docs should be updated to reflect reality.

## Stability & Revenue Risks
1. **No server-side receipt validation.** The `in_app_purchase` implementation relies entirely on client-side purchase status. There is no backend and no RevenueCat to validate receipts. On iOS this is acceptable for a non-consumable (the App Store handles it), but it means premium status is purely in-memory (`_isPremium` bool) and resets on app restart — `restorePurchases()` is called in `initialize()` which mitigates this, but a slow or failed restore could temporarily lock out a paid user.
2. **Export/Import gated behind Premium.** `SettingsScreen` blocks export and import for free users. If a free user loses their device, they lose all recipes with no recovery path. This is a deliberate product decision but carries negative review risk.
3. **No image compression on recipe extraction.** `RecipeRepository._downloadImage()` saves the full-resolution image from the source URL. Only step photos go through `StepPhotoService` compression. NFR-202 requires recipe images to be < 300KB, but this is not enforced for cover images.
4. **`MARKETING.md` lacks execution detail.** Pinterest as primary UA channel is stated but there are no budgets, CPI/LTV expectations, creative test plans, or retention metrics. For a $19.99 one-time purchase with zero recurring revenue, the break-even math on paid acquisition needs to be explicit.
5. **Tests are skeletal.** Three test files exist with a total of 7 test cases:
   - `widget_test.dart` — 1 test: verifies app title renders.
   - `database_helper_test.dart` — 2 tests: confirms `RecipeExtractor` singleton exists (does not test the actual database).
   - `vault_screen_test.dart` — 4 tests: verifies Scaffold, AppBar, FAB, and settings icon render.
   None of these tests exercise the extraction engine, database operations, IAP flows, or Cooking Mode — the four highest-risk areas. The `TEST-PLAN.md` specifies feeding 50 real HTML samples through the parser, but zero such tests exist. The 18 detailed test cases in `TEST-CASES.md` are entirely manual.
6. **Search queries ingredients and instructions as raw text.** `DatabaseHelper.searchRecipes()` does a `LIKE` search across `title`, `ingredients`, and `instructions` columns. Since ingredients/instructions are stored as JSON-encoded arrays (e.g., `["2 cups flour","1 egg"]`), a search for "flour" will match but results depend on SQLite's text matching against JSON syntax. This works but is fragile.

## Next Steps
1. **Reconcile docs with implementation.** Update `SPEC.md` and `ARCHITECTURE.md` to reflect Flutter/Dart, `in_app_purchase`, and `provider` instead of React Native, RevenueCat, and Zustand. Either migrate IAP to RevenueCat (which would add receipt validation and offline caching) or remove RevenueCat references from the architecture doc.
2. **Add recipe image compression.** Apply the same compression logic from `StepPhotoService` (800px max, JPEG 80) to cover images downloaded during extraction, satisfying NFR-202 (< 300KB per image).
3. **Implement automated parser tests.** Create a `test/recipe_extractor_test.dart` that feeds raw HTML fixtures from popular recipe sites (AllRecipes, Serious Eats, NYT Cooking, WordPress Recipe Card blocks) into `RecipeExtractor` and asserts correct field extraction. This is the highest-risk surface and currently has zero coverage.
4. **Add database integration tests.** Test CRUD operations, tag management, step photo persistence, export/import round-tripping, and the 10-recipe count enforcement against an in-memory SQLite instance.
5. **Wire up localization or remove the ARB file.** Either replace hardcoded strings in widgets with `AppLocalizations.of(context)` calls or delete `lib/l10n/app_en.arb` to avoid dead code confusion.
6. **Expand `MARKETING.md`** with CPI/LTV thresholds, creative test plans, Pinterest campaign structure, and retention benchmarks so paid acquisition can be evaluated before spend begins.

