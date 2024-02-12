## Week 3 - Module 3 : Data Warehouse

## Data Warehouse

### What is a Data Warehouse?

A Data Warehouse (DW) is an OLAP solution meant for reporting and data analysis. Unlike Data Lakes, which follow the Extract Load Transform (ELT) model, DWs commonly use the Extract Transform Load (ETL) model.

A DW receives data from different data sources which is then processed in a staging area before being ingested to the actual warehouse (a database) and arranged as needed. DWs may then feed data to separate Data Marts; smaller database systems which end users may use for different purposes.

![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/d0634f23-d25c-438e-982e-e1627ed5be0a)

### BigQuery

BigQuery (BQ) is a Data Warehouse solution offered by Google Cloud Platform.

- BQ is serverless. There are no servers to manage or database software to install; this is managed by Google and it's transparent to the customers.
- BQ is scalable and has high availability. Google takes care of the underlying software and infrastructure.
- BQ has built-in features like Machine Learning, Geospatial Analysis and Business Intelligence among others.
- BQ maximizes flexibility by separating data analysis and storage in different compute engines, thus allowing the customers to budget accordingly and reduce costs.

Some alternatives to BigQuery from other cloud providers would be AWS Redshift or Azure Synapse Analytics.


### Preparing Dataset Files

#### wget (source --> gcs folder)

Source: https://github.com/DataTalksClub/nyc-tlc-data/releases

Files : yellow_tripdata_2019-*.csv.gz & yellow_tripdata_2020-*.csv.gz

Activate Cloud Shell

![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/920d51f2-100c-4665-8954-17fb738853af)

```
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2019-01.csv.gz
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2019-02.csv.gz
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2019-03.csv.gz
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2019-04.csv.gz
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2019-05.csv.gz
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2019-06.csv.gz
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2019-07.csv.gz
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2019-08.csv.gz
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2019-09.csv.gz
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2019-10.csv.gz
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2019-11.csv.gz
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2019-012.csv.gz

wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2020-01.csv.gz
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2020-02.csv.gz
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2020-03.csv.gz
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2020-04.csv.gz
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2020-05.csv.gz
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2020-06.csv.gz
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2020-07.csv.gz
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2020-08.csv.gz
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2020-09.csv.gz
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2020-10.csv.gz
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2020-11.csv.gz
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2020-12.csv.gz
```

#### gsutil cp (GCS folder to GCS bucket)

```
$ gsutil -m cp yellow*.csv.gz gs://de-zoomcamp-garjita-bucket/trip_data
Copying file://yellow_tripdata_2019-01.csv.gz [Content-Type=text/csv]...
Copying file://yellow_tripdata_2019-03.csv.gz [Content-Type=text/csv]...        
Copying file://yellow_tripdata_2019-02.csv.gz [Content-Type=text/csv]...        
Copying file://yellow_tripdata_2019-04.csv.gz [Content-Type=text/csv]...        
Copying file://yellow_tripdata_2019-07.csv.gz [Content-Type=text/csv]...        
Copying file://yellow_tripdata_2019-11.csv.gz [Content-Type=text/csv]...        
Copying file://yellow_tripdata_2019-05.csv.gz [Content-Type=text/csv]...        
Copying file://yellow_tripdata_2020-01.csv.gz [Content-Type=text/csv]...        
Copying file://yellow_tripdata_2019-08.csv.gz [Content-Type=text/csv]...        
Copying file://yellow_tripdata_2020-05.csv.gz [Content-Type=text/csv]...        
Copying file://yellow_tripdata_2019-12.csv.gz [Content-Type=text/csv]...        
Copying file://yellow_tripdata_2019-06.csv.gz [Content-Type=text/csv]...        
Copying file://yellow_tripdata_2020-06.csv.gz [Content-Type=text/csv]...        
Copying file://yellow_tripdata_2020-07.csv.gz [Content-Type=text/csv]...
Copying file://yellow_tripdata_2019-09.csv.gz [Content-Type=text/csv]...        
Copying file://yellow_tripdata_2020-02.csv.gz [Content-Type=text/csv]...        
Copying file://yellow_tripdata_2019-10.csv.gz [Content-Type=text/csv]...
Copying file://yellow_tripdata_2020-03.csv.gz [Content-Type=text/csv]...        
Copying file://yellow_tripdata_2020-04.csv.gz [Content-Type=text/csv]...        
Copying file://yellow_tripdata_2020-08.csv.gz [Content-Type=text/csv]...        
Copying file://yellow_tripdata_2020-09.csv.gz [Content-Type=text/csv]...        
Copying file://yellow_tripdata_2020-10.csv.gz [Content-Type=text/csv]...        
Copying file://yellow_tripdata_2020-11.csv.gz [Content-Type=text/csv]...        
Copying file://yellow_tripdata_2020-12.csv.gz [Content-Type=text/csv]...        
- [24/24 files][  1.9 GiB/  1.9 GiB] 100% Done 169.3 MiB/s ETA 00:00:00         
Operation completed over 24 objects/1.9 GiB.  
```

