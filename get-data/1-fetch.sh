#!/bin/bash -e

# Download all the ngrams for the american corpus
# This takes a while depending on your download speed

BASE_URL="http://storage.googleapis.com/books/ngrams/books/"
FILE_NAME="googlebooks-eng-us-all-1gram-20120701-"
SUFFIX=".gz"

mkdir -p ../ngram-data

pushd ../ngram-data > /dev/null

# Force the directory to be clean
rm -rf *

for LETTER in {a..z}; do
    wget $BASE_URL$FILE_NAME$LETTER$SUFFIX
done

popd > /dev/null
