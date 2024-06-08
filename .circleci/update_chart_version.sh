#!/bin/bash

set -e

# Variables
HELM_REPO_URL=$1
CHART_YAML_PATH="cart-service/Chart.yaml"  # Adjust the path to the Chart.yaml file in the Helm repo
GIT_BRANCH="main"  # Branch to push the changes to

# Clone the Helm chart repository
git clone "https://github.com/$HELM_REPO_URL.git"
cd $(basename "$HELM_REPO_URL")

# Extract the current version
CURRENT_VERSION=$(grep '^version:' "$CHART_YAML_PATH" | awk '{print $2}')
echo "Current version: $CURRENT_VERSION"

# Increment the patch version (x.y.z -> x.y.(z+1))
IFS='.' read -r -a VERSION_PARTS <<< "$CURRENT_VERSION"
PATCH_VERSION=${VERSION_PARTS[2]}
NEW_PATCH_VERSION=$((PATCH_VERSION + 1))
NEW_VERSION="${VERSION_PARTS[0]}.${VERSION_PARTS[1]}.$NEW_PATCH_VERSION"
echo "New version: $NEW_VERSION"

# Update the version in Chart.yaml
sed -i.bak "s/^version: .*/version: $NEW_VERSION/" "$CHART_YAML_PATH"
rm "$CHART_YAML_PATH.bak"

# Commit and push the changes
git config --global user.email "your-email@example.com"
git config --global user.name "Your Name"
git checkout -b update-chart-version
git add "$CHART_YAML_PATH"
git commit -m "Update Helm chart version to $NEW_VERSION"
git push origin update-chart-version

# Create a pull request (optional)
PR_TITLE="Update Helm chart version to $NEW_VERSION"
PR_BODY="This PR updates the Helm chart version to $NEW_VERSION."
gh pr create --title "$PR_TITLE" --body "$PR_BODY" --base $GIT_BRANCH

echo "Helm chart version updated and changes pushed successfully."
