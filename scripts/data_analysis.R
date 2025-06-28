#set working directory
setwd("")

#data unzippen
unzip("Data_RA_raw.zip", exdir = "data/")

#BiocManager installeren en de Rsubread library installeren
install.packages('BiocManager')
BiocManager::install('Rsubread')
library(Rsubread)

#indexeren referentiegenoom
buildindex(
  basename = 'ref_human',
  reference = 'humanrefgenome/ncbi_dataset/data/GCF_000001405.40/GCF_000001405.40_GRCh38.p14_genomic.fna',
  memory = 22000,
  indexSplit = TRUE)

#normaal & rheuma monsters mappen
align.control1 <- align(index = "ref_human", readfile1 = "raw_data/Data_RA_raw/SRR4785819_1_subset40k.fastq", readfile2 = "raw_data/Data_RA_raw/SRR4785819_2_subset40k.fastq", output_file = "control1.BAM")
align.control2 <- align(index = "ref_human", readfile1 = "raw_data/Data_RA_raw/SRR4785820_1_subset40k.fastq", readfile2 = "raw_data/Data_RA_raw/SRR4785820_2_subset40k.fastq", output_file = "control2.BAM")
align.control3 <- align(index = "ref_human", readfile1 = "raw_data/Data_RA_raw/SRR4785828_1_subset40k.fastq", readfile2 = "raw_data/Data_RA_raw/SRR4785828_2_subset40k.fastq", output_file = "control3.BAM")
align.control4 <- align(index = "ref_human", readfile1 = "raw_data/Data_RA_raw/SRR4785831_1_subset40k.fastq", readfile2 = "raw_data/Data_RA_raw/SRR4785831_2_subset40k.fastq", output_file = "control4.BAM")
align.rheuma1 <- align(index = "ref_human", readfile1 = "raw_data/Data_RA_raw/SRR4785979_1_subset40k.fastq", readfile2 = "raw_data/Data_RA_raw/SRR4785979_2_subset40k.fastq", output_file = "rheuma1.BAM")
align.rheuma2 <- align(index = "ref_human", readfile1 = "raw_data/Data_RA_raw/SRR4785980_1_subset40k.fastq", readfile2 = "raw_data/Data_RA_raw/SRR4785980_2_subset40k.fastq", output_file = "rheuma2.BAM")
align.rheuma3 <- align(index = "ref_human", readfile1 = "raw_data/Data_RA_raw/SRR4785986_1_subset40k.fastq", readfile2 = "raw_data/Data_RA_raw/SRR4785986_2_subset40k.fastq", output_file = "rheuma3.BAM")
align.rheuma4 <- align(index = "ref_human", readfile1 = "raw_data/Data_RA_raw/SRR4785988_1_subset40k.fastq", readfile2 = "raw_data/Data_RA_raw/SRR4785988_2_subset40k.fastq", output_file = "rheuma4.BAM")


#Rsamtools downloaden en inladen
BiocManager::install('Rsamtools')
library(Rsamtools)

#Bestandsnamen monsters
samples <- c("control1", "control2", "control3", "control4", "rheuma1", "rheuma2", "rheuma3", "rheuma4")

#sorteren en indexeren van BAM-files
lapply(samples, function(s) {sortBam(file = paste0(s, '.BAM'), destination = paste0(s, '.sorted'))})




#libraries inladen voor count matrix
library(readr)
library(dplyr)
library(Rsamtools)
library(Rsubread)

#vector definieren met namen van BAM-bestanden. Elke BAM bevat reads van een RNA-seq-experiment (bijv. behandeld vs. controle).
allsamples <- c("control1.BAM", "control2.BAM", "control3.BAM", "control4.BAM", "rheuma1.BAM", "rheuma2.BAM", "rheuma3.BAM", "rheuma4.BAM")
View(allsamples)

#count_matrix maken van kleine data
count_matrix <- featureCounts(
  files = allsamples,
  annot.ext = "humanrefgenome/ncbi_dataset/data/GCF_000001405.40/genomic.gtf",
  isPairedEnd = TRUE,
  isGTFAnnotationFile = TRUE,
  GTF.attrType = "gene_id",
  useMetaFeatures = TRUE
)

#volledige count matrix inladen
counts <- read.delim("count_matrix.txt", row.names = 1)
count_matrix <- round(counts)
colnames(count_matrix) <- c("control1", "control2", "control3", "control4", "rheuma1", "rheuma2", "rheuma3", "rheuma4")

