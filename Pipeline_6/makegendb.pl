#!/usr/bin/perl
# Produces perl DBM of rat genome annotation, for EnsEMBL gene IDs => common gene names. 
#There are some EnsEMBL genes/transcripts which do not have a corresponding common name.
use strict;
use warnings;

my %TXES; my %GENES;
my $og; my $ng;
my $nmc;

unless (scalar(@ARGV) == 2) {
	print"Usage: perl makegendb.pl <input gtf> <database name>\n";
	exit;
}

open (IN, "<$ARGV[0]") or die "Could not find $ARGV[0] \n";
dbmopen (%GENES, "@ARGV[1]", 0755) or die "Could not create gene database";


while (<IN>) {
	if ($_ =~ /gene_id "(.+)"; gene_name "(.+)"; gene_source./) {

		$og = $1;
		$ng = $2;

		$GENES{$og} = $ng;
	}
	else {
		$nmc++;
		print "\nNon matching line found: \n\n $_";
	}
}

#Useful for ensuring the script worked as intended, or for debugging
print "$nmc non-matching lines found";

close IN; dbmclose %GENES;
