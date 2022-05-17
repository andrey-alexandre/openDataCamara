library(tidyverse)


call_api <- function(url){
  full_url <- glue::glue('https://dadosabertos.camara.leg.br/api/v2/', url)
  response <- httr::GET(full_url)
  
  query <- httr::content(response, as="text", encoding = 'utf-8')
  json <- jsonlite::fromJSON(query)
  data <- json$dados 
  
  return(data)
}


deputados <- function(id, nome, idLegislatura, siglaUF, siglaPartido, siglaSexo, dataInicio, dataFim, pagina=1, itens=200){
  if(!missing(id)){
    filters <- glue::glue('id={id}')
  }else if(!missing(nome)){
    filters <- glue::glue('nome={nome}')
  }else if(!missing(idLegislatura)){
    filters <- glue::glue('idLegislatura={idLegislatura}')
  }
  if(!missing(siglaUF)) filters <- glue::glue('{filters}&siglaUF={siglaUF}')
  if(!missing(siglaPartido)) filters <- glue::glue('{filters}&siglaPartido={siglaPartido}')
  if(!missing(siglaSexo)) filters <- glue::glue('{filters}&siglaSexo={siglaSexo}')
  if(!missing(dataInicio)) filters <- glue::glue('{filters}&dataInicio={dataInicio}')
  if(!missing(dataFim)) filters <- glue::glue('{filters}&dataFim={dataFim}')
  if(!missing(pagina)) filters <- glue::glue('{filters}&pagina={pagina}')
  if(!missing(itens)) filters <- glue::glue('{filters}&itens={itens}')
  
  url <- glue::glue('deputados?{filters}')
  
  api_answer <- list()
  api_answer$dados <- call_api(url)
  attr(api_answer, 'class') <- 'deputados'
  
  return(api_answer)
}


get_despesas <- function(obj, id, idLegislatura, ano, mes, cnpjCpfFornecedor, pagina=1, itens=200){
  if(!missing(obj)){
    id_filter <- obj$dados$id
  }else{
    id_filter <- id
  }
  
  filters <- glue::glue("pagina={pagina}&itens={itens}")
  if(!missing(idLegislatura)) filters <- glue::glue('{filters}&idLegislatura={idLegislatura}')
  if(!missing(ano)) filters <- glue::glue('{filters}&ano={ano}')
  if(!missing(mes)) filters <- glue::glue('{filters}&mes={mes}')
  if(!missing(cnpjCpfFornecedor)) filters <- glue::glue('{filters}&cnpjCpfFornecedor={cnpjCpfFornecedor}')

  despesas <- data.frame()
  for(iter_id in id_filter){
    url <- glue::glue('deputados/{iter_id}/despesas?{filters}')
    
    api_answer <- call_api(url)
    api_answer['idDeputado'] = iter_id
    
    despesas <- dplyr::bind_rows(despesas, api_answer)
  }

  return(despesas)
}


get_discursos <- function(obj, id, idLegislatura, dataInicio, dataFim, pagina=1, itens=200){
  if(!missing(obj)){
    id_filter <- obj$dados$id
  }else{
    id_filter <- id
  }
  
  filters <- glue::glue("pagina={pagina}&itens={itens}")
  if(!missing(idLegislatura)) filters <- glue::glue('{filters}&idLegislatura={idLegislatura}')
  if(!missing(dataInicio)) filters <- glue::glue('{filters}&dataInicio={dataInicio}')
  if(!missing(dataFim)) filters <- glue::glue('{filters}&dataFim={dataFim}')
  
  discursos <- data.frame()
  for(iter_id in id_filter){
    url <- glue::glue('deputados/{iter_id}/discursos?{filters}')
    
    api_answer <- call_api(url)
    api_answer['idDeputado'] = iter_id
    
    discursos <- dplyr::bind_rows(discursos, api_answer)
  }
  
  return(discursos)
}


