library(tidyverse)


call_api <- function(url){
  full_url <- glue::glue('https://dadosabertos.camara.leg.br/api/v2/', url)
  response <- httr::GET(full_url)
  
  query <- httr::content(response, as="text", encoding = 'utf-8')
  json <- jsonlite::fromJSON(query)
  data <- json$dados 
  
  return(data)
}


proposicoes <- function(id, siglaTipo, numero, ano, idDeputadoAutor, autor, siglaPartidoAutor, idPartidoAutor, 
                        siglaUfAutor, keywords, tramitacaoSenado, dataInicio, dataFim, dataApresentacaoInicio,
                        dataApresentacaoFim, pagina=1, itens=200){
  if(!missing(id)){
    filter_ <- glue::glue('id={id}')
  }else if(!missing(siglaTipo)){
    filters <- glue::glue('siglaTipo={siglaTipo}')
  }else if(!missing(numero)){
    filters <- glue::glue('numero={numero}')
  }
  if(!missing(ano)) filters <- glue::glue('{filters}&ano={ano}')
  if(!missing(idDeputadoAutor)) filters <- glue::glue('{filters}&idDeputadoAutor={idDeputadoAutor}')
  if(!missing(autor)) filters <- glue::glue('{filters}&autor={autor}')
  if(!missing(siglaPartidoAutor)) filters <- glue::glue('{filters}&siglaPartidoAutor={siglaPartidoAutor}')
  if(!missing(idPartidoAutor)) filters <- glue::glue('{filters}&idPartidoAutor={idPartidoAutor}')
  if(!missing(siglaUfAutor)) filters <- glue::glue('{filters}&siglaUfAutor={siglaUfAutor}')
  if(!missing(keywords)) filters <- glue::glue('{filters}&keywords={keywords}')
  if(!missing(tramitacaoSenado)) filters <- glue::glue('{filters}&tramitacaoSenado={tramitacaoSenado}')
  if(!missing(dataInicio)) filters <- glue::glue('{filters}&dataInicio={dataInicio}')
  if(!missing(dataFim)) filters <- glue::glue('{filters}&dataFim={dataFim}')
  if(!missing(dataApresentacaoInicio)) filters <- glue::glue('{filters}&dataApresentacaoInicio={dataApresentacaoInicio}')
  if(!missing(dataApresentacaoFim)) filters <- glue::glue('{filters}&dataApresentacaoFim={dataApresentacaoFim}')
  if(!missing(pagina)) filters <- glue::glue('{filters}&pagina={pagina}')
  if(!missing(itens)) filters <- glue::glue('{filters}&itens={itens}')
  
  if(is.object(filters)){url <- glue::glue('proposicoes?{filters}')}else{url <- glue::glue('proposicoes')}
  
  api_answer <- list()
  api_answer$dados <- call_api(url)
  attr(api_answer, 'class') <- 'proposicoes'
  
  
  return(api_answer)
}


get_autores <- function(obj, id){
  if(!missing(obj)){
    id_filter <- obj$dados$id
  }else{
    id_filter <- id
  }

  autores <- data.frame()
  for(iter_id in id_filter){
    url <- glue::glue('proposicoes/{iter_id}/autores')
    
    api_answer <- call_api(url)
    api_answer['idProposicao'] = iter_id
    
    autores <- dplyr::bind_rows(autores, api_answer)
  }

  return(autores)
}


get_relacionadas <- function(obj, id){
  if(!missing(obj)){
    id_filter <- obj$dados$id
  }else{
    id_filter <- id
  }
  
  relacionadas <- data.frame()
  for(iter_id in id_filter){
    url <- glue::glue('proposicoes/{iter_id}/relacionadas')
    
    api_answer <- call_api(url)
    api_answer['idProposicao'] = iter_id
    
    relacionadas <- dplyr::bind_rows(relacionadas, api_answer)
  }
  
  return(relacionadas)
}


get_temas <- function(obj, id){
  if(!missing(obj)){
    id_filter <- obj$dados$id
  }else{
    id_filter <- id
  }
  
  temas <- data.frame()
  for(iter_id in id_filter){
    url <- glue::glue('proposicoes/{iter_id}/temas')
    
    api_answer <- call_api(url)
    api_answer['idProposicao'] = iter_id
    
    temas <- dplyr::bind_rows(temas, api_answer)
  }
  
  return(temas)
}


get_tramitacoes <- function(obj, id){
  if(!missing(obj)){
    id_filter <- obj$dados$id
  }else{
    id_filter <- id
  }
  
  tramitacoes <- data.frame()
  for(iter_id in id_filter){
    url <- glue::glue('proposicoes/{iter_id}/tramitacoes')
    
    api_answer <- call_api(url)
    api_answer['idProposicao'] = iter_id
    
    tramitacoes <- dplyr::bind_rows(tramitacoes, api_answer)
  }
  
  return(tramitacoes)
}


get_votacoes.proposicoes <- function(obj, id){
  if(!missing(obj)){
    id_filter <- obj$dados$id
  }else{
    id_filter <- id
  }
  
  votacoes <- data.frame()
  for(iter_id in id_filter){
    url <- glue::glue('proposicoes/{iter_id}/votacoes')
    
    api_answer <- call_api(url)
    api_answer['idProposicao'] = iter_id
    
    votacoes <- dplyr::bind_rows(votacoes, api_answer)
  }
  
  return(votacoes)
}