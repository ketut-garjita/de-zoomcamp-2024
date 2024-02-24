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

#### **Answer 1 : It applies a _limit 100_ only to our staging models**

**NOTE :**

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/d67da041-45f1-481b-ab3f-d5cd3bb0136e)


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

**NOTE :**

models/staging/stg_fhv_tripdata.sql

```
{{
    config(
        materialized='view'
    )
}}

with tripdata as 
(
  select *,
    row_number() over(partition by dispatching_base_num, pickup_datetime) as rn
  from {{ source('staging','fhv_tripdata') }}
)
select
    -- identifiers
    {{ dbt_utils.generate_surrogate_key(['dispatching_base_num', 'pickup_datetime']) }} as tripid,
    dispatching_base_num as dispatching_base_num,
    cast(pickup_datetime as timestamp) as pickup_datetime,
    cast(dropOff_datetime as timestamp) as dropoff_datetime,
    {{ dbt.safe_cast("PUlocationID", api.Column.translate_type("integer")) }} as pickup_locationid,
    {{ dbt.safe_cast("DOlocationID", api.Column.translate_type("integer")) }} as dropoff_locationid,
    SR_Flag as sr_flag,
    Affiliated_base_number as affiliated_base_number
from tripdata
where rn = 1


-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}
```

models/core/fact_fhv_trips.sql

```
{{
    config(
        materialized='table'
    )
}}

with fhv_tripdata as (
    select *, 
        'fhv' as service_type
    from {{ ref('stg_fhv_tripdata') }}
), 
fhv_trips as (
    select * from fhv_tripdata
), 
dim_zones as (
    select * from {{ ref('dim_zones') }}
    where borough != 'Unknown'
)
select 
    fhv_trips.tripid,
    fhv_trips.dispatching_base_num,
    fhv_trips.pickup_datetime,
    fhv_trips.dropoff_datetime,
    fhv_trips.pickup_locationid,
    fhv_trips.dropoff_locationid,
    fhv_trips.sr_flag,
    fhv_trips.affiliated_base_number
from fhv_trips
inner join dim_zones as pickup_zone
on fhv_trips.pickup_locationid = pickup_zone.locationid
inner join dim_zones as dropoff_zone
on fhv_trips.dropoff_locationid = dropoff_zone.locationid
```

models/staging/schema.yml

