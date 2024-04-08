# Answers : Module 6 Homework

**Start Red Panda**

Using VS Code or server terminal.

```
cd /mnt/d/zde/data-engineering-zoomcamp/cohorts/2024/06-streaming
code .
```

```
linux $ pwd
/mnt/d/zde/data-engineering-zoomcamp/cohorts/2024/06-streaming
linux $ docker compose up -d
[+] Running 1/1
 ⠿ Container redpanda-1  Started                                                                                   7.5s
```
```
docker ps
```
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/f821864c-101f-4957-9e6c-0d2ac02e4e89)


## Question 1: Redpanda version

```
sudo docker exec -it redpanda-1 bash
```

```
rpk help
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/e6dcfa78-e033-4ec5-a69f-8b3d0e418c48)

```
rpk version
```
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/8c1ca47f-8306-4e69-8bbe-2573682f8b4e)

### Answer 1
```
v22.3.5 (rev 28b2443)
```

## Question 2. Creating a topic
```
rpk topic create test-topic
```
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/59cd7e81-1d30-4d54-81ca-e21afe5a1d61)

### Answer 2
```
TOPIC       STATUS
test-topic  OK
```

*Note: don't exit from this creation topic session !!!*


## Question 3. Connecting to the Kafka server

Open another terminal session.

Install kafka-python (if not installed yet)

```
pip install kafka-python
```

Check kafka version

```
python3
```

```
import kafka
kafka.__version__
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/69c3c3b8-fbf4-4c1a-b294-27334ad3e43f)

Start Jupyter Notebook

```
jupyter-notebook --allow-root
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/dab7d288-cfa1-4164-b630-fad730b40f31)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/a017a135-258d-4512-a0f9-23bd7e49af0a)


### Answer 3
```
True
```

## Question 4. Sending data to the stream

How much time did it take? Where did it spend most of the time?

- Sending the messages
- Flushing
- Both took approximately the same amount of time

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/74cc9296-def0-49dd-8b20-5b6e4365672a)

redpanda@fc5d6c5222a8:/$

```
rpk topic consume test-topic
```

```
{
  "topic": "test-topic",
  "value": "{\"number\": 0}",
  "timestamp": 1710340234553,
  "partition": 0,
  "offset": 0
}
{
  "topic": "test-topic",
  "value": "{\"number\": 1}",
  "timestamp": 1710340234604,
  "partition": 0,
  "offset": 1
}
{
  "topic": "test-topic",
  "value": "{\"number\": 2}",
  "timestamp": 1710340234654,
  "partition": 0,
  "offset": 2
}
{
  "topic": "test-topic",
  "value": "{\"number\": 3}",
  "timestamp": 1710340234705,
  "partition": 0,
  "offset": 3
}
{
  "topic": "test-topic",
  "value": "{\"number\": 4}",
  "timestamp": 1710340234756,
  "partition": 0,
  "offset": 4
}
{
  "topic": "test-topic",
  "value": "{\"number\": 5}",
  "timestamp": 1710340234806,
  "partition": 0,
  "offset": 5
}
{
  "topic": "test-topic",
  "value": "{\"number\": 6}",
  "timestamp": 1710340234858,
  "partition": 0,
  "offset": 6
}
{
  "topic": "test-topic",
  "value": "{\"number\": 7}",
  "timestamp": 1710340234909,
  "partition": 0,
  "offset": 7
}
{
  "topic": "test-topic",
  "value": "{\"number\": 8}",
  "timestamp": 1710340234960,
  "partition": 0,
  "offset": 8
}
{
  "topic": "test-topic",
  "value": "{\"number\": 9}",
  "timestamp": 1710340235011,
  "partition": 0,
  "offset": 9
}
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/16d54ee0-4b8d-401b-aaf6-0e3ba87bc5ca)

### Answer 4
```
Spend most of the time : Sending the messages
```


## Question 5: Sending the Trip Data

**Sending the taxi data**

