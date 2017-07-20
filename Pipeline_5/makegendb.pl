#!/usr/bin/perl
# Produces perl DBM of rat genome annotation, for transcripts and genes. There are some EnsEMBL genes/transcripts which do not have a corresponding common name.
use strict;
use warnings;

my %TXES; my %GENES;
my $og; my $ng;
my $ot; my $nt;
my $nmc;

open (IN, "<genes2.gtf") or die "Could not find genes2.gtf";
dbmopen (%GENES, "rn6_Ens_genes", 0755) or die "No gene db!";
dbmopen (%TXES, "rn6_Ens_txes", 0755) or die "No tx db!";


while (<IN>) {
	if ($_ =~ /gene_id "(.+)"; gene_name "(.+)"; gene_source.+transcript_id "(.+)"; transcript_name "(.+)"; transcript_source/) {

		$og = $1;
		$ng = $2;
		$ot = $3;
		$nt = $4;

		$GENES{$og} = $ng;
		$TXES{$ot} = $nt;
	}
	else {
		$nmc++;
		print "\nNon matching line found: \n\n $_";
	}
}

print "$nmc non-matching lines found";

close IN; dbmclose %GENES; dbmclose %TXES;
