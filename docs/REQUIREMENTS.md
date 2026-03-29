# Recipe Manager & Meal Planner Functional Requirements

## Document Control

| Field | Value |
| --- | --- |
| Document | `REQUIREMENTS.md` |
| Product | Recipe Manager & Meal Planner |
| Scope | Functional requirements only |
| Identifier Format | `REQ-XXX` |
| Primary Platforms | iOS and Android via React Native / Expo |
| Local Storage | SQLite |
| Monetization | RevenueCat-managed one-time purchase |
| Current Commercial Offer | $9.99 lifetime unlock |
| Status | Draft |
| Related Document | `docs/SPEC.md` |

## Purpose

This document defines the functional behavior the product must provide for end users. It expresses what the app must do, not how it will be implemented.

The requirements are written to support:

- product definition,
- engineering implementation,
- QA traceability,
- release planning,
- future change control.

## Requirement Conventions

- `Must` means required for production scope.
- `Should` means strongly desired and expected unless deferred by explicit scope decision.
- `Could` means optional enhancement that may be implemented if capacity allows.
- Each requirement is intentionally testable.
- Requirements are grouped by functional area rather than implementation layer.
- If two requirements appear related, both still apply unless one explicitly narrows the other.

## Functional Scope Summary

This document covers requirements for:

- application access and shell behavior,
- purchase, entitlement, and paywall flows,
- recipe library management,
- AI recipe import from URLs,
- manual recipe creation and editing,
- recipe search, filter, sort, and browse,
- collections and folders,
- recipe photos and image capture,
- nutritional information,
- ingredient scaling,
- weekly meal planning,
- smart grocery list generation and management,
- cooking mode with step-by-step guidance and timers,
- dark mode and appearance behavior,
- user settings and related in-app controls where required to support the above features.

## Assumptions and Product Rules

- The product is a premium utility app rather than an ad-supported content platform.
- The app shall not require account creation for core use.
- The source of truth for user data on-device shall be local structured storage.
- Recipe import from a URL is a premium feature.
- Meal planning, grocery list generation, and cooking mode are premium features.
- The app may allow limited pre-purchase evaluation, but the paid entitlement is the mechanism that unlocks full usage.
- The app is intended for individual users and households, not commercial kitchen operations.

## Functional Requirements

## 1. App Access, Navigation, and Shell

### REQ-001 App Launch
- Priority: Must
- Requirement: The app shall launch to a usable home experience without requiring the user to create or sign in to an account.

### REQ-002 First-Run Introduction
- Priority: Must
- Requirement: On first launch, the app shall present an introductory flow that explains the product’s core value proposition: recipe saving, meal planning, grocery list generation, and cooking assistance.

### REQ-003 Intro Flow Dismissal
- Priority: Must
- Requirement: The user shall be able to skip or complete the introductory flow and proceed into the app without forced registration.

### REQ-004 Intro Flow Revisit
- Priority: Should
- Requirement: The app shall provide a way to revisit onboarding or feature education from settings or help surfaces.

### REQ-005 Core Navigation
- Priority: Must
- Requirement: The app shall provide persistent navigation to the primary product areas: recipes, meal plan, grocery list, and settings or equivalent app controls.

### REQ-006 Current Context Visibility
- Priority: Must
- Requirement: The app shall clearly indicate which primary area is currently active.

### REQ-007 Deep Navigation Return
- Priority: Must
- Requirement: The app shall allow the user to return from any detail screen to its previous list or parent context without data loss.

### REQ-008 Safe Interruption Handling
- Priority: Must
- Requirement: If the app is backgrounded or interrupted while the user is editing or viewing content, the app shall return the user to a sensible state when resumed.

### REQ-009 Unsaved Changes Prompt
- Priority: Must
- Requirement: When the user attempts to leave a screen containing unsaved manual edits, the app shall prompt the user to save, discard, or continue editing.

### REQ-010 Empty State Guidance
- Priority: Must
- Requirement: Primary areas with no user data shall display actionable empty states that guide the user toward the next relevant action.

### REQ-011 Home Entry Point
- Priority: Should
- Requirement: The app shall provide a home or landing view that helps the user resume common tasks such as importing a recipe, planning the week, or opening the grocery list.

### REQ-012 Cross-Feature Entry Points
- Priority: Must
- Requirement: The app shall expose direct entry points from major screens to adjacent workflows, including planning a recipe, adding it to a collection, starting cooking mode, and adding it to a grocery-related workflow where appropriate.

## 2. Purchase, Entitlement, and Premium Access

### REQ-013 Premium Offer Presentation
- Priority: Must
- Requirement: The app shall present a clear premium offer describing the one-time purchase price of $9.99 and the capabilities unlocked by purchase.

### REQ-014 No Subscription Framing
- Priority: Must
- Requirement: The paywall shall describe the commercial model as a one-time purchase and shall not present the product as a recurring subscription.

### REQ-015 Purchase Trigger Points
- Priority: Must
- Requirement: The app shall be able to present the paywall from onboarding, settings, and premium feature entry points.

### REQ-016 Premium Feature Gating
- Priority: Must
- Requirement: When a non-entitled user attempts to access a premium-only capability, the app shall intercept the action and present the premium offer before allowing access.

### REQ-017 Locked Feature Explanation
- Priority: Must
- Requirement: A premium gate shall explain which attempted action is locked and what broader set of product benefits is included with purchase.

### REQ-018 RevenueCat Purchase Flow
- Priority: Must
- Requirement: The app shall initiate and complete in-app purchase flows through RevenueCat-supported entitlement handling.

### REQ-019 Entitlement Confirmation
- Priority: Must
- Requirement: After successful purchase, the app shall update the user interface to reflect unlocked access without requiring the user to restart the app.

