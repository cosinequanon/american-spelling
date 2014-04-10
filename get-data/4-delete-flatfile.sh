#!/bin/bash -e

# Remove the remaining flat files.

# This is it's own script because we want to
# make sure everything has succeeded before
# deleting the remaining data.

pushd ../ngram-data > /dev/null

rm googlebooks-eng-us-all-1gram-20120701-*

popd > /dev/null
