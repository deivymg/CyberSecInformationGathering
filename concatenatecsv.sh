#!/bin/bash

output_file="combined.csv"

# List .txt files in alphabetical order and loop through them
for file in $(ls -lv *.csv); do
    if [ -f "$file" ]; then
        echo "=== $file ===" >> "$output_file"
        cat "$file" >> "$output_file"
        echo "" >> "$output_file"  # Add an empty line after each file
    fi
done