### REQ-020 Purchase Failure Handling
- Priority: Must
- Requirement: If a purchase fails, is cancelled, or cannot be completed, the app shall inform the user and return them to a stable state without falsely granting access.

### REQ-021 Restore Purchases
- Priority: Must
- Requirement: The app shall provide a restore purchases action that allows previously entitled users to regain access on the same platform ecosystem where allowed by store rules.

### REQ-022 Restore Result Messaging
- Priority: Must
- Requirement: The app shall clearly communicate whether purchase restoration succeeded, found no purchase, or failed due to an operational error.

### REQ-023 Entitlement Persistence
- Priority: Must
- Requirement: The app shall persist purchase entitlement locally so that previously unlocked premium access remains available after app relaunch.

### REQ-024 Offline Entitlement Use
- Priority: Must
- Requirement: A user with an already recognized entitlement shall continue to access premium features when offline, subject to local entitlement availability.

### REQ-025 Paywall Exit
- Priority: Must
- Requirement: The user shall be able to dismiss the paywall without purchasing and return to the prior screen.

### REQ-026 Premium Education in Settings
- Priority: Should
- Requirement: Settings shall show the current premium status and provide actions relevant to that state, including purchase, restore, or entitlement confirmation.

### REQ-027 Purchase State Accuracy
- Priority: Must
- Requirement: The app shall not show premium-locked controls as available if the current entitlement state does not permit their use.

### REQ-028 Post-Purchase Welcome
- Priority: Should
- Requirement: After successful purchase, the app shall show a concise confirmation experience that highlights the newly unlocked workflows.

### REQ-029 Premium Access Scope
- Priority: Must
- Requirement: The lifetime purchase shall unlock all premium features included in the current product offering without requiring separate feature-by-feature transactions.

### REQ-030 Purchase Privacy
- Priority: Must
- Requirement: Purchase screens shall not require unnecessary personal information beyond what the platform store and RevenueCat flow require.

## 3. Recipe Library Foundations

### REQ-031 Recipe Library View
- Priority: Must
- Requirement: The app shall provide a primary recipe library where all saved recipes can be browsed.

### REQ-032 Structured Recipe Records
- Priority: Must
- Requirement: Each saved recipe shall be stored as a structured record rather than only as an unprocessed web clip or freeform note.

### REQ-033 Recipe Core Fields
- Priority: Must
- Requirement: A recipe record shall support at minimum a title, ingredients, instructions, servings or yield, and metadata needed for organization and search.

### REQ-034 Recipe Optional Fields
- Priority: Must
- Requirement: A recipe record shall support optional fields including source URL, notes, prep time, cook time, total time, nutrition values, image, collections, and tags or categories where applicable.

### REQ-035 Recipe Detail Screen
- Priority: Must
- Requirement: The app shall provide a detail view for each recipe showing the recipe’s structured content in a readable format.

### REQ-036 Recent Changes Reflection
- Priority: Must
- Requirement: When a recipe is created or edited, the updated version shall appear in the library and detail views without requiring manual refresh by the user.

### REQ-037 Duplicate Recipe Support
- Priority: Should
- Requirement: The app shall allow a recipe to be duplicated to create a new editable copy.

### REQ-038 Recipe Delete
- Priority: Must
- Requirement: The user shall be able to delete a recipe from the library.

### REQ-039 Delete Confirmation
- Priority: Must
- Requirement: Deleting a recipe shall require confirmation to reduce accidental permanent loss.

### REQ-040 Recipe Archive Alternative
- Priority: Could
- Requirement: The app may allow recipes to be archived or hidden from the primary library without permanent deletion.

### REQ-041 Favorite or Quick Access Marker
- Priority: Should
- Requirement: The app shall allow the user to mark a recipe for quick access, such as favorite, pinned, or similar priority designation.

### REQ-042 Metadata Timestamps
- Priority: Should
- Requirement: The app shall track created and last-updated timestamps for recipe records to support sorting and auditability.

## 4. AI Recipe Import from Any URL

### REQ-043 URL Import Entry Point
- Priority: Must
- Requirement: The app shall provide a clear action for importing a recipe from a URL.

### REQ-044 URL Paste Input
- Priority: Must
- Requirement: The import flow shall allow the user to paste or type a recipe page URL manually.

### REQ-045 OS Share Compatibility
- Priority: Should
- Requirement: The app should support receiving shared URLs from other mobile apps via the operating system share sheet where platform capabilities allow.

### REQ-046 Import Start Validation
- Priority: Must
- Requirement: Before starting import, the app shall validate that the input appears to be a usable URL and prompt the user to correct it if invalid.

### REQ-047 Import Progress Feedback
- Priority: Must
- Requirement: While an import is being processed, the app shall display progress or loading feedback so the user knows the action is in progress.

### REQ-048 AI-Assisted Extraction
- Priority: Must
- Requirement: The import workflow shall use AI-assisted parsing to extract structured recipe data from the source URL content when a recipe can be identified.

### REQ-049 Source Agnostic Import Goal
- Priority: Must
- Requirement: The import capability shall be designed to handle a wide variety of recipe websites rather than only a fixed approved domain list.

### REQ-050 Import Output Structure
- Priority: Must
- Requirement: The result of a successful import shall be a structured draft recipe containing extracted fields such as title, ingredients, instructions, and relevant metadata when available.

### REQ-051 Import Review Before Save
- Priority: Must
- Requirement: After extraction, the app shall allow the user to review the imported recipe before final save.

### REQ-052 Editable Import Draft
- Priority: Must
- Requirement: The user shall be able to edit any imported field before saving the recipe into their library.

### REQ-053 Source URL Retention
- Priority: Must
- Requirement: When a recipe is imported from a URL, the source URL shall be stored with the recipe unless the user removes it.

### REQ-054 Import Failure Messaging
- Priority: Must
- Requirement: If the app cannot extract a usable recipe from the URL, it shall inform the user that the import failed and explain available next steps.

