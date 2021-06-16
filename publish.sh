#!/bin/sh

# These commands update the _site dir (which is a submodule). It tracks the
# master branch of the repo, from which dbueno.github.io is pulled.
cd _site
git add --all
git commit -m "Update $(date '+%Y-%m-%dT%H%M')"
git push origin HEAD:master

# After publishing all changes to local files should be commited and the
# (changed) _site submodule need to be updated to the latest.
echo "Remember to commit updates to _site in hakyll branch"
