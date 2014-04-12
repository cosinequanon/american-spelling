"""
Create a mapping with the 300 words we are considering and variations
of those words. We are linking words like coloring to the stem, color.
"""

import json
from collections import defaultdict

from nltk.stem.snowball import EnglishStemmer


def read_300_words():
    """ Read in the data set of 300 words. """
    word_list = []
    file_300 = 'word-data/300words.txt'
    with open(file_300, 'r') as f:
        for line in f:
            parts = line.split()
            word_list.append(parts[0])
            word_list.append(parts[1])
    word_set = frozenset(word_list)
    return word_set


def stem_word(stemmer, word):
    """ Stem a given word. """
    try:
        return stemmer.stem(word)
    except UnicodeDecodeError:
        pass


def main():
    """
    Loop through the ngram file and stem each unique word, if the word matches
    one of the 300 words we are considering, then store that word.
    """
    es = EnglishStemmer()
    words_300 = read_300_words()
    stem_word_map = defaultdict(list)
    ngram_file = 'ngram-data/googlebooks-eng-us-all-1gram-20120701'
    cur_word = ''
    with open(ngram_file, 'r') as f:
        for line in f:
            parts = line.split('|')
            word = parts[0]
            if word != cur_word:
                is_new_word = True
            if is_new_word:
                is_new_word = False
                cur_word = word
                stemmed_word = stem_word(es, word)
                if stemmed_word in words_300:
                    stem_word_map[stemmed_word].append(word)

    with open('word-data/stem_map.json', 'w') as f:
        json.dump(stem_word_map, f)

if __name__ == '__main__':
    main()


