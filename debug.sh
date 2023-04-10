#!/bin/bash

current_version=$(git describe --tags --abbrev=0)

IFS='.' read -ra version_parts <<< "$current_version"

major="${version_parts[0]}"
minor="${version_parts[1]}"
patch="${version_parts[2]}"

echo $major $minor $patch