setwd("/Volumes/apocrita/autoScratch/2017-03-21_other_bee_work/results/2017-07-16_proteomics/")

all_samples.data <- read.table("./all_samples_proteome.txt", header=T)

head(data)

abaecin <- all_samples.data[1, ]
abaecin.gyne<- abaecin[,1:4]
abaecin.predia<- abaecin[,5:8]

test.df <- cbind(t(abaecin.gyne), t(abaecin.predia))
colnames(test.df) <- c("gyne", "predia")
test.df
test.df <- as.data.frame(test.df)

test.gyne.df <- as.data.frame(cbind(rownames(test.df), test.df$gyne))
test.pred.df <- as.data.frame(cbind(rownames(test.df), test.df$predia))

rbind(test.gyne.df, test.pred.df)

test.pred.df$V1<- gsub("GYN", "PRED", test.pred.df$V1)

combined.df <- rbind(test.gyne.df, test.pred.df)

combined.df$V1 <- gsub("0.*", "", combined.df$V1)
head(combined.df)

combined.df$V2 <- as.numeric(as.character(combined.df$V2))

abaecin.plot <- ggplot(combined.df, aes(x=combined.df$V1, y=combined.df$V2, fill=combined.df$V1)) + 
        geom_boxplot() +
        xlab("Life stage") +
        ylab("Log2 values") +
        theme(legend.position="none") +
        ggtitle("Abaecin")


defensin <- all_samples.data[2, ]

defensin.gyne<- defensin[,1:4]
defensin.predia<- defensin[,5:8]

defensin.test.df <- cbind(t(defensin.gyne), t(defensin.predia))
colnames(defensin.test.df) <- c("gyne", "predia")

defensin.test.df <- as.data.frame(defensin.test.df)

defensin.test.gyne.df <- as.data.frame(cbind(rownames(defensin.test.df), defensin.test.df$gyne))
defensin.test.pred.df <- as.data.frame(cbind(rownames(defensin.test.df), defensin.test.df$predia))

rbind(test.gyne.df, test.pred.df)

defensin.test.pred.df$V1<- gsub("GYN", "PRED", defensin.test.pred.df$V1)

defensin.combined.df <- rbind(defensin.test.gyne.df, defensin.test.pred.df)

defensin.combined.df$V1 <- gsub("0.*", "", defensin.combined.df$V1)
head(combined.df)

defensin.combined.df$V2 <- as.numeric(as.character(defensin.combined.df$V2))

defensin.plot <- ggplot(defensin.combined.df, aes(x=defensin.combined.df$V1, y=defensin.combined.df$V2, fill=defensin.combined.df$V1)) + 
        geom_boxplot() +
        xlab("Life stage") +
        ylab("Log2 values") +
        theme(legend.position="none") +
        ggtitle("Defensin")

hymen <- head(all_samples.data[3, ])
hymen.gyne<- hymen[,1:4]
hymen.predia<- hymen[,5:8]

hymen.test.df <- cbind(t(hymen.gyne), t(hymen.predia))
colnames(hymen.test.df) <- c("gyne", "predia")

hymen.test.df <- as.data.frame(hymen.test.df)

hymen.test.gyne.df <- as.data.frame(cbind(rownames(hymen.test.df), hymen.test.df$gyne))
hymen.test.pred.df <- as.data.frame(cbind(rownames(hymen.test.df), hymen.test.df$predia))

rbind(test.gyne.df, test.pred.df)

hymen.test.pred.df$V1<- gsub("GYN", "PRED", hymen.test.pred.df$V1)

hymen.combined.df <- rbind(hymen.test.gyne.df, hymen.test.pred.df)

hymen.combined.df$V1 <- gsub("0.*", "", hymen.combined.df$V1)
head(combined.df)

hymen.combined.df$V2 <- as.numeric(as.character(hymen.combined.df$V2))

hymen.plot <- ggplot(hymen.combined.df, aes(x=hymen.combined.df$V1, y=hymen.combined.df$V2, fill=hymen.combined.df$V1)) + 
        geom_boxplot() +
        xlab("Life stage") +
        ylab("Log2 values") +
        theme(legend.position="none") +
        ggtitle("Hymenoptaecin")

## Plot:
grid.arrange(abaecin.plot, defensin.plot, hymen.plot, ncol=3, nrow=3)

