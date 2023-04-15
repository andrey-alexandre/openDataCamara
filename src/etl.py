from call_api import Politics
import sqlite3
import pandas as pd


def extract_deputados(id_legislatura):
    id_legislatura = range(1, 56) if id_legislatura is None else id_legislatura

    r = Politics('deputados')
    [r.run({'id_legislatura': i, 'itens': 300}) for i in id_legislatura]
    r.data.to_csv('data/historicoDeputados.csv', index=False, decimal=',', sep=';')
    return r.data


def load_deputados(data: pd.DataFrame, conn: sqlite3.Connection):
    data.to_sql('teste', con=conn, if_exists='append')

    print('Tabela carregada')


def run_deputados(conn, id_legislatura=None):
    data_deputados = extract_deputados(id_legislatura)
    load_deputados(data_deputados, conn)
