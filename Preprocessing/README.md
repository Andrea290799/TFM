# Data preprocessing
Once the pair-end-reads files resulting from RNA-analisys are obtained, data preprocessing to increase the sample quality is needed.

## _Preprocess.sh_

This script carries out the following tasks:

- Quality analisys pre-preprocessing with FastQC (results in `fastqc_results_pre_preprocessing`)
- Merging the pair-end-reads files with `merge-paired-reads.sh`
- Removing rRNAS in case that there are contaminations with SortMeRNA software
- Unmerging the pair-end-reads files with `unmerge-paired-reads.sh`
- Trimming adapters with BBDuk software
- Finding and removing adapter sequences, primers, poly-A tails and other types of unwanted sequences with Cutadapt software
- Quality analisys post-preprocessing with FastQC (results in `fastqc_results_post_preprocessing`)

**USAGE**
~~~
$ Preprocess.sh
~~~ 

** You have to take into account the neccessary changes in paths, file names and variables for the script to properly work


