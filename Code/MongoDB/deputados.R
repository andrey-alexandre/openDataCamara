library(tidyverse)
source('Code/MongoDB/config.R')

deputados_collection <- mongo(collection="deputados", db="politics", url=connection_string)

for(idLegislatura_iter in 1:56){
  deputado_list <- deputados(idLegislatura = idLegislatura_iter)
  if(!is_empty(deputado_list$dados)){
    deputados_collection$insert(deputado_list$dados)  
  }else{
    print(glue::glue("Na {idLegislatura_iter}ª legislatura não há dados a partir da API"))
  }
}



library(tidyverse)
source('Code/MongoDB/config.R')
source('Code/deputados.R')

#' Insert new deputies into the "Deputados" collection
#' 
#' @param deputados_conn A Mongo connection to "deputados" collection
#' @param legislaturas_conn A Mongo connection to "legislaturas" collection
#' @param idLegislatura A integer object indicating which legislatures should be requested. 
#' If 0 all legislatures will be requested and if -1, only the current will be requested
#'
#' @return A string with the number of inserted rows
load_deputados <- function(deputados_conn, legislaturas_conn, idLegislatura=0){
  if(length(idLegislatura)>1 | !(idLegislatura %in% c(0, -1)) ){
    idLegislatura_registered <- idLegislatura
  }else if(idLegislatura == 0){
    idLegislatura_registered <- 
      legislaturas_conn$aggregate('[{"$project": {"_id":0, "id": "$id"}}]') %>% unlist()
  }else if(idLegislatura == -1){
    idLegislatura_registered <- 
      legislaturas_conn$aggregate('[{"$project": {"_id":0, "id": "$id"}}]') %>% unlist() %>% max()
  }
  
  deputados_iter <- data.frame()
  deputados_list <- data.frame()
  for(idLegislatura_iter in idLegislatura_registered){
    deputados_iter <- deputados(idLegislatura = idLegislatura_iter)$dados
    
    if(!is_empty(deputados_iter)){
      deputados_list <- bind_rows(deputados_list, deputados_iter)  
    }else{
      print(glue::glue("Na {idLegislatura_iter}ª legislatura não há dados a partir da API"))
    }
  }
  
  idLegislatura_registered <- paste(idLegislatura_registered, collapse=",")
  existing_deputies <- deputados_conn$find(
    query = glue::glue('{"idLegislatura": { "$in" : [<<idLegislatura_registered>>] }}', .open="<<", .close=">>"),
    fields = '{"id" : true, "idLegislatura" : true, "_id": false}'
  )
  
  if(!is_empty(existing_deputies)){
    new_data <- anti_join(deputados_list, existing_deputies, by=c("id", "idLegislatura"))  
  }else{
    deputados_conn$insert(deputados_list)
    
    return(glue::glue('Inserção de {nrow(deputados_list)} registros na coleção "Deputados"'))
  }
  
  if(nrow(new_data) > 0){
    deputados_conn$insert(new_data)
    
    return(glue::glue('Inserção de {nrow(new_data)} registros na coleção "Deputados"'))
  }else{
    return(glue::glue('Não há deputados novos a serem inseridos'))
  }
}


if(!interactive()){
  legislaturas_collection <- mongo(collection="legislaturas", db="politics", url=connection_string)
  deputados_collection <- mongo(collection="deputados", db="politics", url=connection_string)
  load_deputados(deputados_collection, legislaturas_collection, idLegislatura = 0)
}
