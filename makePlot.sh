#!/bin/bash
#
# @author Danny Eck
# @date 2013-08-23
#
# This script grabs the latest curl_results and creates a plot using the Rscript
#

# Out with the old
rm -f curl_results.csv plot.jpg

# Get fresh data
wget path-to-jenkins-job/lastSuccessfulBuild/artifact/curl_results.csv

# ... and plot it!
Rscript plots.R
