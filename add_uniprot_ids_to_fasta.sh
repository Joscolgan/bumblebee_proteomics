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

# BLAST command
#blastp -query 2017-04-07_Bter_2015_v1.fasta \
#       -db ../Apis_Uniprot \
#       -evalue 1e-06 \
#       -num_threads 10 \
#       -outfmt 6 | sort -k1,1 -k12,12nr -k11,11n | sort -u -k1,1 --merge \ |
#       > best_single_hits.bter_vs_apis.blastn

## The results of the BLAST searches indicate that:
# 9908 Bter proteins annotated from Apis search
# 8418 Bter proteins annotated from Dros search

## Four stages of the data:
# 1) Bter matches to both Apis and Dros
# 2) Bter matches to only Apis
# 3) Bter matches to only Dros
# 4) Bter protein sequences without matches to Apis or Dros

## Stage One: Annotate proteins with matches to Apis and Dros
# For files containing the BLAST outputs, parse the field containing Bter protein IDs.
# Sort the Ids and take only unique matches and output
for name in *.blastn; do cut -f 1 "$name" | sort | uniq > "$name".Bter_Ids.txt; done

## Combined Bter_IDs for Apis and Dros BLAST outputs
cat *Bter_Ids* > Bter_IDs_with_Apis_and_Dros_homologues.txt

## Move to a folder for convenience
mv Bter_IDs_with_Apis_and_Dros_homologues.txt stage_1_Apis_Dros_matches/

## Sort and count unique 
sort Bter_IDs_with_Apis_and_Dros_homologues.txt | uniq -c > Bter_IDs_with_Apis_and_Dros_homologues.tmp

sort Bter_IDs_with_Apis_and_Dros_homologues.txt | uniq -c | awk '$1==2' - > Bter_IDs_with_Apis_and_Dros_homologues.confirmed.txt
wc -l Bter_IDs_with_Apis_and_Dros_homologues.confirmed.txt #6873

awk '{ print $2 }' Bter_IDs_with_Apis_and_Dros_homologues.confirmed.txt > Bter_IDs_with_Apis_and_Dros_homologues.confirmed.tmp
mv Bter_IDs_with_Apis_and_Dros_homologues.confirmed.tmp Bter_IDs_with_Apis_and_Dros_homologues.confirmed.txt

## Subset the sequence information for homologues
grep -f Bter_IDs_with_Apis_and_Dros_homologues.confirmed.txt \
        ../best_single_hits.bter_vs_apis.blastn | \
        cut -f 1,2 - > Bter_IDs_with_Apis_and_Dros_homologues.confirmed.Apis_Ids.txt 

grep -f Bter_IDs_with_Apis_and_Dros_homologues.confirmed.txt \
        ../best_single_hits.bter_vs_dros.blastn | \
        cut -f 1,2 - > Bter_IDs_with_Apis_and_Dros_homologues.confirmed.Dros_Ids.txt 

## Using the subset FASTA names (have identified FASTA sequences that are in Bter, Amel and Dmel)
paste Bter_IDs_with_Apis_and_Dros_homologues.confirmed.Apis_Ids.txt \
      Bter_IDs_with_Apis_and_Dros_homologues.confirmed.Dros_Ids.txt | \
      cut -f 1,2,4 - > Bter_IDs_with_Apis_and_Dros_homologues.confirmed.Bter_Apis_Dros.IDs.txt

## 

sed -i 's,.1|,.1_|,g' Bter_IDs_with_Apis_and_Dros_homologues.confirmed.Bter_Apis_Dros.IDs.uniprot_IDs.tmp

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
