#!/bin/bash

FILE="./project.godot"

if [ ! -f "$FILE" ]; then
    echo "File $FILE not found."
    exit 1
fi

godot --headless --export-debug "Android"

cd build/android/
zip -r ./runner.zip ./*
cd ../../