### Diapause vs. Late diapause:
setwd("/Volumes/apocrita/autoScratch/2017-03-21_other_bee_work/results/2017-07-16_proteomics/")

data_diapause <- read.table("./test_mid_late.txt", header=T)
head(data_diapause)

boxplot_plotter <- function(data, x, treat_1, treat_2, gene_name){
        ## Select line (gene) of interest:
        hymen <- data[x, ]
        ## Subset first treatment:
        hymen.gyne<- hymen[,1:4]
        ## Subset second treatment:
        hymen.predia<- hymen[,5:8]
        ## Transpose and combine the two subsets:
        hymen.test.df <- cbind(t(hymen.gyne), t(hymen.predia))
        ## Rename the columns:
        colnames(hymen.test.df) <- c(treat_1, treat_2)
        ## Convert matrix to dataframe:
        hymen.test.df <- as.data.frame(hymen.test.df)
        ## Separate treatment one and treatment two:
        hymen.test.gyne.df <- as.data.frame(cbind(rownames(hymen.test.df), hymen.test.df$PD1))
        hymen.test.pred.df <- as.data.frame(cbind(rownames(hymen.test.df), hymen.test.df$PD3))
        ## Modidfy the treatment names:
        hymen.test.pred.df$V1<- gsub("1PD", "3PD", hymen.test.pred.df$V1)
        ## Add together:
        hymen.combined.df <- rbind(hymen.test.gyne.df, hymen.test.pred.df)
        ## 
        hymen.combined.df$V1 <- gsub("0.*", "", hymen.combined.df$V1)
        ## Convert factor to numeric:
        hymen.combined.df$V2 <- as.numeric(as.character(hymen.combined.df$V2))
        ## Plot:
        hymen.plot <- ggplot(hymen.combined.df, aes(x=hymen.combined.df$V1, y=hymen.combined.df$V2, fill=hymen.combined.df$V1)) + 
                geom_boxplot() +
                xlab("Life stage") +
                ylab("Log2 values") +
                theme(legend.position="none") +
                ggtitle(gene_name)
        hymen.plot
}

dia_late.abaecin<- boxplot_plotter(data_diapause, 1, "DC", "MDC", "Abaecin")
dia_late.lysozyme2 <- boxplot_plotter(data_diapause, 3, "DC", "MDC", "Lysozyme-2")
dia_late.MD2 <- boxplot_plotter(data_diapause, 16, "DC", "MDC", "MD-2-related lipid-recognition protein")
dia_late.MPI <- boxplot_plotter(data_diapause, 17, "DC", "MDC", "inducible metalloproteinase inhibitor")
dia_late.chymo <- boxplot_plotter(data_diapause, 18, "DC", "MDC", "chymotrypsin inhibitor")
dia_late.PGRP <- boxplot_plotter(data_diapause, 20, "DC", "MDC", "PGRP2")
dia_late.SPTZ <- boxplot_plotter(data_diapause, 25, "DC", "MDC", "Spaetzle-like")
dia_late.lysozyme <- boxplot_plotter(data_diapause, 26, "DC", "MDC", "Lysozyme")
dia_late.PGRPSC2 <- boxplot_plotter(data_diapause, 27, "DC", "MDC", "PGRPSC2")

dia_late.conotoxin <- boxplot_plotter(data_diapause, 8, "DC", "MDC", "Omega conotoxin")

grid.arrange(dia_late.abaecin, dia_late.lysozyme2, dia_late.MD2, 
             dia_late.MPI,
             dia_late.chymo,
             dia_late.PGRP,
             dia_late.SPTZ,
             dia_late.lysozyme,
             dia_late.PGRPSC2,
             ncol=3, nrow=3)
## Postdiapause:
data.postdiapause <- read.table("./1day_3day_postdiapause.txt", header=T)
data<- data.postdiapause
x <- 1
treat_1 <- "PD1"
treat_2 <- "PD3"


