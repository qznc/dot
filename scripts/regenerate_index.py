#!/usr/bin/env python3

from pathlib import Path

# Generate index.html listing all HTML files in html_tools
html_tools_dir = Path("html_tools")
index_file = html_tools_dir / "index.html"

with open(index_file, "w") as f:
    f.write("<!DOCTYPE html>\n")
    f.write("<html><head><title>Index of HTML Tools</title></head><body>\n")
    f.write("<h1>Index of HTML Tools</h1><ul>\n")

    # Add all .html files to the index
    for file in sorted(html_tools_dir.glob("*.html")):
        if file.name != "index.html":
            f.write(f'<li><a href="{file.name}">{file.name}</a></li>\n')

    f.write('</ul><p><p>Inspired by Simon Willison\'s <a href="https://simonwillison.net/2025/Dec/10/html-tools/">HTML Tools</a> article.</p></p></body></html>\n')

print("Generated html_tools/index.html, now commit it!")
