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

## Data Loading

Create python script : taxi_data_loading.py
```
cd /mnt/e/dlt/scripts
vi taxi_data_loading.py
Edit taxi_data_loading.py as below :
```

```
import dlt
import duckdb

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

# Define the connection to load to. 
# We now use duckdb, but you can switch to Bigquery later
pipeline = dlt.pipeline(pipeline_name="taxi_data_loading", destination='duckdb', dataset_name='taxi_rides')

# Run the pipeline with default settings, and capture the outcome
info = pipeline.run(data, table_name="users", write_disposition="replace")

# Show the outcome
print(info)
```

Run script:
```
(env) root@Desktop-Gar:/mnt/e/dlt# python scripts/taxi_data_loading.py
```

Output:
```
Pipeline taxi_data_loading load step completed in 2.29 seconds
1 load package(s) were loaded to destination duckdb and into dataset taxi_rides
The duckdb destination used duckdb:////mnt/e/dlt/taxi_data_loading.duckdb location to store data
Load package 1707886397.1636 is LOADED and contains no failed jobs
```

OS prompt :
```
dlt pipeline taxi_data_loading show
```

Open other session

Browser http://localhost:8501/

Navigation --> Explore data

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/98a3ae44-bf03-4397-8c03-9005daf527d3)
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/b2865fc6-0bc1-4ac0-a53b-09c0219052a1)


## Incremental loading

Create python script : taxi_incremental_loading.py
```
cd /mnt/e/dlt/scripts
vi taxi_incremental_loading.py
Edit taxi_incremental_loading.py as below :
```

Python prompt
```
import dlt
import duckdb 

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

pipeline = dlt.pipeline(pipeline_name='taxi_incremental_loading', destination='duckdb', dataset_name='taxi_rides')
info = pipeline.run(data, table_name="users", write_disposition="merge", primary_key="ID")

# show the outcome
print(info)
```

Run script:
```
(env) root@Desktop-Gar:/mnt/e/dlt# python scripts/taxi_incremental_loading.py
```

Output:
```
2024-02-14 12:11:50,609|[WARNING              ]|3864|140488174792704|dlt|reference.py|_verify_schema:357|A column id in table users in schema taxi_incremental_loading is incomplete. It was not bound to the data during normalizations stage and its data type is unknown. Did you add this column manually in code ie. as a merge key?
2024-02-14 12:11:51,046|[WARNING              ]|3864|140488174792704|dlt|reference.py|_verify_schema:357|A column id in table users in schema taxi_incremental_loading is incomplete. It was not bound to the data during normalizations stage and its data type is unknown. Did you add this column manually in code ie. as a merge key?
Pipeline taxi_incremental_loading load step completed in 2.74 seconds
1 load package(s) were loaded to destination duckdb and into dataset taxi_rides
The duckdb destination used duckdb:////mnt/e/dlt/taxi_incremental_loading.duckdb location to store data
Load package 1707887509.7438598 is LOADED and contains no failed jobs
```

dlt pipeline taxi_incremental_loading show

Found pipeline taxi_incremental_loading in /var/dlt/pipelines

  You can now view your Streamlit app in your browser.

  Local URL: http://localhost:8502
  
  Network URL: http://172.25.243.204:8502

Navigation Sample

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/25cbf8fc-de04-4830-88d8-3325f1cf3648)
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/73414c34-23ea-4fcb-934e-e93c56dda5f5)

