#!/bin/bash

find "$1"  -mindepth 1 -maxdepth 1 | xargs -I {} ./PRGM/output/LC.sh '{}' "$1" | sort
