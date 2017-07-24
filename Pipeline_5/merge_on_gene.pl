#!usr/bin/perl
use strict;
use warnings;

my $trim;
my $rn;
my $dataset;
my $gene_short_name;
my $key;
my $locuskey;
my %locushash;
my %locusmin;
my %locusmax;
my %FPKMhash;
my %ALTEREDhash;
my @scrapped_gene_short_names;

#analyses the cufflinks output file genes.fpkm_tracking.
#genes from defined categories of datasets (Rn4/6, trimmed/untrimmed) are normalised to each other and any artifacts produced by cufflinks are removed.
#All genes from all samples per category have their isoforms merged into the main gene, the full locus coordinates are then taken from all isoforms and provided as the new locus coordinates for the merged gene.
#Cufflinks cannot always correctly identify overlapping genes, due to this any genes which are overlapping and cufflinks hasn't been able to differentiate them are removed. If cufflinks cannot differentiate genes it will report two genes in one row and combine their FPKM, as this cannot be split the genes can no longer be analysed so all mention of the genes are removed from that category.
#edit
#This program should be ran using sudo to ensure updatedb is successful. Therefore the following lines check if this was ran with sudo, if not the program is terminated and advises to rerun as sudo.
if ( $< != 0 ) {
print "This script must be run using sudo to ensure full and accurate functionality.\n"; 
exit (0);
}

#creation of directories used by the script
unless (-e 'altered'){
system "mkdir altered";
system "mkdir altered/trimmed";
system "mkdir altered/untrimmed";
}

unless (-e 'final'){
system "mkdir final";
system "mkdir final/trimmed";
system "mkdir final/untrimmed";
}

#required to update results from locate otherwise locate may not find all desired files.
system "updatedb";
#locates all genes.fpkm_tracking files in the groupproject folder from the results of the pipeline (max of 20 results should be found)
my @filename=`locate *groupproject*cuff2*genes.fpkm_tracking`;
#just something to make the output look nicer
my $length = scalar @filename;
print "$length files have been found\n";
print "Merging isoforms for:\n";

#opens each file found, one at a time and runs through the workflow
for my $filename(@filename){
    $filename=~/(untrimmed|trimmed).*(Rn[46]).*(\d{4})/ig; 
    $trim= $1;  
    $rn = $2;   
    $dataset=$3;
    chomp $filename; 
    print $trim."_".$rn."_".$dataset."\n"; 
    open IN, '<', "$filename" or die "Could not open $filename; $!"; 
    open OUT, '>',"altered/".$trim."/".$trim."_".$rn."_".$dataset."_altered" or die"Could not open". $trim."_".$rn."_".$dataset."_altered.\n";
        
        
#whilst there is a line in the INFILE it is read into the script        
        while (<IN>){                       
            my $line = $_;
            	        
# If the line is the first line then it will be printed straight to the OUTFILE	        
	        if ($line =~m/^tracking_id/){   
	            $line =~ s/FPKM/$dataset/g;      
		        print OUT $line;            
		        next;           
            } 
#otherwise the line is split by \t and the 5th column(gene short name) is checked, if it is "-" it will be printed direct to the outfile as cannot merge by gene name if it doesn't have one. 
#also checks if there is a merged gene by looking for "," if it is found all gene names on that row will be added to the scrapped gene short names array             
            else {
                my @line = split "\t", $line;       
                if ($line[4]eq"-"){                
                    next;
                }
                elsif ($line[4] =~ /,/ig){ 
                    my @line4 = split(/,/, $line[4]);
                    for my $i (0..$#line4) {
                        push @scrapped_gene_short_names, $line4[$i]."_".$rn."_".$trim;
                    }
                    next;
		        } else {
# Key for all hashes is now defined as the (gene_short_name)_(rn)_(dataset)_(trim) with the locus key removing the dataset so the locus is merged across all 5 datasets of the same Rn.                
                $gene_short_name=$line[4]; 
                $key = $gene_short_name."_".$rn."_".$dataset."_".$trim;                   
                $locuskey = $gene_short_name."_".$rn."_".$trim;
                }
#The locus is split to three parts - the identifier at the beginning, the start and the end site.                
                $line[6]=~m/([\w-]*):(\d*)-(\d*)/ig;                
                my $chr = $1;                                       
                my $begin = $2;                                     
                my $end = $3;                                       
#populates the locus hash based on the identifier, smallest beginning site and largest ending site values.
                $locusmin{$locuskey}=$begin if !$locusmin{$locuskey} || $begin < $locusmin{$locuskey}; 
                $locusmax{$locuskey}=$end if !$locusmax{$locuskey} || $end > $locusmax{$locuskey};     
                $locushash{$locuskey}=$chr.":".$locusmin{$locuskey}."-".$locusmax{$locuskey};          
#Takes FPKM value of each row and assigns it to the FPKMhash, this is then assigned back to the line FPKM value.                
               $FPKMhash{$key}+=$line[9];
               $line[9]=$FPKMhash{$key};                                                               
#Takes the values from locus hash and FPKM hash and replaces the relevant values of $line then added to a hash for printing
                $line = join "\t", @line;
                $ALTEREDhash{$key}=$line;           
            }   
        }
#hash to print files, could be completed in line above but this allows for changes to be made much simpler        
        while ((my $key, my $value) = each(%ALTEREDhash)){
        print OUT $value; 
    }
#clears alteredhash contents for next file
    %ALTEREDhash=();   
}    

