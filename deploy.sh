#!/bin/bash
set -e
set -x

commit_id=`git log -n1 --format="%h"`
environment_name=`eb list | grep "*" | sed "s/\\* //"`


# deploy
git co master
if [[ `git branch --list deploy` ]]
then
   git branch -D deploy
fi

git co -b deploy
environment_name=`eb list | grep "*" | sed "s/\\* //"`
cp .ebextensions_secret/*.config .ebextensions/
git add -A
git commit -m "Preparing to commit to deploy branch"
eb deploy --timeout 100 --label $commit_id-$environment_name
git co master
git branch -D deploy
