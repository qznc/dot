#!/usr/bin/env python3

from datetime import datetime
from pathlib import Path

# Generate index.html listing all HTML files in html_tools
html_tools_dir = Path("html_tools")
index_file = html_tools_dir / "index.html"

# Get current timestamp
generated_at = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

# Collect HTML files
html_files = sorted(
    file for file in html_tools_dir.glob("*.html") if file.name != "index.html"
)

# Build file list HTML
file_list_html = "\n".join(
    f'    <li><a href="{file.name}">{file.name}</a></li>' for file in html_files
)

# HTML template
template = f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Index of HTML Tools</title>
    <style>
        .footer {{
            color: #666;
            font-size: 0.9rem;
        }}
    </style>
</head>
<body>
    <h1>Index of HTML Tools</h1>
    <ul>
{file_list_html}
    </ul>

    <div class="footer">
        <p>Inspired by Simon Willison's <a href="https://simonwillison.net/2025/Dec/10/html-tools/">HTML Tools</a> article.</p>
        <p><em>Generated: {generated_at}</em></p>
    </div>
</body>
</html>
"""

# Write the file
with open(index_file, "w") as f:
    f.write(template)

print(f"Generated html_tools/index.html with {len(html_files)} tools, now commit it!")
