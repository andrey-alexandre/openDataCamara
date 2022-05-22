library(tidyverse)


call_api <- function(url){
  full_url <- glue::glue('https://dadosabertos.camara.leg.br/api/v2/', url)
  response <- httr::GET(full_url)
  
  query <- httr::content(response, as="text", encoding = 'utf-8')
  json <- jsonlite::fromJSON(query)
  data <- json$dados 
  
  return(data)
}


eventos <- function(id, codTipoEvento, codSituacao, codTipoOrgao, idOrgao, dataInicio, dataFim, horaInicio, horaFim, pagina=1, itens=200){
  if(!missing(id)){
    filters <- glue::glue('id={id}')
  }else if(!missing(codTipoEvento)){
    filters <- glue::glue('codTipoEvento={codTipoEvento}')
  }else if(!missing(codSituacao)){
    filters <- glue::glue('codSituacao={codSituacao}')
  }
  if(!missing(codTipoOrgao)) filters <- glue::glue('{filters}&codTipoOrgao={codTipoOrgao}')
  if(!missing(idOrgao)) filters <- glue::glue('{filters}&idOrgao={idOrgao}')
  if(!missing(dataInicio)) filters <- glue::glue('{filters}&dataInicio={dataInicio}')
  if(!missing(dataFim)) filters <- glue::glue('{filters}&dataFim={dataFim}')
  if(!missing(horaInicio)) filters <- glue::glue('{filters}&horaInicio={horaInicio}')
  if(!missing(horaFim)) filters <- glue::glue('{filters}&horaFim={horaFim}')
  if(!missing(pagina)) filters <- glue::glue('{filters}&pagina={pagina}')
  if(!missing(itens)) filters <- glue::glue('{filters}&itens={itens}')
  
  if(is.object(filters)){url <- glue::glue('eventos?{filters}')}else{url <- glue::glue('eventos')}
  
  api_answer <- list()
  api_answer$dados <- call_api(url)
  attr(api_answer, 'class') <- 'eventos'
  
  
  return(api_answer)
}


get_deputados <- function(obj, id){
  if(!missing(obj)){
    id_filter <- obj$dados$id
  }else{
    id_filter <- id
  }

  deputados <- data.frame()
  for(iter_id in id_filter){
    url <- glue::glue('eventos/{iter_id}/deputados')
    
    api_answer <- call_api(url)
    api_answer['idEvento'] = iter_id
    
    deputados <- dplyr::bind_rows(deputados, api_answer)
  }

  return(deputados)
}


get_orgaos.eventos <- function(obj, id){
  if(!missing(obj)){
    id_filter <- obj$dados$id
  }else{
    id_filter <- id
  }
  
  orgaos <- data.frame()
  for(iter_id in id_filter){
    url <- glue::glue('eventos/{iter_id}/orgaos')
    
    api_answer <- call_api(url)
    api_answer['idEvento'] = iter_id
    
    orgaos <- dplyr::bind_rows(orgaos, api_answer)
  }
  
  return(orgaos)
}


get_pautas <- function(obj, id){
  if(!missing(obj)){
    id_filter <- obj$dados$id
  }else{
    id_filter <- id
  }
  
  pautas <- data.frame()
  for(iter_id in id_filter){
    url <- glue::glue('eventos/{iter_id}/pauta')
    
    api_answer <- call_api(url)
    api_answer['idEvento'] = iter_id
    
    pautas <- dplyr::bind_rows(pautas, api_answer)
  }
  
  return(pautas)
}


get_votacoes.eventos <- function(obj, id){
  if(!missing(obj)){
    id_filter <- obj$dados$id
  }else{
    id_filter <- id
  }
  
  votacoes <- data.frame()
  for(iter_id in id_filter){
    url <- glue::glue('eventos/{iter_id}/votacoes')
    
    api_answer <- call_api(url)
    api_answer['idEvento'] = iter_id
    
    votacoes <- dplyr::bind_rows(votacoes, api_answer)
  }
  
  return(votacoes)
}