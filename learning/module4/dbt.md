# dbt (Data Build Tool) Overview

## What is dbt?

dbt stands for data build tool. It's a transformation tool that allows us to transform process raw data in our Data Warehouse to transformed data which can be later used by Business Intelligence tools and any other data consumers.

**dbt** also allows us to introduce good software engineering practices by defining a deployment workflow:
1. Develop models
2. Test and document models
3. Deploy models with version control and CI/CD.


### How does dbt work?

dbt works by defining a modeling layer that stands on top of our Data Warehouse. Each table is turned into a model and then transformed into a derived model, that can be stored into the Data Warehouse for persistence.

A model consists in:
- *.sql file
- Select statement, no DDL or DML are used
- File that dbt will compile and run in our Data Warehouse


### How to use dbt?

dbt has 2 main components: dbt Core and dbt Cloud with the following characteristics:

**dbt Cloud** - SaaS application to develop and manage dbt projects
- Web-based IDE to develop, run and test a dbt project.
- Jobs orchestration.
- Logging and alerting.
- Intregrated documentation.
- Free for individuals (one developer seat).

**dbt Core** - open-source project that allows the data transformation
- Builds and runs a dbt project (.sql and .yaml files).
- Includes SQL compilation logic, macros and database adapters.
- Includes a CLI interface to run dbt commands locally.
- Open-source and free to use.

For this project, I use :
- dbt Cloud (dbt Cloud IDE) + GCP BigQuery
- dbt Core on Docker + BigQuery


## Developing with dbt

### Anatomy of a dbt model

