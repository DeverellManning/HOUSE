#!/bin/bash

for N in $(seq 1 $(seq 1 8 | shuf | head -n1)); do
echo -n "bar "
done
echo
