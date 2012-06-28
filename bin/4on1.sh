#!/bin/bash
set -e
# convert pdfs to 4 pages on 1 page
pdfnup --nup '2x2' --trim '-0.75cm -0.5cm -0.75cm -0.5cm' --suffix '4' --batch "$@"

