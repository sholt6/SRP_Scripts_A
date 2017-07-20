#!/bin/sh
# Performs rsem-calculate-expression runs in sequence. Be sure to edit paths!
# All paths are absolute so run from where you want the output to be stored

# Following is a breakdown of the command:
# rsem-calculate-expression				calls the RSEM script
# --bowtie-path /home/sjrh2/Tuxedo/bowtie0.12.7 	path to the directory where Bowtie is installed
# --paired-end 						tells RSEM reads are paired-end
# /home/sjrh2/Steered/RNA_Seq_Data/SRR117XXXX_1.fastq location of first set of reads
# /home/sjrh2/Steered/RNA_Seq_Data/SRR117XXXX_2.fastq location of the second set of reads
# /home/sjrh2/Steered/RSEM_reference_rn4/rnX_rsem_ref 	the reference made using rsem-prepare-reference
# SRR117XXXX						a name for the output

echo Starting;

time rsem-calculate-expression --bowtie-path /home/sjrh2/Tuxedo/bowtie0.12.7 --paired-end /home/sjrh2/Steered/RNA_Seq_Data/SRR1177973_1.fastq /home/sjrh2/Steered/RNA_Seq_Data/SRR1177973_2.fastq /home/sjrh2/Steered/RSEM_reference_rn6/rn6_rsem_ref /home/sjrh2/Steered/RSEM_expression_runs/rn6_runs/rsem_rn6_untrimmed_SRR1177973;

echo First Run Finished;


time rsem-calculate-expression --bowtie-path /home/sjrh2/Tuxedo/bowtie0.12.7 --paired-end /home/sjrh2/Steered/RNA_Seq_Data/SRR1178033_1.fastq /home/sjrh2/Steered/RNA_Seq_Data/SRR1178033_2.fastq /home/sjrh2/Steered/RSEM_reference_rn6/rn6_rsem_ref /home/sjrh2/Steered/RSEM_expression_runs/rn6_runs/rsem_rn6_untrimmed_SRR1178033;

echo Second Run Finished;


time rsem-calculate-expression --bowtie-path /home/sjrh2/Tuxedo/bowtie0.12.7 --paired-end /home/sjrh2/Steered/RNA_Seq_Data/SRR1178043_1.fastq /home/sjrh2/Steered/RNA_Seq_Data/SRR1178043_2.fastq /home/sjrh2/Steered/RSEM_reference_rn6/rn6_rsem_ref /home/sjrh2/Steered/RSEM_expression_runs/rn6_runs/rsem_rn6_untrimmed_SRR1178043;

echo Third Run Finished;


time rsem-calculate-expression --bowtie-path /home/sjrh2/Tuxedo/bowtie0.12.7 --paired-end /home/sjrh2/Steered/RNA_Seq_Data/SRR1178050_1.fastq /home/sjrh2/Steered/RNA_Seq_Data/SRR1178050_2.fastq /home/sjrh2/Steered/RSEM_reference_rn6/rn6_rsem_ref /home/sjrh2/Steered/RSEM_expression_runs/rn6_runs/rsem_rn6_untrimmed_SRR1178050;

echo Fourth Run Finished;


time rsem-calculate-expression --bowtie-path /home/sjrh2/Tuxedo/bowtie0.12.7 --paired-end /home/sjrh2/Steered/RNA_Seq_Data/SRR1178059_1.fastq /home/sjrh2/Steered/RNA_Seq_Data/SRR1178059_2.fastq /home/sjrh2/Steered/RSEM_reference_rn6/rn6_rsem_ref /home/sjrh2/Steered/RSEM_expression_runs/rn6_runs/rsem_rn6_untrimmed_SRR1178059;

echo Fifth Run Finished;
