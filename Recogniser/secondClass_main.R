#!/usr/bin/env Rscript
rm(list=ls())
args<-commandArgs(trailingOnly = T)

stopifnot(all(c("tuneR", "keras") %in% installed.packages()[,"Package"]))

library("tuneR")
library("keras")
use_python("/Users/vladimirobolonkin/anaconda3/bin/python3")
# Read file name
# wave.orig<-args[1]
#wave.orig<-"../Test_fiinal/ma5ho-ehcz5-ch-1.wav"
#wave.orig<-"/Users/vladimirobolonkin/Desktop/TodayWorking/Vic/Recogniser/ma5ho-ehcz5-ch-1.wav"
wave.orig<-args[1]
tmp<-try(readWave(wave.orig, from = 1, to=100))
stopifnot(!inherits(tmp, "try-error"))

# Load the model
model<-load_model_hdf5("data/model/2ndClass/model2class")
source("data/scripts/secondClass.R")

run_classification()
