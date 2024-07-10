library(ape)
library(dplyr)
library(treeio)
library(stringr)
library(ggtree)

##<on one file>
cogtree<-read.newick(file="~/Downloads/transfer_23973_files_6a46e41b/Extended_Data_S2/GH77_cluster_2.newick")
is.rooted(cogtree)
d<-data.frame(label=cogtree$tip.label)

#add new labels-
d<-d%>%mutate(bacname=ifelse(str_detect(label,"^'1-"),gsub("^.*--","",d$label),ifelse(str_detect(label,"^'GB-|^'RS-"),gsub("^.*_p__","",d$label),gsub("^.*__d__Bacteria_p__","",d$label))))

d<-d%>%mutate(id=ifelse(str_detect(label,"^'1-"),gsub("_.*$","",d$label),ifelse(str_detect(label,"^'GB-|^'RS-"),gsub("__.*$","",d$label),gsub("__d__.*$","",d$label))))
d$bacname<-gsub("'","",d$bacname)
d$id<-gsub("'","",d$id)
d$label2<-paste0(d$id,"_",d$bacname)

#rename the tree-
cogtree2<-rename_taxa(cogtree, d, label, label2)

#save as nwk-
write.tree(cogtree2,file="~/Downloads/transfer_23973_files_6a46e41b/Extended_Data_S2/GH77_cluster_2.newick.nwk")

#NOTE-Convert the file to PDF using ete3 python script "ete3_pdfgeneration"
#---------------------------------------------------------------------------------------------------------------------------------------#
##<on all files>

filename<-list.files(path= "~/Downloads/transfer_23973_files_6a46e41b/Extended_Data_S2", pattern= ".newick", full.names = TRUE)

for (i in 1:length(filename)){
  cogtree<-read.newick(filename[i]) #read the file
  cogtreename<-gsub("^.*\\/","",filename[i]) #filename
  is.rooted(cogtree)
  d<-data.frame(label=cogtree$tip.label)
  
  #add new labels-
  d<-d%>%mutate(bacname=ifelse(str_detect(label,"^'1-"),gsub("^.*--","",d$label),ifelse(str_detect(label,"^'GB-|^'RS-"),gsub("^.*_p__","",d$label),gsub("^.*__d__Bacteria_p__","",d$label))))
  
  d<-d%>%mutate(id=ifelse(str_detect(label,"^'1-"),gsub("_.*$","",d$label),ifelse(str_detect(label,"^'GB-|^'RS-"),gsub("__.*$","",d$label),gsub("__d__.*$","",d$label))))
  d$bacname<-gsub("'","",d$bacname)
  d$id<-gsub("'","",d$id)
  d$label2<-paste0(d$id,"_",d$bacname)
  
  #rename the tree-
  cogtree2<-rename_taxa(cogtree, d, label, label2)
  
  #save as nwk-
  outputpath="/Users/jigyasaarora/Downloads/transfer_23973_files_6a46e41b/Extended_Data_S2_nwk/"
  fullname<-paste0(outputpath,cogtreename,".nwk")
  write.tree(cogtree2,file=fullname)
}

##CHECK if all the files are finished running
donefilenames<-list.files(path= "~/Downloads/transfer_23973_files_6a46e41b/Extended_Data_S2_nwk/", pattern= ".newick", full.names = TRUE)
length(filename)==length(donefilenames) #it matches!
