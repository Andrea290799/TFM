# Fusion transcript analysis

Once the data is preprocessed, the fusion transcripts analysis can be performed. 

## _STAR-Fusion.sh_

This script develops the next functions:
- Detecting the fusion transcripts present in each sample using STAR-Fusion software. Results are stored in `STAR_Fusion_output`. 

**USAGE**
~~~
$ STAR-Fusion.sh
~~~ 

## _fusions_filtering.R_

This script develops the next functions:
- Fuse together in a matrix the transcript fusions detected of each patient with information about presence, absence and coding effect. 

**USAGE**
~~~
$ fusions_filtering.R
~~~ 


** You have to take into account the neccessary changes in paths, file names and variables for the script to properly work

