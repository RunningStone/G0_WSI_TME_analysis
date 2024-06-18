#!/bin/bash -l

# Batch script to run a serial array job under SGE.

# Request ten minutes of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=48:00:00

# Request 1 gigabyte of RAM for each core/thread 
# (must be an integer followed by M, G, or T)
#$ -l mem=5G

# Request GPU
#$ -l gpu=1

# Request shared memory parallel
#$ -pe smp 8

# Request temp space
#$ -l tmpfs=15G 

# Set up the job array.  In this instance we have requested 10000 tasks
# numbered 2 to 1012. line 1 is name of columns
#$ -t 2-501

# Set the name of the job.
#$ -N BRCA_seg

# Set the working directory to somewhere in your scratch space. 
# Replace "<your_UCL_id>" with your UCL user ID :)
#$ -wd /home/ucbtsp5/Scratch/24Exp01_CellViT_seg/OUTPUT/cellvit_step1_3/

# Run the application.

echo "$JOB_NAME $SGE_TASK_ID"



# 8. Run the application.
module load python3/3.9
module load openjpeg/2.4.0/gnu-4.9.2
module load openslide/3.4.1/gnu-4.9.2

#source ~/cellvit/bin/activate


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
CSV_FILE="/home/ucbtsp5/Scratch/24Exp01_CellViT_seg/DATA/BRCA_files_index_1.csv"
# 提取对应行号的文件路径
WSI_FILE_PATH=$(awk -F',' -v row="$SGE_TASK_ID" 'NR == row {print $3}' "$CSV_FILE")
PATCH_FILE_PATH=$(awk -F',' -v row="$SGE_TASK_ID" 'NR == row {print $6}' "$CSV_FILE")


# 检查是否成功提取到yaml文件路径
if [ -z "$WSI_FILE_PATH" ]; then
  echo "Error: Could not find wsi file path for SGE_TASK_ID $SGE_TASK_ID"
  exit 1
fi

# 检查是否成功提取到yaml文件路径
if [ -z "$PATCH_FILE_PATH" ]; then
  echo "Error: Could not find patch file path for SGE_TASK_ID $SGE_TASK_ID"
  exit 1
fi

# 获取PATCH_FILE_PATH的最后一个文件名
DIR_NAME=$(basename "$(basename "$PATCH_FILE_PATH")")

# 构建新的PATCH_FILE_PATH
PATCH_FILE_PATH="${PATCH_FILE_PATH}/${DIR_NAME}"

echo "Using wsi file: $WSI_FILE_PATH"
echo "Using patch file: $PATCH_FILE_PATH"
# 更新CSV文件，将processing_started列设置为True
#awk -F',' -v row="$SGE_TASK_ID" 'BEGIN{OFS=","} NR == row {$4="True"} 1' "$CSV_FILE" > temp && mv temp "$CSV_FILE"


cd /home/ucbtsp5/Scratch/24Exp01_CellViT_seg/G0_WSI_TME_analysis/step1_nuclei_segmentation/

python3 ./CellViT/cell_segmentation/inference/cell_detection.py \
  --model /home/ucbtsp5/Scratch/24Exp01_CellViT_seg/PRETRAINED/cellvit/CellViT-256-x40.pth\
  --gpu 0 \
  --geojson \
  --outdir_subdir 40x256 \
  process_wsi \
  --wsi_path "$WSI_FILE_PATH" \
  --patched_slide_path "$PATCH_FILE_PATH"

