# List of all fusion analysis output directories
dirs <-list.files(pattern = "\\PL-")

col_names <- c()

all_fusions <- c()
all_coding_effects <- c()
all_patients <- c()

all_LBs <- c()
all_RBs <- c()

for (dir in dirs){
  name <- substr(dir, start = 1, stop = 5)
  col_names <- c(col_names, name) #patients are columns
  
  BD <- read.table(paste(dir,"star-fusion.fusion_predictions.abridged.coding_effect.tsv", sep ="/"), header = FALSE)
  fusions <- BD[,1]
  all_fusions <- c(all_fusions, BD[,1])
  all_LBs <- c(all_LBs, BD[,8])
  all_RBs <- c(all_RBs, BD[,10])
  all_coding_effects <- c(all_coding_effects, BD[,22])
  all_patients <- c(all_patients, rep(name, length(fusions)))
}

# Name and chromosomic positions are fused
all_fusions2 <- c()
for (i in 1:length(all_fusions)){
  all_fusions2 <- c(all_fusions2, paste(all_fusions[i], all_LBs[i], all_RBs[i], sep = "_"))
}

row_names <- unique(all_fusions2)

matriz <-matrix (nrow = length(row_names), ncol = length(col_names))
rownames(matriz) <- row_names
colnames(matriz) <- col_names

for(i in 1:length(all_fusions2)){
  matriz[all_fusions2[i], all_patients[i]] <- all_coding_effects[i]
}

write.table(matriz, file = "fusions.tsv", quote = FALSE, col.names = FALSE)
