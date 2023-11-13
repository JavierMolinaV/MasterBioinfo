#!/bin/bash

#Directory structure obtained from my GitHub with files containing URL to download the human proteome and the MS data
git clone https://github.com/JavierMolinaV/MasterBioinfo.git

cd MasterBioinfo/jmv-proteomics/

mkdir Resources/proteome

#Obtain the .mgf files from ftp
wget -i Data/human_experiments_ftp.txt -P Data/Human-MS/

#Obtain the human proteome from UniProt
wget -i Resources/human_proteome.fasta -O Resources/proteome/human.fasta.gz
gunzip Resources/proteome/human.fasta.gz

#Create decoy peptides and merge decoys with human peptides
decoypyrat Resources/proteome/human.fasta -o Resources/proteome/human.decoy.fasta --decoy_prefix DECOY
cat Resources/proteome/human.fasta Resources/proteome/human.decoy.fasta > Resources/proteome/human.target-decoy.fasta

mkdir -p output/comet

#Peptide search against peptide-decoy file
crux comet --output-dir output/comet --overwrite T --output_txtfile 0 Data/Human-MS/*.mgf Resources/proteome/human.target-decoy.fasta

mkdir -p output/assign-confidence
mkdir -p output/percolator

#Confidence evaluation with assign-confidence and percolator
crux assign-confidence --output-dir output/assign-confidence --overwrite T --decoy-prefix DECOY_ output/comet/*.pep.xml
crux percolator --output-dir output/percolator --overwrite T --decoy-prefix DECOY_ output/comet/*.pep.xml








