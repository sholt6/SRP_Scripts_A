#!/usr/bin/perl
#Having identified unplaced scaffolds in EnsEMBL Rnor_6.0 genes.gtf, this script was used to remove certain offending sequences. It then appends the ERCC annotation file to the newly created genes2.gtf.
use strict;
use warnings;

open (IN, "<genes.gtf") or die "Could not find genes.gtf";
open (OUT, ">genes2.gtf");
open (CUT, ">genes_cut.gtf");

my $cutot;
my $keptot;

while (<IN>) {
	#Sequences are removed where the chromosome identifier does not correspond to a real chromosome
	if ($_ =~ /^((\d+)|(X)|(Y)|(MT))\s/) {
		print OUT $_;
		$keptot++;
	}
	else {
		print CUT $_;
		$cutot++;
	}
}

close IN; close OUT; close CUT;

print "$keptot lines kept\n$cutot lines cut\n";

system "cat ERCC92.gtf >> genes2.gtf";
