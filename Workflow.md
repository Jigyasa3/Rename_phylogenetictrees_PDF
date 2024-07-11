### To create a PDF of file run Step2 as it is. If the tip labels of the file are too long, then that can interfere with the PDF output generation. In that case run Step1 and Step2


## Step1- in R
```
filename<-list.files(path= "~/Downloads/transfer_23973_files_6a46e41b/Extended_Data_S1", pattern= ".newick", full.names = TRUE) #name of the folder and extension of the files

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
  outputpath="/Users/jigyasaarora/Downloads/transfer_23973_files_6a46e41b/Extended_Data_S1_nwk/" #name of the output folder
  fullname<-paste0(outputpath,cogtreename,".nwk") #path and filename of the output file
  write.tree(cogtree2,file=fullname)
}

```

## Step2.0- install the python package
```
#in terminal-
conda install conda-forge::ete3
#in ipython notebook-
import ete3
#NOTE-If this doesn't give an error, then the ete3 python package is successfully installed!
```

## Step2- in python
```
##to read and write multiple files together-https://education.molssi.org/python_scripting_cms/03-multiple_files/index.html
##ete tutorial on generating a pdf- http://etetoolkit.org/docs/latest/tutorial/tutorial_drawing.html#rendering-trees-as-images
import ete3
from ete3 import Tree
import os 
from pathlib import Path
import glob

input_path = os.path.join('/Users/jigyasaarora/Downloads/transfer_23973_files_6a46e41b/Extended_Data_S1_nwk/', '*.nwk')
filenames = glob.glob(input_path)

print(filenames)

##on one file-
#t = Tree("Extended_Data_S1/GH13_23.newick")
#print(t.write())
#t.render("Extended_Data_S1/GH13_23.newick.pdf", w=183, units="mm")

#on all files-
for f in filenames:
    # Get the molecule name
    file_name = os.path.basename(f)
    print(file_name)
    molecule_name =f+".pdf"
    print(molecule_name)

    # Read the data
    t = Tree(f) #or Tree(f, format=1) #format=1 is flexible with internal node names
    ##print(t.write())
    t.render(molecule_name, w=80, h=700, units="mm")

```
