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

# Change to your Git repository directory
cd /path/to/your/repo

# Fetch the latest changes
git fetch

# Check if the current branch is 'main'
current_branch=$(git branch --show-current)
if [ "$current_branch" != "main" ]; then
    echo "You are not on the 'main' branch. Switch to the 'main' branch before running this script."
    exit 1
fi

# Merge the staging branch into main with --ff-only flag
git merge staging --ff-only || { echo "Failed to fast-forward merge. Exiting."; exit 1; }

# Get the current version from the latest tag
current_version=$(git describe --tags --abbrev=0)

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