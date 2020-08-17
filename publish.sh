#!/bin/sh

cd _site
git add --all
git commit -m "Update $(date '+%Y-%m-%dT%H%M')"
git push origin HEAD:master
echo "Remember to commit updates to _site in hakyll branch"
