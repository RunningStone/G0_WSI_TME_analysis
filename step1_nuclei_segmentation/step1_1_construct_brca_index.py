import os
import pandas as pd
from pathlib import Path
# 定义文件路径
base_dir = "/home/ucbtsp5/Scratch/data/BRCA/TCGA-BRCA"
output_csv_dir = "/home/ucbtsp5/Scratch/24Exp01_CellViT_seg/DATA/"
out_csv_name = "BRCA_files_index" # csv
cellvit_nuclei_dir = "/home/ucbtsp5/Scratch/data/BRCA/CellViT_Nuclei/"
yaml_template_path = '/home/ucbtsp5/Scratch/24Exp01_CellViT_seg/G0_WSI_TME_analysis/step1_nuclei_segmentation/CellViT/example/preprocessing_example.yaml'

import os
from pathlib import Path
import pandas as pd
import yaml

# 定义文件夹路径
base_dir = Path(base_dir)
#output_csv_path = Path(output_csv)
cellvit_base_dir = Path(cellvit_nuclei_dir)
yaml_template_path = Path(yaml_template_path)

# 创建 CellViT_Nuclei 基础目录（如果不存在）
cellvit_base_dir.mkdir(parents=True, exist_ok=True)

# 遍历所有子文件夹并找到所有的svs文件
data = []

for folder in base_dir.iterdir():
    if folder.is_dir():
        for svs_file in folder.glob('*.svs'):
            file_name = svs_file.stem  # 文件名（不带.svs的部分）
            folder_name = folder.name  # 文件夹名称
            full_path = str(svs_file)  # 完整文件路径
            process_folder = cellvit_base_dir / folder_name / file_name
            
            # 创建必要的文件夹
            process_folder.mkdir(parents=True, exist_ok=True)
            
            # 配置yaml文件路径
            yaml_output_path = process_folder / 'preprocess_config.yaml'
            
            # 读取yaml模板文件并填入新的路径
            with open(yaml_template_path, 'r') as yaml_file:
                config = yaml.safe_load(yaml_file)
                
            config['wsi_paths'] = str(full_path)
            config['output_path'] = str(process_folder)
            
            # 保存新的yaml文件
            with open(yaml_output_path, 'w') as yaml_file:
                yaml.safe_dump(config, yaml_file)
            
            # 将信息添加到数据列表中
            data.append({
                'folder_name': folder_name,
                'file_name': file_name,
                'full_path': full_path,
                'processing_started': False,
                'processing_completed': False,
                'processed_file_location': str(process_folder),
                'yaml_file_path': str(yaml_output_path)
            })

# 创建DataFrame并保存为CSV文件
df = pd.DataFrame(data)
output_csv_path = f'{output_csv_dir}/{out_csv_name}_all.csv'
df.to_csv(output_csv_path, index=False)
# 分批次保存每400个项目为一个文件
batch_size = 500
num_batches = (len(df) // batch_size) + 1

for i in range(num_batches):
    start_idx = i * batch_size
    end_idx = start_idx + batch_size
    batch_df = df[start_idx:end_idx]
    
    output_csv_path = f'{output_csv_dir}/{out_csv_name}_{i+1}.csv'
    batch_df.to_csv(output_csv_path, index=False)