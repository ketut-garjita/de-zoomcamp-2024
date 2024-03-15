# Answers : Module 6 Homework

## Start Red Panda

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

Question 1: Redpanda version

```
rpk help
```
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/e6dcfa78-e033-4ec5-a69f-8b3d0e418c48)

```
rpk version
```
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/8c1ca47f-8306-4e69-8bbe-2573682f8b4e)

Answer : 
```
v22.3.5 (rev 28b2443)
```

Question 2. Creating a topic
```
rpk topic create test-topic
```
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/59cd7e81-1d30-4d54-81ca-e21afe5a1d61)

Answer : 
```
TOPIC       STATUS
test-topic  OK
```

Question 3. Connecting to the Kafka server

```
pip install kafka-python
```
```
python3
```
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/69c3c3b8-fbf4-4c1a-b294-27334ad3e43f)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/dab7d288-cfa1-4164-b630-fad730b40f31)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/a017a135-258d-4512-a0f9-23bd7e49af0a)

Answer : 
```
True
```

Question 4. Sending data to the stream

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/74cc9296-def0-49dd-8b20-5b6e4365672a)


```
redpanda@fc5d6c5222a8:/$ rpk topic consume test-topic
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


# Question 5: Sending the Trip Data
## Sending the taxi data

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

```
2.2.0
```

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


