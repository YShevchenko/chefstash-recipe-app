# ChefStash Requirements

**Document:** REQUIREMENTS.md  
**Product:** ChefStash  
**Publisher:** Heldig Lab  

---

## 1. Functional Requirements

### 1.1 Recipe Extraction (FR-001 to FR-010)
| ID | Requirement | Priority |
|---|---|---|
| FR-001 | The system shall accept a URL input and fetch the raw HTML. | High |
| FR-002 | The system shall parse the HTML locally to extract `schema.org/Recipe` data (Title, Image, Ingredients, Instructions, Yield). | High |
| FR-003 | The system shall download the primary recipe image and save it to the local Expo FileSystem. | High |
| FR-004 | The system shall allow users to manually type or edit a recipe if the URL parsing fails. | High |

### 1.2 Recipe Management (FR-011 to FR-020)
| ID | Requirement | Priority |
|---|---|---|
| FR-011 | The system shall display a dashboard grid of all saved recipes with thumbnail images. | High |
| FR-012 | The system shall allow users to search saved recipes by title or ingredient. | High |
| FR-013 | The system shall allow users to apply custom tags (e.g., "Dinner", "Vegan") to recipes. | Medium |

### 1.3 Cooking Mode (FR-021 to FR-030)
| ID | Requirement | Priority |
|---|---|---|
| FR-021 | The system shall provide a dedicated "Cooking Mode" view with enlarged typography. | High |
| FR-022 | The system shall prevent the device screen from sleeping while in Cooking Mode. | High |
| FR-023 | The system shall allow users to tap an ingredient to visually strike it out (mark as used). | High |

### 1.4 Premium Features (FR-031 to FR-040)
| ID | Requirement | Priority |
|---|---|---|
| FR-031 | The system shall lock the extraction of > 10 recipes behind a $19.99 one-time Premium unlock. | High |
| FR-032 | The system shall lock custom tagging behind the Premium unlock. | High |
| FR-033 | The system shall lock photo attachments for recipe steps behind the Premium unlock. | High |

> **Note:** Cooking Mode (FR-021 through FR-023) is a free, core feature available to all users. The recipe limit (10 recipes on the free tier) is the primary gating mechanism, not Cooking Mode itself.

### 1.5 Export & Data (FR-041 to FR-050)
| ID | Requirement | Priority |
|---|---|---|
| FR-041 | The system shall allow the user to export all recipes as a standard JSON file. | High |
| FR-042 | The system shall allow the user to import a JSON file to restore recipes. | High |

## 2. Non-Functional Requirements
- **Privacy:** Zero backend. No URLs or recipes are sent to our servers.
- **Offline:** Once a recipe is extracted and saved, viewing and cooking from it must be 100% offline.