### REQ-055 Manual Fallback from Import
- Priority: Must
- Requirement: After an import failure, the app shall provide a direct path to create the recipe manually rather than forcing the user to restart elsewhere.

### REQ-056 Partial Extraction Handling
- Priority: Must
- Requirement: If an import produces incomplete data, the app shall preserve extracted content and allow the user to fill in missing fields manually.

### REQ-057 Unsupported Content Handling
- Priority: Must
- Requirement: If a provided URL does not appear to contain recipe content, the app shall decline the import rather than saving unrelated page text as a recipe.

### REQ-058 Duplicate Detection Hint
- Priority: Should
- Requirement: The app should warn the user when the imported recipe appears to duplicate an existing recipe based on title, source URL, or similar heuristics.

### REQ-059 Duplicate Import Override
- Priority: Must
- Requirement: If a possible duplicate is detected, the user shall be able to continue saving the recipe anyway.

### REQ-060 Imported Field Normalization
- Priority: Must
- Requirement: The import flow shall normalize extracted recipe content into the app’s standard recipe structure so imported recipes behave like manually created recipes.

### REQ-061 Ingredient Parsing on Import
- Priority: Must
- Requirement: Imported ingredient lines shall be stored in a format that preserves the original text while also supporting downstream scaling and grocery list generation where feasible.

### REQ-062 Instruction Step Parsing on Import
- Priority: Must
- Requirement: When instructions can be segmented into steps, the app shall store them as ordered steps rather than only a single undifferentiated block of text.

### REQ-063 Time Metadata Extraction
- Priority: Should
- Requirement: When available in source content, the import flow should extract prep time, cook time, total time, and yield.

### REQ-064 Nutrition Extraction
- Priority: Should
- Requirement: When available in source content, the import flow should extract nutritional information into structured fields.

### REQ-065 Image Extraction
- Priority: Should
- Requirement: When available in source content, the import flow should extract a representative recipe image and attach it to the imported recipe.

### REQ-066 Import Save Confirmation
- Priority: Must
- Requirement: After saving an imported recipe, the app shall confirm success and provide a route to view, edit, plan, or cook the saved recipe.

### REQ-067 Premium Gating for Import
- Priority: Must
- Requirement: URL import shall honor the app’s premium entitlement rules and present purchase options when a non-entitled user attempts to use it.

## 5. Manual Recipe Creation and Editing

### REQ-068 Manual Creation Entry Point
- Priority: Must
- Requirement: The app shall provide an explicit action to create a recipe manually from scratch.

### REQ-069 Manual Recipe Draft
- Priority: Must
- Requirement: Manual recipe creation shall begin as an editable draft before it is committed to the recipe library.

### REQ-070 Required Field Validation
- Priority: Must
- Requirement: The app shall require the user to provide at least the minimum data needed to save a usable recipe, including a title and some recipe content.

### REQ-071 Ingredient Editing
- Priority: Must
- Requirement: The manual editor shall allow the user to add, edit, reorder, and remove ingredient entries.

### REQ-072 Instruction Editing
- Priority: Must
- Requirement: The manual editor shall allow the user to add, edit, reorder, and remove instruction steps.

### REQ-073 Single Step to Multi-Step Support
- Priority: Must
- Requirement: The manual editor shall support recipes with one instruction step or many ordered steps.

### REQ-074 Servings or Yield Entry
- Priority: Must
- Requirement: The manual editor shall allow the user to specify a recipe’s servings or yield in a structured way.

### REQ-075 Time Field Entry
- Priority: Should
- Requirement: The manual editor shall allow entry of prep time, cook time, and total time fields.

### REQ-076 Notes Entry
- Priority: Must
- Requirement: The manual editor shall allow the user to add freeform notes to a recipe.

### REQ-077 Source Attribution Entry
- Priority: Should
- Requirement: The manual editor shall allow the user to add or edit a source name and source URL for a recipe created manually.

### REQ-078 Category and Organization Metadata
- Priority: Must
- Requirement: The manual editor shall allow the user to assign organizational metadata such as collection, folder, or tags where supported by the library model.

### REQ-079 Inline Save
- Priority: Must
- Requirement: The user shall be able to save a recipe draft from the editor without leaving the editing flow first.

### REQ-080 Edit Existing Recipe
- Priority: Must
- Requirement: The app shall allow any existing recipe to be opened in edit mode and modified.

### REQ-081 Preserve Existing Data
- Priority: Must
- Requirement: Editing a recipe shall load the current saved values so the user can modify them without re-entering unchanged information.

### REQ-082 Cancel Editing
- Priority: Must
- Requirement: The user shall be able to cancel manual creation or editing and choose whether to discard changes.

### REQ-083 Ingredient Quantity Format Flexibility
- Priority: Must
- Requirement: The manual editor shall support ingredient quantities expressed as whole numbers, decimals, fractions, ranges, or freeform text when exact structured parsing is not practical.

### REQ-084 Ingredient Unit Support
- Priority: Must
- Requirement: The manual editor shall allow the user to enter ingredient units while also preserving original ingredient phrasing when needed.

### REQ-085 Ingredient Text Preservation
- Priority: Must
- Requirement: If the app parses a manual ingredient entry into structured components, it shall still preserve user-entered ingredient meaning without destructive rewriting.

### REQ-086 Optional Ingredient Grouping
- Priority: Should
- Requirement: The manual editor should support grouping ingredients under headers such as sauce, filling, or topping.

### REQ-087 Optional Instruction Headings
- Priority: Could
- Requirement: The manual editor may support headings or section labels within instructions for complex recipes.

### REQ-088 Draft Recovery
- Priority: Should
- Requirement: If editing is interrupted unexpectedly, the app should recover unsaved draft content when feasible and offer the user a chance to continue editing.

