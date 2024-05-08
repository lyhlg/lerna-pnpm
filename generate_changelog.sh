#!/bin/bash

# Ensure all tags are fetched
git fetch --tags

# Get the latest tag name
latest_tag=$(git describe --tags --abbrev=0)

# Fetch commits from latest tag to HEAD
commits=$(git log $latest_tag..HEAD --pretty=format:"%s (%h)" --abbrev-commit)

# Initialize associative array to hold categorized commits
declare -A changelog_groups

# Parse each commit line
while IFS= read -r line; do
    if [[ "$line" == *":"* ]]; then
        type=$(echo "$line" | cut -d ':' -f 1)
        message=$(echo "$line" | sed -e "s/$type: //" | sed -e "s/ ([a-f0-9]+)$//")
        commit_hash=$(echo "$line" | grep -o '(\w\+)$' | sed 's/[()]//g')
        link="https://github.com/lyhlg/lerna-pnpm/commit/$commit_hash"
        formatted_message="- $message ([#$commit_hash]($link))"
        changelog_groups["$type"]+="$formatted_message\n"
    else
        # Handle commits that don't fit the expected format
        changelog_groups["Uncategorized"]+="$line\n"
    fi
done <<< "$commits"

# Output the formatted changelog
echo "CHANGELOG=''" >> $GITHUB_ENV
for type in "${!changelog_groups[@]}"; do
    echo "CHANGELOG+='# $type\n${changelog_groups[$type]}\n'" >> $GITHUB_ENV
done
