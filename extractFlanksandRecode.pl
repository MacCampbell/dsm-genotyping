#! /usr/bin/perl -w

#06022021
#By Mac Campbell, DrMacCampbell@gmail.com

#A simple script to extract sites from a fasta file.
#At the moment reading to memory.

#We want a tab-delimited input (sites.txt)
#Chrom  Site    Major   Minor MAF
#Easily obtained from a VCF.
# bcftools +fill-tags outputs/101/snps-75-samples-recode-filtered.recode.vcf -- -t MAF | cut -f 1,2,4,5,8 | grep -v "#" > outputs/101/snps-75-samples-recode-filtered.MAF.txt


#Usage
# ./extractFlanksandRecode.pl file.fasta sites.txt

my $fasta=shift;
my $sites=shift;

#Set variables
my $sep ="\t";

#Flanking length
my $buffer=150;


#Read in fasta and store to memory, sigh. It seems that I should make a hash.

my %hash;

my @dat = ReadInFASTA($fasta);
my @sites = GetData($sites);


foreach $entry (@dat) {

	my @a = split($sep, $entry);
	$hash{$a[0]}=$a[1];	
}


foreach my $site (@sites) {
	my @b = split("\t", $site);
	
	my $chrom=$b[0];
	my $site=$b[1];
	my $major=$b[2];
	my $minor=$b[3];
	my $maf=$b[4];

my @sequence=split(//,$hash{$chrom});

print ">".$chrom."-site-".$site."-Major-".$major."-Minor-".$minor."-".$maf."\n";
print @sequence[($site-1-$buffer)..($site-1-1)];
#print $sequence[$site-1]; Replacing site-1 with major/minor
print "[$major/$minor]";
print @sequence[$site..$site-1+$buffer];
print "\n";

}




exit;

sub GetData {
my $infile = shift;
my @result;

open (INFILE, "<$infile") || die ("Can't open $infile\n");

while (<INFILE>) {
	chomp;
	push (@result,$_);
}

return(@result);

}

sub ReadInFASTA {
    my $infile = shift;
    my @line;
    my $i = -1;
    my @result = ();
    my @seqName = ();
    my @seqDat = ();

    open (INFILE, "<$infile") || die "Can't open $infile\n";

    while (<INFILE>) {
        chomp;
        if (/^>/) {  # name line in fasta format
            $i++;
            s/^>\s*//; s/^\s+//; s/\s+$//;
            $seqName[$i] = $_;
            $seqDat[$i] = "";
        } else {
            s/^\s+//; s/\s+$//;
	    s/\s+//g;                  # get rid of any spaces
            next if (/^$/);            # skip empty line
            s/[uU]/T/g;                  # change U to T
            $seqDat[$i] = $seqDat[$i] . uc($_);
        }

	# checking no occurence of internal separator $sep.
	die ("ERROR: \"$sep\" is an internal separator.  Line $. of " .
	     "the input FASTA file contains this charcter. Make sure this " . 
	     "separator character is not used in your data file or modify " .
	     "variable \$sep in this script to some other character.\n")
	    if (/$sep/);

    }
    close(INFILE);

    foreach my $i (0..$#seqName) {
	$result[$i] = $seqName[$i] . $sep . $seqDat[$i];
    }
    return (@result);
}
