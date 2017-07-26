#!/usr/bin/perl
#Having identified unplaced scaffolds in EnsEMBL Rnor_6.0 genes.gtf, this script was used to remove certain offending sequences. 
#Leaving these sequences in trips up RSEM, as it requires that every chromosome referred to in the annotation have a corresponding chromosome.fasta
#It then appends the ERCC annotation file to the newly created genes2.gtf.
use strict;
use warnings;

unless (scalar(@ARGV) == 1) {
	print "Usage: perl gtf_edit.pl <input GTF>\n";
	exit;
}

my $file = $ARGV[0];

#Removes a .gtf extension from an input filename, for processing purposes. If the extension is anything other than .gtf, the script will fail. 
if ($file =~ /\.gtf/) {
	$file = $`;
}

#The original file is left intact and a new one is created. The cut annotations are sent to genes_cut.gtf for reviewing.
open (IN, "<$file.gtf") or die "Could not find $file.gtf";
open (OUT, ">$file" . "2.gtf");
open (CUT, ">$file\_cut.gtf");

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

#These data can be useful as an indication of whether the script has worked as intended, or for debugging
print "$keptot lines kept\n$cutot lines cut\n";

system "cat ERCC92.gtf >> $file" . "2.gtf";
