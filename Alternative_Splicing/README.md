This folder contains the scripts and results of this alternative splicing events analysis. 

SCRIPTS:
  pipeline.sh: it is the main script. It contains all the steps and commands followed to perform the analysis.
  txt files: they define the patients groups.
  filter.sh: script used to filter the rMATS results (used in the main script).
  sashimiplots.sh: script used to plot the alternative splicing events found. 
  to_GSEA.sh: script that prepares the output files to run a GSEAPreranked. 
  GSEA.R: script used by the latter for preparing the output files to run a GSEAPreranked. 

RESULTS:
  GSEA_results: the GSEA significant results for each patients' comparative in those events where there are significant results.
  rMATS_output: relevant rMATS output for each patients' comparative.
  rMATS_output_filtered: relevant rMATS output for each patients' comparative after filtering. 
  sashimiplots_examples: pictures used in the TFM manuscript. 
  to_GSEA_JC: preranked gene lists (GSEA inputs) for each event in each comparative. Only JC reads are considered. 

GROUPS NOMENCLATURE:
  C: control |
  ICS: mild |
  UC: severe 
