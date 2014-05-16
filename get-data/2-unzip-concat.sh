#!/bin/bash -ev 

pushd ../ngram-data > /dev/null

# Now that the data is downloaded, unzip the files.
gunzip *.gz

# Make one large file so we can load it into a db.
# While we are at it we can do some basic filtering that
# will make the data a lot smaller.
awk '
BEGIN{ OFS="|"}
{
    /NR == 4/
    if ($1 ~ /[:lower:]/) {
        if ($1 !~ /([._[:digit:]])/) {
            if ($2 > 1800) {
                print $1, $2, $3, $4
            }
        }
    }
}' googlebooks* > googlebooks-eng-us-all-1gram-20120701

popd > /dev/null
