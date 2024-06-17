import os
import pandas as pd
import yaml
from pathlib import Path

log_folder_path = "/home/ucbtsp5/Scratch/24Exp01_CellViT_seg/OUTPUT"
index_file_path = "/home/ucbtsp5/Scratch/24Exp01_CellViT_seg/DATA/BRCA_files_index_1.csv"

# 读取index文件
df_index = pd.read_csv(index_file_path)

# 新建一个dataframe来记录需要重新运行的文件
need_rerun = pd.DataFrame(columns=df_index.columns)

# 遍历index文件中的每一行
for index, row in df_index.iterrows():
    yaml_file_path = row['yaml_file_path']  # 假设index文件中有yaml文件路径这一列

    result_folder_path = Path(yaml_file_path).parent  # 假设yaml文件路径是一个文件夹，这里获取其父文件夹路径

    # 在预处理结果文件夹中寻找processed json文件
    processed_file_path = os.path.join(result_folder_path, 'processed.json')
    
    if os.path.exists(processed_file_path):
        # 如果找到了processed json文件，则更新index文件
        df_index.at[index, 'processing_started'] = True
        df_index.at[index, 'processing_completed'] = True
    else:
        # 如果没有找到processed json文件，则将对应行添加到need_rerun中
        need_rerun = need_rerun.append(row)

# 保存更新后的index文件
df_index.to_csv(index_file_path, index=False)

# 保存need_rerun文件
need_rerun_file_path = os.path.join(os.path.dirname(index_file_path), 'need_rerun.csv')
need_rerun.to_csv(need_rerun_file_path, index=False)

print("Processing completed.")
