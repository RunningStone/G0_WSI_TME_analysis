cd /repo/location/
cd ./G0_WSI_TME_analysis/step0_download_TCGA/

# get manifast file from GDC portal 
# https://portal.gdc.cancer.gov/projects/TCGA-BRCA

# Download TCGA data
./gdc-client download -m /repo/location/G0_WSI_TME_analysis/step0_download_TCGA/TCGA-BRCA.manifest.txt \
                      -d /save/folder/location/TCGA-BRCA

