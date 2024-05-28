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


# 8. Run the application.
module load python3/3.9-gnu-10.2.0
module load openjpeg/2.4.0/gnu-4.9.2
module load openslide/3.4.1/gnu-4.9.2

source ~/cellvit/bin/activate

python3 ~/CellViT/preprocessing/patch_extraction/main_extraction.py --config ~/CellViT/example/preprocessing_example.yaml
