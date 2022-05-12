library(tidyverse)


call_api <- function(url){
  full_url <- glue::glue('https://dadosabertos.camara.leg.br/api/v2/', url)
  response <- httr::GET(full_url)
  
  query <- httr::content(response, as="text", encoding = 'utf-8')
  json <- jsonlite::fromJSON(query)
  data <- json$dados 
  
  return(data)
}


deputados <- function(id, nome, idLegislatura, siglaUF, siglaPartido, siglaSexo, pagina=1, itens=200, dataInicio, dataFim){
  if(!missing(id)){
    filter <- glue::glue('id={id}')
  }else if(!missing(nome)){
    filter <- glue::glue('nome={nome}')
  }else if(!missing(idLegislatura)){
    filter <- glue::glue('idLegislatura={idLegislatura}')
  }
  if(!missing(siglaUF)) filter <- glue::glue('{filter}&siglaUF={siglaUF}')
  if(!missing(siglaPartido)) filter <- glue::glue('{filter}&siglaPartido={siglaPartido}')
  if(!missing(siglaSexo)) filter <- glue::glue('{filter}&siglaSexo={siglaSexo}')
  if(!missing(dataInicio)) filter <- glue::glue('{filter}&dataInicio={dataInicio}')
  if(!missing(dataFim)) filter <- glue::glue('{filter}&dataFim={dataFim}')
  
  url <- glue::glue('deputados?{filter}')
  api_answer <- call_api(url)
  attr(api_answer, 'class') <- 'deputados'
  
  # return(value)
  return(api_answer)
}

get_despesas.deputado <- function(obj, idLegislatura){
  url <- glue::glue('deputados/{obj$id}/despesas')
  value <- call_api(url)
  
}

felipeRigoni <- deputado('Felipe Rigoni')
print(felipeRigoni)



data <- call_api('votacoes?ordem=DESC&ordenarPor=dataHoraRegistro')
data %>% summarise(data_min = min(data), data_max = max(data))  