#behandelingstabel maken voor welke samples controle of rheuma patienten zijn
treatment <- c("control", "control", "control", "control", "rheuma", "rheuma", "rheuma", "rheuma")
treatment_table <- data.frame(treatment)
rownames(treatment_table) <- c("control1", "control2", "control3", "control4", "rheuma1", "rheuma2", "rheuma3", "rheuma4")
View(treatment_table)
install.packages("Rtools")
library(Rsamtools)
BiocManager::install("DESeq2")
BiocManager::install("KEGGREST")
library(DESeq2)
library(KEGGREST)

#DESeqDataSet aanmaken
dds <- DESeqDataSetFromMatrix(countData = count_matrix,
                              colData = treatment_table,
                              design = ~ treatment)

#analyse uitvoeren
dds <- DESeq(dds)
resultaten <- results(dds)
str(resultaten)


#resultaten opslaan in een bestand
write.table(resultaten, file = 'resultaten/DESeqAnalysis.csv', row.names = TRUE, col.names = TRUE)

#sum van significante genen die op if neergereguleerd zijn
sum(resultaten$padj < 0.05 & resultaten$log2FoldChange > 1, na.rm = TRUE)
sum(resultaten$padj < 0.05 & resultaten$log2FoldChange < -1, na.rm = TRUE)

#opvallende genen uit resultaten bepalen
hoogste_fold_change <- resultaten[order(resultaten$log2FoldChange, decreasing = TRUE), ]
laagste_fold_change <- resultaten[order(resultaten$log2FoldChange, decreasing = FALSE), ]
laagste_p_waarde <- resultaten[order(resultaten$padj, decreasing = FALSE), ]

#belangrijkste genen volgens de analyse
head(laagste_p_waarde)


#volcano plot
if (!requireNamespace("EnhancedVolcano", quietly = TRUE)) {
  BiocManager::install("EnhancedVolcano")
}
library(EnhancedVolcano)

EnhancedVolcano(resultaten,
                lab = rownames(resultaten),
                x = 'log2FoldChange',
                y = 'padj')

#figuur opslaan
dev.copy(png, 'resultaten/VolcanoplotWC.png', 
         width = 8,
         height = 10,
         units = 'in',
         res = 500)
dev.off()


#Gene Ontology Enrichment Analysis
if (!requireNamespace("goseq", quietly = TRUE)) {
  BiocManager::install("goseq")
}
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

BiocManager::install("org.Hs.eg.db")
library(org.Hs.eg.db)
library(goseq)
library(geneLenDataBase)
BiocManager::install("tidyverse")
library(tidyverse)

ddsdata <- read.csv("resultaten/DESeqAnalysis.csv", header = TRUE)


sigData <- as.integer(!is.na(resultaten$padj) & resultaten$padj < 0.01)
names(sigData) <- rownames(resultaten)

head(sigData)

#PWF gebruiken

pwf <- nullp(sigData, "hg19", "geneSymbol", bias.data = resultaten$padj)
goResults <- goseq(pwf, "hg19","geneSymbol", test.cats=c("GO:BP"))

#Package installeren en inladen
install.packages('GOplot')
library(GOplot)
library(dplyr)
library(biomaRt)
library(goseq)
library(dplyr)

goResults %>% 
  top_n(10, wt=-over_represented_pvalue) %>% 
  mutate(hitsPerc=numDEInCat*100/numInCat) %>% 
  ggplot(aes(x=hitsPerc, 
             y=term, 
             colour=over_represented_pvalue, 
             size=numDEInCat)) +
  geom_point() +
  expand_limits(x=0) +
  labs(x="Hits (%)", y="GO term", colour="p value", size="Count")


#GO information met GO accessions krijgen
BiocManager::install('GO.db')
library(GO.db)
GOTERM[[goResults$category[2]]] #adaptive immune response



#KEGG pathway analyse




if (!requireNamespace("pathview", quietly = TRUE)) {
  BiocManager::install("pathview")
}
library(pathview)

resultaten[1] <- NULL
resultaten[2:5] <- NULL

pathview(
  gene.data = count_matrix,
  pathway.id = "hsa04660",  # KEGG ID, hsa voor homo sapiens en 05323 is het ID van rheuma
  species = "hsa",          # hsa staat voor human
  gene.idtype = "SYMBOL",     # Geeft aan dat het KEGG-ID's zijn
  limit = list(gene = 5)    # Kleurbereik voor log2FC van -5 tot +5
)

