library(RSQLite)
library(RSQLite.extfuns)
library(plyr)
library(dplyr)

# read in list of 300 words
word_file <- "word-data/300words.txt"
changed_words <- read.table(word_file, stringsAsFactors = FALSE)
names(changed_words) <- c("new", "old", "letter_change", "change_type")

# read in word mapping of stem words
word_map_file <- 'word-data/stem_map.json'
word_map <- fromJSON(file = word_map_file)
word_map_df <- ldply(names(word_map), function(wm) {
    words <- word_map[[wm]]
    data.frame(
        canonical_word = rep(wm, length(words)),
        word = words,
        stringsAsFactors = FALSE
    )
})

# connect to sqlite table    
db_location <- 'ngram-data/ngram.db'
db_conn <- src_sqlite(db_location)
spelling_grams <- tbl(db_conn, "ngram")

# pull the ngram data corresponding to each word we care about
all_words <- unique(c(changed_words$old, changed_words$new, word_map_df$word))
spelling_df <- ldply(all_words, function(w) {
    as.data.frame(compute(filter(spelling_grams, word == w)))
})

# combine the different word forms with the stem words
spelling_df <- spelling_df %.%
    left_join(word_map_df, by = 'word')

spelling_df <- spelling_df %.%
    mutate(canonical_word = ifelse(is.na(spelling_df$canonical_word),
                                   spelling_df$word,
                                   spelling_df$canonical_word)) %.%
    group_by(canonical_word, year) %.%
    summarise(match_ct = sum(match_ct),
              volumn_ct = sum(volumn_ct)) %.%
    ungroup() %.%
    mutate(word_type = ifelse(spelling_df$canonical_word %in% changed_words$old,
                              'British',
                              'American')) %.%
    select(word = canonical_word, year, match_ct, volumn_ct, word_type)

# we want to get the total instance count for the different
# spelling of the words
changed_words <- mutate(changed_words, word_id = 1:nrow(changed_words))
new_words <- select(changed_words, word = new, word_id, letter_change, change_type)
old_words <- select(changed_words, word = old, word_id, letter_change, change_type)
id_words <- rbind(new_words, old_words)

# filter out words that have a very low frequency
infreq_words <- spelling_df %.%
    inner_join(id_words, by = 'word') %.%
    group_by(word_id) %.%
    summarise(total_word_ct = sum(match_ct)) %.%
    ungroup() %.%
    filter(total_word_ct > 10^5)

changed_word_ct <- spelling_df %.%
    inner_join(id_words, by = 'word') %.%
    group_by(word_id, year, letter_change, change_type) %.%
    summarise(word_ct = sum(match_ct)) %.%
    ungroup()

spelling_change <- changed_word_ct %.%
    select(word_id, year, word_ct) %.%
    semi_join(infreq_words, by = 'word_id') %.% # remove infrequent words
    inner_join(id_words, by = 'word_id') %.%
    inner_join(spelling_df, by = c('word', 'year')) %.%
    mutate(match_pct = match_ct / word_ct) %.%
    filter(word_type == 'American') %.%
    select(word, year, match_pct, letter_change, change_type)

saveRDS(spelling_change, file = 'word-data/spelling_change.RDS')
