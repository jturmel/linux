#!/usr/bin/env bash

docker run -d -p 45484:45484 --restart unless-stopped --name blackd ceeveeya/blackd:latest
docker run -d -p 7105:8000 --restart unless-stopped --name kroki yuzutech/kroki:latest
docker run -d -p 11235:11235 --restart unless-stopped --shm-size=1g --name crawl4ai unclecode/crawl4ai:latest

