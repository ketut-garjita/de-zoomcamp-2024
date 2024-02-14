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

pipeline = dlt.pipeline(pipeline_name="taxi_data_loading", destination='duckdb', dataset_name='taxi_rides')

# run the pipeline with default settings, and capture the outcome
info = pipeline.run(data, table_name="users", write_disposition="replace")

# show the outcome
print(info)
```

OS prompt :
```
dlt pipeline taxi_data show
```

Open other session

Browser http://localhost:8501/

Navigation --> Explore data


## Incremental loading

Create python script : taxi_incremental_loading.py
```
cd /mnt/e/dlt/scripts
vi taxi_data.py
Edit taxi_data.py as below :
```

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
pipeline = dlt.pipeline(pipeline_name='taxi_incremental_loading', destination='duckdb', dataset_name='taxi_rides')

# run the pipeline with default settings, and capture the outcome
info = pipeline.run(data, table_name="users", write_disposition="merge", primary_key="ID")

# show the outcome
print(info)
```
