# ChefStash — Recipe Manager

A Flutter app for saving, organizing, and cooking recipes offline.

## Features

- **URL Recipe Extraction** — Paste any recipe URL and ChefStash parses schema.org/Recipe metadata automatically (title, image, ingredients, instructions, yield, prep/cook times)
- **Offline-First** — All data stored locally with SQLite. No account or internet required after first extraction
- **Cooking Mode** — Dark-mode cooking screen with enlarged text (20sp), ingredient checkboxes with strikethrough, and step-by-step instructions. Screen stays awake via `wakelock_plus`
- **Recipe Vault** — Grid of saved recipes with thumbnails, search by title or ingredient
- **JSON Backup** — Export all recipes to JSON and import back (Premium)
- **Custom Tags** — Organize recipes with custom tags (Premium)

## Pricing

- **Free**: Up to 10 recipes
- **Premium ($19.99)**: Unlimited recipes, custom tags, step photos, export/import

## Tech Stack

- Flutter (Dart)
- SQLite via `sqflite`
- `in_app_purchase` for IAP
- `wakelock_plus` for cooking mode
- `html` + `http` for schema.org parsing
- `share_plus` + `file_picker` for export/import

## Publisher

Heldig Lab — heldig.lab@pm.me
