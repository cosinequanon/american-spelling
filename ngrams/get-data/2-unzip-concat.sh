#!/bin/bash

pushd ../../data > /dev/null

# Now that the data is downloaded, unzip the files.
gunzip *.gz

# Make one large file so we can load it into a db.
# While we are at it we can do some basic filtering that
# will make the data smaller.
awk '{
    if ($2 > 1850) {
        print $0
    }
}' googlebooks* > googlebooks-eng-us-all-1gram-20120701

# Remove the individual files since we don't need them anymore.
rm googlebooks-eng-us-all-1gram-20120701-*

popd > /dev/null
