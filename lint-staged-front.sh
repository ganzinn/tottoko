#!/bin/sh

targetDir="front"

# detect git against tag
if git rev-parse --verify HEAD >/dev/null 2>&1 ;then
  against=HEAD
else
  # Initial commit: diff against an empty tree object
  against=$(git hash-object -t tree /dev/null)
fi

targetFiles=$( \
  git diff --cached --name-only --diff-filter=AM $against | \
  grep -E "^($targetDir)\/" \
)

if [ -n "$targetFiles" ];then
  cd "$targetDir"
  npx lint-staged 2>/dev/null
fi
