from src.call_api import call_api


def extract_deputados(args={'ordem': 'ASC', 'ordenarPor': 'nome'}, id: int=None):
    response = call_api('deputados', args)

if __name__ == '__main__':
    api_name = 'deputados'
    arguments = {'ordem': 'ASC', 'ordenarPor': 'nome'}

    r = call_api(api_name, arguments)