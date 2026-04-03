# ChefStash Detailed Test Cases

**Document:** TEST-CASES.md  

## 1. Recipe Extraction (TC-100)
### TC-101: Standard Schema.org Extraction
1. Tap '+'. Paste the URL for a standard AllRecipes page.
2. Tap "Extract Recipe".
3. **Expected:** Within 2 seconds, the recipe is saved. The title, cover image, and lists of ingredients/instructions are perfectly separated without any blog text or ads.

### TC-102: Fallback Manual Entry
1. Paste a URL to a site that does not use schema.org JSON-LD.
2. **Expected:** The app gracefully fails with "Recipe format not found" and opens the manual entry form, optionally pre-filling the title from the page's `<title>` tag.

## 2. Cooking Mode (TC-200)
### TC-201: Screen Keep-Awake
1. Open a saved recipe and tap "Enter Cooking Mode".
2. Leave the device untouched for 10 minutes (assuming OS auto-lock is set to 1 minute).
3. **Expected:** The screen remains awake and bright.

### TC-202: Ingredient Strikeout
1. In Cooking Mode, tap the ingredient "2 cups flour".
2. **Expected:** The text visually strikes out and dims, helping the user keep their place.

## 3. Recipe Extraction — Extended (TC-100 continued)
### TC-103: Schema.org Extraction — Speed Verification
1. Tap '+'. Paste a URL to a standard AllRecipes or Serious Eats page with full `schema.org/Recipe` JSON-LD.
2. Tap "Extract Recipe".
3. **Expected:** Within 2 seconds, the recipe is saved. Title, ingredients list, and step-by-step instructions are correctly extracted and separated. No blog prose, ads, or life-story paragraphs included.

### TC-104: URL Without Schema.org Data — Fallback
1. Tap '+'. Paste a URL to a food blog that does not use `schema.org/Recipe` JSON-LD (e.g., a simple WordPress post with no structured data).
2. Tap "Extract Recipe".
3. **Expected:** The app shows "Recipe format not found" and opens the manual entry form. The URL field is pre-filled with the pasted URL. The title field may be pre-filled from the page's `<title>` tag.

### TC-105: Invalid URL — Error Handling
1. Tap '+'. Paste an invalid string that is not a valid webpage URL (e.g., "not-a-url", "ftp://random", or a URL to a PDF file).
2. Tap "Extract Recipe".
3. **Expected:** The app displays the error message "Couldn't reach this URL" within a few seconds. No crash, no partial save. The user can edit the URL or switch to manual entry.

### TC-106: Manual Recipe Entry — No URL
1. Tap '+'. Skip the URL field entirely. Tap "Enter Manually".
2. Fill in Title ("Grandma's Pasta"), Ingredients (list of 5 items), and Instructions (3 steps).
3. Tap "Save".
4. **Expected:** The recipe is saved and appears on the dashboard with the title "Grandma's Pasta". A default placeholder image is used. All ingredients and instructions are stored correctly.

## 4. Cooking Mode — Extended (TC-200 continued)
### TC-107: Cooking Mode — Screen Awake and Large Typography
1. Open a saved recipe. Tap "Enter Cooking Mode".
2. Observe the screen layout. Leave the device untouched for 5 minutes.
3. **Expected:** Typography is significantly enlarged for readability at arm's length. The screen remains on and does not dim or auto-lock, regardless of OS sleep settings.

### TC-108: Cooking Mode — Ingredient Strikeout Toggle
1. Enter Cooking Mode for a recipe with 6 ingredients.
2. Tap the 3rd ingredient to strike it out. Tap it again.
3. **Expected:** First tap: the ingredient text shows a visual strikethrough and dims. Second tap: the strikethrough is removed and the ingredient returns to normal appearance.

## 5. Recipe Organization (TC-300)
### TC-109: Custom Tag — Save and Display
1. Open a saved recipe. Tap "Add Tag". Type "Italian". Tap "Save".
2. Return to the dashboard.
3. **Expected:** The recipe now displays the "Italian" tag. The tag is persisted across app restarts.

### TC-110: Search by Title Keyword
1. Save 3 recipes: "Spaghetti Carbonara", "Chicken Tikka Masala", "Spaghetti Bolognese".
2. Tap the search bar. Type "Spaghetti".
3. **Expected:** Results show "Spaghetti Carbonara" and "Spaghetti Bolognese". "Chicken Tikka Masala" is not shown.

### TC-111: Filter by Tag
1. Tag 2 recipes with "Italian" and 1 recipe with "Indian".
2. Tap the tag filter and select "Italian".
3. **Expected:** Only the 2 recipes tagged "Italian" are displayed. The "Indian" recipe is hidden.

## 6. Premium Gating (TC-400)
### TC-112: Premium Gate — 11th Recipe on Free Tier
1. As a free-tier user, save 10 recipes successfully.
2. Tap '+' and attempt to save an 11th recipe (via URL or manual entry).
3. **Expected:** The Premium paywall modal appears, explaining that saving more than 10 recipes requires Premium ($19.99). The 11th recipe is not saved.

### TC-113: Premium Gate — Custom Tag on Free Tier
1. As a free-tier user, open a saved recipe. Tap "Add Tag".
2. **Expected:** The Premium paywall modal appears, explaining that custom tagging requires Premium. The tag is not created.

## 7. Data Management (TC-500)
### TC-114: Delete Recipe
1. Open a saved recipe. Tap "Delete". Confirm the deletion prompt.
2. Return to the dashboard.
3. **Expected:** The recipe is removed from the dashboard grid. The associated image file is deleted from local storage. Storage space is freed.

### TC-115: Export Recipes as JSON
1. Save 5 recipes, some with tags.
2. Navigate to Settings > "Export Recipes". Tap "Export".
3. **Expected:** A JSON file is generated and the share sheet appears. The JSON contains all 5 recipes with their titles, ingredients, instructions, image references, and tags.

### TC-116: Import JSON Backup
1. Export recipes as JSON (TC-115). Delete all recipes from the app.
2. Navigate to Settings > "Import Recipes". Select the previously exported JSON file.
3. **Expected:** All recipes are restored with correct titles, ingredients, instructions, and tags. The dashboard shows all imported recipes.

### TC-117: Offline Mode — Saved Recipes and Cooking Mode
1. Save 3 recipes while online.
2. Enable Airplane Mode on the device.
3. Open the app. Browse saved recipes. Open one and enter Cooking Mode.
4. **Expected:** All saved recipes load normally. Recipe details (title, ingredients, instructions, saved images) display correctly. Cooking Mode works fully (screen awake, strikeout, large text). No error messages about connectivity.

### TC-118: URL Fetch Timeout
1. Tap '+'. Paste a valid URL. Before tapping "Extract Recipe", enable Airplane Mode or ensure the URL points to an extremely slow server.
2. Tap "Extract Recipe".
3. **Expected:** A loading indicator appears. After approximately 10 seconds, a timeout error message is displayed (e.g., "Request timed out. Check your connection."). No crash. The user can retry or switch to manual entry.