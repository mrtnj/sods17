#!/bin/bash


for IT in {1..3};
do
    cd impute_test_fish$IT
    ./AlphaImputev1.5.5 > AlphaImpute.log
    cd ..
done
