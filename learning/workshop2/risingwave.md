# Environments
1. Github Codespace
2. GCP VM Instance

# Prerequisites
1. Docker and Docker Compose
   ```
   @garjita63 ➜ ~/risingwave-data-talks-workshop-2024-03-04 (main) $ docker version
   Client:
      Version:           24.0.9-1
      API version:       1.43
      Go version:        go1.20.13
      Git commit:        293681613032e6d1a39cc88115847d3984195c24
      Built:             Wed Jan 31 20:53:14 UTC 2024
      OS/Arch:           linux/amd64
      Context:           default
     
   Server:
      Engine:
       Version:          24.0.9-1
       API version:      1.43 (minimum version 1.12)
       Go version:       go1.20.13
       Git commit:       fca702de7f71362c8d103073c7e4a1d0a467fadd
       Built:            Thu Feb  1 00:12:23 2024
       OS/Arch:          linux/amd64
       Experimental:     false
      containerd:
       Version:          1.6.28-1
       GitCommit:        ae07eda36dd25f8a1b98dfbf587313b99c0190bb
      runc:
       Version:          1.1.12-1
       GitCommit:        51d5e94601ceffbbd85688df1c928ecccbfa4685
      docker-init:
       Version:          0.19.0
       GitCommit:        de40ad0
    ```
3. Python 3.7 or later
   ```
   @garjita63 ➜ ~/risingwave-data-talks-workshop-2024-03-04 (main) $ python --version
   Python 3.10.13
   ```
4. pip and virtualenv for Python
   ```
   @garjita63 ➜ ~/risingwave-data-talks-workshop-2024-03-04 (main) $ pip --version
   pip 24.0 from /usr/local/python/3.10.13/lib/python3.10/site-packages/pip (python 3.10)
   ```
6. psql (I use PostgreSQL-14.9)
   ```
   @garjita63 ➜ ~/risingwave-data-talks-workshop-2024-03-04 (main) $ psql -V
   psql (PostgreSQL) 16.2 (Ubuntu 16.2-1.pgdg20.04+1)
   ```
7. Clone this repository:
   ```
   git clone git@github.com:risingwavelabs/risingwave-data-talks-workshop-2024-03-04.git
   cd risingwave-data-talks-workshop-2024-03-04
   ```
   Or, if you prefer HTTPS:
   ```
   git clone https://github.com/risingwavelabs/risingwave-data-talks-workshop-2024-03-04.git
   cd risingwave-data-talks-workshop-2024-03-04
   ```

# Datasets

[NYC Taxi & Limousine Commission website](https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page)

- yellow_tripdata_2022-01.parquet
- taxi_zone.csv

Dataset have already been downloaded and are available in the data directory.

The file seed_kafka.py contains the logic to process the data and populate RisingWave.

In this workshop, we will replace the timestamp fields in the trip_data with timestamps close to the current time. That's because yellow_tripdata_2022-01.parquet contains historical data from 2022, and we want to simulate processing real-time data.

# Project Structure

```
@garjita63 ➜ ~/risingwave-data-talks-workshop-2024-03-04 (main) $ tree
.
├── README.md
├── assets
│   ├── mv1_plan.png
│   ├── mv2_plan.png
│   └── project.png
├── clickhouse-sql
│   ├── avg_fare_amt.sql
│   └── demo_table.sql
├── commands.sh
├── data
│   ├── taxi_zone.csv
│   └── yellow_tripdata_2022-01.parquet
├── docker
│   ├── Dockerfile
│   ├── Dockerfile.hdfs
│   ├── README.md
│   ├── aws
│   │   ├── Dockerfile
│   │   └── aws-build.sh
│   ├── aws.env
│   ├── dashboards
│   │   ├── risingwave-dev-dashboard.json
│   │   └── risingwave-user-dashboard.json
│   ├── docker-compose.yml
│   ├── grafana-risedev-dashboard.yml
│   ├── grafana-risedev-datasource.yml
│   ├── grafana.ini
│   ├── hdfs_env.sh
│   ├── multiple_object_storage.env
│   ├── prometheus.yaml
│   └── risingwave.toml
├── homework.md
├── index.html
├── requirements.txt
├── risingwave-sql
│   ├── sink
│   │   ├── avg_fare_amt_sink.sql
│   │   └── demo_clickhouse_sink.sql
│   └── table
│       ├── taxi_zone.sql
│       └── trip_data.sql
├── seed_kafka.py
├── server.py
├── slides.pdf
└── workshop.md
```