![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/971a2190-9115-49fc-bde6-ac8007538a90)
![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/798decc0-6f92-4c1c-a3f8-bc698cc3e082)


### External tables
BigQuery supports a few external data sources: you may query these sources directly from BigQuery even though the data itself isn't stored in BQ.

An external table is a table that acts like a standard BQ table. The table metadata (such as the schema) is stored in BQ storage but the data itself is external.

You may create an external table from a CSV or Parquet file stored in a Cloud Storage bucket:
```
CREATE OR REPLACE EXTERNAL TABLE `nytaxi.external_yellow_tripdata`
OPTIONS (
  format = 'CSV',
  uris = ['gs://de-zoomcamp-garjita-bucket/trip_data/yellow_tripdata_2019-*.csv.gz', 'gs://de-zoomcamp-garjita-bucket/trip_data/yellow_tripdata_2020-*.csv.gz']
);
```

![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/ade14ff9-6307-4ae4-9ca3-c6d5ec1ca703)
![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/35ce1370-3cd6-4aef-a2b2-862a11b50499)


### Regular Internal Table

You may import an external table into BQ as a regular internal table by copying the contents of the external table into a new internal table. For example:
```
CREATE OR REPLACE TABLE nytaxi.yellow_tripdata_non_partitoned AS
SELECT * FROM nytaxi.external_yellow_tripdata;
```

![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/7b09d455-0455-42e6-953d-11a4c5758d7f)


### Partitions

When we create a dataset, we generally have one or more columns that are used as some type of filter (usually columns in where clause). In this case, we can partition a table based on such columns to improve BigQuery's performance. In this lesson, the instructor shows us an example of a dataset containing StackOverflow questions (left), and how the dataset would look like if it was partitioned by the Creation_date field (right).

Partitioning is a powerful feature of BigQuery. Suppose we want to query the questions created on a specific date. Partition improves processing, because BigQuery will not read or process any data from other dates. This improves efficiency and reduces querying costs.

![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/03dfe45a-b014-40f7-ba82-31c5318302a1)

BQ tables can be partitioned into multiple smaller tables. For example, if we often filter queries based on date, we could partition a table based on date so that we only query a specific sub-table based on the date we're interested in.

Partition tables are very useful to improve performance and reduce costs, because BQ will not process as much data per query.

You may partition a table by:

Time-unit column: tables are partitioned based on a TIMESTAMP, DATE, or DATETIME column in the table.
Ingestion time: tables are partitioned based on the timestamp when BigQuery ingests the data.
Integer range: tables are partitioned based on an integer column.

For Time-unit and Ingestion time columns, the partition may be daily (the default option), hourly, monthly or yearly.

Note: BigQuery limits the amount of partitions to 4000 per table. If you need more partitions, consider clustering as well.

Here's an example query for creating a partitioned table:
```
CREATE OR REPLACE TABLE nytaxi.yellow_tripdata_partitoned
PARTITION BY
  DATE(tpep_pickup_datetime) AS
SELECT * FROM nytaxi.external_yellow_tripdata;
```

![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/af2f9fb1-529e-49c7-8f46-901f35557b80)
![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/3bc8a1af-1e3d-43c3-9598-1b0dee7e5f38)

BQ will identify partitioned tables with a specific icon. The Details tab of the table will specify the field which was used for partitioning the table and its datatype.

Querying a partitioned table is identical to querying a non-partitioned table, but the amount of processed data may be drastically different. Here are 2 identical queries to the non-partitioned and partitioned tables we created in the previous queries:
```
SELECT DISTINCT(VendorID)
FROM nytaxi.yellow_tripdata_non_partitoned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2019-06-30';
```

![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/fc65f9f3-dd34-47fe-9ed5-04081692de65)

- Query to non-partitioned table.
- It will process around 1.6GB of data/

![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/2b078bb5-0755-4511-9222-4ef5a3749e9a)

```
SELECT DISTINCT(VendorID)
FROM nytaxi.yellow_tripdata_partitoned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2019-06-30';
```

![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/10d8e0ed-f0cf-4f94-b01e-c98ba187e036)

- Query to partitioned table.
- It will process around 106MB of data.

