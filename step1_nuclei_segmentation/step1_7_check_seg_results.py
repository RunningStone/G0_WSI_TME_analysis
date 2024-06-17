import os
import pandas as pd

# 读取index文件
index_file_path = '/home/ucbtsp5/Scratch/24Exp01_CellViT_seg/DATA/BRCA_files_index_1.csv'  # 请替换为你的index文件路径
not_preprocessed_index = "/home/ucbtsp5/Scratch/24Exp01_CellViT_seg/DATA/need_rerun_index_1.csv"

output_file_path = '/home/ucbtsp5/Scratch/24Exp01_CellViT_seg/DATA/seg_check_index_1.csv'  # 请替换为你希望保存结果的路径
output_file_path2 = '/home/ucbtsp5/Scratch/24Exp01_CellViT_seg/DATA/seg_rerun_index_1.csv'  # 请替换为你希望保存结果的路径

df = pd.read_csv(index_file_path)

df_not_preprocess = pd.read_csv(not_preprocessed_index)
# 创建未处理文件名的集合用于快速查找
not_preprocessed_files = set(df_not_preprocess['file_name'])

# 定义要检查的文件路径的函数
def check_file_existence(row):
    base_path = row['processed_file_location']
    file_name = row['file_name']
    check_path = os.path.join(base_path, file_name, 'cell_detection', '40x256', 'cell_detection.json')
    return os.path.exists(check_path), check_path

# 遍历每一行，检查文件是否存在
results_all = []
results_rerun = []
for _, row in df.iterrows():
    exists, path = check_file_existence(row)
    if not exists:
        #在这里增加额外的判断条件，如果是preprocess失败的文件preprocess_status为False
        preprocess_status = row['file_name'] not in not_preprocessed_files
        if preprocess_status:
            # 预处理成功了但是文件不存在的情况放入rerun文件中
            results_rerun.append({
                'folder_name': row['folder_name'],
                'file_name': row['file_name'],
                "full_path":row['full_path'],
                "processed_file_location": row['processed_file_location'],
                'seg_file_path': path,
            })
        results_all.append({
            'folder_name': row['folder_name'],
            'file_name': row['file_name'],
            "full_path":row['full_path'],
            "processed_file_location": row['processed_file_location'],
            'seg_file_path': path,
            'exists': exists,
            "preprocess_status":preprocess_status,
        })

# 将结果转换为DataFrame并保存为新的CSV文件
results_df = pd.DataFrame(results_all)
results_df.to_csv(output_file_path, index=False)

results_rerun_df = pd.DataFrame(results_rerun)
results_rerun_df.to_csv(output_file_path2, index=False)
# 打印检查结果
print("检查结果已保存到:", output_file_path, output_file_path2)
