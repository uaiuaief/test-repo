#!/bin/bash

# Check if an argument was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 {major|minor|patch}"
    exit 1
fi

bump_type="$1"

# Validate the bump type
if [[ ! $bump_type =~ ^(major|minor|patch)$ ]]; then
    echo "Invalid bump type. Must be one of: major, minor, patch"
    exit 1
fi

# Prompt for confirmation
read -p "This script will merge 'staging' into 'main', bump the $bump_type version, and push the changes. Are you sure you want to proceed? (y/N): " -n 1 -r
echo # Move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Operation canceled."
    exit 1
fi

# Check if the current branch is 'main'
current_branch=$(git branch --show-current)
if [ "$current_branch" != "main" ]; then
    echo "You are not on the 'main' branch. Switch to the 'main' branch before running this script."
    exit 1
fi

# Fetch the latest changes
git fetch

# Merge the staging branch into main with --ff-only flag
git merge origin/staging --ff-only || { echo "Failed to fast-forward merge. Exiting."; exit 1; }

# Get the current version from the latest tag
current_version=$(git tag --sort=-v:refname --merged | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | head -n 1)

# Bump the version based on the provided bump type
IFS='.' read -ra version_parts <<< "$current_version"
major="${version_parts[0]}"
minor="${version_parts[1]}"
patch="${version_parts[2]}"

case $bump_type in
    major)
        new_major=$((major + 1))
        new_version="$new_major.0.0"
        ;;
    minor)
        new_minor=$((minor + 1))
        new_version="$major.$new_minor.0"
        ;;
    patch)
        new_patch=$((patch + 1))
        new_version="$major.$minor.$new_patch"
        ;;
esac

# Create the new version tag and update the 'latest' tag
git tag -a "$new_version" -m "Release $new_version"
git tag -d latest
git tag -a "latest" -m "Latest release"

# Push the changes, new version tag, and updated 'latest' tag
git push origin main --tags
push_exit_status=$?

if [ $push_exit_status -eq 0 ]; then
    echo "Successfully merged staging into main, bumped the $bump_type version to $new_version, and pushed the changes."
else
    echo "Push failed. Please check your remote repository and try again."
    exit 1
fi