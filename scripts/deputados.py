from src.call_api import call_api
from src import etl


def load_deputados(data_list, conn):
    table_name = 'deputados'

    etl.load_table(data=data_list, table=table_name, conn=conn)




if __name__ == '__main__':
    api_name = 'deputados'
    arguments = {'ordem': 'ASC', 'ordenarPor': 'nome'}

    r = call_api(api_name, arguments)

    r_detalhes = call_api(api_name, arguments, id=204521)