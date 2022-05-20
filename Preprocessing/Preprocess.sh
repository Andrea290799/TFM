#!/bin/bash


merge="../../../home/tarr/Documentos/Bioinfo/Scripts/merge-paired-reads.sh"

bac16s="../../../usr/local/bin/sortmerna-2.1/rRNA_databases/silva-bac-16s-id90.fasta"
ibac16s="../../../usr/local/bin/sortmerna-2.1/index/silva-bac-16s-db"
bac23s="../../../usr/local/bin/sortmerna-2.1/rRNA_databases/silva-bac-23s-id98.fasta"
ibac23s="../../../usr/local/bin/sortmerna-2.1/index/silva-bac-23s-db"
arc16s="../../../usr/local/bin/sortmerna-2.1/rRNA_databases/silva-arc-16s-id95.fasta"
iarc16s="../../../usr/local/bin/sortmerna-2.1/index/silva-arc-16s-db"
arc23s="../../../usr/local/bin/sortmerna-2.1/rRNA_databases/silva-arc-23s-id98.fasta"
iarc23s="../../../usr/local/bin/sortmerna-2.1/index/silva-arc-23s-db"
euk18s="../../../usr/local/bin/sortmerna-2.1/rRNA_databases/silva-euk-18s-id95.fasta"
ieuk18s="../../../usr/local/bin/sortmerna-2.1/index/silva-euk-18s-db"
euk28s="../../../usr/local/bin/sortmerna-2.1/rRNA_databases/silva-euk-28s-id98.fasta"
ieuk28s="../../../usr/local/bin/sortmerna-2.1/index/silva-euk-28s"
rfam5s="../../../usr/local/bin/sortmerna-2.1/rRNA_databases/rfam-5s-database-id98.fasta"
irfam5s="../../../usr/local/bin/sortmerna-2.1/index/rfam-5s-db"
rfam58s="../../../usr/local/bin/sortmerna-2.1/rRNA_databases/rfam-5.8s-database-id98.fasta"
irfam58s="../../../usr/local/bin/sortmerna-2.1/index/rfam-5.8s-db"

unmerge="../../../home/tarr/Documentos/Bioinfo/Scripts/unmerge-paired-reads.sh"

bbdukres="../../../usr/local/bin/bbmap/resources"

bbduk="../../../usr/local/bin/bbmap/"

output_dir="./Datos_preprocesados/"

clean_dir= "./Datos_clean/"


# We get all the file names (sample names)
file_names=()
for i in ls Datos/R*
do

    name=$(echo $i | cut -c14-26)
    file_names+=( $name )

done


uniqs_arr=($(for ip in "${file_names[@]}"; do echo "${ip}"; done | sort -u))

# We get the 2 files per sample (pair-end reads)
for i in ${uniqs_arr[@]}
do 

    n=0
    for j in Datos/*$i*
    do
        sample[n]=$j
        n=$(expr 1 + $n)
    done

	name=$(echo ${sample[1]} | cut -c14-26)
	
	## Quality analysis of the sequences
	
	fastqc -t 8 \
	${sample[0]} ${sample[1]} \
	-o fastqc_results

	## merge pair reads

	sh ${merge} ${sample[0]} \
	${sample[1]} \
	${output_dir}${name}.fastq

	## remove rRNAS in case that there are contaminations 
	
	sortmerna --ref \
	${bac16s},${ibac16s}:${bac23s},${ibac23s}:${arc16s},${iarc16s}:${arc23s},${iarc23s}:${euk18s},${ieuk18s}:${euk28s},${ieuk28s}:${rfam5s},${irfam5s}:${rfam58s},${irfam58s} \
	--reads ${output_dir}${name}.fastq --fastx --num_alignments 1 -m 64000 \
	--aligned ${output_dir}${name}_rRNA --other ${output_dir}${name}_non_rRNA \
	-a 40 --paired_in -v --log	

	## unmerge

	sh ${unmerge} ${output_dir}${name}_non_rRNA.fastq \
	${output_dir}${name}_1_sort.fastq \
	${output_dir}${name}_2_sort.fastq 
	
	##trimming adapters (r)
		
	${bbduk}/bbduk.sh in1=${output_dir}${name}_1_sort.fastq \
	in2=${output_dir}${name}_2_sort.fastq \
	ref=${bbdukres}/adapters.fa \
	out1=${output_dir}clean1_r_.SMR.${name}.fastq \
	out2=${output_dir}clean2_r_.SMR.${name}.fastq \
	tbo 

	##trimming adapters (l)
		
	${bbduk}/bbduk.sh threads=40 in1=${output_dir}clean1_r_.SMR.${name}.fastq \
	in2=${output_dir}clean2_r_.SMR.${name}.fastq \
	ref=${bbdukres}/adapters.fa \
	out1=${output_dir}clean1.SMR.${name}.fastq \
	out2=${output_dir}clean2.SMR.${name}.fastq \
	tbo 



	#Pre-processing files (Q=20 y m=40)

	cutadapt --cores=40 -q 20,20 --pair-filter=any -m 40 \
	--output=${clean_dir}out.${name}.1_Q20.SMR.fastq \
	--paired-output=${clean_dir}out.${name}.2_Q20.SMR.fastq \
	${output_dir}clean1.SMR.${name}.fastq\
	${output_dir}clean2.SMR.${name}.fastq

			
	## Quality analysis of the sequences after preprocessing
	
	fastqc -t 8 \
	${clean_dir}out.${name}.1_Q20.SMR.fastq ${clean_dir}out.${name}.2_Q20.SMR.fastq \
	-o fastqc_results_post_preprocessing

		
done




