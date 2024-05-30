#!/bin/bash -l

# Batch script to run an OpenMP threaded job under SGE.

# Request ten minutes of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=3:00:00

# Request 1 gigabyte of RAM for each core/thread 
# (must be an integer followed by M, G, or T)
#$ -l tmem=32G

# Request GPU
#$ -l gpu=1

# Set the name of the job.
#$ -N USARC_3907

# 8. Run the application.
module load python3/3.9-gnu-10.2.0
module load openjpeg/2.4.0/gnu-4.9.2
module load openslide/3.4.1/gnu-4.9.2

source ~/cellvit/bin/activate

python3 ~/CellViT/cell_segmentation/inference/cell_detection.py --batch_size=1 --model PATH_TO_MODEL/CellViT-SAM-H-x40.pth --gpu 0 --geojson process_wsi --wsi_path PATH_TO_DATA/SLIDE_NAME.svs --patched_slide_path PATH_TO_DATA/processed/SLIDE_NAME
