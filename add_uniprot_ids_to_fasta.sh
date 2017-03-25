#!/usr/bin/env bash
##############################################################################
##############################################################################
# Author: Joe Colgan                   Program: add_uniprot_ids_to_fasta.sh
#
# Date: 25/03/2017
#
# Purpose:
# - To add uniprot ids from Drosophila and Apis to Bombus RefSeq
##############################################################################
## Things to know
##================
## BLASTp searches were performed with Bombus RefSeq protein set against 
## Uniprot proteins for Apis mellifera and Drosophila melanogaster
## BLASTp searches were performed using e-value 1e-06.
## Using the output, Bombus proteins with matches in both Apis and Drosophila
## were subsetted. 

## Subset the sequence information for homologues
 cut -d '_' -f 1,2 GCF_000214255.1_Bter_1.0_protein.homologue_list.txt > GCF_000214255.1_Bter_1.0_protein.homologue_list.tmp

## Use the Bombus IDs to parse the BLAST output files for Apis and Drosophila:
grep -f GCF_000214255.1_Bter_1.0_protein.homologue_list.tmp \
      best_single_hits.Apis.evalue_1e06.GCF.blastp \
      > best_single_hits.Apis.evalue_1e06.GCF.blastp.filtered.txt
      
grep -f GCF_000214255.1_Bter_1.0_protein.homologue_list.tmp \
      best_single_hits.Dros.evalue_1e06.GCF.blastp \
      > best_single_hits.Dros.evalue_1e06.GCF.blastp.filtered.txt

## Paste the header information together:
paste best_single_hits.Apis.evalue_1e06.GCF.blastp.filtered.txt best_single_hits.Dros.evalue_1e06.GCF.blastp.filtered.txt \
      | cut -f 1,2,14 - > best_single_hits.Apis.Dros.evalue_1e06.GCF.blastp.filtered.header.txt
      
sed 's/\t/_|/g' best_single_hits.Apis.Dros.evalue_1e06.GCF.blastp.filtered.header.txt \
      > test.txt

grep -f GCF_000214255.1_Bter_1.0_protein.homologue_list.tmp GCF_000214255.1_Bter_1.0_protein.15-06-16.faa > sequence_headers_to_change.txt
sed -i 's/>//g' sequence_headers_to_change.txt

paste sequence_headers_to_change.txt test.txt > names.txt

../src/seqkit replace -p "(.+)" -r '{kv}|$1' -k names.txt \
    GCF_000214255.1_Bter_1.0_protein.15-06-16.faa > GCF_000214255.1_Bter_1.0_protein.15-06-16.renamed.faa