#maps the scrapped gene short name array to a hash to allow for easy searching.
my %scrapped_gene_short_names = map { $_ => 1 } @scrapped_gene_short_names;


#second half of script
#re-reads in each outfile produced to alter the locus and remove overlapping genes completely. These were not done on the first run through as when handling each file one by one the full list of loci and merged genes is not completed until all files from one category read fully.

#updates locate to ensure outfiles can be found
system "updatedb";
#locates all outfiles and resets the filename array with the new paths
@filename=`locate *groupproject*altered*_altered*`;
#just something to make the output look nicer
$length = scalar @filename;
print "\nCorrecting locus for each gene and removing overlapping genes in:\n";

#opens each file found, one at a time and runs through the workflow
for my $filename(@filename){
    $filename=~/(untrimmed|trimmed).*(Rn[46]).*(\d{4})/ig; 
    $trim= $1;  
    $rn = $2;   
    $dataset=$3;
    chomp $filename; 
    print $trim."_".$rn."_".$dataset."\n"; 
    open IN, '<', "$filename" or die "Could not open $filename; $!"; 
    open OUT, '>',"final/".$trim."/".$trim."_".$rn."_".$dataset."_final" or die"Could not open". $trim."_".$rn."_".$dataset."_final.\n";
#reads infile line by line    
    while (<IN>){                       
            my $line = $_;
#if first line is read (identified by tracking_id it is printed direct to out
	        if ($line =~m/^tracking_id/){   
		        print OUT $line;            
		        next;            
            } else {
#parses the line for the gene_short_name         
                my @line = split "\t", $line;       
                $gene_short_name=$line[4];
#sets the key to allow searching through the scrapped_gene_short_name hash
                $key = $gene_short_name."_".$rn."_".$trim;
#if gene_short_name is "_" the line is printed direct to out, no changes will be made  
		        if ($gene_short_name eq"-"){                 
                    next;
#if gene_short_name includes a "," the line is skipped and not printed to the outfile
                } elsif ($gene_short_name =~ /,/ig){ 
                    next;
#if the key is found in the scrapped_gene_short_name hash the line is skipped and not printed to the outfile          
                } elsif ( exists($scrapped_gene_short_names{$key})) {
                    next;
                }
                
#lines only reach this part if the gene short name has not been marked as merged with another gene, set as "-" or includes a comma.
#The locus for the gene is now set to the full locus as created in the first alf of the script, the line is then joined back together and added to a hash for printing                
                $line[6]=$locushash{$key};
                $line = join "\t", @line;
                $ALTEREDhash{$key}=$line;
            }
        }
#hash to print out updated lines. ensures no genes found in the scrapped gene hash are allowed to be printed        
        while ((my $key, my $value) = each(%ALTEREDhash)){
            if ( exists($scrapped_gene_short_names{$locuskey})) {
            next;
        } else {
            print OUT $value; 
        }
    }
#clears alteredhash contents for next file
    %ALTEREDhash=(); 
} 
