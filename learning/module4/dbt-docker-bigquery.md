# Setting up dbt on Docker + BigQuery

Follow [dbt with BigQuery on Docker](https://github.com/DataTalksClub/data-engineering-zoomcamp/tree/main/04-analytics-engineering/docker_setup)

- Login to VM Linux from Windows

  ```
  wsl
  ```

- Create folder : /d/mnr/ZDE/tbtool

  ```
  mkdir /mnt/d/ZDE/dbtool
  ```
  
- Create file : /db//mnt/d/ZDE/dbtool/Dockerfile 

    ```
    ##
    #  Generic dockerfile for dbt image building.  
    #  See README for operational details
    ##
    
    # Top level build args
    ARG build_for=linux/amd64
    
    ##
    # base image (abstract)
    ##
    FROM --platform=$build_for python:3.9.9-slim-bullseye as base
    
    # N.B. The refs updated automagically every release via bumpversion
    # N.B. dbt-postgres is currently found in the core codebase so a value of dbt-core@<some_version> is correct
    
    ARG dbt_core_ref=dbt-core@v1.0.1
    ARG dbt_postgres_ref=dbt-core@v1.0.1
    ARG dbt_redshift_ref=dbt-redshift@v1.0.0
    ARG dbt_bigquery_ref=dbt-bigquery@v1.0.0
    ARG dbt_snowflake_ref=dbt-snowflake@v1.0.0
    ARG dbt_spark_ref=dbt-spark@v1.0.0
    # special case args
    ARG dbt_spark_version=all
    ARG dbt_third_party
    
    # System setup
    RUN apt-get update \
      && apt-get dist-upgrade -y \
      && apt-get install -y --no-install-recommends \
        git \
        ssh-client \
        software-properties-common \
        make \
        build-essential \
        ca-certificates \
        libpq-dev \
      && apt-get clean \
      && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/*
    
    # Env vars
    ENV PYTHONIOENCODING=utf-8
    ENV LANG=C.UTF-8
    
    # Update python
    RUN python -m pip install --upgrade pip setuptools wheel --no-cache-dir
    
    RUN python -m pip install pytz
    
    
    # Set docker basics
    WORKDIR /usr/app/dbt/
    VOLUME /usr/app
    ENTRYPOINT ["dbt"]
    
    ##
    # dbt-core
    ##
    FROM base as dbt-core
    RUN python -m pip install --no-cache-dir "git+https://github.com/dbt-labs/${dbt_core_ref}#egg=dbt-core&subdirectory=core"
    
    ##
    # dbt-postgres
    ##
    FROM base as dbt-postgres
    RUN python -m pip install --no-cache-dir "git+https://github.com/dbt-labs/${dbt_postgres_ref}#egg=dbt-postgres&subdirectory=plugins/postgres"
    
    
    ##
    # dbt-redshift
    ##
    FROM base as dbt-redshift
    RUN python -m pip install --no-cache-dir "git+https://github.com/dbt-labs/${dbt_redshift_ref}#egg=dbt-redshift"
    
    
    ##
    # dbt-bigquery
    ##
    FROM base as dbt-bigquery
    RUN python -m pip install --no-cache-dir "git+https://github.com/dbt-labs/${dbt_bigquery_ref}#egg=dbt-bigquery"
    
    
    ##
    # dbt-snowflake
    ##
    FROM base as dbt-snowflake
    RUN python -m pip install --no-cache-dir "git+https://github.com/dbt-labs/${dbt_snowflake_ref}#egg=dbt-snowflake"
    
    ##
    # dbt-spark
    ##
    FROM base as dbt-spark
    RUN apt-get update \
      && apt-get dist-upgrade -y \
      && apt-get install -y --no-install-recommends \
        python-dev \
        libsasl2-dev \
        gcc \
        unixodbc-dev \
      && apt-get clean \
      && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/*
    RUN python -m pip install --no-cache-dir "git+https://github.com/dbt-labs/${dbt_spark_ref}#egg=dbt-spark[${dbt_spark_version}]"
    
    
    ##
    # dbt-third-party
    ##
    FROM dbt-core as dbt-third-party
    RUN python -m pip install --no-cache-dir "${dbt_third_party}"
    
    ##
    # dbt-all
    ##
    FROM base as dbt-all
    RUN apt-get update \
      && apt-get dist-upgrade -y \
      && apt-get install -y --no-install-recommends \
        python-dev \
        libsasl2-dev \
        gcc \
        unixodbc-dev \
      && apt-get clean \
      && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/*
      RUN python -m pip install --no-cache "git+https://github.com/dbt-labs/${dbt_redshift_ref}#egg=dbt-redshift"
      RUN python -m pip install --no-cache "git+https://github.com/dbt-labs/${dbt_bigquery_ref}#egg=dbt-bigquery"
      RUN python -m pip install --no-cache "git+https://github.com/dbt-labs/${dbt_snowflake_ref}#egg=dbt-snowflake"
      RUN python -m pip install --no-cache "git+https://github.com/dbt-labs/${dbt_spark_ref}#egg=dbt-spark[${dbt_spark_version}]"
      RUN python -m pip install --no-cache "git+https://github.com/dbt-labs/${dbt_postgres_ref}#egg=dbt-postgres&subdirectory=plugins/postgres"
    ```

- Create file : /mnt/d/ZDE/dbtool/docker-compose.yaml

    ```
    version: '3'
    services:
      dbt-bq-dtc:
        build:
          context: .
          target: dbt-bigquery
        image: dbt/bigquery
        volumes:
          - .:/usr/app
          - ~/.dbt:/root/.dbt/
          - ~/.google/credentials/google_credentials.json:/.google/credentials/google_credentials.json
        ports:
          - "8080:8080"
    ```

- Create file : /root/.dbt/profiles.yml 

    ```
    bq-dbt-workshop:
      outputs:
        dev:
          dataset: dbt_ny_taxi
          fixed_retries: 1
          keyfile: /.google/credentials/google_credentials.json
          location: asia-southeast2
          method: service-account
          priority: interactive
          project: dtc-de-course-2024-411803
          threads: 4
          timeout_seconds: 300
          type: bigquery
      target: dev
    ```

- Build images

  ```
  docker compose build
  ```

- Create container

  ```  
  docker compose run dbt-bq-dtc init
  ```

- Run container

  ```
  docker compose run --workdir="//usr/app/dbt/taxi_rides_ny" dbt-bq-dtc debug
  ```

- Login to container

  ```
  docker start dbtool-dbt-bq-dtc-run
  docker ps
  docker exec -it dbtool-dbt-bq-dtc-run bash

  dbt --version

  cd taxi_rides_ny

  -- Load the CSVs into the database. This materializes the CSVs as tables in target schema
  dbt seed

  -- Run the models:
  dbt run

  -- Test data
  dbt test

  -- Alternative: use dbt build to execute with one command the 3 steps above together
  dbt buiild

  -- Generate documentation for the project
  dbt docs generate

  ```

  dbt version

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/01b1f2a6-65ec-45ce-bed3-b0dd4b7c0e6a)

  dbt seed

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/3017cf96-41a1-406c-a9fa-964367b33ae5)

  dbt run

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/e5bd1ce9-0016-4b32-b178-165811f39aea)

  dbt test

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/641d738b-ffe9-4e4b-98e4-a9f9d466fc06)

  dbt docs generate

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/76fc639d-d27f-4d75-9864-cecb0d1c9bed)

 