```
version: 2

sources:
  - name: staging
    database: dtc-de-course-2024-411803
     # For postgres:
      #database: production
    schema: dbt_ny_taxi

      # loaded_at_field: record_loaded_at
    tables:
      - name: green_tripdata
      - name: yellow_tripdata
         # freshness:
           # error_after: {count: 6, period: hour}
      - name: fhv_tripdata     

models:
    - name: stg_green_tripdata
      description: >
        Trip made by green taxis, also known as boro taxis and street-hail liveries.
        Green taxis may respond to street hails,but only in the areas indicated in green on the
        map (i.e. above W 110 St/E 96th St in Manhattan and in the boroughs).
        The records were collected and provided to the NYC Taxi and Limousine Commission (TLC) by
        technology service providers. 
      columns:
          - name: tripid
            description: Primary key for this table, generated with a concatenation of vendorid+pickup_datetime
            tests:
                - unique:
                    severity: warn
                - not_null:
                    severity: warn
          - name: VendorID 
            description: > 
                A code indicating the TPEP provider that provided the record.
                1= Creative Mobile Technologies, LLC; 
                2= VeriFone Inc.
          - name: pickup_datetime 
            description: The date and time when the meter was engaged.
          - name: dropoff_datetime 
            description: The date and time when the meter was disengaged.
          - name: Passenger_count 
            description: The number of passengers in the vehicle. This is a driver-entered value.
          - name: Trip_distance 
            description: The elapsed trip distance in miles reported by the taximeter.
          - name: Pickup_locationid
            description: locationid where the meter was engaged.
            tests:
              - relationships:
                  to: ref('taxi_zone_lookup')
                  field: locationid
                  severity: warn
          - name: dropoff_locationid 
            description: locationid where the meter was engaged.
            tests:
              - relationships:
                  to: ref('taxi_zone_lookup')
                  field: locationid
          - name: RateCodeID 
            description: >
                The final rate code in effect at the end of the trip.
                  1= Standard rate
                  2=JFK
                  3=Newark
                  4=Nassau or Westchester
                  5=Negotiated fare
                  6=Group ride
          - name: Store_and_fwd_flag 
            description: > 
              This flag indicates whether the trip record was held in vehicle
              memory before sending to the vendor, aka “store and forward,”
              because the vehicle did not have a connection to the server.
                Y= store and forward trip
                N = not a store and forward trip
          - name: Dropoff_longitude 
            description: Longitude where the meter was disengaged.
          - name: Dropoff_latitude 
            description: Latitude where the meter was disengaged.
          - name: Payment_type 
            description: >
              A numeric code signifying how the passenger paid for the trip.
            tests: 
              - accepted_values:
                  values: "{{ var('payment_type_values') }}"
                  severity: warn
                  quote: false
          - name: payment_type_description
            description: Description of the payment_type code
          - name: Fare_amount 
            description: > 
              The time-and-distance fare calculated by the meter.
              Extra Miscellaneous extras and surcharges. Currently, this only includes
              the $0.50 and $1 rush hour and overnight charges.
              MTA_tax $0.50 MTA tax that is automatically triggered based on the metered
              rate in use.
          - name: Improvement_surcharge 
            description: > 
              $0.30 improvement surcharge assessed trips at the flag drop. The
              improvement surcharge began being levied in 2015.
          - name: Tip_amount 
            description: > 
              Tip amount. This field is automatically populated for credit card
              tips. Cash tips are not included.
          - name: Tolls_amount 
            description: Total amount of all tolls paid in trip.
          - name: Total_amount 
            description: The total amount charged to passengers. Does not include cash tips.

    - name: stg_yellow_tripdata
      description: > 
        Trips made by New York City's iconic yellow taxis. 
        Yellow taxis are the only vehicles permitted to respond to a street hail from a passenger in all five
        boroughs. They may also be hailed using an e-hail app like Curb or Arro.
        The records were collected and provided to the NYC Taxi and Limousine Commission (TLC) by
        technology service providers. 
      columns:
          - name: tripid
            description: Primary key for this table, generated with a concatenation of vendorid+pickup_datetime
            tests:
                - unique:
                    severity: warn
                - not_null:
                    severity: warn
          - name: VendorID 
            description: > 
                A code indicating the TPEP provider that provided the record.
                1= Creative Mobile Technologies, LLC; 
                2= VeriFone Inc.
          - name: pickup_datetime 
            description: The date and time when the meter was engaged.
          - name: dropoff_datetime 
            description: The date and time when the meter was disengaged.
          - name: Passenger_count 
            description: The number of passengers in the vehicle. This is a driver-entered value.
          - name: Trip_distance 
            description: The elapsed trip distance in miles reported by the taximeter.
          - name: Pickup_locationid
            description: locationid where the meter was engaged.
            tests:
              - relationships:
                  to: ref('taxi_zone_lookup')
                  field: locationid
                  severity: warn
          - name: dropoff_locationid 
            description: locationid where the meter was engaged.
            tests:
              - relationships:
                  to: ref('taxi_zone_lookup')
                  field: locationid
                  severity: warn
          - name: RateCodeID 
            description: >
                The final rate code in effect at the end of the trip.
                  1= Standard rate
                  2=JFK
                  3=Newark
                  4=Nassau or Westchester
                  5=Negotiated fare
                  6=Group ride
          - name: Store_and_fwd_flag 
            description: > 
              This flag indicates whether the trip record was held in vehicle
              memory before sending to the vendor, aka “store and forward,”
              because the vehicle did not have a connection to the server.
                Y= store and forward trip
                N= not a store and forward trip
          - name: Dropoff_longitude 
            description: Longitude where the meter was disengaged.
          - name: Dropoff_latitude 
            description: Latitude where the meter was disengaged.
          - name: Payment_type 
            description: >
              A numeric code signifying how the passenger paid for the trip.
            tests: 
              - accepted_values:
                  values: "{{ var('payment_type_values') }}"
                  severity: warn
                  quote: false
          - name: payment_type_description
            description: Description of the payment_type code
          - name: Fare_amount 
            description: > 
              The time-and-distance fare calculated by the meter.
              Extra Miscellaneous extras and surcharges. Currently, this only includes
              the $0.50 and $1 rush hour and overnight charges.
              MTA_tax $0.50 MTA tax that is automatically triggered based on the metered
              rate in use.
          - name: Improvement_surcharge 
            description: > 
              $0.30 improvement surcharge assessed trips at the flag drop. The
              improvement surcharge began being levied in 2015.
          - name: Tip_amount 
            description: > 
              Tip amount. This field is automatically populated for credit card
              tips. Cash tips are not included.
          - name: Tolls_amount 
            description: Total amount of all tolls paid in trip.
          - name: Total_amount 
            description: The total amount charged to passengers. Does not include cash tips.

    - name: stg_fhv_tripdata
      description: >
        fhv_tripdata
      columns:
          - name: tripid
          - name: dispatching_base_num
          - name: pickup_datetime 
          - name: dropoff_datetime 
          - name: pickup_locationid
          - name: dropoff_locationid 
          - name: sr_flag
          - name: affiliated_base_number
```

models/core/schema.yml

