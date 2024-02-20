#!/bin/bash

set -e

LOGPATH="/cluster/home/lilweber/logs/log_mnket_eeg_preproc"

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

while read -r line
do
    sbj="$line"
    echo "$sbj"

    bsub -R "rusage[mem=16384]" -W 4:00 -o $LOGPATH/log_preproc_$sbj matlab -nodesktop -nosplash -singleCompThread -r "mnket_analyze_subject('$sbj')"

#-R "rusage[mem=16384]"

done < subjects.list
