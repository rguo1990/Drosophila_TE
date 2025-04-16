## Generate an overlap bed file between RepeatMasker's result and Harsh's polishing TEs
## bedextract <query.bed> <target>
## Grab elements from the <query.bed> that overlap elements in <target>
cd ~/Keto/TEMP2/rmsk/
bedextract A4_A7.UU_MU.Zscore.SigFlag.txt A4_Harsh.sorted.bed > A4_Harsh_filter.sorted.bed
