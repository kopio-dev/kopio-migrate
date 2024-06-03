#!/bin/sh
# find ./src/contracts/core/**/facets/*Facet.sol -exec echo {} \; && echo {} \;'
for filename in ./src/**/facets/*Facet.sol; do
    echo $(basename $filename .sol)
    ./utils/getFunctionSelectors.sh $(basename $filename .sol)
done
