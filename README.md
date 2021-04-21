# Before beginning...
# About the mSet Files.
 MetaboAnalystR "caches" the metabolite set libraries
 into your cwd as "qs" files, likewise for their 
 compound name-to-ID mapping
 (with some command that you would use during the enrichment analysis on console).
 
 The qs files from the MetaboAnalyst Platform have the following fields:
 > id = metaboanalyst ID (in the form of "hMSEAXXXX)
 > name = name of the pathology/pathway
 > member = semicolon-delimited text field listing compound common names
 > reference = pubmed anchor html tags
 > image = SMPDB ID
 
## What is a qs file?
 from fileinfo.com
 Automation install script used by Qt, a cross-platform application 
 development toolkit; contains data used to locate and install user-defined 
 features; compressed with the 7zip format.


# About the scripts directory
> installMetaboAnalyst.R
  - code to install required dependencies and MetaboAnalystR itself.
> convertMetaboAnalystLibraries.R
  - has the code that extracts the metabolite libraries
    into separate RDS files for hyper-db
> metaboliteMappingTable.R
  - contains a function, metaboliteMappingTable.R, that acquires the metabolite name mapping through the Xia Lab's Compound Map API. No longer used, since these queries take a long time, but left as a reference point in case we do want to work with the API another time.

# Data Directories

> qs_Files
  - Contains the qs files provided by MetaboAnalystR for Enrichment Analysis
> RDS_Files
  - Contains the RDS files made from extracting above qs files into a hypeR-friendly format. Also contains archive files of the sets based on compound name and by HMDB_ID, for troubleshooting regarding lack of overlap of our metabolites with these sets.

# How did these sets get made?

Within the qs files, there's a "reference" column that contains the pubmed link to the source paper within an html anchor tag.Unclear on if these sets were manually curated or done through mining.

