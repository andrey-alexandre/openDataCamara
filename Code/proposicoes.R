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
    filter <- glue::glue('id={id}')
  }else if(!missing(siglaTipo)){
    filter <- glue::glue('siglaTipo={siglaTipo}')
  }else if(!missing(numero)){
    filter <- glue::glue('numero={numero}')
  }
  if(!missing(ano)) filter <- glue::glue('{filter}&ano={ano}')
  if(!missing(idDeputadoAutor)) filter <- glue::glue('{filter}&idDeputadoAutor={idDeputadoAutor}')
  if(!missing(autor)) filter <- glue::glue('{filter}&autor={autor}')
  if(!missing(siglaPartidoAutor)) filter <- glue::glue('{filter}&siglaPartidoAutor={siglaPartidoAutor}')
  if(!missing(idPartidoAutor)) filter <- glue::glue('{filter}&idPartidoAutor={idPartidoAutor}')
  if(!missing(siglaUfAutor)) filter <- glue::glue('{filter}&siglaUfAutor={siglaUfAutor}')
  if(!missing(keywords)) filter <- glue::glue('{filter}&keywords={keywords}')
  if(!missing(tramitacaoSenado)) filter <- glue::glue('{filter}&tramitacaoSenado={tramitacaoSenado}')
  if(!missing(dataInicio)) filter <- glue::glue('{filter}&dataInicio={dataInicio}')
  if(!missing(dataFim)) filter <- glue::glue('{filter}&dataFim={dataFim}')
  if(!missing(dataApresentacaoInicio)) filter <- glue::glue('{filter}&dataApresentacaoInicio={dataApresentacaoInicio}')
  if(!missing(dataApresentacaoFim)) filter <- glue::glue('{filter}&dataApresentacaoFim={dataApresentacaoFim}')
  
  if(is.object(filter)){url <- glue::glue('proposicoes?{filter}')}else{url <- glue::glue('proposicoes')}
  
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