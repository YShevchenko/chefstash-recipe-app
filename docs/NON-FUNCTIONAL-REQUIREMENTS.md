# ChefStash Non-Functional Requirements

**Document:** NON-FUNCTIONAL-REQUIREMENTS.md  
**Product:** ChefStash  

## 1. Privacy & Security (NFR-100)
- **NFR-101 (Zero-Knowledge):** No recipe data, URLs, or user behavior shall leave the device.
- **NFR-102 (Local Images):** Recipe images must be downloaded and stored locally to prevent dead image links if the original food blog goes offline.

## 2. Performance (NFR-200)
- **NFR-201 (Extraction Speed):** The entire process of fetching the URL, parsing the DOM, downloading the image, and saving to SQLite must complete in < 2.5 seconds on a fast connection.
- **NFR-202 (Storage Efficiency):** Downloaded recipe images must be compressed to < 300KB each.

## 3. Reliability (NFR-300)
- **NFR-301 (Offline):** 100% of saved recipes must be viewable without an internet connection.