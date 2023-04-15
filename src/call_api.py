import requests
import pandas as pd
import time
import sqlite3


def create_args(item):
    if isinstance(item[1], list):
        return f'{item[0]}=' + f'&{item[0]}='.join([str(v) for v in item[1]])
    else:
        return f'{item[0]}={item[1]}'


class Politics:
    def __init__(self, endpoint: str, api_id: int = None):
        self.data = pd.DataFrame()
        self.url = None
        self.endpoint = endpoint
        self.api_id = api_id

    def create_url(self, args: dict):
        id_str = f'/{self.api_id}' if self.api_id is not None else ''
        args_str = '&'.join(list(map(create_args, args.items())))
        args_str = '?' + args_str if args_str else ''
        self.url = f'https://dadosabertos.camara.leg.br/api/v2/{self.endpoint}{id_str}{args_str}'

        return None

    def extract(self):
        page = data_json = 1
        while data_json:
            print(f'Iniciando página {page}')
            url_aux = self.url + f'&pagina={page}'
            response = requests.get(url_aux)

            while response.status_code == 429:
                print('\t\tDeu ruim, tentando novamente!')
                time.sleep(5)
                response = requests.get(url_aux)

            data_json = response.json()['dados']

            self.data = pd.concat([self.data, pd.DataFrame(data_json)])
            page += 1

        return None

    def run(self, args: dict):
        self.create_url(args)
        self.extract()


if __name__ == '__main__':
    con = sqlite3.connect("volume_data/Politics.db")

    r = Politics('deputados')
    [r.run({'idLegislatura': i, 'itens': 300}) for i in [57]]
    r.data.to_sql('historico_deputado', con=con, if_exists='append', index=False)
    r.data.shape

    for idDeputado in r.data.id.unique().tolist():
        print(f'Início da extração do deputado {idDeputado}!\n')

        r2 = Politics(f'deputados/{idDeputado}/despesas')
        r2.run({'ano': [i for i in range(2017, 2024)], 'mes': [i for i in range(1, 13)], 'ordenarPor': 'ano',
                'itens': 300})

        r3 = Politics('proposicoes')
        arguments = {'ano': [i for i in range(2017, 2024)], 'idDeputadoAutor': idDeputado, 'dataInicio': '2017-01-01',
                     'dataApresentacaoInicio': '2017-01-01', 'ordenarPor': 'ano', 'itens': 300}
        r3.run(arguments)

        print(f'\n Despesas do deputado de id {idDeputado}:\n', r2.data.shape)
        if r2.data.shape[0] > 0:
            r2.data['id_deputado'] = idDeputado
            r2.data.to_sql('despesa_deputado', con=con, if_exists='append', index=False)
        print(f'\n Proposições do deputado de id {idDeputado}:\n', r3.data.shape)
        if r3.data.shape[0] > 0:
            r3.data['id_deputado'] = idDeputado
            r3.data.to_sql('proposicoes_deputado', con=con, if_exists='append', index=False)
