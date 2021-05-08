#!/bin/bash


######################################################################################
#taxonomy of assembled contigs
######################################################################################



# install Kaiju following their intructions https://github.com/bioinformatics-centre/kaiju

# run Kiaju to annotate taxonomy of each contig using the strict cut-off [a greedy -e 3 -E 0.00001 -s 65]
./src/kaiju/bin/kaiju -z 20 -t ./src/kaijudb/nodes.dmp -f ./src/kaijudb/nr_euk/kaiju_db_nr_euk.fmi -i ./1_3_contig_assembly/contigs/contigs.fa -a greedy -e 3 -E 0.00001 -s 65 -o ./1_6_kaiju/$i.out -v


# look at the taxonomy names
./src/kaiju/bin/kaiju-addTaxonNames -t ./src/kaijudb/nodes.dmp -n ./src/kaijudb/names.dmp -i ./1_6_kaiju/contigs.out -r superkingdom,kingdom,phylum,class,order,family,genus,species -o ./1_6_kaiju/contigs.name


# export the taxonomy annotation
awk -F"\t" '{OFS="\t"; print $2, $3, $4, $1, $8}' ./1_6_kaiju/contigs.name | awk -F"\t" '{OFS="\t"; print $1, $2, $3, $5}' | sed 's_; _@_g' | sed 's/ /_/g' | tr '@' '\t' | awk -F"\t" '{OFS="\t"; print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11}' > ./1_6_kaiju/contigs.txt


# remove the intermidiate files
rm ./1_6_kaiju/contigs.out

rm ./1_6_kaiju/contigs.name


# mannully remove the contigs that are not annotated to Bacteria, Fungi, Archaea or Viruses
contigs.txt -> tax.txt






######################################################################################
# calculate the relative abundance in each metagenome
######################################################################################


#!/usr/bin/env sh

for f in $(cat metagenome.list.txt)

do
echo $f


echo "#! /usr/bin/env Rscript
####################################################
# load taxonomy of the contigs
t<-read.csv('1_6_kaiju/tax.txt', header=T, sep='	')
t$'Kingdom'<-t$'Genus'<-t$'Species'<-NULL

# load contig reads
a<-read.csv('total_sum/$f.txt', header=F, sep='	')
a$'V2'<-a$'V4'<-NULL
names(a)<-c('contig','count')
head(a)


#########
# merge the taxonomy and mapped reas while keeping the annotated sequences from Bacteria, Fungi, Archaea and Viruses 
t1<-merge(t,a,by=c('contig'),all.x = T)
head(t1)
dim(t1)



# calculate relative abundance at the contig level
t1$'relative'<-t1$'count'/sum(t1$'count')
head(t1)
t1$'count'<-NULL

write.table(t1, file='1_3_contig_abundance/$f.txt', sep='	', row.names=F, quote=F)



# calculate relative abundance at the taxon level
t3<-aggregate(relative ~ taxid, t1, sum)
tail(t3)
t3$'id'<-'$f'

write.table(t3, file='1_6_tax/$f.txt', sep='	', row.names=F, quote=F)



# calculate relative abundance at the Phylum level
t2<-aggregate(relative ~ Phylum, t1, sum)
tail(t2)
t2$'id'<-'$f'

write.table(t2, file='1_6_tax/phylum/$f.txt', sep='	', row.names=F, quote=F)



# calculate relative abundance at the genus level
t4<-aggregate(relative ~ Genus, t1, sum)
tail(t4)
t4$'id'<-'$f'

write.table(t4, file='1_6_tax/genus/$f.txt', sep='	', row.names=F, quote=F)



# calculate relative abundance at the class level
t5<-aggregate(relative ~ Class, t1, sum)
tail(t5)
t5$'id'<-'$f'

write.table(t5, file='1_6_tax/class/$f.txt', sep='	', row.names=F, quote=F)



# calculate relative abundance at the order level
t6<-aggregate(relative ~ Order, t1, sum)
tail(t6)
t6$'id'<-'$f'

write.table(t6, file='1_6_tax/order/$f.txt', sep='	', row.names=F, quote=F)



# calculate relative abundance at the family level
t7<-aggregate(relative ~ Family, t1, sum)
tail(t7)
t7$'id'<-'$f'

write.table(t7, file='1_6_tax/family/$f.txt', sep='	', row.names=F, quote=F)


quit()

" > relative.abundance.R

chmod 755 relative.abundance.R
R < relative.abundance.R --no-save

done




