library(tidyverse)


call_api <- function(url){
  full_url <- glue::glue('https://dadosabertos.camara.leg.br/api/v2/', url)
  response <- httr::GET(full_url)
  
  query <- httr::content(response, as="text", encoding = 'utf-8')
  json <- jsonlite::fromJSON(query)
  data <- json$dados 
  
  return(data)
}


votacoes <- function(id, idVotacao, idEvento, idOrgao, dataInicio, dataFim, pagina=1, itens=200){
  if(!missing(id)){
    filters <- glue::glue('id={id}')
  }else if(!missing(idVotacao)){
    filters <- glue::glue('idVotacao={idVotacao}')
  }else if(!missing(idEvento)){
    filters <- glue::glue('idEvento={idEvento}')
  }
  if(!missing(idOrgao)) filters <- glue::glue('{filters}&idOrgao={idOrgao}')
  if(!missing(dataInicio)) filters <- glue::glue('{filters}&dataInicio={dataInicio}')
  if(!missing(dataFim)) filters <- glue::glue('{filters}&dataFim={dataFim}')
  if(!missing(pagina)) filters <- glue::glue('{filters}&pagina={pagina}')
  if(!missing(itens)) filters <- glue::glue('{filters}&itens={itens}')

  if(is.object(filters)){url <- glue::glue('votacoes?{filters}')}else{url <- glue::glue('votacoes')}
  
  api_answer <- list()
  api_answer$dados <- call_api(url)
  attr(api_answer, 'class') <- 'votacoes'
  
  
  return(api_answer)
}


get_orientacoes <- function(obj, id){
  if(!missing(obj)){
    id_filter <- obj$dados$id
  }else{
    id_filter <- id
  }

  orientacoes <- data.frame()
  for(iter_id in id_filter){
    url <- glue::glue('votacoes/{iter_id}/orientacoes')
    
    api_answer <- call_api(url)
    api_answer['idVotacao'] = iter_id
    
    orientacoes <- dplyr::bind_rows(orientacoes, api_answer)
  }

  return(orientacoes)
}


get_votos <- function(obj, id){
  if(!missing(obj)){
    id_filter <- obj$dados$id
  }else{
    id_filter <- id
  }
  
  votos <- data.frame()
  for(iter_id in id_filter){
    url <- glue::glue('votacoes/{iter_id}/votos')
    
    api_answer <- call_api(url)
    api_answer['idVotacao'] = iter_id
    
    votos <- dplyr::bind_rows(votos, api_answer)
  }
  
  return(votos)
}
