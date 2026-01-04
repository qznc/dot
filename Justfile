regenerate-html-index:
    python3 scripts/regenerate_index.py

update-gh-pages:
    scripts/update_gh_pages.sh

local-html-tools:
    cd html_tools && python3 -m http.server
