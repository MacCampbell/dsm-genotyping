# dsm-genotyping
Genotyping with available Delta Smelt data for creation of a GTSeq panel.    

Should have ~770 samples of RADseq from Delta Smelt. Goal is to compile a diverse set of sequences and produce called genotypes that are informative for diversity monitoring. These can be combined with existing assays, parentage and species id.

## Organization:

__1__ `/meta/` for metadata            

I (Mac Campbell) had a file, meta.csv, from 07212020 that has information about sequenced DSM. I changed it so that the columns were consistent through the file. This directory has various metadata files shared with me or generated/used by scripts.

__2__ `/bamlists/` for bamlists      

__3__ `Analysis files xxx-yyy.zzz`        

Numbered numerically in order of steps taken. R markdown files are designed to be knitted into .html files.   

__4__ `/outputs/` outputs from analyses/scripts   

Outputs from 100-dsm-meta.Rmd goes into outputs/100/

__5__ Ignored directories     

/data/ - for fastqs etc, not synced              
/bams/ - for bams, not synced      
/outputs/ - these are too big for GitHub, can be pulled down in other ways      

## .gitignore

See this file for setup with RStudio.     
