#!/bin/bash

FILE="./project.godot"

if [ ! -f "$FILE" ]; then
    echo "File $FILE not found."
    exit 1
fi
source .venv/bin/activate
godot --headless --export-debug "Android"

cd build/android/
zip -r ./penguin_traveler__survival.zip ./*
cd ../../
