args <- commandArgs(trailingOnly = TRUE)

BD <- read.table(args[1] ,header = TRUE)

# Inclusion Levels of each patient
BD$IncL1 <- strsplit(BD$IncLevel1, ",") 
BD$IncL2 <- strsplit(BD$IncLevel2, ",") 

# Inclusion Levels mean
for (i in 1:nrow(BD)){
  
  BD$IL1_mean[i] = mean(as.numeric(BD$IncL1[[i]]))
  BD$IL2_mean[i] = mean(as.numeric(BD$IncL2[[i]]))
  
}

BD <- na.omit(BD)

for (i in 1:nrow(BD)){
  
  # Inclusion Levels mean and FDR minimum values/1000
  min_1 = min(BD$IL1_mean[which(BD$IL1_mean != 0)])/1000
  min_2 = min(BD$IL2_mean[which(BD$IL2_mean != 0)])/1000
  
  min_fdr = min(BD$FDR[which(BD$FDR != 0)])/1000
    
  BD$IL1_mean_mod[i] =  BD$IL1_mean[i]
  BD$IL2_mean_mod[i] =  BD$IL2_mean[i]
  
  # If the mean value is 0, the minimum value/1000 is assigned
  if (BD$IL1_mean[i] == 0){
    BD$IL1_mean_mod[i] = min_1
  } else if (BD$IL2_mean[i] == 0){
    BD$IL2_mean_mod[i] = min_2
  }
  
  BD$FDR_mod[i] =  BD$FDR[i]
  
  if (BD$FDR[i] == 0){
    BD$FDR_mod[i] = min_fdr
  } 
  
}

# We calculate the metric value
BD$SIG <- (log2(as.numeric(BD$IL2_mean_mod)/as.numeric(BD$IL1_mean_mod)))*(-log10(BD$FDR_mod))

# We assign 0 to metric value if FDR is higher than 0.05
for (i in 1:nrow(BD)){
  if (BD$FDR[i] > 0.05){
    BD$SIG[i] <- 0
  }
}

BD_unique <- as.data.frame(unique(BD$GeneID))

# There are duplicate entries, so we select the one with higer absolute value of the metric
BD_unique$SIG <- 0
for (i in 1:nrow(BD_unique)){

    a <- na.omit(BD[which(BD$GeneID==BD_unique[i,1]),])
    BD_unique[i,2] <- a$SIG[which(abs(as.numeric(a$SIG)) ==  max(abs(as.numeric(a$SIG))))][1]

}

BD_unique <- na.omit(BD_unique)
write.table(BD_unique, file = paste("to_GSEA/", args[2], sep =""))




