# Dropzone Action Info
# Name: Download nHentai Epub
# Description: Given nHentai link, run Epub download + generation
# Handles: Text
# Creator: Your name
# URL: http://yoursite.com
# Events: Clicked, Dragged
# KeyModifiers: Command, Option, Control, Shift
# SkipConfig: No
# RunsSandboxed: Yes
# Version: 1.0
# MinDropzoneVersion: 3.5

import os
import re
import subprocess
import time

MATCH = r"nhentai.net/g/(\d+)"
EPUB_DIR = "/Users/tingzhou/Pictures/.NSFW/Epub"

def dragged():
    number_match = re.search(MATCH, items[0])
    dz.begin("Starting download task...")
    if number_match:
        number = number_match.group(1)
        print(number)
        subprocess.run(
            [
                "/Users/tingzhou/local/bin/make_epub_with_nhentai",
                "--page-id",
                number
            ], cwd=EPUB_DIR, text=True)
        dz.finish("Task Complete!")
        dz.url(False)
    else:
        dz.finish("URL not recognized.")
        dz.url(False)


def clicked():
    subprocess.call(["open", EPUB_DIR])
