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


legislaturas_collection$aggregate('
[
  {
  "$project": {
    "Acc_id": 1, 
    "dataInicio": "$dataInicio", 
    "dataFim": "$dataFim",
    "idLegislatura": "$id"
    }
  },
  {
  "$merge" : {
    "into": { "db": "deputados", "coll": "politics" }, "on": "idLegislatura",  "whenMatched": "replace", "whenNotMatched": "insert"
    } 
  }
]')

fb_locs = deputados_collection$aggregate('[]')
fb_locs %>% 
  inner_join(b$dados %>% select(id, dataInicio), by=c("entrada" = "id")) %>% 
  inner_join(b$dados %>% select(id, dataFim), by=c("saida" = "id"))

