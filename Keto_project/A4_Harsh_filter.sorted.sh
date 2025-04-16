## Generate an overlap bed file between RepeatMasker's result and Harsh's polishing TEs
## bedextract <query.bed> <target>
## Grab elements from the <query.bed> that overlap elements in <target>
cd ~/Keto/TEMP2/rmsk/
bedextract A4.sorted.bed A4_Harsh.sorted.bed > A4_Harsh_filter.sorted.bed

## A4.sorted.bed is RepeatMasker's TE calling, in bed6 format (compatible with TEMP2) 