# Getting Started

Before getting your hands dirty with the project, we will:

1. Run some diagnostics.
2. Start the RisingWave cluster.
3. Setup our python environment.

```
# Check version of psql
psql --version
source commands.sh

# Start the RW cluster
start-cluster

# Setup python
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```
commands.sh contains several commands to operate the cluster. You may reference it to see what commands are available.

# Workshop (Stream Processing in SQL with RisingWave)

[Source](https://github.com/risingwavelabs/risingwave-data-talks-workshop-2024-03-04/blob/main/workshop.md)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/80d902f2-2192-449a-b251-5a0255468bcc)

These two commands shoudl be run every time opening a new terminal.
```
source .venv/bin/activate
```
```
source commands.sh
```

# Starts the risingwave cluster
   start-cluster() {
   	docker-compose -f docker/docker-compose.yml up -d
   }

```
start-cluster
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/303d5627-3a9b-417b-9e3e-1e40ce662546)

# Seed trip data from the parquet file
   stream-kafka() {
   	./seed_kafka.py update
   }
   
```
stream-kafka
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/156c5406-5dc2-4c5e-a0d3-b6850a15b4ea)

Now we can let that run in the background.

Let's open another terminal to create the trip_data table:

```
source commands.sh
psql -f risingwave-sql/table/trip_data.sql
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/873bcba9-ca37-4c60-8d52-7993ae9571d9)

```
psql -c 'SHOW TABLES;'
```

# Stream Processing with Materialized Views in RisingWave

## Validating the ingested data

Now we are ready to begin processing the real-time stream being ingested into RisingWave!

The first thing we will do is to check taxi_zone and trip_data, to make sure the data has been ingested correctly.

Let's start a psql session.

```
source commands.sh
psql
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/80917a61-897d-43b7-8c53-89f1f7d77f1a)

First, we verify taxi_zone, since this is static data:

```
SELECT * FROM taxi_zone;
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/b867d9eb-02c5-4e7e-be00-86f6e8178a62)

We will also query for recent data, to ensure we are getting real-time data.

```
SELECT pulocationid, dolocationid, tpep_pickup_datetime, tpep_dropoff_datetime
FROM trip_data WHERE tpep_dropoff_datetime > now() - interval '1 minute';
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/6b2d4f43-0d52-463a-a237-caf6c03de3d5)

We can join this with taxi_zone to get the names of the zones.

```
SELECT taxi_zone.Zone as pickup_zone, taxi_zone_1.Zone as dropoff_zone, tpep_pickup_datetime, tpep_dropoff_datetime
 FROM trip_data
 JOIN taxi_zone ON trip_data.PULocationID = taxi_zone.location_id
 JOIN taxi_zone as taxi_zone_1 ON trip_data.DOLocationID = taxi_zone_1.location_id
 WHERE tpep_dropoff_datetime > now() - interval '1 minute';
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/c25c9d86-6fff-4e7f-aa90-e5685cc16e8b)

And finally make it into an MV so we can constantly query the latest realtime data:

```
CREATE MATERIALIZED VIEW latest_1min_trip_data AS
 SELECT taxi_zone.Zone as pickup_zone, taxi_zone_1.Zone as dropoff_zone, tpep_pickup_datetime, tpep_dropoff_datetime
 FROM trip_data
 JOIN taxi_zone ON trip_data.PULocationID = taxi_zone.location_id
 JOIN taxi_zone as taxi_zone_1 ON trip_data.DOLocationID = taxi_zone_1.location_id
 WHERE tpep_dropoff_datetime > now() - interval '1 minute';
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/90676919-b950-4836-b8d2-f46204f8acd2)

