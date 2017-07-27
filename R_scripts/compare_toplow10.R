## This script was used to detect similar genes found in the top 10 and least 10

## Necessary package and library required
source("http://www.bioconductor.org/biocLite.R")
biocLite(pkgs = c("readr"))
library("readr")

##### Reads all necessary files into R variables
Treat_top10 <- read_delim("~/Steered/Github_files/Pipeline5/Treat_top10.csv","\t", escape_double = FALSE, trim_ws = TRUE)
Treat_low10 <- read_delim("~/Steered/Github_files/Pipeline5/Treat_least10.csv","\t", escape_double = FALSE, trim_ws = TRUE)
glmTreat_top10 <- read_delim("~/Steered/Github_files/Pipeline6/glmTreat_top10.csv","\t", escape_double = FALSE, trim_ws = TRUE)
glmTreat_low10 <- read_delim("~/Steered/Github_files/Pipeline6/glmTreat_least10.csv","\t", escape_double = FALSE, trim_ws = TRUE)

######Common genes with most logFC in Pipeline 5
P5top_common_all <-Reduce(intersect,list(Treat_top10$Treat_untrimmed_Rn4,Treat_top10$Treat_trimmed_Rn4,Treat_top10$Treat_untrimmed_Rn6,Treat_top10$Treat_trimmed_Rn6))
P5top_common_Rn4 <-Reduce(intersect,list(Treat_top10$Treat_untrimmed_Rn4, Treat_top10$Treat_trimmed_Rn4))
P5top_common_Rn6 <-Reduce(intersect,list(Treat_top10$Treat_untrimmed_Rn6, Treat_top10$Treat_trimmed_Rn6))
P5top_untrim_Rn4_Rn6<-Reduce(intersect,list(Treat_top10$Treat_untrimmed_Rn4, Treat_top10$Treat_untrimmed_Rn6))
P5top_trim_Rn4_Rn6<-Reduce(intersect,list(Treat_top10$Treat_trimmed_Rn4, Treat_top10$Treat_trimmed_Rn6))

######Common genes with least logFC in Pipeline 5
P5low_common_all <-Reduce(intersect,list(Treat_low10$Treat_untrimmed_Rn4,Treat_low10$Treat_trimmed_Rn4,Treat_low10$Treat_untrimmed_Rn6,Treat_low10$Treat_trimmed_Rn6))
P5low_common_Rn4 <-Reduce(intersect,list(Treat_low10$Treat_untrimmed_Rn4, Treat_low10$Treat_trimmed_Rn4))
P5low_common_Rn6 <-Reduce(intersect,list(Treat_low10$Treat_untrimmed_Rn6, Treat_low10$Treat_trimmed_Rn6))
P5low_untrim_Rn4_Rn6<-Reduce(intersect,list(Treat_low10$Treat_untrimmed_Rn4, Treat_low10$Treat_untrimmed_Rn6))
P5low_trim_Rn4_Rn6<-Reduce(intersect,list(Treat_low10$Treat_trimmed_Rn4, Treat_low10$Treat_trimmed_Rn6))

######Common genes with most logFC in Pipeline 6
P6top_common_all <-Reduce(intersect,list(glmTreat_top10$glmTreat_untrimmed_Rn4, glmTreat_top10$glmTreat_trimmed_Rn4, glmTreat_top10$glmTreat_untrimmed_Rn6, glmTreat_top10$glmTreat_trimmed_Rn6))
P6top_common_Rn4 <-Reduce(intersect,list(glmTreat_top10$glmTreat_untrimmed_Rn4, glmTreat_top10$glmTreat_trimmed_Rn4))
P6top_common_Rn6 <-Reduce(intersect,list(glmTreat_top10$glmTreat_untrimmed_Rn6, glmTreat_top10$glmTreat_trimmed_Rn6))
P6top_untrim_Rn4_Rn6<-Reduce(intersect,list(glmTreat_top10$glmTreat_untrimmed_Rn4, glmTreat_top10$glmTreat_untrimmed_Rn6))
P6top_trim_Rn4_Rn6<-Reduce(intersect,list(glmTreat_top10$glmTreat_trimmed_Rn4, glmTreat_top10$glmTreat_trimmed_Rn6))

######Common genes with least logFC in Pipeline 6
P6low_common_all <-Reduce(intersect,list(glmTreat_low10$glmTreat_untrimmed_Rn4, glmTreat_low10$glmTreat_trimmed_Rn4, glmTreat_low10$glmTreat_untrimmed_Rn6, glmTreat_low10$glmTreat_trimmed_Rn6))
P6low_common_Rn4 <-Reduce(intersect,list(glmTreat_low10$glmTreat_untrimmed_Rn4, glmTreat_low10$glmTreat_trimmed_Rn4))
P6low_common_Rn6 <-Reduce(intersect,list(glmTreat_low10$glmTreat_untrimmed_Rn6, glmTreat_low10$glmTreat_trimmed_Rn6))
P6low_untrim_Rn4_Rn6<-Reduce(intersect,list(glmTreat_low10$glmTreat_untrimmed_Rn4, glmTreat_low10$glmTreat_untrimmed_Rn6))
P6low_trim_Rn4_Rn6<-Reduce(intersect,list(glmTreat_low10$glmTreat_trimmed_Rn4, glmTreat_low10$glmTreat_trimmed_Rn6))

######Common genes with highest logFC in Pipeline 5 vs Pipeline 6
P6P5_Rn4untrim_high <-Reduce(intersect,list(Treat_top10$Treat_untrimmed_Rn4, glmTreat_top10$glmTreat_trimmed_Rn4))
P6P5_Rn4trim_high <-Reduce(intersect,list(Treat_top10$Treat_trimmed_Rn4, glmTreat_top10$glmTreat_trimmed_Rn4))
P6P5_Rn6untrim_high <-Reduce(intersect,list(Treat_top10$Treat_untrimmed_Rn6, glmTreat_top10$glmTreat_untrimmed_Rn6))
P6P5_Rn6trim_high <-Reduce(intersect,list(Treat_top10$Treat_trimmed_Rn4, glmTreat_top10$glmTreat_trimmed_Rn6))


######Common genes with least logFC in Pipeline 5 vs Pipeline 6
P6P5_Rn4untrim_low <-Reduce(intersect,list(Treat_low10$Treat_untrimmed_Rn4, glmTreat_low10$glmTreat_trimmed_Rn4))
P6P5_Rn4trim_low <-Reduce(intersect,list(Treat_low10$Treat_trimmed_Rn4, glmTreat_low10$glmTreat_trimmed_Rn4))
P6P5_Rn6untrim_low <-Reduce(intersect,list(Treat_low10$Treat_untrimmed_Rn6, glmTreat_low10$glmTreat_untrimmed_Rn6))
P6P5_Rn6trim_low<-Reduce(intersect,list(Treat_low10$Treat_trimmed_Rn4, glmTreat_low10$glmTreat_trimmed_Rn6))
