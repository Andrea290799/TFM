#!/bin/bash
# -*- ENCODING: UTF-8 -*-

# Genome indexes are generated
STAR --runThreadN 40 --runMode genomeGenerate --genomeDir Indexes --genomeFastaFiles Datos/hg38.fa --sjdbGTFfile Datos/hg38.refGene.gtf --sjdbOverhang 149


# C vs M
./rmats_turbo_v4_1_2/run_rmats --s1 control.txt --s2 mild.txt --gtf Datos/hg38.refGene.gtf --bi Indexes/ -t paired --readLength 70 --variable-read-length --nthread 40 --novelSS --od od_dir_C_ICS --tmp tmp_dir_C_ICS

# C vs S
./rmats_turbo_v4_1_2/run_rmats --s1 control.txt --s2 severe.txt --gtf Datos/hg38.refGene.gtf --bi Indexes/ -t paired --readLength 70 --variable-read-length --nthread 40 --novelSS --od od_dir_C_UC --tmp tmp_dir_C_UC

# M vs S
./rmats_turbo_v4_1_2/run_rmats --s1 mild.txt --s2 severe.txt --gtf Datos/hg38.refGene.gtf --bi Indexes/ -t paired --readLength 70 --variable-read-length --nthread 40 --novelSS --od od_dir_ICS_UC --tmp tmp_dir_ICS_UC

# We filter alternative splicing analysis by rMATS results to select the significative events
./filter.sh od_dir_C_ICS/
./filter.sh od_dir_C_UC/
./filter.sh od_dir_ICS_UC/


# Sashimi plots 
./sashimiplots.sh to_sashimi_C_ICS/ C_ICS
./sashimiplots.sh to_sashimi_C_UC/ C_UC
./sashimiplots.sh to_sashimi_ICS_UC/ ICS_UC

# Preparing files for performing GSEA analysis
./to_GSEA.sh od_dir_C_ICS/
./to_GSEA.sh od_dir_C_UC/
./to_GSEA.sh od_dir_ICS_UC/


