
## Pipeline Tree


![hw02-pipeline-tree](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/536f5c4e-a7aa-4176-8251-e8b1bc529695)


## Blocks
- hw2-extract-taxi.py

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/bb56f5a3-b85d-441a-97d6-ce027ec0186c)

  ```
  import io
  import pandas as pd
  import requests
  
  if 'data_loader' not in globals():
      from mage_ai.data_preparation.decorators import data_loader
  if 'test' not in globals():
      from mage_ai.data_preparation.decorators import test
  
  
  @data_loader
  def load_data_from_api(*args, **kwargs):
      """
      Template for loading data from API
      """
      taxi_dtypes = {
          'VendorID': pd.Int64Dtype(),
          'pasangger_count': pd.Int64Dtype(),
          'trip_distance': float,
          'RateCodeID': pd.Int64Dtype(),
          'store_and_fwd+flag': str,
          'PULocationID': pd.Int64Dtype(),
          'DOLocationID': pd.Int64Dtype(),
          'payment_type': pd.Int64Dtype(),
          'fare_mount': float,
          'extra': float,
          'mta_tax': float,
          'tip_amount': float,
          'tolls_amount': float,
          'improvement_surcharge': float,
          'total_amount': float,
          'congestion_surcharge': float
      }
  
      parse_dates = ["lpep_pickup_datetime", "lpep_dropoff_datetime"]
  
      # Open the file for reading
      url_file = open('taxi_url.txt', 'r')
  
      # Get the first line of the file using the next() function
      first_line = next(url_file)
      
      # Read first line
      df = pd.read_csv(first_line, sep=',', compression='gzip', dtype=taxi_dtypes, parse_dates=parse_dates)
      # df = pd.read_csv(first_line, sep=',', compression='gzip', dtype=taxi_dtypes, parse_dates=True, keep_date_col=True)
  
      # Open file and put to link
      with open('taxi_url.txt', 'r') as text:
          links = text.read().splitlines()    
      
      # Read after first line
      for url in links[1:]:
          df1 = pd.read_csv(url, sep=',', compression='gzip', dtype=taxi_dtypes, parse_dates=parse_dates)
          # df1 = pd.read_csv(url, sep=',', compression='gzip', dtype=taxi_dtypes, parse_dates=True, keep_date_col=True)
          df = pd.concat([df, df1], sort=False)
  
      # Return output    
      return df
  ```

- hw2_transform_taxi.py
  
  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/f6673752-1e4f-4bb9-aa0f-ec189da7e310)
  
  ```
  if 'transformer' not in globals():
      from mage_ai.data_preparation.decorators import transformer
  if 'test' not in globals():
      from mage_ai.data_preparation.decorators import test
  
  
  @transformer
  def transform(data, *args, **kwargs):
      """ Using Numpy
      data = data[np.logical_not(data['passenger_count'].isin([0]))]
      df = data[np.logical_not(data['trip_distance'].isin([0]))]
      return df
      """
      # Replace NaN value into 0 (zero) in passenger_count & trip_distance columns 
      data['passenger_count'] = data['passenger_count'].fillna(0)
      data['trip_distance'] = data['trip_distance'].fillna(0)
  
      # Remove rows tha have 0 (zero) values
      data = data[data['passenger_count'] != 0]
      data = data[data['trip_distance'] != 0]
      
      # Create a new column lpep_pickup_date by converting lpep_pickup_datetime to a date
      from datetime import date
      data['lpep_pickup_date'] = data['lpep_pickup_datetime'].dt.date
      
      # Rename column VendorID to vendor_id
      data.columns = data.columns.str.replace("VendorID", "vendor_id")
  
      # Return output
      return data
  ```

- hw2_export_taxi_postgres.py
  
  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/bf0e24d3-1b82-48a4-a876-a6a02eac264b)

  ```
  from mage_ai.settings.repo import get_repo_path
  from mage_ai.io.config import ConfigFileLoader
  from mage_ai.io.postgres import Postgres
  from pandas import DataFrame
  from os import path
  
  if 'data_exporter' not in globals():
      from mage_ai.data_preparation.decorators import data_exporter
  
  
  @data_exporter
  def export_data_to_postgres(df: DataFrame, **kwargs) -> None:
      """
      Template for exporting data to a PostgreSQL database.
      Specify your configuration settings in 'io_config.yaml'.
  
      Docs: https://docs.mage.ai/design/data-loading#postgresql
      """
      # by default database_name = 'postgres' ==> io_config.yaml
      schema_name = 'mage'  # Specify the name of the schema to export data to
      table_name = 'green_taxi'  # Specify the name of the table to export data to
      config_path = path.join(get_repo_path(), 'io_config.yaml')
      config_profile = 'dev'
  
      with Postgres.with_config(ConfigFileLoader(config_path, config_profile)) as loader:
          loader.export(
              df,
              schema_name,
              table_name,
              index=False,  # Specifies whether to include index in exported table
              if_exists='replace',  # Specify resolution policy if table name already exists
          )
  ```

- hw2_query_taxi.py
  
  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/3594a846-8e66-4582-a0b6-eea148c9336c)

  ```
  -- Docs: https://docs.mage.ai/guides/sql-blocks
  select count(*) from mage.green_taxi;
  ```

- hw2_export_to_gcs_partition.py
  
  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/3d18b83f-f044-47fd-889f-450ed55b5f66)

  ```
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
  ```

