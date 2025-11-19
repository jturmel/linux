#!/bin/sh

docker run -d -p 45484:45484 --restart unless-stopped --name blackd ceeveeya/blackd:latest

