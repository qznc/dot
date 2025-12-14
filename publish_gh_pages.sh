#!/bin/sh

# Generate index.html listing all HTML files in html_tools
echo "<!DOCTYPE html>" > html_tools/index.html
echo "<html><head><title>Index of HTML Tools</title></head><body>" >> html_tools/index.html
echo "<h1>Index of HTML Tools</h1><ul>" >> html_tools/index.html

# Add all .html files to the index
for file in html_tools/*.html; do
    if [ "$file" != "html_tools/index.html" ]; then
        filename=$(basename "$file")
        echo "<li><a href=\"$filename\">$filename</a></li>" >> html_tools/index.html
    fi
done

echo "</ul><p><p>Inspired by Simon Willison's <a href="https://simonwillison.net/2025/Dec/10/html-tools/">HTML Tools</a> article.</p></p></body></html>" >> html_tools/index.html

# Stage the index.html file
git add html_tools/index.html

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
