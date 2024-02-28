## SOLUTION - Week 5 Homework 

In this homework we'll put what we learned about Spark in practice.

For this homework we will be using the FHV 2019-10 data found here. [FHV Data](https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhv/fhv_tripdata_2019-10.csv.gz)

### Question 1: 

**Install Spark and PySpark** 

- Install Spark
- Run PySpark
- Create a local spark session
- Execute spark.version.

What's the output?

> [!NOTE]
> To install PySpark follow this [guide](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/05-batch/setup/pyspark.md)

### Answer 1 : '3.4.2'

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/323fd142-4f03-47a9-ba78-5fde8191401f)


### Question 2: 

**FHV October 2019**

Read the October 2019 FHV into a Spark Dataframe with a schema as we did in the lessons.

Repartition the Dataframe to 6 partitions and save it to parquet.

What is the average size of the Parquet (ending with .parquet extension) Files that were created (in MB)? Select the answer which most closely matches.

- 1MB
- 6MB
- 25MB
- 87MB

### Answer 2 : 6M

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/d9c6d73a-051d-4bb4-9c0c-afebb0bf0974)


### Question 3: 

**Count records** 

How many taxi trips were there on the 15th of October?

Consider only trips that started on the 15th of October.

- 108,164
- 12,856
- 452,470
- 62,610

> [!IMPORTANT]
> Be aware of columns order when defining schema

### Answer 3 : 62,610

```
df = spark.read \
    .option("header", "true") \
    .csv('fhv_tripdata_2019-10.csv.gz')

# create 6 partitions in our dataframe
df = df.repartition(6)
# parquetize and write to fhvhv/2019/10/ folder
df.write.parquet('fhvhv/2019/10/', mode='overwrite')

df = spark.read.parquet('fhvhv/2019/10/*')

df[df['pickup_datetime'].between('2019-10-15 00:00:00', '2019-10-15 59:59:59')].count()
```
Output: 62610


### Question 4: 

**Longest trip for each day** 

What is the length of the longest trip in the dataset in hours?

- 631,152.50 Hours
- 243.44 Hours
- 7.68 Hours
- 3.32 Hours

### Answer 4 : 7.68 Hours

```
from pyspark.sql.functions import *

df = df.withColumn('Result', to_timestamp('dropOff_datetime') - to_timestamp('pickup_datetime'))

df.createOrReplaceTempView('trips_data')

spark.sql("""
SELECT
    (max(Result)/60/60)
FROM
    trips_data
""").show()
```

Output:

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/03fcaa81-f47a-4b42-b441-dcba7b153a69)


### Question 5: 

**User Interface**

Spark’s User Interface which shows the application's dashboard runs on which local port?

- 80
- 443
- 4040
- 8080

### Answer 5 : 4040

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/38d8ffee-f05a-4eeb-bd60-638e8b1da8f9)


### Question 6: 

**Least frequent pickup location zone**

Load the zone lookup data into a temp view in Spark</br>
[Zone Data](https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv)

Using the zone lookup data and the FHV October 2019 data, what is the name of the LEAST frequent pickup location Zone?</br>

- East Chelsea
- Jamaica Bay
- Union Sq
- Crown Heights North

### Answer 6 : Jamaica Bay

```
dfzone = spark.read \
    .option("header", "true") \
    .csv('taxi+_zone_lookup.csv')

dfzone.write.mode("overwrite").parquet('zones')

dfzone.createOrReplaceTempView('zone_data')

spark.sql("""
WITH least as (
    SELECT PUlocationID, count(*)
    FROM trips_data
    GROUP BY PUlocationID
    ORDER BY count(*) LIMIT 1
)
SELECT zone 
FROM zone_data
JOIN least ON PUlocationID = LocationID
""").show()
```

Output:

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/93539e88-d56e-43ff-a8f1-c5fc5195574d)


## Submitting the solutions

- Form for submitting: https://courses.datatalks.club/de-zoomcamp-2024/homework/hw5


### Attachment

[Solution Program File](https://github.com/garjita63/de-zoomcamp-2024/blob/a4965a8a714b7a4cec98a33850a7952c4aa89106/homewok/homework5.ipynb)
