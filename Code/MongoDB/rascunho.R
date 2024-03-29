library(mongolite)
connection_string <- 'mongodb://andrey:1234@localhost/politics'

legislaturas_collection <- mongo(collection="legislaturas", db="politics", url=connection_string)
legislaturas_collection$insert(legislaturas()$dados)

deputados_collection <- mongo(collection="deputados", db="politics", url=connection_string)

for(idLegislatura_iter in 1:56){
  deputado_list <- deputados(idLegislatura = idLegislatura_iter)
  if(!is_empty(deputado_list$dados)){
    deputados_collection$insert(deputado_list$dados)  
  }else{
    print(glue::glue("Na {idLegislatura_iter}ª legislatura não há dados a partir da API"))
  }
}



despesas_collection <- mongo(collection="despesas", db="politics", url=connection_string)

for(ano_iter in 2000:2022){
  for(mes_iter in 1:12){
    despesas_data <- get_despesas(id = deputados_collection$distinct('id'), ano = ano_iter, mes = mes_iter)
    if(!is_empty(despesas_data)){
      despesas_collection$insert(despesas_data)  
    }else{
      print(glue::glue("No {mes_iter}º mês do ano {ano_iter} não há dados provenientes da API"))
    }
  }
}


deputados_por_legislatura <- deputados_collection$aggregate('
[
  {
  "$match" : {"id":92346}
  },
  {
  "$lookup" : {
     "from": "legislaturas",
     "localField": "idLegislatura",
     "foreignField": "id",
     "as": "legislaturaInfo"
    }
  },
  {
  "$project": {
    "id": "$id",
    "dataInicio": "$legislaturaInfo.dataInicio",
    "dataFim": "$legislaturaInfo.dataFim"
    }
  }
]')


deputados_por_legislatura  %>% 
  mutate_if(is.list, . %>% as.character %>% as.Date) %>% 
  group_by(id) %>% 
  summarise(dataInicio = lubridate::year(min(dataInicio)), dataFim = lubridate::year(max(dataFim)))
  
