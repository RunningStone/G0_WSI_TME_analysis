#!/bin/bash -l

# Batch script to run an OpenMP threaded job under SGE.

# Request ten minutes of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=3:00:00

# Request 1 gigabyte of RAM for each core/thread 
# (must be an integer followed by M, G, or T)
#$ -l tmem=32G

# Request GPU
#$ -l gpu=True

# Set the name of the job.
#$ -N USARC_3907

# 8. Run the application.
source /share/apps/source_files/python/python-3.9.5.source

source /home/jianchen/cellvit/bin/activate

export LD_LIBRARY_PATH=/share/apps/openslide-3.4.1/lib:$LD_LIBRARY_PATH

python /home/jianchen/CellViT/cell_segmentation/inference/cell_detection.py --batch_size=1 --model /SAN/colcc/sarcoma_bloodcancer_raw/ploidy/model/CellViT-SAM-H-x40.pth --gpu 0 --geojson process_wsi --wsi_path /SAN/colcc/sarcoma_bloodcancer_raw/ploidy/usarc_he/RNOH_1_6_S00133907_162309.svs --patched_slide_path /SAN/colcc/sarcoma_bloodcancer_raw/ploidy/usarc_he_processed/RNOH_1_6_S00133907_162309