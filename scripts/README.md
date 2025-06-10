# Finding common words

The `top_words.py` script can be used to find the most common words in an input text document
and output the top *N* words as a csv, as well as a wordcloud of common words.

To run the script, you will need to install some dependencies.
It's recommended to create a Python virtual environment for the project.

```bash
python -m venv .venv
source .venv/bin/activate
pip install nltk pandas wordcloud
```

The script can then be run as follows, where N is the number of most frequent words to report
in the output.csv file:

```bash
python top_words.py [input text file] [N]
```

## Input text files

A good source for input text files is [Project Gutenberg](https://www.gutenberg.org/).