We can now query the MV to see the latest data:

```
SELECT * FROM latest_1min_trip_data order by tpep_dropoff_datetime DESC;
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/b08ccba8-37a0-4694-a070-539a4a84755d)

Now we can start processing the data with Materialized Views, to provide analysis of the data stream!

## Materialized View 1: Total Airport Pickups

The first materialized view we create will be to count the total number of pickups at the airports.

This is rather simple, we just need to filter the PULocationID to the airport IDs.

Recall taxi_zone contains metadata around the taxi zones, so we can use that to figure out the airport zones.

```
describe taxi_zone;
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/68fa4a97-329a-46ed-bae4-839f05b6d92a)

Let's first get the zone names by looking at the taxi_zone table:

```
SELECT * FROM taxi_zone WHERE Zone LIKE '%Airport';
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/a4e3c18c-e561-44c6-aaf2-69d3d1938c16)

Then we can simply join on their location ids to get all the trips:

```
    SELECT
        *
    FROM
        trip_data
            JOIN taxi_zone
                 ON trip_data.PULocationID = taxi_zone.location_id
    WHERE taxi_zone.Zone LIKE '%Airport';
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/59eab9ee-8496-44c7-9c24-02aa747d0450)

And finally apply the count(*) aggregation for each airport.

```
    SELECT
        count(*) AS cnt,
        taxi_zone.Zone
    FROM
        trip_data
            JOIN taxi_zone
                 ON trip_data.PULocationID = taxi_zone.location_id
    WHERE taxi_zone.Zone LIKE '%Airport'
    GROUP BY taxi_zone.Zone;
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/87804578-5944-49cf-a3fb-491bb583d4f3)

We can now create a Materialized View to constantly query the latest data:

```
CREATE MATERIALIZED VIEW total_airport_pickups AS
    SELECT
        count(*) AS cnt,
        taxi_zone.Zone
    FROM
        trip_data
            JOIN taxi_zone
                ON trip_data.PULocationID = taxi_zone.location_id
    WHERE taxi_zone.Zone LIKE '%Airport'
    GROUP BY taxi_zone.Zone;
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/b78efe2c-0c84-4f44-bcbf-e95c50564ee2)

We can now query the MV to see the latest data:

```
SELECT * FROM total_airport_pickups;
```
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/fcb763ac-0289-4772-af8a-5e62eff6b95b)

So what actually happens for the MV?

We can examine the query plan to see what's happening:

```
EXPLAIN CREATE MATERIALIZED VIEW total_airport_pickups AS
    SELECT
        count(*) AS cnt,
        taxi_zone.Zone
    FROM
        trip_data
            JOIN taxi_zone
                 ON trip_data.PULocationID = taxi_zone.location_id
    WHERE taxi_zone.Zone LIKE '%Airport'
    GROUP BY taxi_zone.Zone;
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/49ce7d94-bafd-4ae5-8b57-f9cba57ddc4d)

Go to your local [RisingWave Dashboard](http://localhost:5691/) to see the query plan.

Provided a simplified a simpler version here:

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/717a5962-1097-495c-a46b-95b0ca2e41c2)


## Materialized View 2: Airport pickups from JFK Airport, 1 hour before the latest pickup

We can adapt the previous MV to create a more specific one. We no longer need the GROUP BY, since we are only interested in 1 taxi zone, JFK Airport.

```
CREATE MATERIALIZED VIEW airport_pu as
SELECT
    tpep_pickup_datetime,
    pulocationid
FROM
    trip_data
        JOIN taxi_zone
            ON trip_data.PULocationID = taxi_zone.location_id