### REQ-089 Recipe Save Success Feedback
- Priority: Must
- Requirement: When a manual recipe is saved successfully, the app shall provide visible confirmation.

### REQ-090 New Recipe Post-Save Actions
- Priority: Should
- Requirement: After saving a new manual recipe, the app should present relevant next actions such as add photo, assign collection, plan meal, or start cooking mode.

## 6. Recipe Search, Filter, Sort, and Browse

### REQ-091 Library Search
- Priority: Must
- Requirement: The recipe library shall support text search across saved recipes.

### REQ-092 Search Targets
- Priority: Must
- Requirement: Search shall match relevant recipe fields including title and should also consider ingredients, notes, and organizational metadata where available.

### REQ-093 Partial Match Search
- Priority: Must
- Requirement: Search shall support partial text matching so users do not need exact titles.

### REQ-094 Search Result Update
- Priority: Must
- Requirement: Search results shall update as the user submits or refines the query.

### REQ-095 Empty Search Feedback
- Priority: Must
- Requirement: If no recipes match the current query, the app shall state that no results were found and offer a clear way to clear filters or create a recipe.

### REQ-096 Filter by Collection
- Priority: Must
- Requirement: The recipe library shall support filtering recipes by collection or folder membership.

### REQ-097 Filter by Meal Type or Category
- Priority: Should
- Requirement: The app should support filtering by user-defined or product-defined categories such as breakfast, dinner, dessert, or similar labels where such metadata exists.

### REQ-098 Filter by Favorites
- Priority: Should
- Requirement: The app should support filtering recipes to favorites or quick-access recipes.

### REQ-099 Filter by Nutrition Availability
- Priority: Could
- Requirement: The app may support filtering recipes based on whether nutrition information is available.

### REQ-100 Filter by Photo Availability
- Priority: Could
- Requirement: The app may support filtering recipes based on whether the recipe has an image.

### REQ-101 Sort Options
- Priority: Must
- Requirement: The recipe library shall support sorting by at least alphabetic order and recently updated or recently added.

### REQ-102 Additional Sort Options
- Priority: Should
- Requirement: The app should support additional sorts such as recently cooked, cook time, or manually selected priority when the necessary metadata exists.

### REQ-103 Search and Filter Combination
- Priority: Must
- Requirement: The app shall allow search terms and active filters to work together rather than forcing the user to use only one at a time.

### REQ-104 Active Filter Visibility
- Priority: Must
- Requirement: The current active filters shall be visible to the user and removable individually or all at once.

### REQ-105 Search Persistence in Session
- Priority: Should
- Requirement: While the user remains in the library context, the app should preserve the current search and filter state until the user clears it or navigates away intentionally.

### REQ-106 Browse Without Query
- Priority: Must
- Requirement: The library shall remain fully browsable without requiring the user to search first.

### REQ-107 Result Navigation
- Priority: Must
- Requirement: From search or filtered results, the user shall be able to open a recipe detail and return to the same results context.

## 7. Collections and Folders

### REQ-108 Collection Model
- Priority: Must
- Requirement: The app shall allow the user to organize recipes into collections, folders, or an equivalent user-managed grouping model.

### REQ-109 Create Collection
- Priority: Must
- Requirement: The user shall be able to create a new collection or folder.

### REQ-110 Rename Collection
- Priority: Must
- Requirement: The user shall be able to rename an existing collection or folder.

### REQ-111 Delete Collection
- Priority: Must
- Requirement: The user shall be able to delete a collection or folder.

### REQ-112 Collection Delete Safety
- Priority: Must
- Requirement: Deleting a collection shall not delete the recipes assigned to it unless the user explicitly chooses a destructive recipe deletion action.

### REQ-113 Assign Recipe to Collection
- Priority: Must
- Requirement: The user shall be able to assign a recipe to one or more collections or folders if the organizational model permits multiple membership.

### REQ-114 Remove Recipe from Collection
- Priority: Must
- Requirement: The user shall be able to remove a recipe from a collection without deleting the recipe itself.

### REQ-115 Collection Browse
- Priority: Must
- Requirement: The user shall be able to open a collection and browse only the recipes assigned to it.

### REQ-116 Collection Counts
- Priority: Should
- Requirement: The app should show recipe counts for collections to help users understand their organization structure.

### REQ-117 Collection Selection During Save
- Priority: Should
- Requirement: The recipe create and edit flows should allow collection assignment without requiring the user to leave the editor.

### REQ-118 Nested Folders Support
- Priority: Could
- Requirement: The app may support nested folder hierarchies if the chosen organization model includes folders rather than flat collections only.

### REQ-119 Reorder Collections
- Priority: Could
- Requirement: The user may be allowed to reorder top-level collections for personal preference.

### REQ-120 Collection Empty State
- Priority: Must
- Requirement: Empty collections shall display guidance for adding recipes into them.

## 8. Recipe Photos and Image Capture

### REQ-121 Recipe Image Attachment
- Priority: Must
- Requirement: A recipe shall support an attached photo or primary image.

### REQ-122 Photo Capture
- Priority: Must
- Requirement: The app shall allow the user to capture a photo with the device camera and attach it to a recipe.

### REQ-123 Photo Selection from Device
- Priority: Should
- Requirement: The app should allow the user to choose an existing image from the device photo library and attach it to a recipe.

### REQ-124 Image Add During Creation
- Priority: Must
- Requirement: The manual recipe editor shall allow the user to add an image during creation or later editing.

### REQ-125 Image Replace
- Priority: Must
- Requirement: The user shall be able to replace an existing recipe image.

### REQ-126 Image Remove
- Priority: Must
- Requirement: The user shall be able to remove a recipe image without deleting the recipe.

### REQ-127 Imported Image Review
- Priority: Should
- Requirement: If a recipe import includes an image, the user should be able to keep, replace, or remove that image before or after save.

