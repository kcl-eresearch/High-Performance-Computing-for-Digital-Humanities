#!/bin/bash

mkdocs build --clean 
quarto-slides-presentation/KDL-Intro-To-Computing.html site/slides/index.html
mkdocs gh-deploy --dirty 