```
import pyspark
from pyspark.sql import SparkSession

pyspark_version = pyspark.__version__
kafka_jar_package = f"org.apache.spark:spark-sql-kafka-0-10_2.12:{pyspark_version}"

spark = SparkSession \
    .builder \
    .master("local[*]") \
    .appName("GreenTripsConsumer") \
    .config("spark.jars.packages", kafka_jar_package) \
    .getOrCreate()
```
```
4/03/15 08:04:12 WARN Utils: Your hostname, Desktop-Gar resolves to a loopback address: 127.0.1.1; using 172.25.243.204 instead (on interface eth0)
24/03/15 08:04:12 WARN Utils: Set SPARK_LOCAL_IP if you need to bind to another address
:: loading settings :: url = jar:file:/mnt/d/apache/spark-3.4.2-bin-hadoop3/jars/ivy-2.5.1.jar!/org/apache/ivy/core/settings/ivysettings.xml
Ivy Default Cache set to: /root/.ivy2/cache
The jars for the packages stored in: /root/.ivy2/jars
org.apache.spark#spark-sql-kafka-0-10_2.12 added as a dependency
:: resolving dependencies :: org.apache.spark#spark-submit-parent-e03c4a9b-b0e9-4437-9eea-95e93d87b420;1.0
	confs: [default]
	found org.apache.spark#spark-sql-kafka-0-10_2.12;3.4.2 in central
	found org.apache.spark#spark-token-provider-kafka-0-10_2.12;3.4.2 in central
	found org.apache.kafka#kafka-clients;3.3.2 in central
	found org.lz4#lz4-java;1.8.0 in central
	found org.xerial.snappy#snappy-java;1.1.10.3 in central
	found org.slf4j#slf4j-api;2.0.6 in central
	found org.apache.hadoop#hadoop-client-runtime;3.3.4 in central
	found org.apache.hadoop#hadoop-client-api;3.3.4 in central
	found commons-logging#commons-logging;1.1.3 in central
	found com.google.code.findbugs#jsr305;3.0.0 in central
	found org.apache.commons#commons-pool2;2.11.1 in central
:: resolution report :: resolve 1515ms :: artifacts dl 24ms
	:: modules in use:
	com.google.code.findbugs#jsr305;3.0.0 from central in [default]
	commons-logging#commons-logging;1.1.3 from central in [default]
	org.apache.commons#commons-pool2;2.11.1 from central in [default]
	org.apache.hadoop#hadoop-client-api;3.3.4 from central in [default]
	org.apache.hadoop#hadoop-client-runtime;3.3.4 from central in [default]
	org.apache.kafka#kafka-clients;3.3.2 from central in [default]
	org.apache.spark#spark-sql-kafka-0-10_2.12;3.4.2 from central in [default]
	org.apache.spark#spark-token-provider-kafka-0-10_2.12;3.4.2 from central in [default]
	org.lz4#lz4-java;1.8.0 from central in [default]
	org.slf4j#slf4j-api;2.0.6 from central in [default]
	org.xerial.snappy#snappy-java;1.1.10.3 from central in [default]
	---------------------------------------------------------------------
	|                  |            modules            ||   artifacts   |
	|       conf       | number| search|dwnlded|evicted|| number|dwnlded|
	---------------------------------------------------------------------
	|      default     |   11  |   0   |   0   |   0   ||   11  |   0   |
	---------------------------------------------------------------------
:: retrieving :: org.apache.spark#spark-submit-parent-e03c4a9b-b0e9-4437-9eea-95e93d87b420
	confs: [default]
	0 artifacts copied, 11 already retrieved (0kB/20ms)
24/03/15 08:04:17 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
Setting default log level to "WARN".
To adjust logging level use sc.setLogLevel(newLevel). For SparkR, use setLogLevel(newLevel).
```

```
df = spark.read \
    .option("header", "true") \
    .csv('data/green_tripdata_2019-10.csv.gz')
```

```
df.printSchema()
```

```
root
 |-- VendorID: string (nullable = true)
 |-- lpep_pickup_datetime: string (nullable = true)
 |-- lpep_dropoff_datetime: string (nullable = true)
 |-- store_and_fwd_flag: string (nullable = true)
 |-- RatecodeID: string (nullable = true)
 |-- PULocationID: string (nullable = true)
 |-- DOLocationID: string (nullable = true)
 |-- passenger_count: string (nullable = true)
 |-- trip_distance: string (nullable = true)
 |-- fare_amount: string (nullable = true)
 |-- extra: string (nullable = true)
 |-- mta_tax: string (nullable = true)
 |-- tip_amount: string (nullable = true)
 |-- tolls_amount: string (nullable = true)
 |-- ehail_fee: string (nullable = true)
 |-- improvement_surcharge: string (nullable = true)
 |-- total_amount: string (nullable = true)
 |-- payment_type: string (nullable = true)
 |-- trip_type: string (nullable = true)
 |-- congestion_surcharge: string (nullable = true)
```

```
df = df[['lpep_pickup_datetime',
'lpep_dropoff_datetime',
'PULocationID',
'DOLocationID',
'passenger_count',
'trip_distance',
'tip_amount']]

df.printSchema()
```

```
root
 |-- lpep_pickup_datetime: string (nullable = true)
 |-- lpep_dropoff_datetime: string (nullable = true)
 |-- PULocationID: string (nullable = true)
 |-- DOLocationID: string (nullable = true)
 |-- passenger_count: string (nullable = true)
 |-- trip_distance: string (nullable = true)
 |-- tip_amount: string (nullable = true)
```

```
import pandas as pd
print(pd.__version__)
```

2.2.0

```
df_green = df.toPandas()
```

