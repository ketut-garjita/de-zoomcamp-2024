# Homework Solution
1. Pipeline Tree
2. Blocks Script
3. Execution
4. GCS Bucket Files
5. Answering
  

## 1. Pipeline Tree

![hw02-pipeline-tree](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/536f5c4e-a7aa-4176-8251-e8b1bc529695)

## 2. Blocks Script
  ### hw2-extract-taxi.py

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

  ### hw2_transform_taxi.py
  
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

  ### hw2_export_taxi_postgres.py
  
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

  ### hw2_query_taxi.py
  
  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/3594a846-8e66-4582-a0b6-eea148c9336c)

  ```
  -- Docs: https://docs.mage.ai/guides/sql-blocks
  select count(*) from mage.green_taxi;
  ```

  ### hw2_export_to_gcs_partition.py
  
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
  
  os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = "/home/src/<my key>.json"
  
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
  
  ## 3. Execution

  ### hw2-extract-taxi.py
  
  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/6d0a58ca-ede9-4b4b-9cdf-019a083e021c)

  ### hw2_transform_taxi.py

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/c52da6ed-e9ec-4f67-a7ef-8aa6d790f0f3)

  ### hw2_export_taxi_postgres.py

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/92ebc389-990c-4288-82f6-41a7db484f9a)

  ### hw2_query_taxi.py

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/bb61e606-ef7e-4ecd-819f-ca5cb1b9033b)

  ### hw2_export_to_gcs_partition.py

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/5292bbcb-a0b4-49ab-b040-1eea17488bc1)

  
  ## 4. GCS Bucket Files

  -
    ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/8b52fd31-502a-4f83-87aa-c826bbf89238)

  - green_taxi table partitions list
    
    ```
    garjita_ds@cloudshell:~ (dtc-de-course-2024-411803)$ gcloud storage ls  gs://de-zoomcamp-garjita-bucket/green_taxi 
    gs://de-zoomcamp-garjita-bucket/green_taxi/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2009-01-01/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-09-30/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-01/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-02/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-03/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-04/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-05/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-06/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-07/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-08/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-09/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-10/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-11/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-12/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-13/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-14/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-15/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-16/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-17/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-18/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-19/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-20/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-21/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-22/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-23/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-24/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-25/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-26/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-27/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-28/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-29/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-30/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-10-31/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-01/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-02/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-03/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-04/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-05/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-06/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-07/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-08/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-09/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-10/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-11/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-12/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-13/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-14/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-15/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-16/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-17/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-18/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-19/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-20/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-21/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-22/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-23/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-24/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-25/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-26/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-27/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-28/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-29/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-11-30/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-01/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-02/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-03/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-04/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-05/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-06/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-07/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-08/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-09/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-10/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-11/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-12/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-13/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-14/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-15/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-16/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-17/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-18/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-19/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-20/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-21/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-22/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-23/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-24/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-25/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-26/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-27/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-28/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-29/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-30/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2020-12-31/
    gs://de-zoomcamp-garjita-bucket/green_taxi/lpep_pickup_date=2021-01-01/
    ```
        
- Number of partitions folder

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/b9073ce1-d74c-4e81-8cf5-d31f3cc48091)


## 5. Answering

  Question 1. Data Loading
  
  Once the dataset is loaded, what's the shape of the data?
  
  **Answering 1 : 266,855 rows x 20 columns**
  
  Note: Available on execution result of hw2-extract-taxi.py block
  
  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/9b06e0d5-80c8-4cfd-80b2-50a5904a4b24)
  
  
  Question 2. Data Transformation
  
  Upon filtering the dataset where the passenger count is greater than 0 and the trip distance is greater than zero, how many rows are left?
  
  **Answering 2 : 139,370 rows**
  
  Note: Available on execution result of hw2_transform_taxi.py block
  
  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/f518facb-86e7-44b7-b7f9-402eec4a64eb)
  

  Question 3. Data Transformation
  
  Which of the following creates a new column lpep_pickup_date by converting lpep_pickup_datetime to a date?
  
  **Answering 3 : data['lpep_pickup_date'] = data['lpep_pickup_datetime'].dt.date**
  
  Note: Used on hw2_transform_taxi.py block
  
  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/73d13bed-9c03-4600-bf1b-66f16170d600)
  

  Question 4. Data Transformation
  
  What are the existing values of VendorID in the dataset?
  
  **Answering 4 : 1 or 2**
  
  Note:
  
  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/858cffe1-7514-47bf-91de-1f74fcbe9353)
  

  Question 5. Data Transformation
  
  How many columns need to be renamed to snake case?
  
  **Answering 5 : 2**
  
  Note: 
  
  1. lpep_pickup_datetime --> lpep_pickup_date

  2. VendorID --> vendor_id
        
    
  Question 6. Data Exporting
  
  Once exported, how many partitions (folders) are present in Google Cloud?
  
  **Answering 6 : 96**
  
  Note:  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/b9073ce1-d74c-4e81-8cf5-d31f3cc48091)
  

