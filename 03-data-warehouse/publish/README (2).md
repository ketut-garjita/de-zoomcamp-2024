## Week 3 Homework
ATTENTION: At the end of the submission form, you will be required to include a link to your GitHub repository or other public code-hosting site. This repository should contain your code for solving the homework. If your solution includes code that is not in file format (such as SQL queries or shell commands), please include these directly in the README file of your repository.

<b><u>Important Note:</b></u> <p> For this homework we will be using the 2022 Green Taxi Trip Record Parquet Files from the New York
City Taxi Data found here: </br> https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page </br>
If you are using orchestration such as Mage, Airflow or Prefect do not load the data into Big Query using the orchestrator.</br> 
Stop with loading the files into a bucket. </br></br>
<u>NOTE:</u> You will need to use the PARQUET option files when creating an External Table</br>

<b>SETUP:</b></br>
Create an external table using the Green Taxi Trip Records Data for 2022. </br>
Create a table in BQ using the Green Taxi Trip Records for 2022 (do not partition or cluster this table). </br>
</p>


## Week 3 (Data Warehouse) Homework Solutions

### Create Green Tripdata External Table

**Source Data** : the 2022 Green Taxi Trip Record Parquet Files from the New York City Taxi Data (January - December 2022)

[https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page)

```
CREATE OR REPLACE EXTERNAL TABLE `taxidataset.external_green_tripdata`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://de-zoomcamp-garjita-bucket/green_tripdata_2022/green_tripdata_2022-*.parquet']	
);
```
![image](https://github.com/garjita63/dezoomcamp-2024-homework/assets/77673886/dd2ea337-461d-41c3-92ac-b8945f55dd3a)

![image](https://github.com/garjita63/dezoomcamp-2024-homework/assets/77673886/97a04e35-ff13-4e95-a941-56e5b6b983db)


## Question 1:
Question 1: What is count of records for the 2022 Green Taxi Data??
- 65,623,481
- <code style="color:green">840,402</code>
- 1,936,423
- 253,647

## Answer 1:
```
SELECT  COUNT(*) FROM `dtc-de-course-2024-411803.taxidataset.external_green_tripdata`;
```
![image](https://github.com/garjita63/dezoomcamp-2024-homework/assets/77673886/5f9e2d6b-32eb-4988-8258-a6d984b85930)

Anser --> <code style="color:green">840,402</code>


## Question 2:
Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.</br> 
What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?

- <code style="color:green">0 MB for the External Table and 6.41MB for the Materialized Table</code>
- 18.82 MB for the External Table and 47.60 MB for the Materialized Table
- 0 MB for the External Table and 0MB for the Materialized Table
- 2.14 MB for the External Table and 0MB for the Materialized Table

## Answer 2:

*Select from External Table in BigQuery*
 ```
SELECT DISTINCT(PULocationID) FROM taxidataset.external_green_tripdata;
```
![image](https://github.com/garjita63/dezoomcamp-2024-homework/assets/77673886/1849a5a8-ee78-4e3a-8882-a7482cca1149)

*Select from non-partitioned table in BigQuery*
![image](https://github.com/garjita63/dezoomcamp-2024-homework/assets/77673886/d8a9ceb6-9b66-4d61-ab8c-5679b2643eb9)

Anser --> <code style="color:green">0 MB for the External Table and 6.41MB for the Materialized Table</code>
 

## Question 3:
How many records have a fare_amount of 0?
- 12,488
- 128,219
- 112
- <code style="color:green">1,622</code>

## Answer 3:

*Select from external table*
```
SELECT COUNT(*) from taxidataset.external_green_tripdata WHERE fare_amount=0;
```
![image](https://github.com/garjita63/dezoomcamp-2024-homework/assets/77673886/0e452a0e-1382-4e3a-bada-e444f4c4139d)

*Select from non-prtitioned table*
![image](https://github.com/garjita63/dezoomcamp-2024-homework/assets/77673886/678793cc-f317-44b5-ab8f-5b0ec4617a6e)

Answer --> <code style="color:green">1,622</code>


## Question 4:
What is the best strategy to make an optimized table in Big Query if your query will always order the results by PUlocationID and filter based on lpep_pickup_datetime? (Create a new table with this strategy)
- Cluster on lpep_pickup_datetime Partition by PUlocationID
- Partition by lpep_pickup_datetime  Cluster on PUlocationID
- <code style="color:green">Partition by lpep_pickup_datetime  Cluster on PUlocationID</code>
- Partition by lpep_pickup_datetime and Partition by PUlocationID
- Cluster on by lpep_pickup_datetime and Cluster on PUlocationID

## Answer 4:

Best partcice for query performance: 
```
i) Filter on partitioned columns
ii) the order of the columns in which the clustering is specified is important in order to determine the column priority
```
Answer --> <code style="color:green">Partition by lpep_pickup_datetime  Cluster on PUlocationID</code>


## Question 5:
Write a query to retrieve the distinct PULocationID between lpep_pickup_datetime
06/01/2022 and 06/30/2022 (inclusive)</br>

Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 4 and note the estimated bytes processed. What are these values? </br>

Choose the answer which most closely matches.</br> 

- 22.82 MB for non-partitioned table and 647.87 MB for the partitioned table
- <code style="color:green">12.82 MB for non-partitioned table and 1.12 MB for the partitioned table</code>
- 5.63 MB for non-partitioned table and 0 MB for the partitioned table
- 10.31 MB for non-partitioned table and 10.31 MB for the partitioned table

## Answer 5

Create partitined table
```
CREATE OR REPLACE TABLE taxidataset.green_tripdata_partitioned
PARTITION BY DATE(lpep_pickup_datetime)
CLUSTER BY PUlocationID AS
SELECT * FROM taxidataset.external_green_tripdata;
```
![image](https://github.com/garjita63/dezoomcamp-2024-homework/assets/77673886/b68907b9-3a97-47e0-b132-e02a85b0d862)

**Retrieve the distinct PULocationID between lpep_pickup_datetime 06/01/2022 and 06/30/2022 (inclusive)**

*Select from non-partitioned table*
```
SELECT DISTINCT(PULocationID) 
FROM taxidataset.green_tripdata_non_partitoned
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' and '2022-06-30';
```
![image](https://github.com/garjita63/dezoomcamp-2024-homework/assets/77673886/5a157deb-1ef3-478d-b495-651eb2b6bd0f)

*Select from partitioned table*
```
SELECT DISTINCT(PULocationID)
FROM taxidataset.green_tripdata_partitioned
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' and '2022-06-30';
```
![image](https://github.com/garjita63/dezoomcamp-2024-homework/assets/77673886/39431313-1618-467b-bf11-cae8ff915f2c)

Answer --> <code style="color:green">12.82 MB for non-partitioned table and 1.12 MB for the partitioned table</code>


## Question 6: 
Where is the data stored in the External Table you created?

- Big Query
- <code style="color:green">GCP Bucket</code>
- Big Table
- Container Registry

## Answer 6:

An external table is a table that acts like a standard BQ table. The table metadata (such as the schema) is stored in BQ storage but the data itself is external (GCP Bucket).

Answer --> <code style="color:green">GCP Bucket</code>


## Question 7:
It is best practice in Big Query to always cluster your data:
- True
- False

## Answer 7:
- Clustered tables can improve query performance and reduce query costs.
- If your queries commonly filter on particular columns, clustering accelerates queries because the query only scans the blocks that match the filter.
- If your queries filter on columns that have many distinct values (high cardinality), clustering accelerates these queries by providing BigQuery with detailed metadata for where to get input data.
- Clustering enables your table's underlying storage blocks to be adaptively sized based on the size of the table.

Answer --> True


## (Bonus: Not worth points) Question 8:
No Points: Write a SELECT count(*) query FROM the materialized table you created. How many bytes does it estimate will be read? Why?

## Answer 8:

*Select from non_partitioned table*
```
SELECT COUNT(*) FROM taxidataset.green_tripdata_non_partitoned;
```
![image](https://github.com/garjita63/dezoomcamp-2024-homework/assets/77673886/e0a0f8a2-914e-424f-91d9-452e4814b441)

*Select from partitioned table*
```

 
## Submitting the solutions

* Form for submitting: TBD
* You can submit your homework multiple times. In this case, only the last submission will be used. 

Deadline: TBD

