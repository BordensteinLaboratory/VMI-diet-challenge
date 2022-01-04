#Move to the directory containing reads that do not map to the human genome
cd /data/bordenstein_lab/vmi/vmimetagenomics/year2/1_2_human_reads

#Before running the following loop, create a text file (subject.txt) listing all subject IDs, separating oral and fecal samples
#Create a folder for each subject's fecal and oral samples
#Move all fecal samples for an individual into the appropriate folder
#Move all oral samples for an individual into the appropriate folder

#This loop will then create .csv files listing all samples within those folders
#These folders and .csv files will be used as input for the assembly_array.sh script


project=/data/bordenstein_lab/vmi/vmi_metagenomics/year2

cd ${project}/1_2_human_reads

for subject in $(cat subject.txt)
do
	ls ${project}/1_2_human_reads/${subject}/run1_*.R1.fastq.gz | tr "\n" "," | sed 's/,$//' > ${project}/1_2_human_reads/${subject}/R1.csv
	ls ${project}/1_2_human_reads/${subject}/run1_*.R2.fastq.gz | tr "\n" "," | sed 's/,$//' > ${project}/1_2_human_reads/${subject}/R2.csv
done
