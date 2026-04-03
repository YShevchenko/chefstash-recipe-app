# ChefStash Product Spec

## 1. Product Identity

### 1.1 Working Product Name
ChefStash (Recipe Vault)

### 1.2 Product Category
Mobile utility for recipe extraction and offline management.

### 1.3 Product Type
Privacy-first, offline iOS and Android app built with React Native and Expo.

### 1.4 Core Identity Statement
Modern recipe websites are broken. They are 5,000 words of SEO-optimized life stories buried under auto-playing video ads and newsletter popups. Existing recipe apps either force you into a $30/year subscription (Paprika) or rely on cloud syncing that breaks. ChefStash is a brutalist, offline-first vault. You paste a URL, and the app uses a local parsing engine to strip out everything except the Title, Ingredients, and Instructions. It saves them instantly. 

## 2. Vision Statement

Cooking should be relaxing. Scrolling through ads with messy hands is not relaxing. ChefStash aims to be the fastest way to get from a web URL to a clean, highly legible, ad-free cooking screen. It is a one-time purchase that stores recipes forever on your device.

## 3. Core Concept

The user opens the app and pastes a URL (e.g., from NYT Cooking or a food blog).
The app fetches the raw HTML and uses a local JS parser (like Cheerio) to extract the `schema.org/Recipe` JSON-LD data.
Within 1 second, the recipe is saved to the local SQLite database.
The user views the recipe in "Cooking Mode":
1. The screen stays awake.
2. The typography is massive and high-contrast.
3. Ingredients can be tapped to cross them off as they are added to the pot.

## 4. Target Audience
- Home cooks frustrated by bloated food blogs.
- People who want a digital recipe box but refuse to pay monthly subscriptions.
- Users who value offline access to their favorite recipes (e.g., cooking while camping or traveling).

## 5. Monetization Strategy

**Freemium (One-Time IAP)**
- **Free Tier:** Extract and save up to 10 recipes. Good for proving the extraction engine works flawlessly.
- **Premium Tier ($19.99 One-Time):** Unlimited recipes, custom categorizing (tags), and photo attachments for recipe steps.
- **Why this maximizes revenue:** The $20 price point is highly competitive against subscription apps. By removing the backend parsing server, we have zero ongoing costs, making the $20 a 100% margin sale.

## 6. Marketing & User Acquisition Strategy
**Classification:** Tier 4 Niche
**Primary Ad Platforms:** Pinterest (Food/Recipe boards).
**Targeting:** Home cooks, meal preppers.
**Core Hook:** "Skip the 5,000-word life story and the auto-playing ads. Paste the URL and instantly extract just the recipe."
**Geographic Strategy:** US/UK primarily.

