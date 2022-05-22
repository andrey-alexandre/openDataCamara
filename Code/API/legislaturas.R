library(tidyverse)


call_api <- function(url){
  full_url <- glue::glue('https://dadosabertos.camara.leg.br/api/v2/', url)
  response <- httr::GET(full_url)
  
  query <- httr::content(response, as="text", encoding = 'utf-8')
  json <- jsonlite::fromJSON(query)
  data <- json$dados 
  
  return(data)
}


legislaturas <- function(id, data, pagina=1, itens=200){
  filters <- glue::glue("pagina={pagina}&itens={itens}")
  
  if(!missing(id)) filters <- glue::glue('id={id}')
  if(!missing(data)) filters <- glue::glue('{filters}&data={data}')
  
  url <- glue::glue('legislaturas?{filters}')
  
  api_answer <- list()
  api_answer$dados <- call_api(url)
  attr(api_answer, 'class') <- 'legislaturas'
  
  return(api_answer)
}


get_mesas.legislaturas <- function(obj, id, dataInicio, dataFim, pagina=1, itens=200){
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
    url <- glue::glue('legislaturas/{iter_id}/mesa?{filters}')
    
    api_answer <- call_api(url)
    api_answer['legislaturas'] = iter_id
    
    mesas <- dplyr::bind_rows(mesas, api_answer)
  }
  
  return(mesas)
}
