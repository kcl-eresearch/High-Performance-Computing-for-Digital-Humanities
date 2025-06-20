"""
Counts occurrences of words in a text file.

Usage: python top_words.py [input_file.txt] [top_N]

Given a text file as input, this script finds the most common words and outputs
a wordcloud image of the most common words and a .csv file of the top_N words.
Before counting, the input text is tokenized and the punctuation and 
common words (stop words) are removed.

"""

import nltk
import wordcloud
import pandas as pd
import os
import sys

nltk.download('punkt_tab')
nltk.download('stopwords')

from nltk.corpus import stopwords
from string import punctuation

# set up
punct = punctuation + "“" + "”" + "’"
english_stop_words = set(stopwords.words('english'))

# process command line arguments
file_name = sys.argv[1]
top_N = int(sys.argv[2])

file_base, ext = os.path.splitext(os.path.basename(file_name))

# read in text
with open(file_name, encoding='utf-8-sig') as f:
    txt = f.read().lower()

# split text into tokens
tokens = nltk.word_tokenize(txt)
# remove punctuation and common words
tokens = [word for word in tokens if 
                     word not in english_stop_words and
                     word not in punct]

# create wordcloud and save to file
wc = wordcloud.WordCloud()
wc.generate(",".join(tokens))
wc.to_file(file_base + '-wordcloud.png')

# write csv file of top N tokens
token_distribution = nltk.FreqDist(tokens)
top_tokens = pd.DataFrame(token_distribution.most_common(top_N),
                            columns=['Word', 'Frequency'])

top_tokens.to_csv(file_base + '-top.csv')