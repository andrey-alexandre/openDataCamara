library(tidyverse)


call_api <- function(url){
  full_url <- glue::glue('https://dadosabertos.camara.leg.br/api/v2/', url)
  response <- httr::GET(full_url)
  
  query <- httr::content(response, as="text", encoding = 'utf-8')
  json <- jsonlite::fromJSON(query)
  data <- json$dados 
  
  return(data)
}


orgaos <- function(id, sigla, codTipoOrgao, dataInicio, dataFim, pagina=1, itens=200){
  if(!missing(id)){
    filter <- glue::glue('id={id}')
  }else if(!missing(sigla)){
    filter <- glue::glue('sigla={sigla}')
  }else if(!missing(codTipoOrgao)){
    filter <- glue::glue('codTipoOrgao={codTipoOrgao}')
  }
  
  if(!missing(dataInicio)) filter <- glue::glue('{filter}&dataInicio={dataInicio}')
  if(!missing(dataFim)) filter <- glue::glue('{filter}&dataFim={dataFim}')
  if(!missing(pagina)) filter <- glue::glue('{filter}&pagina={pagina}')
  if(!missing(itens)) filter <- glue::glue('{filter}&itens={itens}')

  if(is.object(filter)){url <- glue::glue('orgaos?{filter}')}else{url <- glue::glue('orgaos')}
  
  api_answer <- list()
  api_answer$dados <- call_api(url)
  attr(api_answer, 'class') <- 'orgaos'
  
  
  return(api_answer)
}


get_eventos.orgaos <- function(obj, id, dataInicio, dataFim, pagina=1, itens=200){
  if(!missing(obj)){
    id_filter <- obj$dados$id
  }else{
    id_filter <- id
  }
  
  filter <- glue::glue("pagina={pagina}&itens={itens}")
  if(!missing(dataInicio)) filter <- glue::glue('{filter}&dataInicio={dataInicio}')
  if(!missing(dataInicio)) filter <- glue::glue('{filter}&dataInicio={dataInicio}')
  
  eventos <- data.frame()
  for(iter_id in id_filter){
    url <- glue::glue('orgaos/{iter_id}/eventos?{filter}')
    
    api_answer <- call_api(url)
    api_answer['idOrgao'] = iter_id
    
    eventos <- dplyr::bind_rows(eventos, api_answer)
  }

  return(eventos)
}


get_membros <- function(obj, id, dataInicio, dataFim, pagina=1, itens=200){
  if(!missing(obj)){
    id_filter <- obj$dados$id
  }else{
    id_filter <- id
  }
  
  filter <- glue::glue("pagina={pagina}&itens={itens}")
  if(!missing(dataInicio)) filter <- glue::glue('{filter}&dataInicio={dataInicio}')
  if(!missing(dataInicio)) filter <- glue::glue('{filter}&dataInicio={dataInicio}')
  
  membros <- data.frame()
  for(iter_id in id_filter){
    url <- glue::glue('orgaos/{iter_id}/membros?{filter}')
    
    api_answer <- call_api(url)
    api_answer['idOrgao'] = iter_id
    
    membros <- dplyr::bind_rows(membros, api_answer)
  }
  
  return(membros)
}


get_votacoes.orgaos <- function(obj, id, idProposicao, dataInicio, dataFim, pagina=1, itens=200){
  if(!missing(obj)){
    id_filter <- obj$dados$id
  }else{
    id_filter <- id
  }
  
  filter <- glue::glue("pagina={pagina}&itens={itens}")
  if(!missing(idProposicao)) filter <- glue::glue('{filter}&idProposicao={idProposicao}')
  if(!missing(dataInicio)) filter <- glue::glue('{filter}&dataInicio={dataInicio}')
  if(!missing(dataFim)) filter <- glue::glue('{filter}&dataFim={dataFim}')
  
  votacoes <- data.frame()
  for(iter_id in id_filter){
    url <- glue::glue('orgaos/{iter_id}/votacoes?{filter}')
    
    api_answer <- call_api(url)
    api_answer['idOrgao'] = iter_id
    
    votacoes <- dplyr::bind_rows(votacoes, api_answer)
  }
  
  return(votacoes)
}
