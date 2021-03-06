#!/bin/bash

set -euxo pipefail

apt update
apt install unzip

TEST_DIR=/tmp/testrun/

mkdir -p $TEST_DIR

cd $TEST_DIR

wget https://uni-muenster.sciebo.de/s/7vpqRSEATYcvlnP/download

unzip download

conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
conda install --yes --name base wg-blimp
#conda install --yes --name base 'snakemake-minimal>=5.8' click ruamel.yaml r-base r-shiny r-shinydashboard r-data.table r-ggplot2 r-htmlwidgets r-dt r-httpuv h5py pysam
conda clean --all --yes

#git clone --recursive https://github.com/MarWoes/wg-blimp /root/wg-blimp
#pip install /root/wg-blimp

cd $TEST_DIR
wg-blimp create-config --cores-per-job 4 fastq chr22.fasta blood1,blood2 sperm1,sperm2 results config.yaml
wg-blimp run-snakemake-from-config --cores=4 --dry-run config.yaml
wg-blimp run-snakemake-from-config --cores=4 config.yaml

cd /
rm -rf $TEST_DIR
