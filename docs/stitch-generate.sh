#!/bin/bash
# Script to generate ChefStash UI designs using Google Stitch

set -e
WORK_DIR="/Users/yts/lab/planned/recipe-manager/docs/stitch-designs"
mkdir -p "$WORK_DIR"
LOG_FILE="$WORK_DIR/generation.log"

echo "Starting Stitch Generation for ChefStash..." > "$LOG_FILE"
TOKEN=$(gcloud auth application-default print-access-token)
export STITCH_ACCESS_TOKEN=$TOKEN
export GOOGLE_CLOUD_PROJECT=lab-apps-490222
export PATH="/opt/homebrew/bin:$PATH"

echo "Creating project..." | tee -a "$LOG_FILE"
PROJECT_JSON=$(stitch-mcp tool create_project -d '{"title": "ChefStash - Vibecodable"}' -o json)
PROJECT_ID=$(echo "$PROJECT_JSON" | grep -o '"name":"projects/[^"]*' | cut -d'/' -f2 | head -1)

if [ -z "$PROJECT_ID" ]; then
  echo "Failed to create project." | tee -a "$LOG_FILE"
  exit 1
fi

declare -a PROMPTS=(
  "Mobile app home screen for a recipe vault. Light theme. A brutalist, clean masonry grid of recipe thumbnails with bold black titles. A search bar at the top. A floating action button with a '+' icon in the bottom right."
  "Mobile app modal for adding a recipe. Pure white background. A large text input field for pasting a URL. A massive, prominent 'Extract Recipe' button in dark slate. A subtle text link below: 'Or add manually'."
  "Mobile app recipe detail view. Top half shows a full-width food photo and the title 'Spaghetti Carbonara'. Below it are two tabs: 'Ingredients' and 'Instructions'. A clean list of ingredients is shown. Pinned to the bottom is a massive orange 'Enter Cooking Mode' button."
  "Mobile app 'Cooking Mode' screen. Landscape orientation layout, but can be portrait. Huge, high-contrast typography. The screen is split: left side shows a scrollable list of ingredients with large checkboxes, right side shows the current instruction step. Brutalist design."
  "Mobile app settings screen. Light theme. Simple list layout. Toggles for Dark Mode. Buttons for 'Export Data to JSON' and 'Import Data'. A prominent section highlighting a $19.99 Premium Unlock for 'Unlimited Recipes'."
)

declare -a FILENAMES=(
  "01_Dashboard"
  "02_AddRecipeModal"
  "03_RecipeView"
  "04_CookingMode"
  "05_Settings"
)

for i in "${!PROMPTS[@]}"; do
  export STITCH_ACCESS_TOKEN=$(gcloud auth application-default print-access-token)
  PROMPT="${PROMPTS[$i]}"
  FILENAME="${FILENAMES[$i]}"
  
  echo "Generating Screen $((i+1))/5: $FILENAME..." | tee -a "$LOG_FILE"
  SCREEN_JSON=$(stitch-mcp tool generate_screen_from_text -d "{\"projectId\": \"$PROJECT_ID\", \"prompt\": \"$PROMPT\"}" -o json || true)
  SCREEN_ID=$(echo "$SCREEN_JSON" | grep -o '"name":"projects/[^"]*/screens/[^"]*' | cut -d'/' -f4 | head -1)
  
  if [ -n "$SCREEN_ID" ]; then
    echo "  Success! Screen ID: $SCREEN_ID" | tee -a "$LOG_FILE"
    CODE_JSON=$(stitch-mcp tool get_screen_code -d "{\"projectId\": \"$PROJECT_ID\", \"screenId\": \"$SCREEN_ID\"}" -o json || true)
    echo "$CODE_JSON" > "$WORK_DIR/$FILENAME.json"
    echo "  Saved to $FILENAME.json" | tee -a "$LOG_FILE"
  else
    echo "  Failed to generate screen. Response: $SCREEN_JSON" | tee -a "$LOG_FILE"
  fi
done
echo "All tasks completed!" | tee -a "$LOG_FILE"