You may check the amount of rows of each partition in a partitioned table with a query such as this:
```
SELECT table_name, partition_id, total_rows
FROM `nytaxi.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name = 'yellow_tripdata_partitoned'
ORDER BY total_rows DESC;
```
This is useful to check if there are data imbalances and/or biases in your partitions.

![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/9ecf8b37-d6a2-4978-af2b-eb6d28f61e34)


### Clustering

We can cluster tables based on some field. In the StackOverflow example presented by the instructor, after partitioning questions by date, we may want to cluster them by tag in each partition. Clustering also helps us to reduce our costs and improve query performance. The field that we choose for clustering depends on how the data will be queried.

![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/8c75cd3b-9141-4619-b903-50a95133d8ac)

Clustering consists of rearranging a table based on the values of its columns so that the table is ordered according to any criteria. Clustering can be done based on one or multiple columns up to 4; the order of the columns in which the clustering is specified is important in order to determine the column priority.

Clustering may improve performance and lower costs on big datasets for certain types of queries, such as queries that use filter clauses and queries that aggregate data.

Note: tables with less than 1GB don't show significant improvement with partitioning and clustering; doing so in a small table could even lead to increased cost due to the additional metadata reads and maintenance needed for these features.

Clustering columns must be top-level, non-repeated columns. The following datatypes are supported:

- DATE
- BOOL
- GEOGRAPHY
- INT64
- NUMERIC
- BIGNUMERIC
- STRING
- TIMESTAMP
- DATETIME

A partitioned table can also be clustered. Here's an example query for creating a partitioned and clustered table:
```
CREATE OR REPLACE TABLE nytaxi.yellow_tripdata_partitoned_clustered
PARTITION BY DATE(tpep_pickup_datetime)
CLUSTER BY VendorID AS
SELECT * FROM nytaxi.external_yellow_tripdata;
```

![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/8b51adc2-f12d-49b3-8c97-856926fc6975)
![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/504e5dc9-8d51-4ffa-a41d-b42f2f0280d1)

Just like for partitioned tables, the Details tab for the table will also display the fields by which the table is clustered.

![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/e02ed5e6-c1b5-4e97-8fb1-3dda6e6d538d)
![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/068de331-1ec0-48c1-ad8b-0c3e5ddd7828)

Here are 2 identical queries, one for a partitioned table and the other for a partitioned and clustered table:
```
SELECT count(*) as trips
FROM nytaxi.yellow_tripdata_partitoned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2020-12-31'
  AND VendorID=1;
```
- Query to non-clustered, partitioned table.
- This will process about 1.1GB of data.

![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/846337c1-e463-4414-9c2c-5313a5482691)

```
SELECT count(*) as trips
FROM nytaxi.yellow_tripdata_partitoned_clustered
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2020-12-31'
  AND VendorID=1;
