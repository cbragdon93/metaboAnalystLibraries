library(dplyr)
library(stringr)
#' scraping the metabolite library files
#' for all the pubmed links they referenced
#' during their constructions. Consult the READMEs for details

#' Yeah, I copy-pasted
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
p=sapply(qsFiles, function(f){
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
  thisMsetLit <- sapply(
    1:length(thisTime$name), function(x){
      thisPath=thisTime[x,"name"]
      thisPathId=thisTime[x,"id"]
      #' remove the u html tag elements from anchors
      uPattern = "<u.*?>.*</u>"
      aPatternOne = "<a href=\""
      aPatternTwo = "\" target=\"_blank\"></a>"
      theseReferences = thisTime[x, "reference"]
      anchorsOnly = gsub(
        uPattern,
        "",
        theseReferences
      )
      # I'd have nested/piped all the gsubs,
      # but doing that seemed to break the
      # string searches/splits...
      prunedAnchors =
        gsub(
          aPatternTwo, 
          "", 
          gsub(
            aPatternOne, 
            "", 
            anchorsOnly
          )
        ) %>%
        strsplit(
          "\n"
        )
      myList = prunedAnchors
      names(myList) = paste(thisPath,thisPathId,sep=name_delim)
      myList
    }
  )
  saveRDS(thisMsetLit,
          file.path(
            rdsDir,
            "literatureReferences",
            paste0(thisLibrary, "_References.RDS")
          ))
})

#' Afterwards, I compressed the RDS files
#' since I did this extraction both by name and by HMDB_ID