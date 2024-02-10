-- Create external table
CREATE OR REPLACE EXTERNAL TABLE `nytaxi.external_yellow_tripdata`
OPTIONS (
  format = 'CSV',
  uris = ['gs://de-zoomcamp-garjita-bucket/trip_data/yellow_tripdata_2019-*.csv.gz', 'gs://de-zoomcamp-garjita-bucket/trip_data/yellow_tripdata_2020-*.csv.gz']
);


-- Create non-partitioned table
CREATE OR REPLACE TABLE nytaxi.yellow_tripdata_non_partitoned AS
SELECT * FROM nytaxi.external_yellow_tripdata;

-- Create partitioned table
CREATE OR REPLACE TABLE nytaxi.yellow_tripdata_partitoned
PARTITION BY
  DATE(tpep_pickup_datetime) AS
SELECT * FROM nytaxi.external_yellow_tripdata;

-- Select distinct VendorID where tpep_pickup_datetime between 2019-06-01' AND '2019-06-30' (June 2019)
SELECT DISTINCT(VendorID)
FROM taxi-rides-ny.nytaxi.yellow_tripdata_non_partitoned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2019-06-30';

-- Check the amount of rows of each partition in a partitioned table 
SELECT table_name, partition_id, total_rows
FROM `nytaxi.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name = 'yellow_tripdata_partitoned'
ORDER BY total_rows DESC;

-- Creating a partitioned and clustered table
CREATE OR REPLACE TABLE nytaxi.yellow_tripdata_partitoned_clustered
PARTITION BY DATE(tpep_pickup_datetime)
CLUSTER BY VendorID AS
SELECT * FROM nytaxi.external_yellow_tripdata;

-- Query example of select count for specific VendorID and tpep_pickup_datetime
SELECT count(*) as trips
FROM nytaxi.yellow_tripdata_partitoned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2020-12-31'
  AND VendorID=1;


-- Create table for BigQuery Machine Learning 
CREATE OR REPLACE TABLE `nytaxi_eu.yellow_tripdata_ml` (
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

  FROM nytaxi_eu.yellow_tripdata_partitoned
  WHERE fare_amount != 0
);

-- Create a simple linear regression model with default settings
CREATE OR REPLACE MODEL nytaxi_eu.tip_model
OPTIONS (
  model_type='linear_reg',
  input_label_cols=['tip_amount'],
  DATA_SPLIT_METHOD='AUTO_SPLIT'
) AS
SELECT
  *
FROM
  nytaxi_eu.yellow_tripdata_ml
WHERE
  tip_amount IS NOT NULL;

-- get a description of the features 
SELECT * FROM ML.FEATURE_INFO(MODEL `nytaxi_eu.tip_model`);

-- Model evaluation against a separate dataset 
SELECT
  *
FROM
ML.EVALUATE(
  MODEL `nytaxi_eu.tip_model`, (
    SELECT
      *
    FROM
      `nytaxi_eu.yellow_tripdata_ml`
    WHERE
      tip_amount IS NOT NULL
  )
);

-- The main purpose of a ML model is to make predictions. A ML.PREDICT statement is used for doing them:
SELECT
  *
FROM
ML.PREDICT(
  MODEL `nytaxi_eu.tip_model`, (
    SELECT
      *
    FROM
      `nytaxi_eu.yellow_tripdata_ml`
    WHERE
      tip_amount IS NOT NULL
  )
);

-- BQ ML has a special ML.EXPLAIN_PREDICT statement that will return the prediction along with the most important features that were involved in calculating the prediction for each of the records we want predicted.
SELECT
  *
FROM
ML.EXPLAIN_PREDICT(
  MODEL `nytaxi_eu.tip_model`,(
    SELECT
      *
    FROM
      `nytaxi_eu.yellow_tripdata_ml`
    WHERE
      tip_amount IS NOT NULL
  ), STRUCT(3 as top_k_features)
);

-- CREATE OR REPLACE MODEL `nytaxi_eu.tip_hyperparam_model`
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
`nytaxi_eu.yellow_tripdata_ml`
WHERE
tip_amount IS NOT NULL;

-- Just like in regular ML models, BQ ML models can be improved with hyperparameter tuning. Here's an example query for tuning:
CREATE OR REPLACE MODEL `nytaxi_eu.tip_hyperparam_model`
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
`nytaxi_eu.yellow_tripdata_ml`
WHERE
tip_amount IS NOT NULL;


  
