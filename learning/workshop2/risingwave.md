# Envronment
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
```
start-cluster
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/303d5627-3a9b-417b-9e3e-1e40ce662546)

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


