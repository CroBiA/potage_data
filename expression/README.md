By default, POTAGE uses this directory for all the gene expression data to be displayed. Here, you will find information
on what data files are required and how to specify per-dataset configuration files for use by POTAGE.

# Files, Directory Structure and Formats

To help keep things organised, we advise the use of a subdirectory for each gene expression data set. If you have multiple
data sets, they will be displayed within the POTAGE interface in the order in which the directory's are listed. Therefore,
it is advisable to prefix the data set's subdirectory name with a 3-digit number. For example, the IWGSC public RNA-Seq
data set which comes with POTAGE is placed in the [`001_iwgsc`](001_iwgsc) subdirectory; ensuring that it will apprear first in the POTAGE interface.

The following sections describe the files required for each data set and should be placed into the data set's subdirectory.
 
## Expression Data File

A tab-separated file with a header line. The first three column headers are "gene_id, start and stop". If a gene_id is unique withi the file the start and stop fields are ignored, otherwised these are used to ensure that only values for the longest variant of a gene are displayed by POTAGE. This is a way of dealing with cufflinks reporting low abundance alternative transcripts even when we are interested in per-gene expression only. Each subsequent column header contains the data point label. 

## Config File
 
A plain text file, with the `.cfg` filename extension, containing tag/value pairs defining data set specific parameters.
 
### Comments
 
Lines starting with `#` are comment lines and are ignored.

### Tag Names
 
The first non-whitespace characters on non-comment files constitute the `tag name`.

Valid tags names are:

  * `ShortName` : Short name for the data set. This value is used when displaying expression information and there is limited 
                  available space.
  * `LongName`  : Long name for the data set. This value is used when displaying expression information and there is more
                  space available.
  * `FileName`  : The name of the file containing expression values for the data set.
  * `Unit`      : The units of expression contained within the file defined by the `Filename` tag. Typical values for this tag are
                  `FPKM`, `CPM`, `TMM` etc ...
  
### Tag Values
 
All characters following the first group of 1 or more white-space charaters on non-comment lines constitute the `tag value`. Tag
values can contain white-space; strings should not be enclosed in quotes.


# Adding more data sets

Here we present an example workflow for including additional RNA-Seq datasets in POTAGE. We omit the read QC and alignment steps. We assume the user is able to generate a valid BAM file per data point which is to be displayed in POTAGE. The appropriate reference for aligning the reads when using a splice-aware aligner is `MiPS_genes_PlusMinus2kb_allTranscripts__AND__HCS_UNMAPPED_CDS.fasta`. 

Alternatively the user may resort to aligning their reads to [transcripts](ftp://ftpmips.helmholtz-muenchen.de/plants/wheat/IWGSC/genePrediction_v2.1/ta_IWGSC_MIPSv2.1_HCS_CDS_2013Nov28.fa.gz) , or even quantify the expression values using an alignment-free approach such as [Salmon](https://combine-lab.github.io/salmon/) or [kallisto](https://pachterlab.github.io/kallisto/). 

We include some of the settings used for aligning RNA-Seq reads from the [Meiosis](https://www.ncbi.nlm.nih.gov/bioproject/PRJEB5029) dataset 

```bash
    STAR \
    --runMode alignReads \
    --readFilesIn ${R1} ${R2} \
    --readFilesCommand pigz -dcp2 \
    --outFileNamePrefix ${OUTBASENAME} \
    --outSAMtype BAM SortedByCoordinate \
    --outFilterMultimapScoreRange 0 \
    --outFilterMultimapNmax 5 \
    --outFilterMismatchNoverLmax 0.00 \
    --outFilterMatchNminOverLread 1.0 \
    --outSJfilterOverhangMin 35 20 20 20 \
    --outSJfilterCountTotalMin 10 3 3 3 \
    --outSJfilterCountUniqueMin 5 1 1 1 \
    --alignEndsType EndToEnd \
    --alignSoftClipAtReferenceEnds No \
    --outSAMstrandField intronMotif \
    --alignIntronMax 10000 \
    --alignMatesGapMax 10000 \
    --outSAMattrRGline ID:${SAMPLE} PL:Illumina PU:${SAMPLE} LB:${SAMPLE} SM:${SAMPLE%_?} || exit 1 
```



## Quantify expression using cufflinks from BAM files generated using STAR 

For each of the the (per data point - merge if necessary) BAM files run 

        cufflinks -G MIPS_genes_PlusMinus2kb_allTranscripts.gtf data_point.bam \
        -o expression/data_point \
        --no-update-check --max-multiread-fraction 1 --library-type fr-unstranded 

In the case of Chinese Spring [Meiosis](https://www.ncbi.nlm.nih.gov/bioproject/PRJEB5029) dataset this could be done as follows:

        for f in merged_bams/*.bam; do s=${f##*/}; 
          cufflinks -G MIPS_genes_PlusMinus2kb_allTranscripts.gtf \
          ${f} expression/${s%.bam}; 
        done

## Aggregate per-gene FPKM values from individaul data points into a single table

        for d in expression/* ; do   
          LAST=${d}/sorted_genes.fpkm_tracking
          sort ${d}/genes.fpkm_tracking > ${LAST}
        done
        cut -f7 ${LAST} | tr ':-' '\t\t'  > genes.common
        cp genes.common genes.joined
        for d in expression/*; do
          tmp1=$(mktemp tmp.fpkms.joined.XXXXXXXXXX) 
          paste genes.joined <(cut -f10 ${d}/sorted_genes.fpkm_tracking) > ${tmp1} && mv ${tmp1} genes.joined
        done
        printf 'gene_id\tstart\tstop' > header.txt
        for d in expression/*; do
          s=${d##*/}
          printf "\t${s}" >> header.txt
        done
        cat header.txt <(printf '\n') <(tail -n +2 genes.joined) > data_points_expression.tsv 


## Create a simple configuration file describing the data set

For example, for the Chinese Spring Meiosis dataset we need

        #Expression dataset configuration
        ShortName Mei
        LongName  Chinese Spring - Meiosis
        Unit      FPKM
        FileName  meiose.tsv





