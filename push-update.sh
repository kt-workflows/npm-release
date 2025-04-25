#!/bin/bash

# First parameter is optional commit message, defaults to "update"
COMMIT_MESSAGE=${1:-"update"}

# Push the changes to the remote repository
git add .
git commit -m "$COMMIT_MESSAGE"

# Fetch latest version tag from the remote repository
git fetch --tags
# Get the latest version tag that starts with "v"
LATEST_TAG=$(git tag -l "v*" | sort -V | tail -n 1)
# If no tag exists, create a new one
if [ -z "$LATEST_TAG" ]; then
    LATEST_TAG="v1.0.0"
    git tag -a "$LATEST_TAG" -m "$COMMIT_MESSAGE"
    git push origin "$LATEST_TAG"
fi
# Get the major version from the latest tag
MAJOR_TAG=$(echo "$LATEST_TAG" | cut -d '.' -f 1)
# Force push the tag to the remote repository
# This is necessary if the tag already exists
git tag -af "$MAJOR_TAG" -m "$COMMIT_MESSAGE"

# Push changes to the remote repository
git push
git push --force origin "$MAJOR_TAG"
