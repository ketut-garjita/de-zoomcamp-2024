Source : <br>
https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/cohorts/2024/workshops/dlt_resources/data_ingestion_workshop.md

Here’s how you would do that on your local machine. I will walk you through before showing you in colab as well.

First, install dlt in new OS environment

Command prompt
```
cd /mnt/e/dlt
python -m venv ./env
source ./env/bin/activate
pip install dlt[duckdb]

```

```
source ./env/bin/activate

# for first, time install pandas, streamlist
pip install pandas
pip install streamlit
```

Create python script : people_append.py
```
cd /mnt/e/dlt/scripts
vi people_append.py
Edit people_append.py as below :
```

```
data = [
    {
        "vendor_name": "VTS",
		"record_hash": "b00361a396177a9cb410ff61f20015ad",
        "time": {
            "pickup": "2009-06-14 23:23:00",
            "dropoff": "2009-06-14 23:48:00"
        },
        "Trip_Distance": 17.52,
        "coordinates": {
            "start": {
                "lon": -73.787442,
                "lat": 40.641525
            },
            "end": {
                "lon": -73.980072,
                "lat": 40.742963
            }
        },
        "Rate_Code": None,
        "store_and_forward": None,
        "Payment": {
            "type": "Credit",
            "amt": 20.5,
            "surcharge": 0,
            "mta_tax": None,
            "tip": 9,
            "tolls": 4.15,
			"status": "booked"
        },
        "Passenger_Count": 2,
        "passengers": [
            {"name": "John", "rating": 4.9},
            {"name": "Jack", "rating": 3.9}
        ],
        "Stops": [
            {"lon": -73.6, "lat": 40.6},
            {"lon": -73.5, "lat": 40.5}
        ]
    },
]

# define the connection to load to. 
# We now use duckdb, but you can switch to Bigquery later

import dlt
import duckdb 

pipeline = dlt.pipeline(pipeline_name="taxi_data", destination='duckdb', dataset_name='taxi_rides')

# run the pipeline with default settings, and capture the outcome
info = pipeline.run(data, table_name="users", write_disposition="replace")

# show the outcome
print(info)
```

OS prompt :
```
dlt pipeline taxi_data show
```

Browser http://localhost:8501/

Navigation --> Explore data


## Incremental loading

Incremental loading means that as we update our datasets with the new data, we would only load the new data, as opposed to making a full copy of a source’s data all over again and replacing the old version.

By loading incrementally, our pipelines run faster and cheaper.

dlt currently supports 2 ways of loading incrementally:
Append:
We can use this for immutable or stateless events (data that doesn’t change), such as taxi rides - For example, every day there are new rides, and we could load the new ones only instead of the entire history.
We could also use this to load different versions of stateful data, for example for creating a “slowly changing dimension” table for auditing changes. For example, if we load a list of cars and their colors every day, and one day one car changes color, we need both sets of data to be able to discern that a change happened.
Merge:
We can use this to update data that changes.
For example, a taxi ride could have a payment status, which is originally “booked” but could later be changed into “paid”, “rejected” or “cancelled”


Here is how you can think about which method to use:

![image](https://github.com/garjita63/de-zoomcamp-2024-homework-workshop-data-ingestion/assets/77673886/a3ce3f2c-fadb-4912-859a-1a9598a68438)


If you want to keep track of when changes occur in stateful data (slowly changing dimension) then you will need to append the data


Let’s do a merge example together:
💡 This is the bread and butter of data engineers pulling data, so follow along.

In our previous example, the payment status changed from "booked" to “cancelled”. Perhaps Jack likes to fraud taxis and that explains his low rating. Besides the ride status change, he also got his rating lowered further.
The merge operation replaces an old record with a new one based on a key. The key could consist of multiple fields or a single unique id. We will use record hash that we created for simplicity. If you do not have a unique key, you could create one deterministically out of several fields, such as by concatenating the data and hashing it.
A merge operation replaces rows, it does not update them. If you want to update only parts of a row, you would have to load the new data by appending it and doing a custom transformation to combine the old and new data.
In this example, the score of the 2 drivers got lowered and we need to update the values. We do it by using merge write disposition, replacing the records identified by record hash present in the new data.

![image](https://github.com/garjita63/de-zoomcamp-2024-homework-workshop-data-ingestion/assets/77673886/91b2ae26-298c-4488-8203-3cbf413c13e6)

Python prompt
```
data = [
    {
        "vendor_name": "VTS",
		"record_hash": "b00361a396177a9cb410ff61f20015ad",
        "time": {
            "pickup": "2009-06-14 23:23:00",
            "dropoff": "2009-06-14 23:48:00"
        },
        "Trip_Distance": 17.52,
        "coordinates": {
            "start": {
                "lon": -73.787442,
                "lat": 40.641525
            },
            "end": {
                "lon": -73.980072,
                "lat": 40.742963
            }
        },
        "Rate_Code": None,
        "store_and_forward": None,
        "Payment": {
            "type": "Credit",
            "amt": 20.5,
            "surcharge": 0,
            "mta_tax": None,
            "tip": 9,
            "tolls": 4.15,
			"status": "cancelled"
        },
        "Passenger_Count": 2,
        "passengers": [
            {"name": "John", "rating": 4.4},
            {"name": "Jack", "rating": 3.6}
        ],
        "Stops": [
            {"lon": -73.6, "lat": 40.6},
            {"lon": -73.5, "lat": 40.5}
        ]
    },
]

# define the connection to load to. 
# We now use duckdb, but you can switch to Bigquery later
pipeline = dlt.pipeline(destination='duckdb', dataset_name='taxi_rides')

# run the pipeline with default settings, and capture the outcome
info = pipeline.run(data, 
					table_name="users", 
					write_disposition="merge", 
					merge_key="record_hash")

# show the outcome
print(info)
```

Output

![image](https://github.com/garjita63/de-zoomcamp-2024-homework-workshop-data-ingestion/assets/77673886/7bd8e945-b71f-46c2-9dde-ec9af2dd2b6f)



```
import dlt

data = [
    {
        "vendor_name": "VTS",
		"record_hash": "b00361a396177a9cb410ff61f20015ad",
        "time": {
            "pickup": "2009-06-14 23:23:00",
            "dropoff": "2009-06-14 23:48:00"
        },
        "Trip_Distance": 17.52,
        "coordinates": {
            "start": {
                "lon": -73.787442,
                "lat": 40.641525
            },
            "end": {
                "lon": -73.980072,
                "lat": 40.742963
            }
        },
        "Rate_Code": None,
        "store_and_forward": None,
        "Payment": {
            "type": "Credit",
            "amt": 20.5,
            "surcharge": 0,
            "mta_tax": None,
            "tip": 9,
			"tolls": 4.15,
			"status": "cancelled"
        },
        "Passenger_Count": 2,
        "passengers": [
            {"name": "John", "rating": 4.4},
            {"name": "Jack", "rating": 3.6}
        ],
        "Stops": [
            {"lon": -73.6, "lat": 40.6},
            {"lon": -73.5, "lat": 40.5}
        ]
    },
]

# define the connection to load to. 
# We now use duckdb, but you can switch to Bigquery later
pipeline = dlt.pipeline(destination='duckdb', dataset_name='taxi_rides')

info = pipeline.run(data, table_name="users", write_disposition="merge", merge_key="record_hash")

# show the outcome
print(info)
```
![image](https://github.com/garjita63/de-zoomcamp-2024-homework-workshop-data-ingestion/assets/77673886/2ba2cccb-15a1-46ac-8faa-93380a6d3a64)

Note:<br>
![image](https://github.com/garjita63/de-zoomcamp-2024-homework-workshop-data-ingestion/assets/77673886/77d224af-d5f0-496c-bdfe-2808aa0c0fc1)

Solved : 

Change 
```
info = pipeline.run(data, table_name="users", write_disposition="merge", merge_key="record_hash")
```
to
```
info = pipeline.run(data, table_name="users", write_disposition="merge", primary_key="ID")
```