```
t0 = time.time()

topic_name = 'green-trips'

for row in df_green.itertuples(index=False):
    row_dict = {col: getattr(row, col) for col in row._fields}
    print(row_dict)

t01 = time.time()
print('\n')
print(f'Sending data took {(t01 - t0):.2f} seconds')

producer.flush()

t1 = time.time()
print(f'Flusing took {(t1 - t01):.2f} seconds')
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/a908127b-601a-4430-96bf-2df5dd251a69)

```
{'lpep_pickup_datetime': '2019-10-01 00:26:02', 'lpep_dropoff_datetime': '2019-10-01 00:39:58', 'PULocationID': '112', 'DOLocationID': '196', 'passenger_count': '1', 'trip_distance': '5.88', 'tip_amount': '0'}
{'lpep_pickup_datetime': '2019-10-01 00:18:11', 'lpep_dropoff_datetime': '2019-10-01 00:22:38', 'PULocationID': '43', 'DOLocationID': '263', 'passenger_count': '1', 'trip_distance': '.80', 'tip_amount': '0'}
.......
.......
{'lpep_pickup_datetime': '2019-10-23 22:41:48', 'lpep_dropoff_datetime': '2019-10-23 22:45:12', 'PULocationID': '97', 'DOLocationID': '49', 'passenger_count': '1', 'trip_distance': '.65', 'tip_amount': '0'}
{'lpep_pickup_datetime': '2019-10-23 22:00:07', 'lpep_dropoff_datetime': '2019-10-23 22:06:24', 'PULocationID': '82', 'DOLocationID': '83', 'passenger_count': '1', 'trip_distance': '.90', 'tip_amount': '0'}
{'lpep_pickup_datetime': '2019-10-23 22:37:45', 'lpep_dropoff_datetime': '2019-10-23 22:44:53', 'PULocationID': '129', 'DOLocationID': '260', 'passenger_count': '1', 'trip_distance': '1.00', 'tip_amount': '0'}
{'lpep_pickup_datetime': '2019-10-23 22:19:02', 'lpep_dropoff_datetime': '2019-10-23 22:43:36', 'PULocationID': '41', 'DOLocationID': '48', 'passenger_count': '1', 'trip_distance': '4.39', 'tip_amount': '4.61'}
{'lpep_pickup_datetime': '2019-10-23 22:21:12', 'lpep_dropoff_datetime': '2019-10-23 22:27:26', 'PULocationID': '260', 'DOLocationID': '260', 'passenger_count': '6', 'trip_distance': '.74', 'tip_amount': '0'}
{'lpep_pickup_datetime': '2019-10-23 22:51:11', 'lpep_dropoff_datetime': '2019-10-23 23:01:28', 'PULocationID': '260', 'DOLocationID': '160', 'passenger_count': '6', 'trip_distance': '2.38', 'tip_amount': '2.26'}
{'lpep_pickup_datetime': '2019-10-23 22:32:21', 'lpep_dropoff_datetime': '2019-10-23 22:42:13', 'PULocationID': '92', 'DOLocationID': '53', 'passenger_count': '1', 'trip_distance': '2.69', 'tip_amount': '0'}
{'lpep_pickup_datetime': '2019-10-23 22:27:41', 'lpep_dropoff_datetime': '2019-10-23 22:38:52', 'PULocationID': '74', 'DOLocationID': '239', 'passenger_count': '1', 'trip_distance': '2.77', 'tip_amount': '0'}
{'lpep_pickup_datetime': '2019-10-23 22:22:10', 'lpep_dropoff_datetime': '2019-10-23 22:39:22', 'PULocationID': '97', 'DOLocationID': '61', 'passenger_count': '1', 'trip_distance': '2.39', 'tip_amount': '2.86'}
{'lpep_pickup_datetime': '2019-10-23 22:42:33', 'lpep_dropoff_datetime': '2019-10-23 22:50:48', 'PULocationID': '179', 'DOLocationID': '193', 'passenger_count': '1', 'trip_distance': '2.02', 'tip_amount': '0'}

