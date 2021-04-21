# About the scripts directory

> installMetaboAnalyst.R
  - code to install required dependencies and MetaboAnalystR itself.
> convertMetaboAnalystLibraries.R
  - has the code that extracts the metabolite libraries
    into separate RDS files for hyper-db
> metaboliteMappingTable.R
  - contains a function, metaboliteMappingTable.R, that acquires the metabolite name mapping through the Xia Lab's Compound Map API. No longer used, since these queries take a long time, but left as a reference point in case we do want to work with the API another time.
