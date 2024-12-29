#!/usr/bin/env python3

import os
import requests
import json

GITHUB_API = "https://api.github.com/repos/lxmfy/LXMFy/releases"
DOWNLOAD_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "files")

def get_releases():
    response = requests.get(GITHUB_API)
    releases = response.json()
    
    for release in releases:
        version = release['tag_name']
        version_dir = os.path.join(DOWNLOAD_DIR, version)
        os.makedirs(version_dir, exist_ok=True)
        
        for asset in release['assets']:
            download_url = asset['browser_download_url']
            filename = asset['name']
            file_path = os.path.join(version_dir, filename)
            
            if not os.path.exists(file_path):
                print(f"Downloading {filename} for version {version}")
                response = requests.get(download_url)
                with open(file_path, 'wb') as f:
                    f.write(response.content)

if __name__ == "__main__":
    os.makedirs(DOWNLOAD_DIR, exist_ok=True)
    get_releases() 