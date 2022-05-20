for file in $1*MATS*;
do
    name=$(echo $file | rev | cut -c5- | rev )
    Rscript GSEA.R $file ${name}toGSEA.txt

    cat to_GSEA/${name}toGSEA.txt | tr " " "\t" | cut -f2,3 | tr -d '"' | tr -s " " "\t" | tail -n +2  > to_GSEA/${name}_toGSEA.rnk
    rm to_GSEA/${name}toGSEA.txt
done