```
version: 2

models:
  - name: dim_zones
    description: >
      List of unique zones idefied by locationid. 
      Includes the service zone they correspond to (Green or yellow).

  - name: dm_monthly_zone_revenue
    description: >
      Aggregated table of all taxi trips corresponding to both service zones (Green and yellow) per pickup zone, month and service.
      The table contains monthly sums of the fare elements used to calculate the monthly revenue. 
      The table contains also monthly indicators like number of trips, and average trip distance. 
    columns:
      - name: revenue_monthly_total_amount
        description: Monthly sum of the the total_amount of the fare charged for the trip per pickup zone, month and service.
        tests:
            - not_null:
                severity: error
      
  - name: fact_trips
    description: >
      Taxi trips corresponding to both service zones (Green and yellow).
      The table contains records where both pickup and dropoff locations are valid and known zones. 
      Each record corresponds to a trip uniquely identified by tripid. 
    columns:
      - name: tripid
        data_type: string
        description: "unique identifier conformed by the combination of vendorid and pickyp time"

      - name: vendorid
        data_type: int64
        description: ""

      - name: service_type
        data_type: string
        description: ""

      - name: ratecodeid
        data_type: int64
        description: ""

      - name: pickup_locationid
        data_type: int64
        description: ""

      - name: pickup_borough
        data_type: string
        description: ""

      - name: pickup_zone
        data_type: string
        description: ""

      - name: dropoff_locationid
        data_type: int64
        description: ""

      - name: dropoff_borough
        data_type: string
        description: ""

      - name: dropoff_zone
        data_type: string
        description: ""

      - name: pickup_datetime
        data_type: timestamp
        description: ""

      - name: dropoff_datetime
        data_type: timestamp
        description: ""

      - name: store_and_fwd_flag
        data_type: string
        description: ""

      - name: passenger_count
        data_type: int64
        description: ""

      - name: trip_distance
        data_type: numeric
        description: ""

      - name: trip_type
        data_type: int64
        description: ""

      - name: fare_amount
        data_type: numeric
        description: ""

      - name: extra
        data_type: numeric
        description: ""

      - name: mta_tax
        data_type: numeric
        description: ""

      - name: tip_amount
        data_type: numeric
        description: ""

      - name: tolls_amount
        data_type: numeric
        description: ""

      - name: ehail_fee
        data_type: numeric
        description: ""

      - name: improvement_surcharge
        data_type: numeric
        description: ""

      - name: total_amount
        data_type: numeric
        description: ""

      - name: payment_type
        data_type: int64
        description: ""

      - name: payment_type_description
        data_type: string
        description: ""

  - name: fact_fhv_trips
    description: >
        Taxi trips corresponding to both service zones (FHV).
        The table contains records where both pickup and dropoff locations are valid and known zones. 
        Each record corresponds to a trip uniquely identified by tripid. 
    columns:
      - name: tripid
        data_type: string
        description: "unique identifier conformed by the combination of vendorid and pickyp time"

      - name: dispatching_base_num
        data_type: string
        description: ""
        
      - name: pickup_datetime 
        data_type: timestamp
        description: ""       

      - name: dropoff_datetime 
        data_type: timestamp
        description: ""
      
      - name: pickup_locationid
        data_type: int64
        description: ""
      
      - name: dropoff_locationid 
        data_type: int64
        description: ""
      
      - name: sr_flag
        data_type: string
        description: ""
      
      - name: affiliated_base_number
        data_type: string
        description: ""
```

```
dbt build -m stg_fhv_tripdata --vars 'is_test_run: false'
```
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/bc604143-d41f-4478-a48d-202514d6bdca)


```
dbt build -m fact_fhv_trips --vars 'is_test_run: false'
``` 
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/738296ba-7f44-43a9-ac21-95e5a19fa998)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/ae63e60a-e6e9-4ac7-add1-aa3a5a9dffea)


### Question 4 (2 points)

**What is the service that had the most rides during the month of July 2019 month with the biggest amount of rides after building a tile for the fact_fhv_trips table?**

Create a dashboard with some tiles that you find interesting to explore the data. One tile should show the amount of trips per month, as done in the videos for fact_trips, including the fact_fhv_trips data.

- FHV
- Green
- Yellow
- FHV and Green

#### **Answer 4 : Yellow**

**NOTE :**

[https://lookerstudio.google.com/reporting/1e23efd0-d4b3-4362-a555-9cb223dc8e42](https://lookerstudio.google.com/s/v3ZJvK3Vdss)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/f6cfbfad-b684-4674-bbd9-6d8ef8e074ae)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/82c24e33-1fa6-4884-92e9-60659792697b)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/53eded49-8c6c-4672-b129-be7e0311fa69)


## Submitting the solutions

* Form for submitting: https://courses.datatalks.club/de-zoomcamp-2024/homework/hw4