### REQ-128 Camera Permission Request
- Priority: Must
- Requirement: The app shall request device camera permission only when needed for photo capture.

### REQ-129 Camera Permission Failure Handling
- Priority: Must
- Requirement: If camera access is denied or unavailable, the app shall explain the issue and allow the user to continue without taking a photo.

### REQ-130 Image Display in Library
- Priority: Should
- Requirement: The library should display recipe imagery where present to improve recognition and browsing.

### REQ-131 Image Display in Detail View
- Priority: Must
- Requirement: The recipe detail screen shall display the recipe’s primary image when one exists.

### REQ-132 Image Persistence
- Priority: Must
- Requirement: Attached recipe images shall remain associated with the recipe across app relaunches.

## 9. Nutritional Information

### REQ-133 Nutrition Field Support
- Priority: Must
- Requirement: A recipe shall support structured nutrition fields, including at minimum calories when nutrition data is available.

### REQ-134 Additional Nutrition Fields
- Priority: Should
- Requirement: The nutrition model should support common additional values such as protein, fat, carbohydrates, fiber, sugar, sodium, and serving size when available.

### REQ-135 Nutrition Import Retention
- Priority: Must
- Requirement: If nutrition information is extracted during import, the app shall retain it within the saved recipe.

### REQ-136 Manual Nutrition Entry
- Priority: Must
- Requirement: The manual editor shall allow the user to enter or modify nutrition information.

### REQ-137 Nutrition Optionality
- Priority: Must
- Requirement: A recipe shall remain valid and usable even if no nutrition information is provided.

### REQ-138 Nutrition Display
- Priority: Must
- Requirement: The recipe detail view shall display nutrition information when it exists.

### REQ-139 Nutrition Serving Context
- Priority: Must
- Requirement: When nutrition information is shown, the app shall indicate the serving basis if that information is known.

### REQ-140 Nutrition Editability
- Priority: Must
- Requirement: Nutrition values stored with a recipe shall be editable by the user.

### REQ-141 Imported Nutrition Review
- Priority: Should
- Requirement: The import review flow should allow the user to inspect and edit imported nutrition values before saving.

### REQ-142 Nutrition Searchability
- Priority: Could
- Requirement: The app may support search or filter behaviors that include nutrition-related attributes where such metadata is structured.

## 10. Ingredient Scaling and Yield Adjustment

### REQ-143 Recipe Scaling Control
- Priority: Must
- Requirement: The recipe detail view shall allow the user to scale ingredient quantities relative to the recipe’s base servings or yield.

### REQ-144 Display of Base Yield
- Priority: Must
- Requirement: The app shall display the recipe’s original servings or yield so the user understands the baseline from which scaling occurs.

### REQ-145 Increase and Decrease Scaling
- Priority: Must
- Requirement: The user shall be able to increase or decrease recipe yield to a desired target amount.

### REQ-146 Scaled Ingredient Update
- Priority: Must
- Requirement: When scaling is applied, ingredient quantities shall update accordingly wherever those quantities can be interpreted.

### REQ-147 Unscalable Ingredient Preservation
- Priority: Must
- Requirement: If a quantity cannot be safely scaled because it is ambiguous or purely textual, the app shall preserve the original ingredient text rather than generating misleading output.

### REQ-148 Fraction-Friendly Display
- Priority: Should
- Requirement: Scaled quantities should be displayed in a user-friendly format appropriate for cooking, including common fractions when suitable.

### REQ-149 Scale Reset
- Priority: Must
- Requirement: The user shall be able to return the recipe to its original base servings or yield after scaling.

### REQ-150 Scaling in Grocery Generation
- Priority: Must
- Requirement: If a meal plan or grocery list is generated from a scaled recipe instance, the ingredient quantities used for grocery generation shall reflect the selected scaled amount.

### REQ-151 Scaling Persistence by Context
- Priority: Should
- Requirement: The app should distinguish between temporarily scaling a recipe for viewing and intentionally planning a specific scaled amount for a scheduled meal.

### REQ-152 Recipe Integrity After Scaling
- Priority: Must
- Requirement: Temporary viewing-scale changes shall not permanently overwrite the recipe’s base ingredient quantities unless the user explicitly edits and saves the recipe.

## 11. Weekly Meal Planning

### REQ-153 Meal Plan Calendar View
- Priority: Must
- Requirement: The app shall provide a weekly meal planning view that allows the user to see and manage meals across a week.

### REQ-154 Week Navigation
- Priority: Must
- Requirement: The meal planning view shall allow the user to move to previous and future weeks.

### REQ-155 Day-Level Planning
- Priority: Must
- Requirement: The user shall be able to assign recipes to specific days within the selected week.

### REQ-156 Meal Slot Support
- Priority: Should
- Requirement: The planner should support assigning recipes to meal slots such as breakfast, lunch, dinner, or custom slots where the planning model includes them.

### REQ-157 Add Recipe to Plan
- Priority: Must
- Requirement: The user shall be able to add an existing saved recipe to the meal plan from the planner or from the recipe detail screen.

### REQ-158 Remove Planned Meal
- Priority: Must
- Requirement: The user shall be able to remove a scheduled recipe from the meal plan.

### REQ-159 Edit Planned Meal
- Priority: Must
- Requirement: The user shall be able to replace or reschedule an existing planned meal entry.

### REQ-160 Multiple Meals per Day
- Priority: Must
- Requirement: The planner shall support more than one meal entry on the same day when the user schedules multiple recipes or multiple meal slots.

### REQ-161 Planned Quantity or Servings
- Priority: Must
- Requirement: A planned meal entry shall support a servings or scale context so grocery generation can reflect the intended quantity for that scheduled cook.