```

### Answer 5 : 7.32 seconds

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/563142f3-ac24-4d0e-b7d7-83486c9945f0)


## Question 6. Parsing the data

### Answer 6

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/8ce9ab71-02d7-440c-a242-07e10bcdeab0)

```
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:26:02", "lpep_dropoff_datetime": "2019-10-01 00:39:58", "PULocationID": 112, "DOLocationID": 196, "passenger_count": 1.0, "trip_distance": 5.88, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=0, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 35, 270000), timestampType=0)Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:26:02", "lpep_dropoff_datetime": "2019-10-01 00:39:58", "PULocationID": 112, "DOLocationID": 196, "passenger_count": 1.0, "trip_distance": 5.88, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=0, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 35, 270000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:26:02', lpep_dropoff_datetime='2019-10-01 00:39:58', PULocationID=112, DOLocationID=196, passenger_count=1.0, trip_distance=5.88, tip_amount=0.0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:26:02", "lpep_dropoff_datetime": "2019-10-01 00:39:58", "PULocationID": 112, "DOLocationID": 196, "passenger_count": 1.0, "trip_distance": 5.88, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=1, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 35, 322000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:26:02", "lpep_dropoff_datetime": "2019-10-01 00:39:58", "PULocationID": 112, "DOLocationID": 196, "passenger_count": 1.0, "trip_distance": 5.88, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=1, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 35, 322000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:26:02', lpep_dropoff_datetime='2019-10-01 00:39:58', PULocationID=112, DOLocationID=196, passenger_count=1.0, trip_distance=5.88, tip_amount=0.0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:08:13", "lpep_dropoff_datetime": "2019-10-01 00:17:56", "PULocationID": 97, "DOLocationID": 188, "passenger_count": 1.0, "trip_distance": 2.52, "tip_amount": 2.26}'), topic='green-trips', partition=0, offset=45, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 37, 582000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:08:13", "lpep_dropoff_datetime": "2019-10-01 00:17:56", "PULocationID": 97, "DOLocationID": 188, "passenger_count": 1.0, "trip_distance": 2.52, "tip_amount": 2.26}'), topic='green-trips', partition=0, offset=44, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 37, 531000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:08:13', lpep_dropoff_datetime='2019-10-01 00:17:56', PULocationID=97, DOLocationID=188, passenger_count=1.0, trip_distance=2.52, tip_amount=2.26)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:35:01", "lpep_dropoff_datetime": "2019-10-01 00:43:40", "PULocationID": 65, "DOLocationID": 49, "passenger_count": 1.0, "trip_distance": 1.47, "tip_amount": 1.86}'), topic='green-trips', partition=0, offset=55, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 38, 103000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:35:01", "lpep_dropoff_datetime": "2019-10-01 00:43:40", "PULocationID": 65, "DOLocationID": 49, "passenger_count": 1.0, "trip_distance": 1.47, "tip_amount": 1.86}'), topic='green-trips', partition=0, offset=56, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 38, 155000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:35:01', lpep_dropoff_datetime='2019-10-01 00:43:40', PULocationID=65, DOLocationID=49, passenger_count=1.0, trip_distance=1.47, tip_amount=1.86)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:28:09", "lpep_dropoff_datetime": "2019-10-01 00:30:49", "PULocationID": 7, "DOLocationID": 179, "passenger_count": 1.0, "trip_distance": 0.6, "tip_amount": 1.0}'), topic='green-trips', partition=0, offset=66, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 38, 672000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:28:09", "lpep_dropoff_datetime": "2019-10-01 00:30:49", "PULocationID": 7, "DOLocationID": 179, "passenger_count": 1.0, "trip_distance": 0.6, "tip_amount": 1.0}'), topic='green-trips', partition=0, offset=66, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 38, 672000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:28:26', lpep_dropoff_datetime='2019-10-01 00:32:01', PULocationID=41, DOLocationID=74, passenger_count=1.0, trip_distance=0.56, tip_amount=0.0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:28:26", "lpep_dropoff_datetime": "2019-10-01 00:32:01", "PULocationID": 41, "DOLocationID": 74, "passenger_count": 1.0, "trip_distance": 0.56, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=75, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 39, 136000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:28:26", "lpep_dropoff_datetime": "2019-10-01 00:32:01", "PULocationID": 41, "DOLocationID": 74, "passenger_count": 1.0, "trip_distance": 0.56, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=76, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 39, 187000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:14:01', lpep_dropoff_datetime='2019-10-01 00:26:16', PULocationID=255, DOLocationID=49, passenger_count=1.0, trip_distance=2.42, tip_amount=0.0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:14:01", "lpep_dropoff_datetime": "2019-10-01 00:26:16", "PULocationID": 255, "DOLocationID": 49, "passenger_count": 1.0, "trip_distance": 2.42, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=84, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 39, 598000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:14:01", "lpep_dropoff_datetime": "2019-10-01 00:26:16", "PULocationID": 255, "DOLocationID": 49, "passenger_count": 1.0, "trip_distance": 2.42, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=85, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 39, 650000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:03:03', lpep_dropoff_datetime='2019-10-01 00:17:13', PULocationID=130, DOLocationID=131, passenger_count=1.0, trip_distance=3.4, tip_amount=2.85)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:03:03", "lpep_dropoff_datetime": "2019-10-01 00:17:13", "PULocationID": 130, "DOLocationID": 131, "passenger_count": 1.0, "trip_distance": 3.4, "tip_amount": 2.85}'), topic='green-trips', partition=0, offset=93, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 40, 62000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:03:03", "lpep_dropoff_datetime": "2019-10-01 00:17:13", "PULocationID": 130, "DOLocationID": 131, "passenger_count": 1.0, "trip_distance": 3.4, "tip_amount": 2.85}'), topic='green-trips', partition=0, offset=95, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 40, 164000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:07:10", "lpep_dropoff_datetime": "2019-10-01 00:23:38", "PULocationID": 24, "DOLocationID": 74, "passenger_count": 3.0, "trip_distance": 3.18, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=102, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 40, 526000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:07:10', lpep_dropoff_datetime='2019-10-01 00:23:38', PULocationID=24, DOLocationID=74, passenger_count=3.0, trip_distance=3.18, tip_amount=0.0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:07:10", "lpep_dropoff_datetime": "2019-10-01 00:23:38", "PULocationID": 24, "DOLocationID": 74, "passenger_count": 3.0, "trip_distance": 3.18, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=104, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 40, 628000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:25:48", "lpep_dropoff_datetime": "2019-10-01 00:49:52", "PULocationID": 255, "DOLocationID": 188, "passenger_count": 1.0, "trip_distance": 4.7, "tip_amount": 1.0}'), topic='green-trips', partition=0, offset=111, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 40, 988000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:25:48', lpep_dropoff_datetime='2019-10-01 00:49:52', PULocationID=255, DOLocationID=188, passenger_count=1.0, trip_distance=4.7, tip_amount=1.0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:25:48", "lpep_dropoff_datetime": "2019-10-01 00:49:52", "PULocationID": 255, "DOLocationID": 188, "passenger_count": 1.0, "trip_distance": 4.7, "tip_amount": 1.0}'), topic='green-trips', partition=0, offset=113, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 41, 89000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:25:48", "lpep_dropoff_datetime": "2019-10-01 00:49:52", "PULocationID": 255, "DOLocationID": 188, "passenger_count": 1.0, "trip_distance": 4.7, "tip_amount": 1.0}'), topic='green-trips', partition=0, offset=119, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 41, 398000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:03:12', lpep_dropoff_datetime='2019-10-01 00:14:43', PULocationID=129, DOLocationID=160, passenger_count=1.0, trip_distance=3.1, tip_amount=0.0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:03:12", "lpep_dropoff_datetime": "2019-10-01 00:14:43", "PULocationID": 129, "DOLocationID": 160, "passenger_count": 1.0, "trip_distance": 3.1, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=124, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 41, 657000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:03:12", "lpep_dropoff_datetime": "2019-10-01 00:14:43", "PULocationID": 129, "DOLocationID": 160, "passenger_count": 1.0, "trip_distance": 3.1, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=128, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 41, 865000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:44:56', lpep_dropoff_datetime='2019-10-01 00:51:06', PULocationID=18, DOLocationID=169, passenger_count=1.0, trip_distance=1.19, tip_amount=0.25)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:44:56", "lpep_dropoff_datetime": "2019-10-01 00:51:06", "PULocationID": 18, "DOLocationID": 169, "passenger_count": 1.0, "trip_distance": 1.19, "tip_amount": 0.25}'), topic='green-trips', partition=0, offset=136, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 42, 279000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:44:56", "lpep_dropoff_datetime": "2019-10-01 00:51:06", "PULocationID": 18, "DOLocationID": 169, "passenger_count": 1.0, "trip_distance": 1.19, "tip_amount": 0.25}'), topic='green-trips', partition=0, offset=139, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 42, 432000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:55:14', lpep_dropoff_datetime='2019-10-01 01:00:49', PULocationID=223, DOLocationID=7, passenger_count=1.0, trip_distance=1.09, tip_amount=1.46)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:55:14", "lpep_dropoff_datetime": "2019-10-01 01:00:49", "PULocationID": 223, "DOLocationID": 7, "passenger_count": 1.0, "trip_distance": 1.09, "tip_amount": 1.46}'), topic='green-trips', partition=0, offset=146, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 42, 793000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:55:14", "lpep_dropoff_datetime": "2019-10-01 01:00:49", "PULocationID": 223, "DOLocationID": 7, "passenger_count": 1.0, "trip_distance": 1.09, "tip_amount": 1.46}'), topic='green-trips', partition=0, offset=148, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 42, 895000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:55:14', lpep_dropoff_datetime='2019-10-01 01:00:49', PULocationID=223, DOLocationID=7, passenger_count=1.0, trip_distance=1.09, tip_amount=1.46)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:06:06", "lpep_dropoff_datetime": "2019-10-01 00:11:05", "PULocationID": 75, "DOLocationID": 262, "passenger_count": 1.0, "trip_distance": 1.24, "tip_amount": 2.01}'), topic='green-trips', partition=0, offset=154, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 43, 206000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:06:06", "lpep_dropoff_datetime": "2019-10-01 00:11:05", "PULocationID": 75, "DOLocationID": 262, "passenger_count": 1.0, "trip_distance": 1.24, "tip_amount": 2.01}'), topic='green-trips', partition=0, offset=157, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 43, 361000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:06:06', lpep_dropoff_datetime='2019-10-01 00:11:05', PULocationID=75, DOLocationID=262, passenger_count=1.0, trip_distance=1.24, tip_amount=2.01)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:00:19", "lpep_dropoff_datetime": "2019-10-01 00:14:32", "PULocationID": 97, "DOLocationID": 228, "passenger_count": 1.0, "trip_distance": 3.03, "tip_amount": 3.58}'), topic='green-trips', partition=0, offset=163, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 43, 672000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:00:19", "lpep_dropoff_datetime": "2019-10-01 00:14:32", "PULocationID": 97, "DOLocationID": 228, "passenger_count": 1.0, "trip_distance": 3.03, "tip_amount": 3.58}'), topic='green-trips', partition=0, offset=165, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 43, 776000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:00:19', lpep_dropoff_datetime='2019-10-01 00:14:32', PULocationID=97, DOLocationID=228, passenger_count=1.0, trip_distance=3.03, tip_amount=3.58)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:09:31", "lpep_dropoff_datetime": "2019-10-01 00:20:41", "PULocationID": 41, "DOLocationID": 74, "passenger_count": 1.0, "trip_distance": 2.03, "tip_amount": 2.16}'), topic='green-trips', partition=0, offset=171, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 44, 85000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:09:31", "lpep_dropoff_datetime": "2019-10-01 00:20:41", "PULocationID": 41, "DOLocationID": 74, "passenger_count": 1.0, "trip_distance": 2.03, "tip_amount": 2.16}'), topic='green-trips', partition=0, offset=174, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 44, 238000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:09:31', lpep_dropoff_datetime='2019-10-01 00:20:41', PULocationID=41, DOLocationID=74, passenger_count=1.0, trip_distance=2.03, tip_amount=2.16)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:09:31", "lpep_dropoff_datetime": "2019-10-01 00:20:41", "PULocationID": 41, "DOLocationID": 74, "passenger_count": 1.0, "trip_distance": 2.03, "tip_amount": 2.16}'), topic='green-trips', partition=0, offset=179, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 44, 495000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:30:36", "lpep_dropoff_datetime": "2019-10-01 00:34:30", "PULocationID": 41, "DOLocationID": 42, "passenger_count": 1.0, "trip_distance": 0.73, "tip_amount": 1.26}'), topic='green-trips', partition=0, offset=183, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 44, 701000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:30:36', lpep_dropoff_datetime='2019-10-01 00:34:30', PULocationID=41, DOLocationID=42, passenger_count=1.0, trip_distance=0.73, tip_amount=1.26)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:30:36", "lpep_dropoff_datetime": "2019-10-01 00:34:30", "PULocationID": 41, "DOLocationID": 42, "passenger_count": 1.0, "trip_distance": 0.73, "tip_amount": 1.26}'), topic='green-trips', partition=0, offset=185, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 44, 805000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:58:32", "lpep_dropoff_datetime": "2019-10-01 01:05:08", "PULocationID": 41, "DOLocationID": 116, "passenger_count": 1.0, "trip_distance": 1.48, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=194, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 45, 267000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:58:32', lpep_dropoff_datetime='2019-10-01 01:05:08', PULocationID=41, DOLocationID=116, passenger_count=1.0, trip_distance=1.48, tip_amount=0.0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:58:32", "lpep_dropoff_datetime": "2019-10-01 01:05:08", "PULocationID": 41, "DOLocationID": 116, "passenger_count": 1.0, "trip_distance": 1.48, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=192, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 45, 164000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:11:58", "lpep_dropoff_datetime": "2019-10-01 00:16:21", "PULocationID": 134, "DOLocationID": 134, "passenger_count": 2.0, "trip_distance": 0.89, "tip_amount": 1.36}'), topic='green-trips', partition=0, offset=203, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 45, 728000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:11:58', lpep_dropoff_datetime='2019-10-01 00:16:21', PULocationID=134, DOLocationID=134, passenger_count=2.0, trip_distance=0.89, tip_amount=1.36)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:11:58", "lpep_dropoff_datetime": "2019-10-01 00:16:21", "PULocationID": 134, "DOLocationID": 134, "passenger_count": 2.0, "trip_distance": 0.89, "tip_amount": 1.36}'), topic='green-trips', partition=0, offset=203, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 45, 728000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:42:27", "lpep_dropoff_datetime": "2019-10-01 01:04:30", "PULocationID": 260, "DOLocationID": 92, "passenger_count": 1.0, "trip_distance": 4.21, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=210, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 46, 89000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:42:27', lpep_dropoff_datetime='2019-10-01 01:04:30', PULocationID=260, DOLocationID=92, passenger_count=1.0, trip_distance=4.21, tip_amount=0.0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:42:27", "lpep_dropoff_datetime": "2019-10-01 01:04:30", "PULocationID": 260, "DOLocationID": 92, "passenger_count": 1.0, "trip_distance": 4.21, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=210, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 46, 89000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:42:27', lpep_dropoff_datetime='2019-10-01 01:04:30', PULocationID=260, DOLocationID=92, passenger_count=1.0, trip_distance=4.21, tip_amount=0.0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:42:27", "lpep_dropoff_datetime": "2019-10-01 01:04:30", "PULocationID": 260, "DOLocationID": 92, "passenger_count": 1.0, "trip_distance": 4.21, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=217, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 46, 448000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:42:27", "lpep_dropoff_datetime": "2019-10-01 01:04:30", "PULocationID": 260, "DOLocationID": 92, "passenger_count": 1.0, "trip_distance": 4.21, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=218, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 46, 499000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:03:38", "lpep_dropoff_datetime": "2019-10-01 00:12:43", "PULocationID": 83, "DOLocationID": 56, "passenger_count": 1.0, "trip_distance": 1.64, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=224, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 46, 807000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:03:38', lpep_dropoff_datetime='2019-10-01 00:12:43', PULocationID=83, DOLocationID=56, passenger_count=1.0, trip_distance=1.64, tip_amount=0.0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:03:38", "lpep_dropoff_datetime": "2019-10-01 00:12:43", "PULocationID": 83, "DOLocationID": 56, "passenger_count": 1.0, "trip_distance": 1.64, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=225, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 46, 858000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:12:30", "lpep_dropoff_datetime": "2019-10-01 00:27:16", "PULocationID": 181, "DOLocationID": 89, "passenger_count": 1.0, "trip_distance": 3.6, "tip_amount": 0.74}'), topic='green-trips', partition=0, offset=232, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 47, 217000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:12:30', lpep_dropoff_datetime='2019-10-01 00:27:16', PULocationID=181, DOLocationID=89, passenger_count=1.0, trip_distance=3.6, tip_amount=0.74)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:12:30", "lpep_dropoff_datetime": "2019-10-01 00:27:16", "PULocationID": 181, "DOLocationID": 89, "passenger_count": 1.0, "trip_distance": 3.6, "tip_amount": 0.74}'), topic='green-trips', partition=0, offset=232, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 47, 217000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:12:30", "lpep_dropoff_datetime": "2019-10-01 00:27:16", "PULocationID": 181, "DOLocationID": 89, "passenger_count": 1.0, "trip_distance": 3.6, "tip_amount": 0.74}'), topic='green-trips', partition=0, offset=239, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 47, 574000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:12:30', lpep_dropoff_datetime='2019-10-01 00:27:16', PULocationID=181, DOLocationID=89, passenger_count=1.0, trip_distance=3.6, tip_amount=0.74)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:44:27", "lpep_dropoff_datetime": "2019-10-01 00:54:27", "PULocationID": 181, "DOLocationID": 188, "passenger_count": 1.0, "trip_distance": 2.44, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=240, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 47, 626000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:44:27", "lpep_dropoff_datetime": "2019-10-01 00:54:27", "PULocationID": 181, "DOLocationID": 188, "passenger_count": 1.0, "trip_distance": 2.44, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=246, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 47, 935000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:44:27', lpep_dropoff_datetime='2019-10-01 00:54:27', PULocationID=181, DOLocationID=188, passenger_count=1.0, trip_distance=2.44, tip_amount=0.0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:44:27", "lpep_dropoff_datetime": "2019-10-01 00:54:27", "PULocationID": 181, "DOLocationID": 188, "passenger_count": 1.0, "trip_distance": 2.44, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=249, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 48, 89000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:04:40", "lpep_dropoff_datetime": "2019-10-01 00:10:02", "PULocationID": 226, "DOLocationID": 226, "passenger_count": 1.0, "trip_distance": 1.58, "tip_amount": 1.56}'), topic='green-trips', partition=0, offset=255, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 48, 396000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:04:40', lpep_dropoff_datetime='2019-10-01 00:10:02', PULocationID=226, DOLocationID=226, passenger_count=1.0, trip_distance=1.58, tip_amount=1.56)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:04:40", "lpep_dropoff_datetime": "2019-10-01 00:10:02", "PULocationID": 226, "DOLocationID": 226, "passenger_count": 1.0, "trip_distance": 1.58, "tip_amount": 1.56}'), topic='green-trips', partition=0, offset=256, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 48, 448000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:22:41", "lpep_dropoff_datetime": "2019-10-01 00:31:53", "PULocationID": 33, "DOLocationID": 80, "passenger_count": 1.0, "trip_distance": 4.46, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=263, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 48, 809000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:22:41', lpep_dropoff_datetime='2019-10-01 00:31:53', PULocationID=33, DOLocationID=80, passenger_count=1.0, trip_distance=4.46, tip_amount=0.0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:22:41", "lpep_dropoff_datetime": "2019-10-01 00:31:53", "PULocationID": 33, "DOLocationID": 80, "passenger_count": 1.0, "trip_distance": 4.46, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=264, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 48, 860000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:38:00", "lpep_dropoff_datetime": "2019-10-01 00:45:50", "PULocationID": 256, "DOLocationID": 37, "passenger_count": 1.0, "trip_distance": 1.81, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=270, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 49, 167000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:38:00', lpep_dropoff_datetime='2019-10-01 00:45:50', PULocationID=256, DOLocationID=37, passenger_count=1.0, trip_distance=1.81, tip_amount=0.0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:38:00", "lpep_dropoff_datetime": "2019-10-01 00:45:50", "PULocationID": 256, "DOLocationID": 37, "passenger_count": 1.0, "trip_distance": 1.81, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=272, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 49, 270000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:38:00", "lpep_dropoff_datetime": "2019-10-01 00:45:50", "PULocationID": 256, "DOLocationID": 37, "passenger_count": 1.0, "trip_distance": 1.81, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=278, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 49, 577000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:38:00', lpep_dropoff_datetime='2019-10-01 00:45:50', PULocationID=256, DOLocationID=37, passenger_count=1.0, trip_distance=1.81, tip_amount=0.0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:38:00", "lpep_dropoff_datetime": "2019-10-01 00:45:50", "PULocationID": 256, "DOLocationID": 37, "passenger_count": 1.0, "trip_distance": 1.81, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=279, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 49, 629000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:54:35", "lpep_dropoff_datetime": "2019-10-01 01:01:39", "PULocationID": 80, "DOLocationID": 148, "passenger_count": 1.0, "trip_distance": 2.33, "tip_amount": 1.96}'), topic='green-trips', partition=0, offset=284, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 49, 887000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:54:35', lpep_dropoff_datetime='2019-10-01 01:01:39', PULocationID=80, DOLocationID=148, passenger_count=1.0, trip_distance=2.33, tip_amount=1.96)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:54:35", "lpep_dropoff_datetime": "2019-10-01 01:01:39", "PULocationID": 80, "DOLocationID": 148, "passenger_count": 1.0, "trip_distance": 2.33, "tip_amount": 1.96}'), topic='green-trips', partition=0, offset=287, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 50, 43000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:55:48", "lpep_dropoff_datetime": "2019-10-01 01:00:45", "PULocationID": 223, "DOLocationID": 7, "passenger_count": 5.0, "trip_distance": 0.82, "tip_amount": 1.36}'), topic='green-trips', partition=0, offset=292, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 50, 299000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:55:48', lpep_dropoff_datetime='2019-10-01 01:00:45', PULocationID=223, DOLocationID=7, passenger_count=5.0, trip_distance=0.82, tip_amount=1.36)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:55:48", "lpep_dropoff_datetime": "2019-10-01 01:00:45", "PULocationID": 223, "DOLocationID": 7, "passenger_count": 5.0, "trip_distance": 0.82, "tip_amount": 1.36}'), topic='green-trips', partition=0, offset=295, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 50, 452000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:52:36", "lpep_dropoff_datetime": "2019-10-01 00:52:42", "PULocationID": 92, "DOLocationID": 92, "passenger_count": 1.0, "trip_distance": 0.0, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=300, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 50, 709000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:52:36', lpep_dropoff_datetime='2019-10-01 00:52:42', PULocationID=92, DOLocationID=92, passenger_count=1.0, trip_distance=0.0, tip_amount=0.0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:52:36", "lpep_dropoff_datetime": "2019-10-01 00:52:42", "PULocationID": 92, "DOLocationID": 92, "passenger_count": 1.0, "trip_distance": 0.0, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=302, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 50, 812000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:52:36", "lpep_dropoff_datetime": "2019-10-01 00:52:42", "PULocationID": 92, "DOLocationID": 92, "passenger_count": 1.0, "trip_distance": 0.0, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=307, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 51, 67000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:52:36', lpep_dropoff_datetime='2019-10-01 00:52:42', PULocationID=92, DOLocationID=92, passenger_count=1.0, trip_distance=0.0, tip_amount=0.0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:20:56", "lpep_dropoff_datetime": "2019-10-01 00:27:52", "PULocationID": 129, "DOLocationID": 83, "passenger_count": 1.0, "trip_distance": 1.49, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=311, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 51, 273000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:20:56", "lpep_dropoff_datetime": "2019-10-01 00:27:52", "PULocationID": 129, "DOLocationID": 83, "passenger_count": 1.0, "trip_distance": 1.49, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=315, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 51, 479000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:20:56', lpep_dropoff_datetime='2019-10-01 00:27:52', PULocationID=129, DOLocationID=83, passenger_count=1.0, trip_distance=1.49, tip_amount=0.0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:20:56", "lpep_dropoff_datetime": "2019-10-01 00:27:52", "PULocationID": 129, "DOLocationID": 83, "passenger_count": 1.0, "trip_distance": 1.49, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=318, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 51, 633000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:37:54", "lpep_dropoff_datetime": "2019-10-01 00:50:51", "PULocationID": 130, "DOLocationID": 205, "passenger_count": 1.0, "trip_distance": 3.6, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=323, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 51, 891000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:37:54', lpep_dropoff_datetime='2019-10-01 00:50:51', PULocationID=130, DOLocationID=205, passenger_count=1.0, trip_distance=3.6, tip_amount=0.0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:37:54", "lpep_dropoff_datetime": "2019-10-01 00:50:51", "PULocationID": 130, "DOLocationID": 205, "passenger_count": 1.0, "trip_distance": 3.6, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=326, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 52, 45000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:42:34", "lpep_dropoff_datetime": "2019-10-01 00:45:23", "PULocationID": 179, "DOLocationID": 223, "passenger_count": 1.0, "trip_distance": 0.53, "tip_amount": 1.06}'), topic='green-trips', partition=0, offset=331, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 52, 301000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:42:34", "lpep_dropoff_datetime": "2019-10-01 00:45:23", "PULocationID": 179, "DOLocationID": 223, "passenger_count": 1.0, "trip_distance": 0.53, "tip_amount": 1.06}'), topic='green-trips', partition=0, offset=333, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 52, 402000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:42:34', lpep_dropoff_datetime='2019-10-01 00:45:23', PULocationID=179, DOLocationID=223, passenger_count=1.0, trip_distance=0.53, tip_amount=1.06)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:42:34", "lpep_dropoff_datetime": "2019-10-01 00:45:23", "PULocationID": 179, "DOLocationID": 223, "passenger_count": 1.0, "trip_distance": 0.53, "tip_amount": 1.06}'), topic='green-trips', partition=0, offset=338, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 52, 657000), timestampType=0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:57:00", "lpep_dropoff_datetime": "2019-10-01 00:59:27", "PULocationID": 7, "DOLocationID": 7, "passenger_count": 1.0, "trip_distance": 0.53, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=341, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 52, 812000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:57:00', lpep_dropoff_datetime='2019-10-01 00:59:27', PULocationID=7, DOLocationID=7, passenger_count=1.0, trip_distance=0.53, tip_amount=0.0)
Row(key=None, value=bytearray(b'{"lpep_pickup_datetime": "2019-10-01 00:57:00", "lpep_dropoff_datetime": "2019-10-01 00:59:27", "PULocationID": 7, "DOLocationID": 7, "passenger_count": 1.0, "trip_distance": 0.53, "tip_amount": 0.0}'), topic='green-trips', partition=0, offset=346, timestamp=datetime.datetime(2024, 4, 8, 11, 53, 53, 71000), timestampType=0)
Row(lpep_pickup_datetime='2019-10-01 00:57:00', lpep_dropoff_datetime='2019-10-01 00:59:27', PULocationID=7, DOLocationID=7, passenger_count=1.0, trip_distance=0.53, tip_amount=0.0)
```


## Question 7: Most popular destination

### Answer 7

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/17439ea3-0278-41d9-9552-0e542f6131a4)