```
- Query to partitioned and clustered data.
- This will process about 865MB of data.

![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/18ba29b0-b54c-4b87-ae7c-072e05d47552)


### Partitioning vs Clustering

As mentioned before, you may combine both partitioning and clustering in a table, but there are important differences between both techniques that you need to be aware of in order to decide what to use for your specific scenario:

![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/45bb746c-b3f9-46ce-b5ee-b072b501f1e4)

You may choose clustering over partitioning when partitioning results in a small amount of data per partition, when partitioning would result in over 4000 partitions or if your mutation operations modify the majority of partitions in the table frequently (for example, writing to the table every few minutes and writing to most of the partitions each time rather than just a handful).

BigQuery has automatic reclustering: when new data is written to a table, it can be written to blocks that contain key ranges that overlap with the key ranges in previously written blocks, which weaken the sort property of the table. BQ will perform automatic reclustering in the background to restore the sort properties of the table.

- For partitioned tables, clustering is maintaned for data within the scope of each partition.


### Best practices

Here's a list of best practices for BigQuery:

- Cost reduction
    - Avoid SELECT * . Reducing the amount of columns to display will drastically reduce the amount of processed data and lower costs.
    - Price your queries before running them.
    - Use clustered and/or partitioned tables if possible.
    - Use streaming inserts with caution. They can easily increase cost.
    - Materialize query results in different stages.
- Query performance
    - Filter on partitioned columns.
    - Denormalize data.
    - Use nested or repeated columns.
    - Use external data sources appropiately. Constantly reading data from a bucket may incur in additional costs and has worse performance.
    - Reduce data before using a JOIN.
    - Do not threat WITH clauses as prepared statements.
    - Avoid oversharding tables.
    - Avoid JavaScript user-defined functions.
    - Use approximate aggregation functions rather than complete ones such as HyperLogLog++.
    - Order statements should be the last part of the query.
    - Optimize join patterns.
    - Place the table with the largest number of rows first, followed by the table with the fewest rows, and then place the remaining tables by decreasing size.
        - This is due to how BigQuery works internally: the first table will be distributed evenly and the second table will be broadcasted to all the nodes. Check the Internals section for more details.


## Machine Learning with BigQuery

### Introduction to BigQuery ML

BigQuery ML is a BQ feature which allows us to create and execute Machine Learning models using standard SQL queries, without additional knowledge of Python nor any other programming languages and without the need to export data into a different system.

The pricing for BigQuery ML is slightly different and more complex than regular BigQuery. Some resources are free of charge up to a specific limit as part of the Google Cloud Free Tier. You may check the current pricing in this link.

BQ ML offers a variety of ML models depending on the use case, as the image below shows:

![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/b46ca3fb-7603-4a59-afc9-9b77e307b822)

We will now create a few example queries to show how BQ ML works. Let's begin with creating a custom table:
```
CREATE OR REPLACE TABLE `nytaxi.yellow_tripdata_ml` (
  `passenger_count` INTEGER,
  `trip_distance` FLOAT64,
  `PULocationID` STRING,
  `DOLocationID` STRING,
  `payment_type` STRING,
  `fare_amount` FLOAT64,
  `tolls_amount` FLOAT64,
  `tip_amount` FLOAT64
) AS (
  SELECT passenger_count, trip_distance, CAST(PULocationID AS STRING), CAST(DOLocationID AS STRING), CAST(payment_type AS STRING), fare_amount, tolls_amount, tip_amount

  FROM nytaxi.yellow_tripdata_partitoned
  WHERE fare_amount != 0
);
```

![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/e33eb00d-fd86-420d-9e3c-7052846cb109)
![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/def7127e-4cd6-4e8a-8217-0bda9e5693df)

- BQ supports feature preprocessing, both manual and automatic.
- A few columns such as PULocationID are categorical in nature but are represented with integer numbers in the original table. We cast them as strings in order to get BQ to automatically preprocess them as categorical features that will be one-hot encoded.
- Our target feature for the model will be tip_amount. We drop all records where tip_amount equals zero in order to improve training.

Let's now create a simple linear regression model with default settings:
```
CREATE OR REPLACE MODEL nytaxi.tip_model
OPTIONS (
  model_type='linear_reg',
  input_label_cols=['tip_amount'],
  DATA_SPLIT_METHOD='AUTO_SPLIT'
) AS
SELECT
  *
FROM
  nytaxi.yellow_tripdata_ml
WHERE
  tip_amount IS NOT NULL;
```

![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/23fd4954-1d45-4875-a456-d8e01f6ffeb2)
![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/b3b67bc5-d52a-49ef-a251-2ba5252ce9cd)

- The CREATE MODEL clause will create the nytaxi.tip_model model
- The OPTIONS() clause contains all of the necessary arguments to create our model/
    - model_type='linear_reg' is for specifying that we will create a linear regression model.
    - input_label_cols=['tip_amount'] lets BQ know that our target feature is tip_amount. For linear regression models, target features must be real numbers.
    - DATA_SPLIT_METHOD='AUTO_SPLIT' is for automatically splitting the dataset into train/test datasets.
- The SELECT statement indicates which features need to be considered for training the model.
    - Since we already created a dedicated table with all of the needed features, we simply select them all.
- Running this query may take several minutes.
- After the query runs successfully, the BQ explorer in the side panel will show all available models (just one in our case) with a special icon. Selecting a model will open a new tab with additional info such as model details, training graphs and evaluation metrics.

We can also get a description of the features with the following query:
```
SELECT * FROM ML.FEATURE_INFO(MODEL `nytaxi.tip_model`);
```
- The output will be similar to describe() in Pandas.

Model evaluation against a separate dataset is as follows:
```
SELECT
  *
FROM
ML.EVALUATE(
  MODEL `nytaxi.tip_model`, (
    SELECT
      *
    FROM
      `nytaxi.yellow_tripdata_ml`
    WHERE
      tip_amount IS NOT NULL
  )
);
```

![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/a13f8a33-cf33-4184-a983-3c29098e98c7)

- This will output similar metrics to those shown in the model info tab but with the updated values for the evaluation against the provided dataset.
- In this example we evaluate with the same dataset we used for training the model, so this is a silly example for illustration purposes.

The main purpose of a ML model is to make predictions. A ML.PREDICT statement is used for doing them:
```
SELECT
  *