postdiapause.plot.hymen <- boxplot_plotter(data.postdiapause, 1, "PD1", "PD3", "Hymenoptaecin")
postdiapause.plot.gst <- boxplot_plotter(data.postdiapause, 10, "PD1", "PD3", "GST")
postdiapause.plot.thioredoxin <- boxplot_plotter(data.postdiapause, 14, "PD1", "PD3", "Thioredoxin-2")
postdiapause.plot.sod <- boxplot_plotter(data.postdiapause, 17, "PD1", "PD3", "Superoxide dismutase")
postdiapause.plot.serpinb3 <- boxplot_plotter(data.postdiapause, 19, "PD1", "PD3", "SerpinB3")
postdiapause.plot.antichymotrypsin <- boxplot_plotter(data.postdiapause, 21, "PD1", "PD3", "Antichymotrypsin-2")
postdiapause.plot.antichymotrypsin2 <- boxplot_plotter(data.postdiapause, 25, "PD1", "PD3", "Chymotrypsin inhibitor 1")
postdiapause.plot.antichymotrypsin3 <- boxplot_plotter(data.postdiapause, 26, "PD1", "PD3", "Chymotrypsin inhibitor 2")
postdiapause.plot.PGRP2 <- boxplot_plotter(data.postdiapause, 30, "PD1", "PD3", "PGRP2")
postdiapause.plot.ebsp <- boxplot_plotter(data.postdiapause, 31, "PD1", "PD3", "Ejaculotory bulb-specific protein")
postdiapause.plot.serpin3 <- boxplot_plotter(data.postdiapause, 33, "PD1", "PD3", "Serpin-3")
postdiapause.plot.lysozyme <- boxplot_plotter(data.postdiapause, 46, "PD1", "PD3", "Lysozyme-like")
postdiapause.plot.antichymotrypsin4 <- boxplot_plotter(data.postdiapause, 49, "PD1", "PD3", "Chymotrypsin inhibitor 3")
postdiapause.plot.vitellogenin <- boxplot_plotter(data.postdiapause, 39, "PD1", "PD3", "Vitellogenin")
postdiapause.plot.alaserpin <- boxplot_plotter(data.postdiapause, 44, "PD1", "PD3", "Alaserpin")

boxplot_plotter(data.postdiapause, 47, "PD1", "PD3", "C1q protein")
boxplot_plotter(data.postdiapause, 43, "PD1", "PD3", "Uncharacterised")


grid.arrange(postdiapause.plot.hymen,
             postdiapause.plot.serpinb3,
             postdiapause.plot.alaserpin,
             postdiapause.plot.antichymotrypsin,
             postdiapause.plot.antichymotrypsin2,
             postdiapause.plot.antichymotrypsin3,
             postdiapause.plot.antichymotrypsin4,
             postdiapause.plot.PGRP2,
             postdiapause.plot.serpin3,
             postdiapause.plot.lysozyme,
             ncol=3, nrow=4)

## All samples:
## Read in the samples:
all_samples.data <- read.table("./all_samples_proteome.txt", header=T)

abaecin <- all_samples.data[39, ]

all_sample_plotter <- function(data, x, gene_name){
        abaecin <- data[x, ]
        abaecin.gyne<- abaecin[,1:4]
        abaecin.predia<- abaecin[,5:8]
        abaecin.middia<- abaecin[,9:12]
        abaecin.latedia<- abaecin[,13:16]
        abaecin.1postdia<- abaecin[,17:20]
        abaecin.3postdia<- abaecin[,21:24]
        ## Combine:
        test.df <- cbind(t(abaecin.gyne), 
                 t(abaecin.predia),
                 t(abaecin.middia),
                 t(abaecin.latedia),
                 t(abaecin.1postdia),
                 t(abaecin.3postdia))
        ## Rename columns:
        colnames(test.df) <- c("gyne", "predia", "middia", 
                       "latedia", "postdia1", "postdia3")
        ## Convert to dataframe:
        test.df <- as.data.frame(test.df)
        ##
test.gyne.df <- as.data.frame(cbind(rownames(test.df), test.df$gyne))
test.pred.df <- as.data.frame(cbind(rownames(test.df), test.df$predia))
test.middia.df <- as.data.frame(cbind(rownames(test.df), test.df$middia))
test.latedia.df <- as.data.frame(cbind(rownames(test.df), test.df$latedia))
test.1postdia.df <- as.data.frame(cbind(rownames(test.df), test.df$postdia1))
test.3postdia.df <- as.data.frame(cbind(rownames(test.df), test.df$postdia3))
##
new.test.df <- rbind(test.gyne.df, test.pred.df, test.middia.df,
                test.latedia.df, test.1postdia.df, test.3postdia.df)
## Change the column names:
new.test.df$status <- c("Gyne", "Gyne", "Gyne", "Gyne",
                 "Predia", "Predia", "Predia", "Predia",
                 "Middia", "Middia", "Middia", "Middia",
                 "Late", "Late", "Late", "Late",
                 "Post1", "Post1", "Post1", "Post1",
                 "Post3", "Post3", "Post3", "Post3")

new.test.df$V2 <- as.numeric(as.character(new.test.df$V2))

new.test.df$status <- as.character(new.test.df$status)
#Then turn it back into an ordered factor
new.test.df$status <- factor(new.test.df$status, levels=unique(new.test.df$status))

## Plot all samples:
plot <-ggplot(new.test.df, aes(x=new.test.df$status, y=new.test.df$V2, fill=new.test.df$status)) + 
        geom_boxplot() +
        xlab("Life stage") +
        ylab("Peptide intensity value") +
        theme(legend.position="none") +
        ggtitle(gene_name)

plot
}


