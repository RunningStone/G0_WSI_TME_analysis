#!/bin/bash -l

# Batch script to run an OpenMP threaded job under SGE.

# Request ten minutes of wallclock time (format hours:minutes:seconds).
#$ -l h_rt=35:59:59

# Request 1 gigabyte of RAM for each core/thread 
# (must be an integer followed by M, G, or T)
#$ -l tmem=32G

# Request GPU
#$ -l gpu=True

# Set the name of the job.
#$ -N USARC_preprocessing

#$ -m be

#$ -M jianan.c@ucl.ac.uk

# 8. Run the application.
source /share/apps/source_files/python/python-3.9.5.source

source /home/jianchen/cellvit/bin/activate

export LD_LIBRARY_PATH=/share/apps/openslide-3.4.1/lib:$LD_LIBRARY_PATH

python3 /home/jianchen/CellViT/preprocessing/patch_extraction/main_extraction.py --config /home/jianchen/CellViT/example/preprocessing_example.yaml