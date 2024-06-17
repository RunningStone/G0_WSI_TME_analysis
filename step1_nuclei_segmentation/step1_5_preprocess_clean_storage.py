import os
import shutil
import pandas as pd
from pathlib import Path
import yaml

# 定义索引文件路径
preprocess_index = '/home/ucbtsp5/Scratch/24Exp01_CellViT_seg/DATA/BRCA_files_index_2.csv'

# 读取索引文件
df = pd.read_csv(preprocess_index)

# 获取第二次预处理的输出文件夹路径
folders_to_delete = df['processed_file_location'].tolist()

# 定义yaml模板文件路径
yaml_template_path = '/home/ucbtsp5/Scratch/24Exp01_CellViT_seg/G0_WSI_TME_analysis/step1_nuclei_segmentation/data/preprocessing_example.yaml'

# 删除并重建文件夹，创建preprocess_config.yaml文件
for folder in folders_to_delete:
    process_folder = Path(folder)
    
    # 删除文件夹及其内容
    if process_folder.exists() and process_folder.is_dir():
        print(f"删除文件夹：{process_folder}")
        shutil.rmtree(process_folder)
    
    # 重建文件夹
    process_folder.mkdir(parents=True, exist_ok=True)
    
    # 配置yaml文件路径
    yaml_output_path = process_folder / 'preprocess_config.yaml'
    
    # 读取yaml模板文件并填入新的路径
    with open(yaml_template_path, 'r') as yaml_file:
        config = yaml.safe_load(yaml_file)
        
    # 找到相应的行
    row = df[df['processed_file_location'] == folder].iloc[0]
    full_path = row['full_path']
    
    config['wsi_paths'] = str(full_path)
    config['output_path'] = str(process_folder)
    
    # 保存新的yaml文件
    with open(yaml_output_path, 'w') as yaml_file:
        yaml.safe_dump(config, yaml_file)

print("处理完成。")
