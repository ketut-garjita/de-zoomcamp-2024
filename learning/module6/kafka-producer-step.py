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