get_eventos.deputados <- function(obj, id, dataInicio, dataFim, pagina=1, itens=200){
  if(!missing(obj)){
    id_filter <- obj$dados$id
  }else{
    id_filter <- id
  }
  
  filters <- glue::glue("pagina={pagina}&itens={itens}")
  if(!missing(dataInicio)) filters <- glue::glue('{filters}&dataInicio={dataInicio}')
  if(!missing(dataFim)) filters <- glue::glue('{filters}&dataFim={dataFim}')
  
  eventos <- data.frame()
  for(iter_id in id_filter){
    url <- glue::glue('deputados/{iter_id}/eventos?{filters}')
    
    api_answer <- call_api(url)
    api_answer['idDeputado'] = iter_id
    
    eventos <- dplyr::bind_rows(eventos, api_answer)
  }
  
  return(eventos)
}


get_frentes <- function(obj, id){
  if(!missing(obj)){
    id_filter <- obj$dados$id
  }else{
    id_filter <- id
  }
  
  frentes <- data.frame()
  for(iter_id in id_filter){
    url <- glue::glue('deputados/{iter_id}/eventos')
    
    api_answer <- call_api(url)
    api_answer['idDeputado'] = iter_id
    
    frentes <- dplyr::bind_rows(frentes, api_answer)
  }
  
  return(frentes)
}


get_ocupacoes <- function(obj, id){
  if(!missing(obj)){
    id_filter <- obj$dados$id
  }else{
    id_filter <- id
  }
  
  ocupacoes <- data.frame()
  for(iter_id in id_filter){
    url <- glue::glue('deputados/{iter_id}/ocupacoes')
    
    api_answer <- call_api(url)
    api_answer['idDeputado'] = iter_id
    
    ocupacoes <- dplyr::bind_rows(ocupacoes, api_answer)
  }
  
  return(ocupacoes)
}


get_orgaos.deputados <- function(obj, id, dataInicio, dataFim, pagina=1, itens=200){
  if(!missing(obj)){
    id_filter <- obj$dados$id
  }else{
    id_filter <- id
  }
  
  filters <- glue::glue("pagina={pagina}&itens={itens}")
  if(!missing(dataInicio)) filters <- glue::glue('{filters}&dataInicio={dataInicio}')
  if(!missing(dataFim)) filters <- glue::glue('{filters}&dataFim={dataFim}')
  
  orgaos <- data.frame()
  for(iter_id in id_filter){
    url <- glue::glue('deputados/{iter_id}/orgaos?{filters}')
    
    api_answer <- call_api(url)
    api_answer['idDeputado'] = iter_id
    
    orgaos <- dplyr::bind_rows(orgaos, api_answer)
  }
  
  return(orgaos)
}


get_profissoes <- function(obj, id){
  if(!missing(obj)){
    id_filter <- obj$dados$id
  }else{
    id_filter <- id
  }
  
  profissoes <- data.frame()
  for(iter_id in id_filter){
    url <- glue::glue('deputados/{iter_id}/profissoes')
    
    api_answer <- call_api(url)
    api_answer['idDeputado'] = iter_id
    
    profissoes <- dplyr::bind_rows(profissoes, api_answer)
  }
  
  return(profissoes)
}


get_mesas <- function(obj, id, dataInicio, dataFim, pagina=1, itens=200){
  if(!missing(obj)){
    id_filter <- obj$dados$id
  }else{
    id_filter <- id
  }
  
  filters <- glue::glue("pagina={pagina}&itens={itens}")
  if(!missing(dataInicio)) filters <- glue::glue('{filters}&dataInicio={dataInicio}')
  if(!missing(dataFim)) filters <- glue::glue('{filters}&dataFim={dataFim}')
  
  mesas <- data.frame()
  for(iter_id in id_filter){
    url <- glue::glue('deputados/{iter_id}/mesas?{filters}')
    
    api_answer <- call_api(url)
    api_answer['idDeputado'] = iter_id
    
    mesas <- dplyr::bind_rows(mesas, api_answer)
  }
  
  return(mesas)
}
