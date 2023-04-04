#!/bin/bash

if [[ $(git rev-parse --abbrev-ref HEAD) == "main" ]]; then
    echo "You are currently on the main branch."
else
    echo "You are not on the main branch."
fi
