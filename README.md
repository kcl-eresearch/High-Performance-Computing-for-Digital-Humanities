# Introduction to High Performance Computing

This repo contains the e-Research training materials for using the CREATE HPC.

## Layout

    mkdocs.yml       # The configuration file.
    requirements.txt # Python dependencies to build the site.
    docs/
        images/      # Images used in the training materials.
        index.md     # The training homepage.
        slides.md    # Workshop slides in `reveal.js` format.
        *.md         # Other markdown pages.
    programs/        # Source code of example programs used in the training.
        Makefile     # Build the example programs.
    theme/           # Custom site themes for e.g. `reveal.js` slides

## Dependencies

You can create a Python virtual environment to install the dependencies for building the site.

    python3 -m venv hpcvenv
    source hpcvenv/bin/activate
    pip install -r requirements.txt

In order to build the slides, you will need to clone the `reveal.js` submodule using:

    git submodule update --init --recursive

## Building and viewing

You can use `mkdocs serve` command to preview the changes as you make them.
From the root of the repository run

    mkdocs serve

The command will compile the docs and start up a webserver
(by default it will be served on `http://127.0.0.1:8000`).

If you want to only compile the docs execute:

    mkdocs build

The command will compile the docs and place the content in the `site` directory.

### Syntax checks

Use [markdownlint](https://github.com/markdownlint/markdownlint)
to check for markdown style issues:

    mdl docs/ README.md

If you are using a [docker container](https://hub.docker.com/r/pipelinecomponents/markdownlint):

    docker run -v $PWD:/code pipelinecomponents/markdownlint -- docs/ README.md

## Deployment

Once changes have been merged to the `main` branch, run `mkdocs gh-deploy` to build the pages and push to the live server.
