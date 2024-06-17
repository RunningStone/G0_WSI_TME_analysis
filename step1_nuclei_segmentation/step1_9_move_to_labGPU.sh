#!/bin/bash

# 定义索引文件路径
INDEX_FILE="path_to_index_file.csv"

# 定义远程服务器信息
REMOTE_USER="adaada"
REMOTE_SERVER="128.40.179.170"
REMOTE_DIR="~/Experiments/DATA/BRCA/nuclei_cellvit/"

# 读取索引文件中的处理结果文件夹位置
mapfile -t processed_folders < <(awk -F',' 'NR>1 {print $6}' "$INDEX_FILE")

# 使用rsync传输文件，支持断点续传
for folder in "${processed_folders[@]}"
do
    if [ -d "$folder" ]; then
        echo "Transferring $folder to $REMOTE_USER@$REMOTE_SERVER:$REMOTE_DIR"
        rsync -avz --progress "$folder" "$REMOTE_USER@$REMOTE_SERVER:$REMOTE_DIR"
    else
        echo "Warning: $folder does not exist or is not a directory"
    fi
done

echo "All files have been transferred."