dbt models are a combination of SQL (using SELECT statements) and [Jinja templating language](https://jinja.palletsprojects.com/en/3.0.x/) to define templates.

Below is an example of **abt model**:

```
{{
    config(materialized='table')
}}

SELECT *
FROM staging.source_table
WHERE record_state = 'ACTIVE'
```

- In the Jinja statement defined within {{ }} block we call the config function. More information about Jinja and how to use it for dbt [in this link](https://docs.getdbt.com/docs/building-a-dbt-project/jinja-macros).
- The config function is commonly used at the beginning of a model to define a materialization strategy: a strategy for persisting dbt models in a data warehouse
- There are 4 materialization strategies with the following characteristics:
- View: When using the view materialization, the model is rebuilt as a view on each run, via a create view as statement
- Table: The model is rebuilt as a table on each run, via a create table as statement
- Incremental: Allow dbt to insert or update records into a table since the last time that dbt as run
- Ephemeral: Are not directly build into the database. Instead, dbt will interpolate the code from this model into dependent models as a common table expression (CTE)


### The FROM clause of a dbt model

The FROM clause within a SELECT statement defines the sources of the data to be used.

The following sources are available to dbt models:

**Sources** : The data loaded within our Data Warehouse.
- We can access this data with the source() function.
- The sources key in our YAML file contains the details of the databases that the source() function can access and translate into proper SQL-valid names.
- Additionally, we can define "source freshness" to each source so that we can check whether a source is "fresh" or "stale", which can be useful to check whether our data pipelines are working properly.
- More info about sources in [this link}(https://docs.getdbt.com/docs/building-a-dbt-project/using-sources).
  
**Seeds** : CSV files which can be stored in our repo under the seeds folder.
- The repo gives us version controlling along with all of its benefits.
- Seeds are best suited to static data which changes infrequently.
- Seed usage:
    - Add a CSV file to our seeds folder.
    - Run the [dbt seed command](https://docs.getdbt.com/reference/commands/seed) to create a table in our Data Warehouse.
- If we update the content of a seed, running dbt seed will append the updated values to the table rather than substituing them. Running dbt seed --full-refresh instead will drop the old table and create a new one.
    - Refer to the seed in our model with the ref() function.
    - More info about seeds in [this link](https://docs.getdbt.com/docs/building-a-dbt-project/seeds).
    - 
Here's an example of how we would declare a source in a .yml file:

```
sources:
    - name: staging
      database: production
      schema: trips_data_all

      loaded_at_field: record_loaded_at
      tables:
        - name: green_tripdata
        - name: yellow_tripdata
          freshness:
            error_after: {count: 6, period: hour}
```

And here's how we would reference a source in a FROM clause:

```
FROM {{ source('staging','yellow_tripdata') }}
```

- The first argument of the source() function is the source name, and the second is the table name.

In the case of seeds, assuming we've got a taxi_zone_lookup.csv file in our seeds folder which contains locationid, borough, zone and service_zone:

```
SELECT
    locationid,
    borough,
    zone,
    replace(service_zone, 'Boro', 'Green') as service_zone
FROM {{ ref('taxi_zone_lookup) }}
```

The ref() function references underlying tables and views in the Data Warehouse. When compiled, it will automatically build the dependencies and resolve the correct schema fo us. So, if BigQuery contains a schema/dataset called dbt_dev inside the my_project database which we're using for development and it contains a table called stg_green_tripdata, then the following code...

```
WITH green_data AS (
    SELECT *,
        'Green' AS service_type
    FROM {{ ref('stg_green_tripdata') }}
),
```

...will compile to this:

```
WITH green_data AS (
    SELECT *,
        'Green' AS service_type
    FROM "my_project"."dbt_dev"."stg_green_tripdata"
),
```

- The ref() function translates our references table into the full reference, using the database.schema.table structure.
- If we were to run this code in our production environment, dbt would automatically resolve the reference to make ir point to our production schema.


### Defining a source and creating a model

It's time to create our first model.

We will begin by creating 2 new folders under our models folder:
- staging will have the raw models.
- core will have the models that we will expose at the end to the BI tool, stakeholders, etc.

Under staging we will add 2 new files: sgt_green_tripdata.sql and schema.yml:

```
# schema.yml

version: 2

sources:
    - name: staging
      database: our_project
      schema: trips_data_all

      tables:
          - name: green_tripdata
          - name: yellow_tripdata
```

- We define our sources in the schema.yml model properties file.
- We are defining the 2 tables for yellow and green taxi data as our sources.

```
-- sgt_green_tripdata.sql

{{ config(materialized='view') }}

select * from {{ source('staging', 'green_tripdata') }}
limit 100
```

- This query will create a view in the staging dataset/schema in our database.
- We make use of the source() function to access the green taxi data table, which is defined inside the schema.yml file.

The advantage of having the properties in a separate file is that we can easily modify the schema.yml file to change the database details and write to different databases without having to modify our sgt_green_tripdata.sql file.

we may know run the model with the dbt run command, either locally or from dbt Cloud.


### Macros

Macros are pieces of code in Jinja that can be reused, similar to functions in other languages.

dbt already includes a series of macros like config(), source() and ref(), but custom macros can also be defined.

Macros allow us to add features to SQL that aren't otherwise available, such as:
- Use control structures such as if statements or for loops.
- Use environment variables in our dbt project for production.
- Operate on the results of one query to generate another query.
- Abstract snippets of SQL into reusable macros.

Macros are defined in separate .sql files which are typically stored in a macros directory.

There are 3 kinds of Jinja delimiters:
- {% ... %} for statements (control blocks, macro definitions)
- {{ ... }} for expressions (literals, math, comparisons, logic, macro calls...)
- {# ... #} for comments.
- 
Here's a macro definition example:

```
{# This macro returns the description of the payment_type #}

{% macro get_payment_type_description(payment_type) %}

    case {{ payment_type }}
        when 1 then 'Credit card'
        when 2 then 'Cash'
        when 3 then 'No charge'
        when 4 then 'Dispute'
        when 5 then 'Unknown'
        when 6 then 'Voided trip'
    end

{% endmacro %}
```

- The macro keyword states that the line is a macro definition. It includes the name of the macro as well as the parameters.
- The code of the macro itself goes between 2 statement delimiters. The second statement delimiter contains an endmacro keyword.
- In the code, we can access the macro parameters using expression delimiters.
- The macro returns the code we've defined rather than a specific value.

Here's how we use the macro:

```
select
    {{ get_payment_type_description('payment-type') }} as payment_type_description,
    congestion_surcharge::double precision
from {{ source('staging','green_tripdata') }}
where vendorid is not null
```

- We pass a payment-type variable which may be an integer from 1 to 6.

And this is what it would compile to:

```
select
    case payment_type
        when 1 then 'Credit card'
        when 2 then 'Cash'
        when 3 then 'No charge'
        when 4 then 'Dispute'
        when 5 then 'Unknown'
        when 6 then 'Voided trip'
    end as payment_type_description,
    congestion_surcharge::double precision
from {{ source('staging','green_tripdata') }}
where vendorid is not null
```

- The macro is replaced by the code contained within the macro definition as well as any variables that we may have passed to the macro parameters.


### Packages

Macros can be exported to **packages**, similarly to how classes and functions can be exported to libraries in other languages. Packages contain standalone dbt projects with models and macros that tackle a specific problem area.

When we add a package to our project, the package's models and macros become part of our own project. A list of useful packages can be found in the dbt package hub.

To use a package, we must first create a packages.yml file in the root of our work directory. Here's an example:

```
packages:
  - package: dbt-labs/dbt_utils
    version: 0.8.0
```

After declaring our packages, we need to install them by running the dbt deps command either locally or on dbt Cloud.

we may access macros inside a package in a similar way to how Python access class methods:

```
select
    {{ dbt_utils.surrogate_key(['vendorid', 'lpep_pickup_datetime']) }} as tripid,
    cast(vendorid as integer) as vendorid,
    -- ...
```

- The surrogate_key() macro generates a hashed surrogate key with the specified fields in the arguments.


### Variables

Like most other programming languages, **variables** can be defined and used across our project.
Variables can be defined in 2 different ways:

- Under the vars keyword inside dbt_project.yml.

```
vars:
    payment_type_values: [1, 2, 3, 4, 5, 6]
```

- As arguments when building or running our project.

```
dbt build --m <our-model.sql> --vars 'is_test_run: false'
```

Variables can be used with the var() macro. For example:

```
{% if var('is_test_run', default=true) %}

    limit 100

{% endif %}
```

- In this example, the default value for is_test_run is true; in the absence of a variable definition either on the dbt_project.yml file or when running the project, then is_test_run would be true.
- Since we passed the value false when runnning dbt build, then the if statement would evaluate to false and the code within would not run.


# Setting up dbt Cloud IDE + GCP BigQuery

We will need to create a dbt cloud using [this link](https://www.getdbt.com/signup/) and connect to our Data Warehouse following [these instructions](https://docs.getdbt.com/docs/dbt-cloud/cloud-configuring-dbt-cloud/cloud-setting-up-bigquery-oauth). More detailed instructions available in [this guide](https://docs.getdbt.com/guides/bigquery?step=1)

[My dbt Cloud IDE + BigQuery setup and testing]([https://github.com/garjita63/de-zoomcamp-2024/blob/f20803245ace345a017a40736ee02d19d26e285e/learning/module4/dbt-cloud-IDE-setup.md](https://github.com/garjita63/de-zoomcamp-2024/blob/main/learning/module4/dbt-cloud-bigquery.md)


# Setting up dbt on Docker + BigQuery

[My dbt-docker-bigquery link](https://github.com/garjita63/de-zoomcamp-2024/blob/main/learning/module4/dbt-docker-bigquery.md)

