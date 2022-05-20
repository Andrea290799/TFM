#!/bin/bash
# -*- ENCODING: UTF-8 -*-

# We get all the file names (sample names)
file_names=( )

for file in Datos_clean/*
do
    name=$(echo $file | rev | cut -c14- | rev)
    file_names+=(${name})

done

uniqs_arr=($(for ip in "${file_names[@]}"; do echo "${ip}"; done | sort -u))

# We get the 2 files per sample (pair-end reads)
for name in ${uniqs_arr[@]}
do
    samples=()
    file=*$name* 
    for i in $file 
    do
        samples+=($i)
    done

    sample=$(echo $name | cut -c13-)

    $(STAR-Fusion --genome_lib_dir ./GRCh38_gencode_v37_CTAT_lib_Mar012021.plug-n-play/ctat_genome_lib_build_dir \
             --left_fq ${samples[0]} \
             --right_fq ${samples[1]} \
             --output_dir ${sample}_star_fusion_outdir --FusionInspector validate --examine_coding_effect)

done
