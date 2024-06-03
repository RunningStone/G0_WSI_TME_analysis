#!/bin/bash -l

# Batch script to run a serial array job under SGE.

# Request ten minutes of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=03:59:59

# Request 1 gigabyte of RAM for each core/thread 
# (must be an integer followed by M, G, or T)
#$ -l mem=32G

# Request GPU
#$ -l gpu=False

# Set up the job array.  In this instance we have requested 10000 tasks
# numbered 2 to 1012. line 1 is name of columns
#$ -t 2-72

# Set the name of the job.
#$ -N CellViT_BRCA

# Set the working directory to somewhere in your scratch space. 
# Replace "<your_UCL_id>" with your UCL user ID :)
#$ -wd /home/ucbtsp5/Scratch/24Exp01_CellViT_seg/OUTPUT/cellvit_step1_2/part1/

# Run the application.

echo "$JOB_NAME $SGE_TASK_ID"



# 8. Run the application.
module load python3/3.9
module load openjpeg/2.4.0/gnu-4.9.2
module load openslide/3.4.1/gnu-4.9.2

source ~/cellvit/bin/activate


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('$HOME/Scratch/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/Scratch/anaconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/Scratch/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/Scratch/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
source ~/.bashrc
which conda
conda activate cellvit_env


# 定义CSV文件路径
CSV_FILE="/home/ucbtsp5/Scratch/24Exp01_CellViT_seg/DATA/need_rerun.csv"

# 提取对应行号的yaml文件路径
YAML_FILE_PATH=$(awk -F',' -v row="$SGE_TASK_ID" 'NR == row {print $7}' "$CSV_FILE")

# 检查是否成功提取到yaml文件路径
if [ -z "$YAML_FILE_PATH" ]; then
  echo "Error: Could not find yaml file path for SGE_TASK_ID $SGE_TASK_ID"
  exit 1
fi

echo "Using config file: $YAML_FILE_PATH"
# 更新CSV文件，将processing_started列设置为True
#awk -F',' -v row="$SGE_TASK_ID" 'BEGIN{OFS=","} NR == row {$4="True"} 1' "$CSV_FILE" > temp && mv temp "$CSV_FILE"


cd /home/ucbtsp5/Scratch/24Exp01_CellViT_seg/G0_WSI_TME_analysis/step1_nuclei_segmentation/

python3 ./CellViT/preprocessing/patch_extraction/main_extraction.py --config "$YAML_FILE_PATH"
