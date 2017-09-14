There are two major data components to POTAGE:

  1. [Global](./global) - the core precomputed information on which POTAGE is built
  2. [Expression](./expression) - the gene expression data sets for visualisation within POTAGE

You are most likely to want to add additional gene expression data sets to POTAGE, so we describe here the process for doing so.

# Adding expression data sets

Here we present an example workflow for including additional RNA-Seq datasets in POTAGE. We omit the read QC and alignment steps. We assume the user is able to generate a valid BAM file per data point which is to be displayed in POTAGE. The appropriate reference for aligning the reads when using a splice-aware aligner is `MiPS_genes_PlusMinus2kb_allTranscripts__AND__HCS_UNMAPPED_CDS.fasta.gz` (TO BE ADDED TO REPO). 

Alternatively the user may resort to aligning their reads to [transcripts](ftp://ftpmips.helmholtz-muenchen.de/plants/wheat/IWGSC/genePrediction_v2.1/ta_IWGSC_MIPSv2.1_HCS_CDS_2013Nov28.fa.gz), or even quantify the expression values using an alignment-free approach such as [Salmon](https://combine-lab.github.io/salmon/) or [kallisto](https://pachterlab.github.io/kallisto/). 

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
        cat header.txt <(printf '\n') <(tail -n +2 genes.joined) > meiose.tsv 


## Create a simple configuration file describing the data set

For example, for the Chinese Spring Meiosis dataset `config.cfg` might look as follows:

        #Expression dataset configuration
        ShortName Mei
        LongName  Chinese Spring - Meiosis
        Unit      FPKM
        FileName  meiose.tsv

## Make files available to your POTAGE instance and re-load the web-app

POTAGE picks up the expression data sets from a directory specified in `potage.cfg`, by default this is `expression`. For an additional dataset to be loaded into POTAGE we create a new sub-directory under `expression`, for example:

        mkdir expression/002_meiose

We then place the file with expression values (`meiose.tsv`) and the data set configuration file `config.cfg` in the newly created sub-directory
