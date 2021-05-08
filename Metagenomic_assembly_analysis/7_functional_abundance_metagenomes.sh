#!/usr/bin/env sh

################################################################################################
# to calculate the relative abundance of the functions: CAZyme, ARGs, and COGs in each metagenome
################################################################################################


####################
# CAZyme
####################

for f in $(cat metagenome.list.txt)
do
echo $f

echo "#! /usr/bin/env Rscript
####################################################
# load the taxonomy of contigs
t<-read.csv('1_6_kaiju/tax.txt', header=T, sep='	')
t$'Kingdom'<-t$'Genus'<-t$'Species'<-NULL

# load cazyme of contigs
b<-read.csv('1_1_CAZy/cazy.txt', header=T, sep='	')
head(b)
b$'Kingdom'<-b$'taxid'<-NULL

# load mapped reads of metagenome
a<-read.csv('total_sum/$f.txt', header=F, sep='	')
a$'V2'<-a$'V4'<-NULL
names(a)<-c('contig','count')
head(a)


#########
# keep the annotated sequences from Bacteria, Fungi, Archaea and Viruses 
t1<-merge(t,a,by=c('contig'),all.x = T)
head(t1)
dim(t1)

# calculate relative abundance
t1$'relative'<-t1$'count'/sum(t1$'count')
head(t1)
t1$'count'<-NULL

# keep the contigs with identified sequences in the metagenome
t2<-t1[which(t1$'relative' > 0),]

#combine taxonomic file and cazyme hit
b1<-merge(b,t2,all.x=T)
head(b1)
b2<-b1[which(b1$'relative' > 0),]

# calculate the relative abundance of cazyme of contigs
b2$'abundance'<-b2$'relative'*b2$'hit'
head(b2)
b2$'hit'<-b2$'relative'<-NULL

# calculate the relative abundance of cazyme at the taxon level
b3<-aggregate(abundance ~ taxid+cazy, b2, sum)

write.table(b3, file='1_1_CAZy/$f.txt', sep='	', row.names=F, quote=F)

quit()

" > cazyme.R

chmod 755 cazyme.R
R < cazyme.R --no-save

done







##############
# ARGs
##############

for f in $(cat metagenome.list.txt)
do
echo $f


echo "#! /usr/bin/env Rscript
####################################################
# load the taxonomy of contigs
t<-read.csv('1_6_kaiju/tax.txt', header=T, sep='	')
t$'Kingdom'<-t$'Genus'<-t$'Species'<-NULL

# load ARGs of contigs
c<-read.csv('1_2_ARG/arg.txt', header=T, sep='	')
head(c)

# load mapped reads of metagenome
a<-read.csv('total_sum/$f.txt', header=F, sep='	')
a$'V2'<-a$'V4'<-NULL
names(a)<-c('contig','count')
head(a)


#########
# keep the annotated sequences from Bacteria, Fungi, Archaea and Viruses 
t1<-merge(t,a,by=c('contig'),all.x = T)
head(t1)
dim(t1)

# calculate relative abundance
t1$'relative'<-t1$'count'/sum(t1$'count')
head(t1)
t1$'count'<-NULL

# keep the contigs with identified sequences in the metagenome
t2<-t1[which(t1$'relative' > 0),]

#combine taxonomic file and ARG hit
c1<-merge(c,t2,all.x=T)
head(c1)
c2<-c1[which(c1$'relative' > 0),]

# calculate the relative abundance of ARG of contigs
c2$'abundance'<-c2$'relative'*c2$'hit'
head(c2)
c2$'hit'<-c2$'relative'<-NULL

# calculate the relative abundance of ARG at the taxon level
c3<-aggregate(abundance ~ taxid+RF, c2, sum)
tail(c3)

write.table(c3, file='1_2_ARG/$f.txt', sep='	', row.names=F, quote=F)

quit()

" > arg.R

chmod 755 arg.R
R < arg.R --no-save

done






##############
# COGs
##############

for f in $(cat metagenome.list.txt)
do
echo $f

echo "#! /usr/bin/env Rscript
####################################################
# load the taxonomy of contigs
t<-read.csv('1_6_kaiju/tax.txt', header=T, sep='	')
t$'Kingdom'<-t$'Genus'<-t$'Species'<-NULL

# load COG of contigs
c<-read.csv('cog.txt', header=T, sep='	')

# load mapped reads of metagenome
a<-read.csv('total_sum/$f.txt', header=F, sep='	')
a$'V2'<-a$'V4'<-NULL
names(a)<-c('contig','count')
head(a)


#########
# keep the annotated sequences from Bacteria, Fungi, Archaea and Viruses 
t1<-merge(t,a,by=c('contig'),all.x = T)

# calculate relative abundance
t1$'relative'<-t1$'count'/sum(t1$'count')
t1$'count'<-NULL

# keep the contigs with identified sequences in the metagenome
t2<-t1[which(t1$'relative' > 0),]

# combine taxonomic file and COG hit
c1<-merge(c,t2,all.x=T)
c2<-c1[which(c1$'relative' > 0),]

# calculate the relative abundance of COG of contigs
c2$'abundance'<-c2$'relative'*c2$'hit'
c2$'hit'<-c2$'relative'<-NULL

# calculate the relative abundance of COG at the taxon level
c3<-aggregate(abundance ~ taxid+COG, c2, sum)

write.table(c3, file='1_3_COG/$f.txt', sep='	', row.names=F, quote=F)

quit()
" > cog.R

chmod 755 cog.R
R < cog.R --no-save

done


