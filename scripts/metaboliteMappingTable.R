library(httr)
#' API way to get compound mapping
metaboliteMappingTable <-
  function(nameVec,
           outputColumns = c(
             "Query", "Match", "HMDB", 
             "KEGG", "PubChem", "ChEBI", "SMILES"
             )
  ) {
  # First create a list containing a vector of the compounds to be queried (separated by a semi-colon)  
  # and another character vector containing the compound id type.
  # The items in the list MUST be queryList and inputType
  # Valid input types are: "name", "hmdb", "kegg", "pubchem", "chebi", "metlin"
  toSend = list(queryList = nameVec, inputType = "name")
  
  # The MetaboAnalyst API url
  call <- "http://api.xialab.ca/mapcompounds"
  
  # Use httr::POST to send the request to the MetaboAnalyst API
  # The response will be saved in query_results
  query_results <- httr::POST(call, body = toSend, encode = "json")
  
  # Check if response is ok (TRUE)
  # 200 is ok! 401 means an error has occured on the user's end.
  query_results$status_code==200
  
  # Parse the response into a table
  # Will show mapping to "hmdb_id", "kegg_id", "pubchem_id", "chebi_id", "metlin_id", "smiles" 
  query_results_text <- content(query_results, "text", encoding = "UTF-8")
  query_results_json <- jsonlite::fromJSON(query_results_text, simplifyVector=T, simplifyDataFrame=T, flatten = T)
  successfulMaps=(query_results_json$Query==query_results_json$Match)
  # since we're working with queries of common names
  # which may not always work, only keep those with
  # successful hits
  query_results_table <- as.data.frame(query_results_json)#(cbind.data.frame(query_results_json[outputColumns]))
  rownames(query_results_table) <- query_results_table$Query
  return(query_results_table)
  }
