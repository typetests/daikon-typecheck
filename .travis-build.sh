#!/bin/bash
ROOT=$TRAVIS_BUILD_DIR/..

# Fail the whole script if any command fails
set -e

## Build Checker Framework
(cd $ROOT && git clone https://github.com/typetools/checker-framework.git)
# This also builds annotation-tools and jsr308-langtools
(cd $ROOT/checker-framework/ && ./.travis-build-without-test.sh)
export CHECKERFRAMEWORK=$ROOT/checker-framework

## Obtain daikon
(cd $ROOT && git clone https://github.com/codespecs/daikon.git)

travis_wait 120 make -C $ROOT/daikon/java check-all
