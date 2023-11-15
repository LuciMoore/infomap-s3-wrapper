#!/bin/bash

set +x 

# Initialize variables with default values
s3_bids_path="s3://subpop/abcd_hcp_pipeline/derivatives"
output_dir="/home/feczk001/shared/projects/infomap-s3-wrapper/OUTPUT" # where to save the data
wb_command_path="/home/faird/shared/code/external/utilities/workbench/1.4.2/workbench/bin_rh_linux64/wb_command"
repetition_time=1.761
minutes_limit='none'
run_folder=`pwd`
fd_threshold=0.2

run_files_folder="${run_folder}/run_files.syncTM"
output_logs_folder="${run_folder}/output_logs"
TM_template="template.s3sync_then_TM_run"

if [ ! -d "${run_files_folder}" ]; then
    mkdir -p "${run_files_folder}"
fi

if [ ! -d "${output_logs_folder}" ]; then
    mkdir -p "${output_logs_folder}"
fi

# counter to create run numbers
k=0
echo $s3_bids_path

for i in `s3cmd ls "${s3_bids_path}"/ | awk '{print $2}'`; do
	# does said folder include subject folder?
echo $i
	sub_text=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $1}'`
	if [ "sub" = "${sub_text}" ]; then # if parsed text matches to "sub", continue
		subj_id=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $2}'`
		for j in `s3cmd ls "${s3_bids_path}"/${sub_text}-${subj_id}/ | awk '{print $2}'`; do
			ses_text=`echo ${j} |  awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $1}'`
			if [ "ses" = "${ses_text}" ]; then
				ses_id=`echo ${j} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $2}'` 
				sed -e "s|SUBJECTID|${subj_id}|g" -e "s|SESID|${ses_id}|g" -e "s|S3BIDSPATH|${s3_bids_path}|g" -e "s|WB_COMMAND|${wb_command_path}|g" -e "s|FD_THRESHOLD|${fd_threshold}|g" -e "s|REPETITION_TIME|${repetition_time}|g" -e "s|MINUTES_LIMIT|${minutes_limit}|g" -e "s|OUTPUT_DIR|${output_dir}|g"  ${run_folder}/${TM_template} > ${run_files_folder}/run${k}
				k=$((k+1))
			fi
		done
	fi
done

chmod 775 -R ${run_files_folder}


sed -e "s|GROUP|${group}|g" -e "s|EMAIL|${email}|g" -i ${run_folder}/resources_TM_run.sh 

