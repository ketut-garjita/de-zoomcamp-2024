from mage_ai.settings.repo import get_repo_path
from mage_ai.io.config import ConfigFileLoader
from mage_ai.io.google_cloud_storage import GoogleCloudStorage
import os
import pandas as pd
from pandas import DataFrame
from os import path
import pyarrow as pa
import pyarrow.parquet as pq 
import datetime as dt
from datetime import date


if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter

os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = "/home/src/dtc-de-course-2024-411803-122da5536446.json"

project_id = 'dtc-de-course-2024-411803'
bucket_name = 'de-zoomcamp-garjita-bucket'
table_name = "green_taxi"
root_path = f'{bucket_name}/{table_name}'

config_path = path.join(get_repo_path(), 'io_config.yaml')
config_profile = 'default'

@data_exporter
def export_data(data, *args, **kwargs):
    data['lpep_pickup_date'] = data['lpep_pickup_datetime'].dt.date 
   
    table = pa.Table.from_pandas(data)
    gcs = pa.fs.GcsFileSystem()
    pq.write_to_dataset(
        table,
        root_path=root_path,
        partition_cols=['lpep_pickup_date'],
        filesystem=gcs
    )