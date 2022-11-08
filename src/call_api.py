import requests
import pandas as pd


def create_args(item):
    if isinstance(item[1], list):
        return f'{item[0]}=' + f'&{item[0]}='.join([str(v) for v in item[1]])
    else:
        return f'{item[0]}={item[1]}'


def call_api(api: str, args: dict, id:int=None):
    id_str = f'/{id}' if id is not None else ''
    args_str = '&'.join(list(map(create_args, arguments.items())))
    url = f'https://dadosabertos.camara.leg.br/api/v2/{api}{id_str}?{args_str}'
    response = requests.get(url)

    return pd.DataFrame(response.json()['dados'])


if __name__ == '__main__':
    api_name = 'deputados'
    arguments = {'ordem': 'ASC', 'ordenarPor': 'nome', 'idLegislatura': [55, 56]}

    r = call_api(api_name, arguments)
