#!/bin/bash

inputWav=$1

# Run initial detector
./detector.sh $inputWav

# Run second classifier
Rscript --vanilla secondClass_main.R $inputWav