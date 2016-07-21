#!/bin/bash
ROOT=$TRAVIS_BUILD_DIR/..

# Required argument $1 is one of:
#   formatter, interning, lock, nullness, regex, signature, nothing


# Fail the whole script if any command fails
set -e

## Short version, intended to be used when triggering downstream Travis jobs.
echo "Should next trigger downstream jobs."
true

## Build Checker Framework
(cd $ROOT && git clone --depth 1 https://github.com/typetools/checker-framework.git)
# This also builds annotation-tools and jsr308-langtools
(cd $ROOT/checker-framework/ && ./.travis-build-without-test.sh)
export CHECKERFRAMEWORK=$ROOT/checker-framework
 
## Obtain daikon
(cd $ROOT && git clone --depth 1 https://github.com/codespecs/daikon.git)

## Obtain daikon
(cd $ROOT && git clone --depth 1 https://github.com/codespecs/daikon.git)
## Is the dyncomp-jdk task needed?
# make -C $ROOT/daikon/java compile dyncomp-jdk
make -C $ROOT/daikon/java compile
make -C $ROOT/daikon daikon.jar

## It would be better to just run "make check-all", but that times out, so break
## it into different Travis jobs.  That also helps to indicate the specific
## error that occurred.
## make -C $ROOT/daikon/java check-all

# As of July 2016, timing for Travis jobs (which includes building the Checker Framework and Daikon):
# check-formatter : 30 minutes
# check-interning : 32 minutes
# check-lock : 40 minutes
# check-nullness : 96 minutes
# check-regex : 33 minutes
# check-signature : 30 minutes
# How are the long run times for check-nullness possible?
# Keep that as a downstream job if it times out now?

if [[ "$1" == "formatter" ]]; then
  make -C $ROOT/daikon/java check-formatter
elif [[ "$1" == "interning" ]]; then
  make -C $ROOT/daikon/java check-interning
elif [[ "$1" == "lock" ]]; then
  make -C $ROOT/daikon/java check-lock
elif [[ "$1" == "nullness" ]]; then
  make -C $ROOT/daikon/java check-nullness
elif [[ "$1" == "regex" ]]; then
  make -C $ROOT/daikon/java check-regex
elif [[ "$1" == "signature" ]]; then
  make -C $ROOT/daikon/java check-signature
elif [[ "$1" == "nothing" ]]; then
  true
else
  echo "Bad argument '$1' to travis-build.sh"
  false
fi
