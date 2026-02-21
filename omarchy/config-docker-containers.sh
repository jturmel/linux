#!/usr/bin/env bash

docker run -d -p 45484:45484 --restart unless-stopped --name blackd ceeveeya/blackd:latest
docker run yuzutech/kroki --restart unless-stopped --name kroki
