#!/bin/sh

# Get the tree hash of the html_tools subfolder
tree_hash=$(git ls-tree HEAD html_tools | head -n 1 | awk '{print $3}')

# Create a new commit using the tree hash
if git show-ref --verify --quiet refs/heads/gh_pages; then
    parent_commit=$(git rev-parse gh_pages)
    new_commit_hash=$(git commit-tree "$tree_hash" -p "$parent_commit" -m "Update gh_pages with html_tools content")
else
    new_commit_hash=$(git commit-tree "$tree_hash" -m "Create gh_pages with html_tools content")
fi

# Update the gh_pages branch reference
git update-ref refs/heads/gh_pages "$new_commit_hash"

# Push the branch to the remote
git push origin gh_pages

echo "Updated gh_pages branch with html_tools content. New commit: $new_commit_hash"
echo "See https://qznc.github.io/dot/"