### REQ-162 Planner Visibility of Recipe Summary
- Priority: Should
- Requirement: Planned meals should show enough recipe identity information, such as title and optionally image, to be recognizable at a glance.

### REQ-163 Open Recipe from Plan
- Priority: Must
- Requirement: The user shall be able to open the recipe detail directly from a planned meal entry.

### REQ-164 Add Meal from Recipe Search
- Priority: Should
- Requirement: When assigning a recipe to the meal plan, the user should be able to search or filter the recipe library rather than scrolling a long list only.

### REQ-165 Planner Empty State
- Priority: Must
- Requirement: If a week has no planned meals, the planner shall display guidance for adding recipes.

### REQ-166 Copy or Repeat Meal Entries
- Priority: Should
- Requirement: The planner should allow the user to copy or repeat a meal entry to another day or week to reduce repetitive scheduling.

### REQ-167 Week-Level Summary
- Priority: Should
- Requirement: The planner should provide a concise summary of how many meals are scheduled in the current week.

### REQ-168 Planner Save Behavior
- Priority: Must
- Requirement: Changes to planned meals shall be saved so that the week view is restored accurately after app relaunch.

### REQ-169 Unscheduled Recipes Remain Independent
- Priority: Must
- Requirement: Adding a recipe to the library shall not automatically add it to the meal plan unless the user explicitly schedules it.

### REQ-170 Planned Meal Source Tracking
- Priority: Must
- Requirement: Each planned meal entry shall remain linked to the underlying recipe so future grocery generation and recipe access use the correct recipe data.

### REQ-171 Delete Recipe Impact on Plan
- Priority: Must
- Requirement: If a recipe that is used in the meal plan is deleted, the app shall warn the user and define how the affected planned entries will be handled before completing deletion.

### REQ-172 Planned Meal Notes
- Priority: Could
- Requirement: The planner may support optional notes on a planned meal entry, such as leftovers, prep reminder, or guest count context.

## 12. Smart Grocery List Generation and Management

### REQ-173 Grocery List View
- Priority: Must
- Requirement: The app shall provide a grocery list area where shopping items can be reviewed and managed.

### REQ-174 Generate from Meal Plan
- Priority: Must
- Requirement: The app shall be able to generate grocery items automatically from recipes scheduled in the meal plan.

### REQ-175 User-Controlled Generation
- Priority: Must
- Requirement: Grocery generation from the meal plan shall be user-initiated or clearly user-confirmed, rather than occurring invisibly in a way that obscures what changed.

### REQ-176 Date Scope for Generation
- Priority: Must
- Requirement: The app shall allow grocery generation for a defined planning scope, such as the current week or a selected date range tied to planned meals.

### REQ-177 Ingredient Inclusion
- Priority: Must
- Requirement: Grocery generation shall include ingredients required by the selected planned meals.

### REQ-178 Scaled Quantity Inclusion
- Priority: Must
- Requirement: Grocery generation shall use the planned recipe’s servings or scale context when determining ingredient quantities.

### REQ-179 Ingredient Consolidation
- Priority: Must
- Requirement: The app shall consolidate overlapping grocery items where ingredients from multiple planned meals can reasonably be combined.

### REQ-180 Preserve Traceability
- Priority: Must
- Requirement: Even when grocery items are consolidated, the app shall preserve traceability back to the recipes or planned meals that contributed those items.

### REQ-181 Manual Grocery Add
- Priority: Must
- Requirement: The grocery list shall allow users to add items manually that are not generated from planned recipes.

### REQ-182 Manual Grocery Edit
- Priority: Must
- Requirement: The user shall be able to edit grocery item name, quantity, note, and related list fields as supported by the item model.

### REQ-183 Manual Grocery Delete
- Priority: Must
- Requirement: The user shall be able to remove grocery items from the list.

### REQ-184 Mark Item Complete
- Priority: Must
- Requirement: The user shall be able to mark grocery items as acquired or completed while shopping.

### REQ-185 Unmark Item Complete
- Priority: Must
- Requirement: The user shall be able to unmark a previously completed grocery item.

### REQ-186 Completed Item Presentation
- Priority: Must
- Requirement: The grocery list shall visually distinguish completed items from remaining items.

### REQ-187 Keep Generated and Manual Items Together
- Priority: Must
- Requirement: The grocery list shall allow generated items and manually added items to coexist in the same actionable shopping workflow.

### REQ-188 Regeneration with User Control
- Priority: Must
- Requirement: If the user regenerates grocery items from the meal plan, the app shall prevent accidental destruction of manual edits by clearly communicating how regenerated data will be merged, replaced, or updated.

### REQ-189 Incremental Regeneration
- Priority: Should
- Requirement: The grocery generation workflow should support adding missing items from newly planned meals without forcing a full list reset.

### REQ-190 Source-Aware Grocery Review
- Priority: Should
- Requirement: The user should be able to inspect which recipe or planned meal contributed a grocery item.

### REQ-191 Grocery Item Notes
- Priority: Should
- Requirement: Grocery items should support notes such as brand preference, substitution reminder, or store-specific detail.

### REQ-192 Grocery Categorization
- Priority: Should
- Requirement: The app should support organizing grocery items into shopping categories such as produce, dairy, pantry, frozen, or uncategorized where feasible.

### REQ-193 Grocery Sort and Group
- Priority: Should
- Requirement: The user should be able to view grocery items grouped or sorted in a way that supports efficient shopping.

### REQ-194 Grocery Search
- Priority: Could
- Requirement: The grocery list may support search within current items for large shopping lists.

### REQ-195 Grocery Clear Completed
- Priority: Must
- Requirement: The user shall be able to clear completed grocery items without deleting the remaining active items.

### REQ-196 Grocery Clear All
- Priority: Must
- Requirement: The user shall be able to clear the entire grocery list with confirmation.

