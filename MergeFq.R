## Keto
## the script is to merge two fastq files

table=readxl::read_excel("~/Downloads/Keto MA.xlsx",sheet = "Library Prep")
colnames(table)=table[1,]
table=table[-1,]
lines=NULL
for(i in 1:nrow(table)){
  line=paste0("cat ","../1st/",table$`Sequence_ID (First Run)`[i],"-READ1-Sequences.txt.gz",
              " ../2nd/",table$`Sequence_ID (Second Run)`[i],"-READ1-Sequences.txt.gz",
              ">",table$`Sequence_ID (First Run)`[i],"-READ1-All.txt.gz")
  line.2=paste0("cat ","../1st/",table$`Sequence_ID (First Run)`[i],"-READ2-Sequences.txt.gz",
                " ../2nd/",table$`Sequence_ID (Second Run)`[i],"-READ2-Sequences.txt.gz",
                ">",table$`Sequence_ID (First Run)`[i],"-READ2-All.txt.gz")
  lines=rbind(lines,line,line.2)
}

write.table(lines,"~/Downloads/cat_sh.sh",quote = FALSE,row.names = FALSE,col.names = FALSE)