## True hypothetical proteins:
all_sample_plotter(all_samples.data, 4, "Uncharacterised_protein")
all_sample_plotter(all_samples.data, 5, "Uncharacterised_protein")
all_sample_plotter(all_samples.data, 13, "Uncharacterised_protein")
all_sample_plotter(all_samples.data, 20, "Uncharacterised_protein")
all_sample_plotter(all_samples.data, 21, "Uncharacterised_protein")
all_sample_plotter(all_samples.data, 28, "Uncharacterised_protein")
all_sample_plotter(all_samples.data, 31, "Uncharacterised_protein")
all_sample_plotter(all_samples.data, 32, "Uncharacterised_protein")
all_sample_plotter(all_samples.data, 37, "Uncharacterised_protein")
all_sample_plotter(all_samples.data, 38, "Uncharacterised_protein")
all_sample_plotter(all_samples.data, 39, "Uncharacterised_protein")
all_sample_plotter(all_samples.data, 40, "Uncharacterised_protein")
all_sample_plotter(all_samples.data, 41, "Uncharacterised_protein")
all_sample_plotter(all_samples.data, 46, "Uncharacterised_protein")
all_sample_plotter(all_samples.data, 50, "Uncharacterised_protein")
all_sample_plotter(all_samples.data, 51, "Uncharacterised_protein")
all_sample_plotter(all_samples.data, 53, "Uncharacterised_protein")
all_sample_plotter(all_samples.data, 56, "Uncharacterised_protein")
all_sample_plotter(all_samples.data, 66, "Uncharacterised_protein")
all_sample_plotter(all_samples.data, 72, "Uncharacterised_protein")
all_sample_plotter(all_samples.data, 73, "Uncharacterised_protein")
all_sample_plotter(all_samples.data, 79, "Uncharacterised_protein")
all_sample_plotter(all_samples.data, 80, "Uncharacterised_protein")
all_sample_plotter(all_samples.data, 81, "Uncharacterised_protein")
all_sample_plotter(all_samples.data, 84, "Uncharacterised_protein")
all_sample_plotter(all_samples.data, 92, "Uncharacterised_protein")
all_sample_plotter(all_samples.data, 95, "Uncharacterised_protein")
all_sample_plotter(all_samples.data, 99, "Uncharacterised_protein")
all_sample_plotter(all_samples.data, 103, "Uncharacterised_protein")

## Olfactory proteins:
OBP3.plot <- all_sample_plotter(all_samples.data, 37, "OBP3")
OBP19.plot <- all_sample_plotter(all_samples.data, 38, "OBP19")
OBP4.plot  <- all_sample_plotter(all_samples.data, 39, "OBP4")
ejac.1.plot <- all_sample_plotter(all_samples.data, 30, "Ejac_1")
ejac.2.plot <- all_sample_plotter(all_samples.data, 62, "Ejac_2")
odorant.binding.plot <- all_sample_plotter(all_samples.data, 65, "OBP")

grid.arrange(OBP3.plot, OBP19.plot, OBP4.plot)
grid.arrange(ejac.1.plot, ejac.2.plot, odorant.binding.plot)

## :
## True hypothetical proteins:
all_sample_plotter(all_samples.data, 4, "Uncharacterised_protein")
