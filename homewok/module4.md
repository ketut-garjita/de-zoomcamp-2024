## ANSWERS - Module 4 Homework 

In this homework, we'll use the models developed during the week 4 videos and enhance the already presented dbt project using the already loaded Taxi data for fhv vehicles for year 2019 in our DWH.

This means that in this homework we use the following data [Datasets list](https://github.com/DataTalksClub/nyc-tlc-data/)
* Yellow taxi data - Years 2019 and 2020
* Green taxi data - Years 2019 and 2020 
* fhv data - Year 2019. 

We will use the data loaded for:

* Building a source table: `stg_fhv_tripdata`
* Building a fact table: `fact_fhv_trips`
* Create a dashboard 

If you don't have access to GCP, you can do this locally using the ingested data from your Postgres database
instead. If you have access to GCP, you don't need to do it for local Postgres - only if you want to.

> **Note**: if your answer doesn't match exactly, select the closest option 

### Question 1: 

**What happens when we execute dbt build --vars '{'is_test_run':'true'}'**
You'll need to have completed the ["Build the first dbt models"](https://www.youtube.com/watch?v=UVI30Vxzd6c) video. 
- It's the same as running *dbt build*
- It applies a _limit 100_ to all of our models
- It applies a _limit 100_ only to our staging models
- Nothing

#### **Answer 1 : It applies a _limit 100_ to all of our models**


### Question 2: 

**What is the code that our CI job will run? Where is this code coming from?**  

- The code that has been merged into the main branch
- The code that is behind the creation object on the dbt_cloud_pr_ schema
- The code from any development branch that has been opened based on main
- The code from the development branch we are requesting to merge to main

#### **Answer 2 : The code that is behind the creation object on the dbt_cloud_pr_ schema**

**NOTE :** 

**Continuous integration in dbt Cloud**

To implement a continuous integration (CI) workflow in dbt Cloud, you can set up automation that tests code changes by running CI jobs before merging to production. dbt Cloud tracks the state of what’s running in your production environment so, when you run a CI job, only the modified data assets in your pull request (PR) and their downstream dependencies are built and tested in a staging schema. You can also view the status of the CI checks (tests) directly from within the PR; this information is posted to your Git provider as soon as a CI job completes. Additionally, you can enable settings in your Git provider that allow PRs only with successful CI checks be approved for merging.

**How CI works**

When you set up CI jobs, dbt Cloud listens for webhooks from your Git provider indicating that a new PR has been opened or updated with new commits. When dbt Cloud receives one of these webhooks, it enqueues a new run of the CI job.

dbt Cloud builds and tests the models affected by the code change in a temporary schema, unique to the PR. This process ensures that the code builds without error and that it matches the expectations as defined by the project's dbt tests. The unique schema name follows the naming convention dbt_cloud_pr_<job_id>_<pr_id> (for example, dbt_cloud_pr_1862_1704).


### Question 3 (2 points)

**What is the count of records in the model fact_fhv_trips after running all dependencies with the test run variable disabled (:false)?**  
Create a staging model for the fhv data, similar to the ones made for yellow and green data. Add an additional filter for keeping only records with pickup time in year 2019.
Do not add a deduplication step. Run this models without limits (is_test_run: false).

Create a core model similar to fact trips, but selecting from stg_fhv_tripdata and joining with dim_zones.
Similar to what we've done in fact_trips, keep only records with known pickup and dropoff locations entries for pickup and dropoff locations. 
Run the dbt model without limits (is_test_run: false).

- 12998722
- 22998722
- 32998722
- 42998722

#### **Answer 3 : 22998722**


### Question 4 (2 points)

**What is the service that had the most rides during the month of July 2019 month with the biggest amount of rides after building a tile for the fact_fhv_trips table?**

Create a dashboard with some tiles that you find interesting to explore the data. One tile should show the amount of trips per month, as done in the videos for fact_trips, including the fact_fhv_trips data.

- FHV
- Green
- Yellow
- FHV and Green

#### **Answer 4 : Yellow**

**NOTE :**

https://lookerstudio.google.com/reporting/1e23efd0-d4b3-4362-a555-9cb223dc8e42

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/53eded49-8c6c-4672-b129-be7e0311fa69)


## Submitting the solutions

* Form for submitting: https://courses.datatalks.club/de-zoomcamp-2024/homework/hw4
