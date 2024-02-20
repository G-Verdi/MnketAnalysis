#!/bin/bash

set -e

LOGPATH="/cluster/home/lilweber/logs/log_mnket_eeg_init"

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

bsub -R "rusage[mem=16384]" -W 4:00 -o $LOGPATH/log_init matlab -nodesktop -nosplash -singleCompThread -r "mnket_setup_analysis_folder"

