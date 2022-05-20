#$1 = the new directory's name
#$2 = the selected comparative

mkdir $1
cp -r tmp_dir_$2/*bam* $1 #bam files for each patient
cp filtered/od_dir_$2/*IncLvl* $1 #we gen the filtered results
cp od_dir_$2/*grouping* $1 #grouping file

# we get all the bams of the comparative
for bam in $1*bam*
do
    bams+=($bam)
done

# Alternative splicing events (there are two types of files per event, JC and JCEC)
events=(A3SS A3SS A5SS A5SS MXE MXE RI RI SE SE)

n=0
for file in $1*IncLvl*;
do
    echo ${events[n]}
    echo $file
    name=$(echo $file | rev | cut -c25- | rev)
    python2 ./rmats2sashimiplot/src/rmats2sashimiplot/rmats2sashimiplot.py -o ${name}_sashimiplots --b1 ${bams[0]}/Aligned.sortedByCoord.out.bam,${bams[1]}/Aligned.sortedByCoord.out.bam,${bams[2]}/Aligned.sortedByCoord.out.bam --b2 ${bams[3]}/Aligned.sortedByCoord.out.bam,${bams[4]}/Aligned.sortedByCoord.out.bam,${bams[5]}/Aligned.sortedByCoord.out.bam -t ${events[n]} -e $file --l1 SampleOne --l2 SampleTwo --group-info $1grouping.gf
    let "n+=1"
done






