from src.call_api import Politics
from src import etl

import requests
import pandas as pd

class deputados:
    def __init__(self):
        self.api = 'deputados'

    def start
def load_deputados(args):
    api = 'deputados'
    deputados = Politics(api)

    deputados.run(args)
    return deputados.data

    # etl.load_table(data=data_list, table=api, conn=conn)


if __name__ == '__main__':
    api_name = 'deputados'
    arguments = {'ordem': 'ASC', 'ordenarPor': 'nome', 'idLegislatura': [50, 51, 52, 53, 54, 55, 56]}

    r = load_deputados(args=arguments)

    r_detalhes = call_api(api_name, arguments, id=204521)