WHERE
        taxi_zone.Borough = 'Queens'
  AND taxi_zone.Zone = 'JFK Airport';
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/271f2ddb-fc78-41f3-86c1-4719c0ca6fde)

Next, we also want to keep track of the latest pickup

```
CREATE MATERIALIZED VIEW latest_jfk_pickup AS
    SELECT
        max(tpep_pickup_datetime) AS latest_pickup_time
    FROM
        trip_data
            JOIN taxi_zone
                ON trip_data.PULocationID = taxi_zone.location_id
    WHERE
        taxi_zone.Borough = 'Queens'
      AND taxi_zone.Zone = 'JFK Airport';
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/bbcd3f31-3914-4084-bf28-7d8b058a4d2e)

Finally, let's get the counts of the pickups from JFK Airport, 1 hour before the latest pickup

```
CREATE MATERIALIZED VIEW jfk_pickups_1hr_before AS
    SELECT
        count(*) AS cnt
    FROM
        airport_pu
            JOIN latest_jfk_pickup
                ON airport_pu.tpep_pickup_datetime > latest_jfk_pickup.latest_pickup_time - interval '1 hour'
            JOIN taxi_zone
                ON airport_pu.PULocationID = taxi_zone.location_id
    WHERE
        taxi_zone.Borough = 'Queens'
      AND taxi_zone.Zone = 'JFK Airport';
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/98dd3578-1792-43c3-ac10-f6a4992a49f3)

Simplified query plan:

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/0ccd79d9-2c8a-4a63-9726-0681faa3ef0d)


## Materialized View 3: Top 10 busiest zones in the last 1 minute

First we can write a query to get the counts of the pickups from each zone.

```
SELECT
    taxi_zone.Zone AS dropoff_zone,
    count(*) AS last_1_min_dropoff_cnt
FROM
    trip_data
        JOIN taxi_zone
            ON trip_data.DOLocationID = taxi_zone.location_id
GROUP BY
    taxi_zone.Zone
ORDER BY last_1_min_dropoff_cnt DESC
    LIMIT 10;
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/f7a8969f-c468-42f1-80a1-e6368483a39e)

Next, we can create a temporal filter to get the counts of the pickups from each zone in the last 1 minute.

That has the form:

```
CREATE MATERIALIZED VIEW busiest_zones_1_min AS SELECT
    taxi_zone.Zone AS dropoff_zone,
    count(*) AS last_1_min_dropoff_cnt
FROM
    trip_data
        JOIN taxi_zone
            ON trip_data.DOLocationID = taxi_zone.location_id
WHERE
    trip_data.tpep_dropoff_datetime > (NOW() - INTERVAL '1' MINUTE)
GROUP BY
    taxi_zone.Zone
ORDER BY last_1_min_dropoff_cnt DESC
    LIMIT 10;
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/80f0bf0e-4e1b-4821-a60c-a938024d7269)


## Materialized View 4: Longest trips

Here, the concept is similar as the previous MV, but we are interested in the top 10 longest trips for the last 5 min.

First we create the query to get the longest trips:

```
SELECT
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    taxi_zone_pu.Zone as pickup_zone,
    taxi_zone_do.Zone as dropoff_zone,
    trip_distance
FROM
    trip_data
        JOIN taxi_zone as taxi_zone_pu
             ON trip_data.PULocationID = taxi_zone_pu.location_id
        JOIN taxi_zone as taxi_zone_do
             ON trip_data.DOLocationID = taxi_zone_do.location_id
ORDER BY
    trip_distance DESC
    LIMIT 10;
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/caeaeac6-3217-4107-9d59-2b7fef708a5b)

Then we can create a temporal filter to get the longest trips for the last 5 minutes:

```
CREATE MATERIALIZED VIEW longest_trip_1_min AS SELECT
        tpep_pickup_datetime,
        tpep_dropoff_datetime,
        taxi_zone_pu.Zone as pickup_zone,
        taxi_zone_do.Zone as dropoff_zone,
        trip_distance
    FROM
        trip_data
    JOIN taxi_zone as taxi_zone_pu
        ON trip_data.PULocationID = taxi_zone_pu.location_id
    JOIN taxi_zone as taxi_zone_do
        ON trip_data.DOLocationID = taxi_zone_do.location_id
    WHERE
        trip_data.tpep_pickup_datetime > (NOW() - INTERVAL '5' MINUTE)
    ORDER BY
        trip_distance DESC
    LIMIT 10;
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/c14278c0-3e8b-44f0-a1f8-cb6dbfc49a54)


