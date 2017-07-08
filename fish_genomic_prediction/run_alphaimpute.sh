#!/bin/bash


for CHR in {1..24};
do
    cd impute_fish$CHR
    ./AlphaImputev1.5.5 > AlphaImpute.log
    cd ..
done
