#!/bin/bash

# current_version=$(git tag --sort=-v:refname --merged | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | head -n 1)

# IFS='.' read -ra version_parts <<< "$current_version"

# major="${version_parts[0]}"
# minor="${version_parts[1]}"
# patch="${version_parts[2]}"

# echo $major $minor $patch

# git push origin main --tags
# push_exit_status=$?

# echo $push_exit_status
# !/bin/sh

# Get all local tags
# local_tags=$(git tag -l)

# # Loop through each local tag and delete it
# for tag in $local_tags; do
#   git tag -d $tag
# done

# # Get all remote tags
# remote_tags=$(git ls-remote --tags)

# # Loop through each remote tag and delete it
# for tag in $remote_tags; do
#   git push origin :refs/tags/$(echo $tag | awk -F '/' '{print $3}')
# done
