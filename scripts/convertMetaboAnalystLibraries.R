library(qs) # required to read qs files
library(MetaboAnalystR)
# source("metaboliteMappingTable.R") # If you want to go with the API, which would take a long time

#' Before beginning...
#' MetaboAnalystR "caches" the metabolite set libraries
#' into your cwd as "qs" files, likewise for their 
#' compound name-to-ID mapping
#' (with some command that you would use during the enrichment analysis on console).
#' 
#' The qs files from the MetaboAnalyst Platform have the following fields:
#' > id = metaboanalyst ID (in the form of "hMSEAXXXX)
#' > name = name of the pathology/pathway
#' > member = semicolon-delimited text field listing compound common names
#' > reference = pubmed anchor html tags
#' > image = SMPDB ID
#' 
#' What is a qs file?
#' from fileinfo.com
#' Automation install script used by Qt, a cross-platform application 
#' development toolkit; contains data used to locate and install user-defined 
#' features; compressed with the 7zip format.
#' 
#' ===========================================================================
whereOnFS <- dirname(rstudioapi::getSourceEditorContext()$path)
qsDir<-file.path(whereOnFS,"../qs_Files/")
rdsDir<-file.path(whereOnFS,"../RDS_Files/")
#' goal is to create RDSs of the metabolite sets
#' from metaboAnalystR. They "cache" compound library qs files
#' in your cwd, so we're excluding them from the loop here, and
#' using them as references instead.
qsFiles <- setdiff(
  list.files(qsDir, pattern = ".qs"),
  c(
    "compound_db.qs",
    "master_compound_db.qs",
    "syn_nms.qs",
    "master_syn_nms.qs"
  )
)
#' print list of qs files in cwd for good measure
print(qsFiles)
compoundsReference <- qread(file.path(qsDir, "master_compound_db.qs"))
#' for the final rds filenames and for bringing along the hMSEA ID
#' along in the pathway name
name_delim <- "_"

#' for each qs file
#' of interest...
sapply(qsFiles, function(f){
  #' For progress/tracking, which
  #' library we're on right now.
  print(f)
  #' get name of the mset(in filename)
  thisLibrary=strsplit(f,"[.]")[[1]][1]
  #' read current qs file.
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
      #' that takes the preferred ID name output as a param.
      myList=list(theseMembers)
      if(F){
        #' Mind you, there isn't a perfect 1:1 mapping of compound_name:HMDB_ID,
        #' Useful to be mindful of for potential troubleshooting.
        theseMembersByHMDBID = compoundsReference[compoundsReference$name %in% unlist(theseMembers), "hmdb_id"]
        myList=list(theseMembersByHMDBID)
      }
      #' I brought their hMSEA IDs for the ride below, in case 
      #' we wanted to use those for a unique identifier.
      names(myList)=paste(thisPath,thisPathId,sep=name_delim)
      myList
    }
  )
  #' where the constructed MSet gets written to
  saveRDS(thisMset, paste0(rdsDir,file="",thisLibrary,".RDS"))
  #' Don't freak out at the output. since
  #' I'm simply saving the RDS version of what I've processed
  #' I don't return anything. If you just want to work with it outright,
  #' have the sapply "return(`thisMset`)" instead
})
#' Afterwards, I compressed the RDS files
#' since I did this extraction both by name and by HMDB_ID