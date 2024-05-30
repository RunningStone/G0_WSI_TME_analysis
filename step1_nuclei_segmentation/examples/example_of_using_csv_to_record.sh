# 定义CSV文件路径
CSV_FILE="/home/ucbtsp5/Scratch/24Exp01_CellViT_seg/G0_WSI_TME_analysis/step1_nuclei_segmentation/data/BRCA_files_index.csv"
SGE_TASK_ID=2
# 提取对应行号的yaml文件路径
YAML_FILE_PATH=$(awk -F',' -v row="$SGE_TASK_ID" 'NR == row {print $7}' "$CSV_FILE")

# 检查是否成功提取到yaml文件路径
if [ -z "$YAML_FILE_PATH" ]; then
  echo "Error: Could not find yaml file path for SGE_TASK_ID $SGE_TASK_ID"
  exit 1
fi

echo "Using config file: $YAML_FILE_PATH"