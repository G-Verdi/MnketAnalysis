#!/bin/bash

set -e

LOGPATH="/cluster/home/lilweber/logs/log_mnket_eeg_quality"

mkdir $LOGPATH ||
    while true; do
	read -p "Do you wish to append to files?" yn
	case $yn in
	    [Yy]* ) break;;
	    [Nn]* ) exit;;
	    * ) echo "Please answer yes or no.";;
	esac
    done

cd /cluster/home/lilweber/prj/mnket/    

bsub -R "rusage[mem=16384]" -W 4:00 -o $LOGPATH/log_quality matlab -nodesktop -nosplash -singleCompThread -r "loop_mnket_quality_check"

