# ChefStash UI/UX Specification

**Document:** UI-UX-SPEC.md  
**Product:** ChefStash  

## 1. Design Philosophy
- **Brutalist Utility:** Food blogs are visually overwhelming. ChefStash is the antidote. The UI should be extremely clean, borderless, and rely heavily on typography rather than colorful UI elements.
- **Kitchen-Friendly:** Buttons in Cooking Mode must be massive. Users often tap screens with a knuckle when their hands are covered in dough.

## 2. Color Palette
- **Background:** `#FFFFFF` (Pure white for maximum contrast).
- **Primary:** `#2C3E50` (Dark slate for headings and major buttons).
- **Accent:** `#E67E22` (Warm orange for Cooking Mode actions).

## 3. Screens (Vibecodable)
1. **The Vault (Home):** A clean masonry grid of recipe thumbnails. A prominent search bar. A floating action button with a '+' icon to add a URL.
2. **Add Recipe Modal:** A simple text input for pasting a URL. A large "Extract Recipe" button. A subtle link below it: "Or add manually".
3. **Recipe View:** A clean split view. Top half is the image and title. Below are two tabs: "Ingredients" and "Instructions". A massive "Enter Cooking Mode" button pinned to the bottom.
4. **Cooking Mode (Landscape/Portrait):** Screen lock disabled. Huge text. Ingredients have large checkboxes next to them.
5. **Settings:** Toggles for Dark Mode. Export/Import JSON data. $19.99 Premium Unlock button.

**Note:** Stitch-generated designs may use approximate hex values. The authoritative palette is defined above.

## Error & Edge States

- **URL fetch failure:** Show inline error "Couldn't reach this URL. Check your connection and try again." with a Retry button.
- **No schema.org data found:** Show "Couldn't auto-extract recipe. Add it manually?" with pre-filled URL and empty fields for title/ingredients/instructions.
- **Storage full:** Show alert "Your device is running low on storage. Delete some recipes or free up space."
- **Import failure:** Show "This file doesn't look like a valid ChefStash export. Make sure it's an unmodified .json file."
- **Empty state (no recipes):** Show illustration + "Your vault is empty. Paste a URL or add a recipe manually to get started."
- **Loading state:** Skeleton cards while recipe list loads from SQLite.