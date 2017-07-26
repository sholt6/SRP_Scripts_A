###################################
## This script carries out DEG analysis on our RSEM counts of Wang data as aligned to Ensembl releases 4 and 6 of the rat genome
## Analysis is carried out using the edgeR package, which is reliant on BioConductor
## Output includes summary table, logFC tables, MD Plots and Volcano Plots
###################################

library(edgeR)

rm(list=ls())

###Must uncomment desired input
#name <- "rn4_trimmed"
#name <- "rn4_untrimmed"
#name <- "rn6_trimmed"
#name <- "rn6_untrimmed"

rawdata <- read.delim(paste('/home/sjrh2/Steered/edgeR/',name,'.tsv', sep =""), header = TRUE, sep = "\t", row.names = 1)

group <- factor(c(1,2,2,1,2))

dge <- DGEList(counts=rawdata, group=group)

#Next two lines remove any genes which are expressed in <= 2 rats
keep <- rowSums(cpm(dge) > 0) >=1
dge <- dge[keep, , keep.lib.sizes=FALSE]

dge <- calcNormFactors(dge, method='TMM')

design <- model.matrix(~ 0+factor(c(1,2,2,1,2)))
colnames(design)<-c("Control","Treatment")

dge <- estimateDisp(dge, design)


## Quasi-likelihood F-test:
fit <- glmQLFit(dge, design, robust=TRUE)
con <- makeContrasts(Treatment - Control, levels=design)

qlf <- glmQLFTest(fit, contrast=con)
treat <- glmTreat(fit, coef = ncol(fit$design), contrast = con, lfc = log2(1.5))
treat$table$FC <- 2^(abs(treat$table$logFC))
treat$table$FC <- ifelse(treat$table$logFC <0, treat$table$FC*(-1), treat$table$FC*1)


### Save QLF Results
write.table(qlf$table, file = paste("/home/sjrh2/Steered/edgeR/Results/",name,"_QLF_logFC", sep = ""), sep="\t", row.names=TRUE, col.names = NA)
write.table(summary(decideTests(qlf, adjust.method = "none")), file = paste("/home/sjrh2/Steered/edgeR/Results/",name,"_QLF_summary", sep = ""), sep="\t", row.names=TRUE, col.names = NA)

# MD Plot (QLF)
jpeg(paste("/home/sjrh2/Steered/edgeR/Results/",name,"_QLF_MDplot.jpg", sep = ""))
plotMD(qlf, main = name, ylim = c(-10,10))
dev.off()

# Volcano Plot (QLF)
jpeg(paste("/home/sjrh2/Steered/edgeR/Results/",name,"_QLF_Vplot.jpg", sep = ""))
plot(qlf$table$logFC, -log10(qlf$table$PValue), pch=19, cex=0.2, col=ifelse(qlf$table$logFC < -1.5, "red", ifelse(qlf$table$logFC > 1.5, "red","black")), main = name, xlab = "logFC", ylab = "-log10(P-Val)", ylim = c(0,12))
abline(h=1.3, col="blue")
abline(h=2, col="green")
dev.off()



### Save Treat Results
write.table(treat$table, file = paste("/home/sjrh2/Steered/edgeR/Results/",name,"_Treat_logFC", sep = ""), sep="\t", row.names=TRUE, col.names = NA)
write.table(summary(decideTests(treat, adjust.method = "none")), file = paste("/home/sjrh2/Steered/edgeR/Results/",name,"_Treat_summary", sep = ""), sep="\t", row.names=TRUE, col.names = NA)

# MD Plot (Treat)
jpeg(paste("/home/sjrh2/Steered/edgeR/Results/",name,"_Treat_MDplot.jpg", sep = ""))
plotMD(treat, main = name, ylim = c(-10,10))
dev.off()

# Volcano Plot (Treat)
jpeg(paste("/home/sjrh2/Steered/edgeR/Results/",name,"_Treat_Vplot.jpg", sep = ""))
plot(treat$table$logFC, -log10(treat$table$PValue), pch=19, cex=0.2, col=ifelse(treat$table$logFC < -1.5, "red", ifelse(treat$table$logFC > 1.5, "red","black")), main = name, xlab = "logFC", ylab = "-log10(P-Val)", ylim = c(0,12))
abline(h=1.3, col="blue")
abline(h=2, col="green")
dev.off()
