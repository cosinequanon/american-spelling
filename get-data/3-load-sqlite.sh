#!/bin/bash -e

# Load the ngram data set into a sqlite database

pushd ../ngram-data > /dev/null

# older versions of sqlite3 gave me errors so I have to use this one
# sqlite3="/usr/local/Cellar/sqlite/3.8.4.3/bin/sqlite3"
sqlite3 ngram.db < ../get-data/load-sqlite.sql

popd > /dev/null
