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
# ./extractFlanksandRecode.pl sites.txt

my $sites=shift;

#Set variables
my $sep ="\t";

#Flanking length
my $buffer=150;


#Reading in fasta and store to memory, takes a lot. It seems that I should make a hash.


my @sites = GetData($sites);


foreach my $site (@sites) {
	my @b = split("\t", $site);
	
	my $chrom=$b[0];
	my $site=$b[1];
	my $major=$b[2];
	my $minor=$b[3];
	my $maf=$b[4];

`samtools faidx /home/maccamp/genomes/hypomesus-20210204/Hyp_tra_F_20210204.fa	> temp.fasta`;

my $fasta = "temp.fasta";

#Should only have one sequence
my @dat = ReadInFASTA($fasta);
my @a = split($sep, $dat[0]);
my @sequence = split(//, $a[1]);

print ">".$chrom."-site-".$site."-Major-".$major."-Minor-".$minor."-".$maf."\n";
print @sequence[($site-1-$buffer)..($site-1-1)];
#print $sequence[$site-1]; Replacing site-1 with major/minor
print "[$major/$minor]";
print @sequence[$site..$site-1+$buffer];
print "\n";

}

`rm temp.fasta`;


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
