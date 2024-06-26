#!/bin/bash

set -e

# Variables
HELM_REPO_URL=$1
NEW_VERSION=$3
EMAIL=$2
CHART_YAML_PATH="cart-service/Chart.yaml"  # Adjust the path to the Chart.yaml file in the Helm repo
IMAGE_YAML_PATH="cart-service/values.yaml"
GIT_BRANCH="main"  # Branch to push the changes to
# Clone the Helm chart repository 
git clone "https://prashant:${TOKEN}@github.com/$HELM_REPO_URL.git"
# git clone https://<username>:<token>@github.com/username/repository.git

cd $(basename "$HELM_REPO_URL")

# # Extract the current version
# CURRENT_VERSION=$(grep '^version:' "$CHART_YAML_PATH" | awk '{print $2}')
# echo "Current version: $CURRENT_VERSION"

# # Increment the patch version (x.y.z -> x.y.(z+1))
# IFS='.' read -r -a VERSION_PARTS <<< "$CURRENT_VERSION"
# PATCH_VERSION=${VERSION_PARTS[2]}
# NEW_PATCH_VERSION=$((PATCH_VERSION + 1))
# NEW_VERSION="${VERSION_PARTS[0]}.${VERSION_PARTS[1]}.$NEW_PATCH_VERSION"
# echo "New version: $NEW_VERSION"

# Update the version in Chart.yaml
sed -i.bak "s/^version: .*/version: $NEW_VERSION/" "$CHART_YAML_PATH"
rm "$CHART_YAML_PATH.bak"

#Update the version in values.yaml
# Update the tag in values.yaml
sed -i "s/^ *tag: .*/  tag: \"$NEW_VERSION\"/" "$IMAGE_YAML_PATH"
# sed -i.bak 's/tag: ".*"/tag: "'$NEW_VERSION'"/' "$IMAGE_YAML_PATH"
# rm "$IMAGE_YAML_PATH.bak"

# Commit and push the changes
git config --global user.email "prashantsingh830@gmail.com"
git config --global user.name "Prashant"
git add .
git commit -m "Update Helm chart version to $NEW_VERSION"
git push origin main


echo "Helm chart version updated and changes pushed successfully."
