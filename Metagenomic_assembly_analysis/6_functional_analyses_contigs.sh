#!/bin/bash


##################################################################################################
# to parse the microbiome and virome funtions (ARGs, CAZymes, and COGs) for the assembled contigs
##################################################################################################


# predict gene using prodigal
prodigal -i ~/1_3_contig_assembly/contigs/contigs.fa -o coords.gbk -a ~/1_3_contig_assembly/contigs/contigs.faa -p meta




##########################
# ARGs
##########################
# Resfams datbase "Resfams-full.hmm.gz" from Dantas lab

#prepare Resfams HMM database
./hmmer-3.2.1/src/hmmpress Resfams-full.hmm

# using hmmscan to serach the assembled contigs against the Resfams HMM database
./hmmer-3.2.1/src/hmmscan --cpu 2 --cut_ga --tblout ~/1_2_ARG/contigs.dom ~/databases/antibiotic_resistance_ref/Resfams-full.hmm ~/1_3_contig_assembly/contigs/contigs.faa > /dev/null


# parse the hmmscan results
cat contigs.dom | grep -v '^#' | awk '{print $3,$2,$1,"1"}' | tr ' ' '\t' > contigs.1
cut -f1 contigs.1 | sed 's/k87_/k87@/g' | tr '_' '\t' | tr '@' '_' | cut -f1 > contigs.2
paste contigs.1 contigs.2 > contigs.3


# run the R-script to get the hit of each gene for each contig
###############################################################
#! /usr/bin/env Rscript
library(reshape2)

df<-read.delim('contigs.3', header=F, sep='\t')
df$'V1' <- NULL

df1<-aggregate(V4 ~ V5 + V2 + V3, data = df, sum)

colnames(df1)<-c('contig','RF','ARG','hit')
write.table(df1,'arg.txt',quote=F,row.names=F,col.names=F,sep='\t')
###############################################################






##########################
# CAZyme
##########################
# microbiome: custom CAZymes database carbohydrate.hmm
# virome: those genes encoding peptidoglycanase in the arbohydrate.hmm


#prepare CAZyme database
./hmmer-3.2.1/src/hmmpress ~/databases/cazyme_ref/carbohydrate.hmm

# using hmmscan to serach the assembled contigs against the ustom CAZyme database
./hmmer-3.2.1/src/hmmscan --cpu 2 --domtblout ~/1_1_CAZy/contigs.dom -E 1e-5 ~/databases/cazyme_ref/carbohydrate.hmm ~/1_3_contig_assembly/contigs/contigs.faa > /dev/null


# run the hmmscan-parser.sh with the cutoff: E-value < 1e-15 and covered fraction of HMM > 0.35, regardeless of alignment length 
# http://bcb.unl.edu/dbCAN/download/hmmscan-parser.sh

# hmmscan-parser.sh
####################
#!/usr/bin/env sh
cat contigs.dom | grep -v '^#' | awk '{print $1,$3,$4,$6,$13,$16,$17,$18,$19}' | tr ' ' '\t' | sort -k 3,3 -k 8n -k 9n | \
perl -e 'while(<>){chomp;@a=split;next if $a[-1]==$a[-2];push(@{$b{$a[2]}},$_);}foreach(sort keys %b){@a=@{$b{$_}};for($i=0;$i<$#a;$i++){@b=split(/\t/,$a[$i]);@c=split(/\t/,$a[$i+1]);$len1=$b[-1]-$b[-2];$len2=$c[-1]-$c[-2];$len3=$b[-1]-$c[-2];if($len3>0 and ($len3/$len1>0.5 or $len3/$len2>0.5)){if($b[4]<$c[4]){splice(@a,$i+1,1);}else{splice(@a,$i,1);}$i=$i-1;}}foreach(@a){print $_."\n";}}' | \
perl -e 'while(<>){chomp;@a=split(/\t/,$_);if(($a[-1]-$a[-2])>80){print $_,"\t",($a[-3]-$a[-4])/$a[1],"\n" if $a[4]<1e-15;}else{print $_,"\t",($a[-3]-$a[-4])/$a[1],"\n" if $a[4]<1e-15;}}' | awk '$NF>0.35' | sort -k 3 -k 8,9g > contigs.1
####################

cat contigs.1 | awk 'BEGIN {OFS="\t"}; {print $1,$3,"1"}' > contigs.2

cut -f2 contigs.2 | sed 's/k87_/k87@/g' | tr '_' '\t' | tr '@' '_' | cut -f1 > contigs.3
paste contigs.2 contigs.3 > contigs.4


# run the R-script to get the hit of each gene for each contig
###############################################################
#! /usr/bin/env Rscript

library(reshape2)

df<-read.delim('contigs.4', header=F, sep='\t')

df1<-aggregate(V3 ~ V4 + V1, data = df, sum)

colnames(df1)<-c('contig','gene','hit')

write.table(df1,'cazyme.txt',quote=F,row.names=F,sep='\t')
###############################################################







##########################
# COGs
##########################

# using prokka
prokka ~/1_3_contig_assembly/contigs/contigs.fa --outdir contigs --norrna --notrna --metagenome --cpus 20

grep 'ID=' *.gff | grep 'COG' | cut -f1,9 > cog1.txt

cut -f2 cog1.txt | sed 's_COG:_@_g' | cut -f2 -d'@' | cut -f1 -d';' > cog2.txt

paste cog1.txt cog2.txt | cut -f1,3 > cog3.txt



# run the R-script to get the hit of each gene for each contig
###############################################################
#! /usr/bin/env Rscript

t<-read.csv('cog3.txt', header=F, sep='\t')
head(t)
names(t)<-c('contig','COG')
t$'hit'<-1

t1<-aggregate(hit ~ contig+COG, t, sum)
tail(t1)

write.table(t1, file='cog.txt', sep='\t', row.names=F, quote=F)
###############################################################



