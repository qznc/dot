#!/usr/bin/env python3

from urllib.request import urlopen
from os.path import expanduser
from os import system
import re

URL = "http://photography.nationalgeographic.com/photography/photo-of-the-day/"
#URL = "http://photography.nationalgeographic.com/photography/photo-of-the-day/aphrodite-kykuit-cook-jenshel/"
WALLPAPER = expanduser("~/current_wallpaper.jpg")

def get_image_url():
	page = urlopen(URL).read().decode("utf8")
	pattern = re.compile('<div class="download_link"><a href="([^"]+)">Download Wallpaper')
	match = pattern.search(page)
	if match:
		return match.group(1)
	print("No download link, use low resolution version")

	pattern = re.compile('<img src="([^"]+)"')
	match = pattern.search(page)
	if match:
		return match.group(1)
	print("No image found")

def save_image(url):
	data = urlopen(url).read()
	with open(WALLPAPER, 'wb') as fh:
		fh.write(data)

save_image(get_image_url())
system("gsettings set org.gnome.desktop.background picture-uri file://"+WALLPAPER)
