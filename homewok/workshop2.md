# Homework

## Answer

## Setting up

In order to get a static set of results, we will use historical data from the dataset.

Run the following commands:
```bash
# Load the cluster op commands.
source commands.sh
# First, reset the cluster:
clean-cluster
# Start a new cluster
start-cluster
# wait for cluster to start
sleep 5
# Seed historical data instead of real-time data
seed-kafka
# Recreate trip data table
psql -f risingwave-sql/table/trip_data.sql
# Wait for a while for the trip_data table to be populated.
sleep 5
# Check that you have 100K records in the trip_data table
# You may rerun it if the count is not 100K
psql -c "SELECT COUNT(*) FROM trip_data"
```

## Question 1

Create a materialized view to compute the average, min and max trip time **between each taxi zone**.

From this MV, find the pair of taxi zones with the highest average trip time.
You may need to use the [dynamic filter pattern](https://docs.risingwave.com/docs/current/sql-pattern-dynamic-filters/) for this.

Bonus (no marks): Create an MV which can identify anomalies in the data. For example, if the average trip time between two zones is 1 minute,
but the max trip time is 10 minutes and 20 minutes respectively.

Options:
1. Yorkville East, Steinway
2. Murray Hill, Midwood
3. East Flatbush/Farragut, East Harlem North
4. Midtown Center, University Heights/Morris Heights

### Answer 1 : **Yorkville East, Steinway**

### Solution

```
CREATE MATERIALIZED VIEW max_averrage_trip_time AS
    WITH t AS (
        SELECT
			PULocationID,
			DOLocationID,
			AVG(tpep_dropoff_datetime - tpep_pickup_datetime) AS subtract_dropoff_pickup
        FROM trip_data
		GROUP BY PULocationID, DOLocationID
	)
    SELECT tz1.Zone AS PUZone, tz2.Zone AS DOZone, MAX(t.subtract_dropoff_pickup) AS max_averrage_trip_time
    FROM t
    	JOIN taxi_zone tz1
       		ON t.PULocationID = tz1.location_id
		JOIN taxi_zone tz2
			ON t.DOLocationID = tz2.location_id
	GROUP BY tz1.Zone, tz2.Zone
	ORDER BY max_averrage_trip_time DESC
	LIMIT 1
;
```
```
CREATE_MATERIALIZED_VIEW
```

```
CREATE MATERIALIZED VIEW max_trip_time AS
    WITH t AS (
        SELECT
			PULocationID,
			DOLocationID,
			MAX(tpep_dropoff_datetime - tpep_pickup_datetime) AS subtract_dropoff_pickup
        FROM trip_data
		GROUP BY PULocationID, DOLocationID
	)
    SELECT tz1.Zone AS PUZone, tz2.Zone AS DOZone, MAX(t.subtract_dropoff_pickup) AS max_trip_time
    FROM t
    JOIN taxi_zone tz1
        ON t.PULocationID = tz1.location_id
	JOIN taxi_zone tz2
		ON t.DOLocationID = tz2.location_id
	GROUP BY tz1.Zone, tz2.Zone
	ORDER BY max_trip_time DESC
	LIMIT 1
;
CREATE_MATERIALIZED_VIEW
```

```
CREATE MATERIALIZED VIEW min_trip_time AS
    WITH t AS (
        SELECT
			PULocationID,
			DOLocationID,
			MIN(tpep_dropoff_datetime - tpep_pickup_datetime) AS subtract_dropoff_pickup
        FROM trip_data
		GROUP BY PULocationID, DOLocationID
	)
    SELECT tz1.Zone AS PUZone, tz2.Zone AS DOZone, MAX(t.subtract_dropoff_pickup) AS min_trip_time
    FROM t
    JOIN taxi_zone tz1
        ON t.PULocationID = tz1.location_id
	JOIN taxi_zone tz2
		ON t.DOLocationID = tz2.location_id
	GROUP BY tz1.Zone, tz2.Zone
	ORDER BY min_trip_time ASC
	LIMIT 1
;
CREATE_MATERIALIZED_VIEW
```

```
dev=> select * from max_averrage_trip_time;
     puzone     |  dozone  | averrage_trip_time 
----------------+----------+--------------------
 Yorkville East | Steinway | 23:59:33
(1 row)
```


## Question 2

Recreate the MV(s) in question 1, to also find the **number of trips** for the pair of taxi zones with the highest average trip time.

Options:
1. 5
2. 3
3. 10
4. 1

### Answer 2 : **1**

### Solution
```
CREATE MATERIALIZED VIEW count_max_averrage_trip_time AS
  WITH t AS (
        SELECT
			PULocationID,
			DOLocationID,
			MAX(tpep_dropoff_datetime - tpep_pickup_datetime) AS subtract_dropoff_pickup
        FROM trip_data
	GROUP BY PULocationID, DOLocationID
	)
	SELECT count(*)
	FROM t, max_averrage_trip_time
	WHERE subtract_dropoff_pickup = max_averrage_trip_time
;
```
```
CREATE_MATERIALIZED_VIEW
```
```
dev=> select * from count_max_averrage_trip_time;
 count 
-------
     1
(1 row)
```


## Question 3

From the latest pickup time to 17 hours before, what are the top 3 busiest zones in terms of number of pickups?
For example if the latest pickup time is 2020-01-01 12:00:00,
then the query should return the top 3 busiest zones from 2020-01-01 11:00:00 to 2020-01-01 12:00:00.

HINT: You can use [dynamic filter pattern](https://docs.risingwave.com/docs/current/sql-pattern-dynamic-filters/)
to create a filter condition based on the latest pickup time.

NOTE: For this question `17 hours` was picked to ensure we have enough data to work with.

Options:
1. Clinton East, Upper East Side North, Penn Station
2. LaGuardia Airport, Lincoln Square East, JFK Airport
3. Midtown Center, Upper East Side South, Upper East Side North
4. LaGuardia Airport, Midtown Center, Upper East Side North

### Answer 3 : **Midtown Center, Upper East Side South, Upper East Side North**


