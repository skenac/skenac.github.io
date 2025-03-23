#!/bin/bash

set -e

# Ensure we're on the source branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [[ "$CURRENT_BRANCH" != "sources" ]]; then
  echo "⚠️ Please run this from the source branch."
  exit 1
fi

echo "📤 Committing changes to source branch..."
git add .
git commit -m "Update source: $(date '+%Y-%m-%d %H:%M:%S')" || echo "🟢 No changes to commit."
git push origin sources

echo "🔧 Building site..."
bundle exec jekyll build

echo "🚀 Committing built site in _site/ (gh-pages)..."
cd _site
git add .
touch .nojekyll
git commit -m "Deploy site: $(date '+%Y-%m-%d %H:%M:%S')" || echo "🟢 No changes to commit."
git push origin gh-pages
cd ..

echo "✅ Deployment complete."