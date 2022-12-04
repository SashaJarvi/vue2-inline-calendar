#!/usr/bin/env sh

# abort on errors
set -e

# build
yarn run build:gh

# navigate into the build output directory
cd dist-gh

git init
git checkout main || git checkout -b main
git add -A
git commit --allow-empty -m 'Deploy to Github Pages'

# we are deploying to https://<USERNAME>.github.io/<REPO>
git push -f git@github.com:SashaJarvi/vue2-inline-calendar.git main:gh-pages

cd -
rm -rf dist-gh
