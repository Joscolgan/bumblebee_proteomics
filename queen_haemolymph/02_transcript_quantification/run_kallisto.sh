## Create directories:
mkdir data
mkdir code
mkdir results
mkdir src
mkdir bin

## Download software
cd src
wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-mac64.tar.gz
tar -zxvf sratoolkit.current-mac64.tar.gz
rm sratoolkit.current-mac64.tar.gz
cd ../bin

## Create symbolic link for executables:
ln -s ../src/sratoolkit.2.9.2-mac64/bin/fastq-dump.2.9.2 . 
cd ../data

## Download files:
while read line                                                                                                                                               
do
abbrev_name="${line:0:6}"
wget ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/SRR/"$abbrev_name"/"$line"/"$line".sra
done < samples_to_download

## Split downloaded files
for name in *.sra                                                                                                                                             
do
../bin/fastq-dump.2.9.2 --split-3 "$name"
new_name="$(echo "$name" | cut -d '.' -f 1 - )"
gzip "$new_name".fastq
rm -f "$name"
done

## Download kallisto for performing pseudoalignments:
cd ../src
wget https://github.com/pachterlab/kallisto/releases/download/v0.45.0/kallisto_mac-v0.45.0.tar.gz
tar -zxvf kallisto_mac-v0.45.0.tar.gz
cd ../bin

## Create symbolic link for running kallisto:
ln -s ../src/kallisto/kallisto .

## Create reference for pseudo alignments:
cd ../data/
mkdir reference_files
cd reference_files
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/214/255/GCF_000214255.1_Bter_1.0/GCF_000214255.1_Bter_1.0_rna.fna.gzgunzip GCF_000214255.1_Bter_1.0_rna.fna.gz

## Create an index
cd ../results/
mdkir 2019-01-25_kallisto_alignments
cd 2019-01-25_kallisto_alignments
../../bin/kallisto index -i bter_1.0 ../../data/reference_files/GCF_000214255.1_Bter_1.0_rna.fna

## Quantify samples:
## Create symbolic links for each sample:
ln -s ../../data/*.gz .

## Run kallisto:
for name in *.gz
do
output_name="$(echo "$name" | cut -d '.' -f 1 - )"
../../bin/kallisto quant -i bter_1.0 -o "$output_name" --single -l 200 -s 20 "$name"
done
