from datetime import datetime

from airflow import DAG
from airflow.operators.python import PythonOperator


def tarefa_teste():
    print("DAG de teste executada com sucesso!")


with DAG(
    dag_id="start_dag",
    start_date=datetime(2026, 1, 1),
    schedule_interval=None,
    catchup=False,
    tags=["teste"],
) as dag:

    task_hello = PythonOperator(
        task_id="tarefa_hello",
        python_callable=tarefa_teste,
    )

    task_hello
