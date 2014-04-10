-- Load the sqlite database with the ngrams data
-- and create an index on the words

.echo ON

drop table if exists ngram;

create table ngram (
    word text,
    year integer,
    match_ct integer,
    volumn_ct integer
);

.import googlebooks-eng-us-all-1gram-20120701 ngram

create index word_index on ngram (word);
