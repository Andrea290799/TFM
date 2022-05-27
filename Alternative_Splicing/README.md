# Alternative splicing analysis

Once the data is preprocessed, the alternative splicing analysis can be performed. 

## _pipeline.sh_

This is the main script that develops the next functions:
- Generating genome indexes with STAR software
- Getting the alternative splicing results for patients comparisons with rMATS software. You need to indicate which patients belong to each group in the analysed comparative (`control.txt`, `mild.txt` and `severe.txt`). Results are stored in `rMATS_output` directory. Inside, there is a results folder per patients comparative, and there, there are 2 files per event (JC and JCEC, we only consider JC), a grouping file (needed for sashimi plots) and a data summary. 
- Filtering the rMATS output with `filetr.sh` to keep only those alternative splicing events that are significative, stored in `rMATS_output_filtered`. Inside, there is a results folder per patients comparative, and there, there are 4 filtered files per event (there are 2 for JC and other 2 for JCEC: one considering FDR for filtering and the other considering FDR and the inclusion level). 
- Getting the sashimi plots of siginficative alternative splicing events with `sashimiplots.sh`. Some examples are in `sashimiplots_examples` directory. 
- Creating a genes affected by differential splicing ranked list to perform a GSEA analysis with `to_GSEA.sh` that in turn uses `GSEA.R` script. Generated ranked lists are in `to_GSEA_JC` directory. GSEA results are in `GSEA_results` directory. 


**USAGE**
~~~
$ pipeline.sh
~~~ 

** You have to take into account the neccessary changes in paths, file names and variables for the script to properly work
