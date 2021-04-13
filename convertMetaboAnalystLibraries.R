library(qs) # required to read qs files
library(MetaboAnalystR)
# source("metaboliteMappingTable.R") # If you want to go with the API, which would take a long time

#' Before beginning...
#' MetaboAnalystR "caches" the metabolite set libraries
#' into your cwd as "qs" files, likewise for their 
#' compound name-to-ID mapping(with some command that you would use during the enrichment analysis).
#' 
#' The qs files from the MetaboAnalyst Platform have the following fields:
#' > id = metaboanalyst ID (in the form of "hMSEAXXXX)
#' > name = name of the pathology/pathway
#' > member = semicolon-delimited text field listing compound common names
#' > reference = pubmed anchor tags
#' > image = SMPDB ID


qsDir<-"./Documents/projects/metaboAnalystLibraries/"
#' goal is to create RDSs of the metabolite sets
#' from metaboAnalystR. They "cache" compound library qs files
#' in your cwd, so we're excluding them from the loop here, and
#' using them as references instead.
qsFiles<-setdiff(list.files(qsDir, pattern=".qs"),c("compound_db.qs","master_compound_db.qs","syn_nms.qs","master_syn_nms.qs"))
#' print list of qs files in cwd for good measure
print(qsFiles)
compoundsReference = qread(file.path(qsDir,"master_compound_db.qs"))
#' for the final rds filenames.
#' 
name_delim="_"


sapply(qsFiles, function(f){
  #' where am I?
  print(f)
  #' get name of the mset(in filename)
  thisLibrary=strsplit(f,"[.]")[[1]][1]
  #' 
  thisTime <- qread(file.path(qsDir,f))
  #' compile mset
  #' for each pathway in the qs file... (since the members for each
  #' pathway are all together in a semi-colon delimited field, we can
  #' do what I'm doing here)
  thisMset <- sapply(
    1:length(thisTime$name), function(x){
      thisPath=thisTime[x,"name"]
      thisPathId=thisTime[x,"id"]
      #' break up the member value by semicolon
      #' to get vector of compounds
      theseMembers=list(strsplit(thisTime[x,"member"], "; ")[[1]])[[1]]
      #' if you want to get a different ID(e.g. HMDB ID) rather than name,
      #' work with this "debug" block
      #' or you can just adapt this entire code into a function
      #' that takes the preferred ID name as a param.
      myList=list(theseMembers)
      if(F){
        theseMembersByHMDBID = compoundsReference[compoundsReference$name %in% unlist(theseMembers), "hmdb_id"]
        myList=list(theseMembersByHMDBID)
      }
      names(myList)=paste(thisPath,thisPathId,sep=name_delim)
      myList
    }
  )
  saveRDS(thisMset, paste0(qsDir,"/RDS_Files/",file="",thisLibrary,".RDS"))
  #' Don't freak out at the output. since
  #' I'm simply saving the RDS version of what I've processed
  #' I don't return anything.
}
)
