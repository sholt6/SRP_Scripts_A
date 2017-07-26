#!/bin/sh
#This command was used to build a reference transcriptome using RSEM and Bowtie, for use in quantifying transcripts
rsem-prepare-reference --gtf /home/sjrh2/Steered/Rattus_norvegicus/Ensembl/Rnor_6.0/Annotation/Genes/genes2.gtf --bowtie-path /home/sjrh2/Tuxedo/bowtie0.12.7 /home/sjrh2/Steered/Rattus_norvegicus/Ensembl/Rnor_6.0/Sequence/Chromosomes /home/sjrh2/Steered/RSEM_reference_rn6/rn6_rsem_ref