### REQ-197 Grocery Empty State
- Priority: Must
- Requirement: If the grocery list has no items, the app shall explain how to generate items from the meal plan or add them manually.

### REQ-198 Grocery Manual Quantity Adjustment
- Priority: Must
- Requirement: The user shall be able to manually adjust generated grocery quantities if household inventory or shopping preference requires modification.

### REQ-199 Grocery Item Merge Safety
- Priority: Must
- Requirement: When consolidation is ambiguous, the app shall prefer preserving separate grocery items over incorrectly merging distinct ingredients.

### REQ-200 Grocery Units Preservation
- Priority: Must
- Requirement: Grocery items shall preserve useful unit context from recipe ingredients where doing so helps the user shop accurately.

### REQ-201 Grocery Regeneration After Meal Removal
- Priority: Must
- Requirement: If planned meals are removed after grocery generation, the app shall provide a way to refresh the grocery list so it reflects the updated plan.

### REQ-202 Grocery Direct Add from Recipe
- Priority: Should
- Requirement: The app should allow the user to add ingredients from an individual recipe to the grocery list even outside the full meal plan generation flow.

### REQ-203 Grocery State Persistence
- Priority: Must
- Requirement: Grocery item completion state and manual edits shall persist across app relaunches.

### REQ-204 Grocery Premium Gating
- Priority: Must
- Requirement: Automatic grocery generation from the meal plan shall honor premium entitlement rules.

## 13. Cooking Mode and Timers

### REQ-205 Cooking Mode Entry
- Priority: Must
- Requirement: A recipe shall provide a dedicated cooking mode optimized for step-by-step use while actively cooking.

### REQ-206 Cooking Mode Step Presentation
- Priority: Must
- Requirement: Cooking mode shall present recipe instructions as ordered steps with clear separation between them.

### REQ-207 Current Step Focus
- Priority: Must
- Requirement: Cooking mode shall emphasize the current instruction step so the user can focus on one action at a time.

### REQ-208 Step Navigation
- Priority: Must
- Requirement: The user shall be able to move forward and backward through instruction steps in cooking mode.

### REQ-209 Full Recipe Access from Cooking Mode
- Priority: Must
- Requirement: While in cooking mode, the user shall still be able to access ingredient information and relevant recipe context without losing their place.

### REQ-210 Keep Screen Awake
- Priority: Must
- Requirement: Cooking mode shall keep the screen awake while active, subject to platform limitations and user permissions.

### REQ-211 Scaled Ingredient Visibility in Cooking Mode
- Priority: Must
- Requirement: If the recipe is being viewed at a scaled yield, cooking mode shall reflect the same scaled ingredient quantities.

### REQ-212 Timer Detection Support
- Priority: Must
- Requirement: Cooking mode shall support launching timers associated with steps when the step contains a time-based action or the user adds one explicitly.

### REQ-213 Manual Timer Launch
- Priority: Must
- Requirement: The user shall be able to start a timer from within cooking mode without leaving the recipe.

### REQ-214 Multiple Concurrent Timers
- Priority: Should
- Requirement: The app should support multiple active cooking timers at the same time.

### REQ-215 Timer Labeling
- Priority: Should
- Requirement: Timers should display a label tied to the recipe step or a user-provided description so the user knows what the timer is for.

### REQ-216 Timer Completion Alert
- Priority: Must
- Requirement: When a cooking timer completes, the app shall notify the user with an in-app alert and any allowed local notification behavior.

### REQ-217 Timer Management
- Priority: Must
- Requirement: The user shall be able to view active timers and cancel or stop them.

### REQ-218 Timer Persistence Across Navigation
- Priority: Must
- Requirement: An active timer shall continue running if the user leaves the current recipe screen or temporarily backgrounds the app, subject to platform limits.

### REQ-219 Cooking Mode Exit
- Priority: Must
- Requirement: The user shall be able to exit cooking mode and return to the standard recipe view.

### REQ-220 Cooking Completion Context
- Priority: Could
- Requirement: The app may allow the user to mark a recipe as cooked or recently cooked upon completing a cooking session.

### REQ-221 Step Progress Retention in Session
- Priority: Should
- Requirement: If the user leaves cooking mode temporarily during an active session, the app should restore them to the current step when they return.

### REQ-222 Cooking Mode Premium Gating
- Priority: Must
- Requirement: Cooking mode and its timer workflow shall honor premium entitlement rules if designated premium.

## 14. Dark Mode and Appearance

### REQ-223 Dark Mode Support
- Priority: Must
- Requirement: The app shall support a dark appearance theme across primary screens and workflows.

### REQ-224 Light Mode Support
- Priority: Must
- Requirement: The app shall support a light appearance theme across primary screens and workflows.

### REQ-225 System Theme Follow
- Priority: Must
- Requirement: The app shall be able to follow the device system appearance setting automatically.

### REQ-226 Manual Theme Override
- Priority: Must
- Requirement: The user shall be able to choose light mode, dark mode, or system default from app settings.

### REQ-227 Theme Persistence
- Priority: Must
- Requirement: The selected appearance preference shall persist across app relaunches.

### REQ-228 Theme Consistency
- Priority: Must
- Requirement: Theme changes shall apply consistently to major surfaces including recipe library, recipe detail, planner, grocery list, cooking mode, paywall, and settings.

### REQ-229 Theme Transition Safety
- Priority: Should
- Requirement: Switching theme shall not cause loss of navigation state, edits, or active timers.

### REQ-230 Dark Mode Asset Handling
- Priority: Should
- Requirement: Images, icons, overlays, and contrast-dependent UI states should remain usable in dark mode without obscuring recipe content.

## 15. Settings, Help, and Product Controls

### REQ-231 Settings Screen
- Priority: Must
- Requirement: The app shall provide a settings area containing controls needed to manage purchase state, appearance, and feature-related preferences.

