#!/bin/bash

#This script was executed on a HPCC using a slurm script to assign KEGG orthologue numbers to predicted genes identified on contigs using Prodigal during the assembly based analysis (Source:https://academic.oup.com/bioinformatics/article/36/7/2251/5631907)

./exec_annotation -f mapper --profile=./profiles --ko-list=ko_list -o all_kos_cohort1.txt --cpu=1 prodigal_predicted_amino_acid_sequences.faa
