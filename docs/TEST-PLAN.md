# ChefStash Test Plan

**Document:** TEST-PLAN.md  

## 1. Strategy
The primary risk is the HTML parser failing on poorly formatted websites. Testing must focus on the robustness of the extraction engine.

## 2. Testing Tiers
- **Unit Tests:** Feed 50 different raw HTML strings from popular recipe sites (NYT Cooking, Bon Appetit, AllRecipes) into the JS parser and assert the resulting JSON matches the expected `schema.org/Recipe` object.
- **Integration Tests:** Ensure `expo-file-system` correctly downloads and compresses the image URL extracted from the parser.
- **E2E Tests:** Paste a URL, verify extraction, enter Cooking Mode, and verify the screen does not sleep.