### REQ-232 Appearance Settings
- Priority: Must
- Requirement: Settings shall include the user’s appearance selection controls.

### REQ-233 Purchase Settings
- Priority: Must
- Requirement: Settings shall include purchase status visibility and the ability to restore purchases.

### REQ-234 Help for Import Limitations
- Priority: Should
- Requirement: The app should provide contextual help explaining that imported recipes may require review or manual correction.

### REQ-235 Help for Grocery Generation
- Priority: Should
- Requirement: The app should provide guidance explaining how grocery items are generated from planned meals and how manual edits interact with regeneration.

### REQ-236 Permission Education
- Priority: Must
- Requirement: When the app requests camera or notification permissions for feature use, it shall explain why the permission improves the workflow.

### REQ-237 Notification Preference for Timers
- Priority: Should
- Requirement: If the app uses local notifications for timer completion, settings should allow the user to understand and manage that behavior within the limits provided by the operating system.

### REQ-238 Feature Discovery Links
- Priority: Could
- Requirement: Settings or help surfaces may include links to revisit feature education for recipe import, meal planning, grocery generation, and cooking mode.

## 16. Cross-Cutting Functional Integrity

### REQ-239 Library Consistency Across Features
- Priority: Must
- Requirement: Recipes created, imported, edited, organized, planned, or cooked shall always refer back to the same underlying recipe record unless the user explicitly duplicates the recipe.

### REQ-240 Cross-Feature Recipe Actions
- Priority: Must
- Requirement: From a recipe detail screen, the app shall support adjacent actions relevant to that recipe, including edit, assign collection, plan meal, start cooking mode, and where supported add ingredients to grocery workflows.

### REQ-241 Data Use of Deleted Recipes
- Priority: Must
- Requirement: If a recipe is deleted, the app shall prevent orphaned or misleading references in connected workflows such as meal planning and grocery traceability.

### REQ-242 Graceful Handling of Missing Optional Data
- Priority: Must
- Requirement: The app shall gracefully handle recipes that are missing optional fields such as image, nutrition, time data, or source URL without breaking core usage.

### REQ-243 Structured Ingredient Reuse
- Priority: Must
- Requirement: Ingredient information stored for a recipe shall be usable by both recipe display and grocery generation workflows without requiring duplicate user entry.

### REQ-244 Structured Instruction Reuse
- Priority: Must
- Requirement: Instruction steps stored for a recipe shall be reusable by both standard recipe detail view and cooking mode.

### REQ-245 Save Reliability in User Flow
- Priority: Must
- Requirement: After the user saves a change in one feature area, the updated state shall be visible in dependent feature areas the next time they are opened.

### REQ-246 Error Recovery Paths
- Priority: Must
- Requirement: When a feature operation fails, such as import, purchase, or grocery regeneration, the app shall provide a recovery path rather than leaving the user at a dead end.

### REQ-247 Non-Destructive Defaults
- Priority: Must
- Requirement: When the app must choose between preserving user data and discarding it during ambiguous operations, it shall default toward preserving user data and asking for confirmation before destructive loss.

### REQ-248 Mobile Context Suitability
- Priority: Must
- Requirement: Feature flows shall support mobile-native usage contexts including quick capture, one-handed review where feasible, and interruption-resilient task completion.

### REQ-249 Clear User-Controlled State Changes
- Priority: Must
- Requirement: Significant state changes such as deleting recipes, clearing grocery items, replacing collections, or overwriting regenerated list content shall require clear user intent.

### REQ-250 Offline Use of Existing Content
- Priority: Must
- Requirement: The user shall be able to browse previously saved recipes, existing meal plans, and existing grocery lists without network access after that data is already stored locally.

## Traceability Matrix by Feature Area

| Feature Area | Requirement Range |
| --- | --- |
| App access and shell | `REQ-001` to `REQ-012` |
| Purchase and premium access | `REQ-013` to `REQ-030` |
| Recipe library foundations | `REQ-031` to `REQ-042` |
| AI recipe import | `REQ-043` to `REQ-067` |
| Manual recipe creation and editing | `REQ-068` to `REQ-090` |
| Search, filter, sort, browse | `REQ-091` to `REQ-107` |
| Collections and folders | `REQ-108` to `REQ-120` |
| Photos and image capture | `REQ-121` to `REQ-132` |
| Nutritional information | `REQ-133` to `REQ-142` |
| Scaling and yield adjustment | `REQ-143` to `REQ-152` |
| Weekly meal planning | `REQ-153` to `REQ-172` |
| Grocery generation and shopping workflow | `REQ-173` to `REQ-204` |
| Cooking mode and timers | `REQ-205` to `REQ-222` |
| Dark mode and appearance | `REQ-223` to `REQ-230` |
| Settings and product controls | `REQ-231` to `REQ-238` |
| Cross-cutting integrity | `REQ-239` to `REQ-250` |

## Requirement Coverage Notes

- Recipe import is covered by `REQ-043` to `REQ-067`.
- Manual recipe creation is covered by `REQ-068` to `REQ-090`.
- Meal planning is covered by `REQ-153` to `REQ-172`.
- Smart grocery list generation is covered by `REQ-173` to `REQ-204`.
- Recipe search and filtering are covered by `REQ-091` to `REQ-107`.
- Cooking mode and timers are covered by `REQ-205` to `REQ-222`.
- Recipe scaling is covered by `REQ-143` to `REQ-152`.
- Nutritional information is covered by `REQ-133` to `REQ-142`.
- Photo capture is covered by `REQ-121` to `REQ-132`.
- Collections and folders are covered by `REQ-108` to `REQ-120`.
- Dark mode is covered by `REQ-223` to `REQ-230`.
- In-app purchase and entitlement behavior are covered by `REQ-013` to `REQ-030`.

## End of Document
