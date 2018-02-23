## This file is for plotting of Venn diagram associated with mussel proteomics:

## The study
##============================================================================

## Proteomic analysis of PLA and HDPE exposed mussels identified a total of 
## 40 genes to be differentially abundant. 
## Of this number, 6 were differentially expressed in both in comparison to control
## 11 HDPE vs. control
## 4 PLA vs. control

## Load modules:
install.packages("VennDiagram")
library(VennDiagram)

dev.off()

##
draw.pairwise.venn(19, 8, 5, category = c("HDPE vs. Control", "PLA vs. Control"), 
                   lty = 1, 
                   fill = c("grey", "white"), 
                   cex = 1.5, cat.fontface = 2,
                   alpha = rep(0.5, 2), 
                   cat.pos = c(0,0), 
                   cat.cex=1.5,
                   cat.dist = rep(0.050, 2), scaled = FALSE) 

draw.pairwise.venn(4, 3, 2, category = c("HDPE vs. Control", "PLA vs. Control"), 
                   lty = 1, 
                   fill = c("grey", "white"), 
                   cex = 1.5, cat.fontface = 2,
                   alpha = rep(0.5, 2), 
                   cat.pos = c(0,0), 
                   cat.cex=1.5,
                   cat.dist = rep(0.050, 2), scaled = FALSE) 


              
?draw.pairwise.venn
