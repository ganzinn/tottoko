#!/bin/sh

targetDir="front"

cd "$targetDir"
CI=true npm test
