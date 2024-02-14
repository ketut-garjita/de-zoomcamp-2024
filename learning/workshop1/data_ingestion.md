## Introducing dlt (data load tool)

dlt is a python library created for the purpose of assisting data engineers to build simpler, faster and more robust pipelines with minimal effort.

You can think of dlt as a loading tool that implements the best practices of data pipelines enabling you to just “use” those best practices in your own pipelines, in a declarative way.

This enables you to stop reinventing the flat tyre, and leverage dlt to build pipelines much faster than if you did everything from scratch.

dlt automates much of the tedious work a data engineer would do, and does it in a way that is robust. dlt can handle things like:

Schema: Inferring and evolving schema, alerting changes, using schemas as data contracts.
Typing data, flattening structures, renaming columns to fit database standards. In our example we will pass the “data” you can see above and see it normalised.
Processing a stream of events/rows without filling memory. This includes extraction from generators.
Loading to a variety of dbs or file formats.
Let’s use it to load our nested json to duckdb:

Here’s how you would do that on your local machine. I will walk you through before showing you in colab as well.

First, install dlt

Command prompt
```
python -m venv ./env
source ./env/bin/activate
pip install dlt[duckdb]

Successfully installed PyYAML-6.0.1 SQLAlchemy-2.0.25 astunparse-1.6.3 certifi-2024.2.2 charset-normalizer-3.3.2 click-8.1.7 dlt-0.4.2 duckdb-0.9.2 fsspec-2024.2.0 gitdb-4.0.11 gitpython-3.1.41 giturlparse-0.12.0 greenlet-3.0.3 hexbytes-1.0.0 humanize-4.9.0 idna-3.6 jsonpath-ng-1.6.1 makefun-1.15.2 orjson-3.9.13 packaging-23.2 pathvalidate-3.2.0 pendulum-3.0.0 ply-3.11 python-dateutil-2.8.2 pytz-2024.1 requests-2.31.0 requirements-parser-0.5.0 semver-3.0.2 setuptools-69.0.3 simplejson-3.19.2 six-1.16.0 smmap-5.0.1 tenacity-8.2.3 time-machine-2.13.0 tomlkit-0.12.3 types-setuptools-69.0.0.20240125 typing-extensions-4.9.0 tzdata-2023.4 urllib3-2.2.0 wheel-0.42.0

```
Open other OS session<br>
Command prompt<br>
```
source ./env/bin/activate
```
```
# for first, time install pandas
pip install pandas
```
```
# for first, time install streamlit
pip install streamlit
```


Command prompt
```
python
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

pipeline = dlt.pipeline(pipeline_name="taxi_data",
						destination='duckdb', 
						dataset_name='taxi_rides')

# run the pipeline with default settings, and capture the outcome
info = pipeline.run(data, 
                    table_name="users", 
                    write_disposition="replace")

# show the outcome
print(info)
```


```
dlt pipeline taxi_data show
```
Output<br>
Pipeline taxi_data load step completed in 1.69 seconds<br>
1 load package(s) were loaded to destination duckdb and into dataset taxi_rides<br>
The duckdb destination used duckdb:////mnt/c/WINDOWS/system32/taxi_data.duckdb location to store data<br>
Load package 1707269084.1495888 is LOADED and contains no failed jobs<br>


Output<br>

![image](https://github.com/garjita63/de-zoomcamp-2024-homework-workshop-data-ingestion/assets/77673886/b886eb22-c09e-4a82-941c-8e5f29605e6e)

Browser http://localhost:8501/

Navigation --> Explore data

![image](https://github.com/garjita63/de-zoomcamp-2024-homework-workshop-data-ingestion/assets/77673886/d264acee-5d51-46b5-8417-821aa8238e0d)

Navigation --> Load info

![image](https://github.com/garjita63/de-zoomcamp-2024-homework-workshop-data-ingestion/assets/77673886/fbbb0ef6-96d7-4784-9c41-b38326a58241)


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
