#!/bin/bash

if [[ $(git rev-parse --abbrev-ref HEAD) != "main" ]]; then
    echo "You need to be in the main branch to run this script."
    exit 1

echo "You are currently on the main branch."
