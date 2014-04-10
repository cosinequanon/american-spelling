#!/bin/bash -e

# Run all scripts for fetching and importing data.

./1-fetch.sh
./2-unzip-concat.sh
./3-load-sqlite.sh
./4-delete-flatfile.sh
