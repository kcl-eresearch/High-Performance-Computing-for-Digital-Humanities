#! /bin/bash -l

module load python/3.11.6-gcc-13.2.0
source .venv/bin/activate

python top_words.py frankenstein.txt 20