FROM
ML.PREDICT(
  MODEL `nytaxi.tip_model`, (
    SELECT
      *
    FROM
      `nytaxi.yellow_tripdata_ml`
    WHERE
      tip_amount IS NOT NULL
  )
);
```

![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/b4f6019b-621e-4fd8-8407-aca4a279a9e4)

- The SELECT statement within ML.PREDICT provides the records for which we want to make predictions.
- Once again, we're using the same dataset we used for training to calculate predictions, so we already know the actual tips for the trips, but this is just an example.

Additionally, BQ ML has a special ML.EXPLAIN_PREDICT statement that will return the prediction along with the most important features that were involved in calculating the prediction for each of the records we want predicted.
```
SELECT
  *
FROM
ML.EXPLAIN_PREDICT(
  MODEL `nytaxi.tip_model`,(
    SELECT
      *
    FROM
      `nytaxi.yellow_tripdata_ml`
    WHERE
      tip_amount IS NOT NULL
  ), STRUCT(3 as top_k_features)
);
```

![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/e1ccd6fd-c1f2-4232-b208-19ed48a10c31)

- This will return a similar output to the previous query but for each prediction, 3 additional rows will be provided with the most significant features along with the assigned weights for each feature.
  
Just like in regular ML models, BQ ML models can be improved with hyperparameter tuning. Here's an example query for tuning:
```
CREATE OR REPLACE MODEL `nytaxi.tip_hyperparam_model`
OPTIONS (
  model_type='linear_reg',
  input_label_cols=['tip_amount'],
  DATA_SPLIT_METHOD='AUTO_SPLIT',
  num_trials=5,
  max_parallel_trials=2,
  l1_reg=hparam_range(0, 20),
  l2_reg=hparam_candidates([0, 0.1, 1, 10])
) AS
SELECT
*
FROM
`nytaxi.yellow_tripdata_ml`
WHERE
tip_amount IS NOT NULL;
```

![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/1cb57233-ae06-4872-9e6c-5994ad15dd8f)

--> *Solved by creating a new project & dataset in new reqion. Here I use EU region.*

- We create a new model as normal but we add the num_trials option as an argument.
- All of the regular arguments used for creating a model are available for tuning. In this example we opt to tune the L1 and L2 regularizations.

All of the necessary reference documentation is available [in this link].(https://cloud.google.com/bigquery/docs/reference/libraries-overview)

![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/57a96cb1-44ef-4d1e-b94a-837c5afa9d8e)
![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/2ad8edbf-55f2-45a5-ba09-44341d2c0d48)
![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/0f47476b-736f-47be-bb94-ba14aa2cfcc7)

**My Asia Region Dataset**

![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/3ebb5913-e928-425e-b1bc-9ca77fcfb1dd)

**My EU Region Dataset**

![image](https://github.com/garjitads/de-zoomcamp-2024-week3/assets/157445647/72470d29-64de-4922-92b3-3102b108c6b3)


### BigQuery ML deployment

ML models created within BQ can be exported and deployed to Docker containers running TensorFlow Serving.

The following steps are based on this official tutorial. All of these commands are to be run from a terminal and the gcloud sdk must be installed.

1. Authenticate to your GCP project.
```
gcloud auth login
```

2. Export the model to a Cloud Storage bucket.
```
bq --project_id my-project-multi-region extract -m nytaxi_eu.tip_model gs://taxi_ml_model63/tip_model
```

3. Download the exported model files to a temporary directory.
```
mkdir /tmp/model

gsutil cp -r gs://taxi_ml_model63/tip_model /tmp/model
```

4. Create a version subdirectory
```
mkdir -p serving_dir/tip_model/1

cp -r /tmp/model/tip_model/* serving_dir/tip_model/1

# Optionally you may erase the temporary directoy
rm -r /tmp/model
```

5. Pull the TensorFlow Serving Docker image
```
docker pull tensorflow/serving
```

6.Run the Docker image. Mount the version subdirectory as a volume and provide a value for the MODEL_NAME environment variable.
```
# Make sure you don't mess up the spaces!
docker run \
  -p 8501:8501 \
  --mount type=bind,source=`pwd`/serving_dir/tip_model,target=/models/tip_model \
  -e MODEL_NAME=tip_model \
  -t tensorflow/serving &
```

7. With the image running, run a prediction with curl, providing values for the features used for the predictions.
```
curl \
  -d '{"instances": [{"passenger_count":1, "trip_distance":12.2, "PULocationID":"193", "DOLocationID":"264", "payment_type":"2","fare_amount":20.4,"tolls_amount":0.0}]}' \
  -X POST http://localhost:8501/v1/models/tip_model:predict
```

Example: 
```
{
    "predictions": [[0.2497064033370151]
    ]
}
```

