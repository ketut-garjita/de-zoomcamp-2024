##### Table of Contents  

[Redpanda Demo Project Architecture](#Redpanda Demo Project Architecture)
[Session Terminal 2 (Kafka Producer)](#Session Terminal 2 (Kafka Producer))
[Session Terminal 3 (Kafka Consumer](#Session Terminal 3 (Kafka Consumer)
[Check (Review) Output](#Check (Review) Output)



## Redpanda Demo Project Architecture

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/4e738fff-48b2-43ad-bc3a-5daf084c0e5e)


## Session Terminal 1 (Preparations)

- Open Operating System terminal

- Create docker-compose.yml
```
version: '3.7'
services:
  # Redpanda cluster
  redpanda-1:
    image: docker.redpanda.com/vectorized/redpanda:v22.3.5
    container_name: redpanda-1
    command:
      - redpanda
      - start
      - --smp
      - '1'
      - --reserve-memory
      - 0M
      - --overprovisioned
      - --node-id
      - '1'
      - --kafka-addr
      - PLAINTEXT://0.0.0.0:29092,OUTSIDE://0.0.0.0:9092
      - --advertise-kafka-addr
      - PLAINTEXT://redpanda-1:29092,OUTSIDE://localhost:9092
      - --pandaproxy-addr
      - PLAINTEXT://0.0.0.0:28082,OUTSIDE://0.0.0.0:8082
      - --advertise-pandaproxy-addr
      - PLAINTEXT://redpanda-1:28082,OUTSIDE://localhost:8082
      - --rpc-addr
      - 0.0.0.0:33145
      - --advertise-rpc-addr
      - redpanda-1:33145
    ports:
      # - 8081:8081
      - 8082:8082
      - 9092:9092
      - 28082:28082
      - 29092:29092
    volumes:
      - ./producer.properties:/etc/kafka/producer.properties
```

- Goto the directory where is docker-compose.yml created

- Start docker container (redpanda-a)
```
docker compose up -d
```

- Check container, is it up
```
docker ps
```

- Create **download-green-taxi.py** script for downloading the [green_tripdata_2019-10.csv.gz](https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz)
```
!wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz
```

- Run **download-green-taxi.py** script from OS prompt
```
python download-green-taxi.py
```

- Check dataset file
```
ls -al green_tripdata_2019-10.csv.gz
```

- Install kafka (if installed yet)
```
pip install kafka-python
```

- Check kafka installed
```
import kafka
kafka.__version__
exit()
```

- Goto to the container
```
docker exec -it redpanda-1 bash
```

- Inside redpanda container, check rpk comands e.g. help, version, etc...
```
rpk help
rpk version
```

- Create consume topic
```
rpk topic consume green-trips
```

- The screen will show *no activity yet* . Awaiting sending data started (see session terminal 2 below)

  *Don't close session terminal 1 !!*

  
## Session Terminal 2 (Kafka Producer)

- Open Operating System terminal

- Create **kafka-producer-step.py**
```
# connecting-to-kafka-server
import json
import time

from kafka import KafkaProducer

def json_serializer(data):
    return json.dumps(data).encode('utf-8')

server = 'localhost:9092'

producer = KafkaProducer(
    bootstrap_servers=[server],
    value_serializer=json_serializer
)

producer.bootstrap_connected()

# Read dataset and define dataFrame
import pandas as pd
df_green =  pd.read_csv("green_tripdata_2019-10.csv.gz")

columns_to_list = ['lpep_pickup_datetime',
'lpep_dropoff_datetime',
'PULocationID',
'DOLocationID',
'passenger_count',
'trip_distance',
'tip_amount']

df_green = df_green[columns_to_list]

# Sedning essages (data)
for row in df_green.itertuples(index=False):
    row_dict = {col: getattr(row, col) for col in row._fields}
    print(row_dict)
    # break

    # TODO implement sending the data here
    topic_name = 'green-trips'
    for i in range(10):
        message = {'number': i}
        producer.send(topic_name, value=row_dict)
        print(f"Sent: {row}_dict")
        time.sleep(0.05)

    producer.flush()
```

- Run **kafka-producer-step.py** script
```
pyhton kafka-producer-step.py
```

- The screen will show data being transmitted.....
  

## Session Terminal 3 (Kafka Consumer)

- Open Operating System terminal

- Create **kafka-consumer-step.py**
```
# connecting-to-kafka-server
import json
import time

from kafka import KafkaProducer

def json_serializer(data):
    return json.dumps(data).encode('utf-8')

server = 'localhost:9092'

producer = KafkaProducer(
    bootstrap_servers=[server],
    value_serializer=json_serializer
)

producer.bootstrap_connected()


# Creating the PySpark consumer
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

green_stream = spark \
    .readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "localhost:9092") \
    .option("subscribe", "green-trips") \
    .option("startingOffsets", "earliest") \
    .load()

def peek(mini_batch, batch_id):
    first_row = mini_batch.take(1)

    if first_row:
        print(first_row[0])

green_stream.writeStream.foreachBatch(peek).start()


# Parsing the data
from pyspark.sql import types

schema = types.StructType() \
    .add("lpep_pickup_datetime", types.StringType()) \
    .add("lpep_dropoff_datetime", types.StringType()) \
    .add("PULocationID", types.IntegerType()) \
    .add("DOLocationID", types.IntegerType()) \
    .add("passenger_count", types.DoubleType()) \
    .add("trip_distance", types.DoubleType()) \
    .add("tip_amount", types.DoubleType())

from pyspark.sql import functions as F

green_stream = green_stream \
  .select(F.from_json(F.col("value").cast('STRING'), schema).alias("data")) \
  .select("data.*")


# do some streaming analytics.
from pyspark.sql.functions import col
from pyspark.sql.functions import current_timestamp

df_green_stream = green_stream.withColumn("timestamp", current_timestamp())

popular_destinations = df_green_stream \
    .groupBy(F.window(col("timestamp"), "5 minutes"), df_green_stream.DOLocationID) \
    .count() \
    .sort(col("count").desc()) \
    .limit(1) \
    .writeStream \
    .outputMode("complete") \
    .format("console") \
    .option("truncate", "true") \
    .start()

popular_destinations.awaitTermination()
```

- Run **kafka-consumer-step.py**
```
pyhton kafka-consumer-step.py
```

- The screem will show data sent from producer --> broker --> consumer.


## Check (Review) Output

- Check Session Termiinal 1 (Preparation Session - green-trips topic)
- Check Session Termiinal 2 (Producer Session - sending data)
- Check Session Termiinal 3 (Consumer Session - receiving data)
    