## Materialized View 5: Average Fare Amount vs Number of rides

How does avg_fare_amt change relative to number of pickups per minute?

We use something known as a [tumble window function](https://docs.risingwave.com/docs/current/sql-function-time-window/#tumble-time-window-function), to compute this.

```
CREATE MATERIALIZED VIEW avg_fare_amt AS
SELECT
    avg(fare_amount) AS avg_fare_amount_per_min,
    count(*) AS num_rides_per_min,
    window_start,
    window_end
FROM
    TUMBLE(trip_data, tpep_pickup_datetime, INTERVAL '1' MINUTE)
GROUP BY
    window_start, window_end
ORDER BY
    num_rides_per_min ASC;
```

For each window we compute the average fare amount and the number of rides.

That's all for the materialized views!

Now we will see how to sink the data out from RisingWave.


# How to sink data from RisingWave to Clickhouse

Reference:

- https://docs.risingwave.com/docs/current/data-delivery/
- https://docs.risingwave.com/docs/current/sink-to-clickhouse/
  
We have done some simple analytics and processing of the data in RisingWave.

Now we want to sink the data out to Clickhouse, for further analysis.

We will create a Clickhouse table to store the data from the materialized views.

Open n anew termina.

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/2cf3ec21-d18b-407e-820e-d49cd51bc5c6)

```
source commands.sh
clickhouse-client-term
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/4c9cfb2f-bacc-4b25-a17e-a38bbe1ca799)

```
CREATE TABLE avg_fare_amt(
    avg_fare_amount_per_min numeric,
    num_rides_per_min Int64,
) ENGINE = ReplacingMergeTree
PRIMARY KEY (avg_fare_amount_per_min, num_rides_per_min);
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/8aa3a27b-70b7-47c6-be3c-5fb8a0c47fb8)

We will create a Clickhouse sink to sink the data from the materialized views to the Clickhouse table.

```
CREATE SINK IF NOT EXISTS avg_fare_amt_sink AS SELECT avg_fare_amount_per_min, num_rides_per_min FROM avg_fare_amt
WITH (
    connector = 'clickhouse',
    type = 'append-only',
    clickhouse.url = 'http://clickhouse:8123',
    clickhouse.user = '',
    clickhouse.password = '',
    clickhouse.database = 'default',
    clickhouse.table='avg_fare_amt',
    force_append_only = 'true'
);
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/dafd0cd4-8398-4b62-80f1-362a65743898)

Now we can run queries on the data ingested into clickhouse:

```
clickhouse-client-term
```

Run some queries in Clickhouse

```
select max(avg_fare_amount_per_min) from avg_fare_amt;
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/c315ebb0-e853-4aae-8f31-81efe6af22ec)

```
select min(avg_fare_amount_per_min) from avg_fare_amt;
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/b9c4521d-2801-43bc-becb-f00e39809f18)


# Summary

In this workshop you have learnt:

- How to ingest data into RisingWave using Kafka
- How to process the data using Materialized Views
   - Using Aggregations
   - Using Temporal Filters
   - Using Window Functions (Tumble)
   - Using Joins
   - Layering MVs to build a stream pipeline
- How to sink the data out from RisingWave to Clickhouse

# What's next?

https://tutorials.risingwave.com/docs/category/basics


# Homework

To further understand the concepts, please try the [Homework](https://github.com/risingwavelabs/risingwave-data-talks-workshop-2024-03-04/blob/main/homework.md).





