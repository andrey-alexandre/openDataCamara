library(tidyverse)
source('Code/MongoDB/config.R')
source('Code/legislaturas.R')

#' Insert new legislatures into the "Legislaturas" collection
#' 
#' @param conn A Mongo Connection object
#' @param date A date to search for the legislature in force at the time. If empty, returns all legislatures.
#' @return A string with the number of inserted rows
load_legislaturas <- function(conn, date){
  if(!missing(date)){
    extract_data <- legislaturas(data = date)$dados
  }else{
    extract_data <- legislaturas()$dados
  }
  
  existing_ids <- conn$aggregate('[{"$project": {"_id":0, "id": "$id"}}]') %>% unlist()
  
  new_data <- filter( extract_data, !( id %in% existing_ids ) )
  
  if(nrow(new_data) > 0){
    conn$insert(new_data)
    
    return(glue::glue('Inserção de {nrow(new_data)} registros na coleção "Legislaturas"'))
  }else{
    return(glue::glue('Não há legislaturas novas'))
  }
}


if(!interactive()){
  legislaturas_collection <- mongo(collection="legislaturas", db="politics", url=connection_string)
  load_legislaturas(legislaturas_collection, date=Sys.Date())
}