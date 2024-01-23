# DTC (Data Talks Club) Data Engineering Zoomcamp 2024
### Week 1 : 01-docker-terraform

## LEARNING

## 1_terraform_gcp

main.tf
```
terraform {
  required_providers {  
    google = {    
      source  = "hashicorp/google"      
      version = "5.11.0"      
    }    
  }  
}

provider "google" {
  credentials = file(var.credentials)  
  project     = var.project  
  region      = var.region  
}

resource "google_storage_bucket" "demo-bucket" {
  name          = var.gcs_bucket_name
  location      = var.location
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_bigquery_dataset" "demo_dataset" {
  dataset_id = var.bq_dataset_name
  location   = var.location
}
```

variables.tf
```
variable "credentials" {
  description = "My Credentials"
  default     = "./keys/my-creds.json"
}

variable "project" {
  description = "Project"
  default     = "terraform-demo-411405"
}

variable "region" {
  description = "Region"
  default     = "ASIA"
}

variable "location" {
  description = "Project Location"
  default     = "asia-southeast2"
}

variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  default     = "demo_dataset"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  default     = "terraform-demo-411405-terra-bucket"
}

variable "gcs_storage_class" {
  description = "Backet Storage Class"
  default     = "STANDARD"
}
```


## 2_docker_sql

### - Installation

- Docker Desktop : https://docs.docker.com/desktop/
  
- Python 3.9
```
  docker pull python:3.9
```
- Postgres 13
```
  docker pull postgres:13
```
- pgAdmin
```
  docker pull dpage/pgadmin4
```

### - Setup Postgres and pgAdmin without Docker-Compose
####	Running Postgres and pgAdmin together in same network

- Create a network
  
  ```
  docker network create pg-network
  docker netwrok ls
  ```

- Run Postgres (change the path in -v variable)
  ```
	docker run -it \
		-e POSTGRES_USER="root" \
		-e POSTGRES_PASSWORD="root" \
		-e POSTGRES_DB="ny_taxi" \
		-v /app/zoomcamp/data-engineering-zoomcamp/01-docker-terraform/2_docker_sql/ny_taxi_postgres_data:/var/lib/postgresql/13/main \
		-p 5432:5432 \
		--network=pg-network \
		--name pg-database \
		postgres:13
	```

- Run pgAdmin
  ```
	docker run -it \
		-e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
		-e PGADMIN_DEFAULT_PASSWORD="root" \
		-p 8080:80 \
		--network=pg-network \
		--name pgadmin \
		dpage/pgadmin4
  ```
      
- Build the image (using Dockerfile)
  ```
	docker build -t taxi_ingest:v001 .
  ```
- Data ingestion
	Run the script with Docker
  ```	
	URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"
  
	docker run -it --network=pg-network taxi_ingest:v001 \
			--user=root \
			--password=root \
			--host=pg-database \
			--port=5432 \
			--db=ny_taxi \
			--table_name=yellow_taxi_trips \
			--url=${URL}
  ```

-	Check table
  	```
	docker exec -it pg-database psql -U root -d ny_taxi --password
  	Password: 
	select count(*) from yellow_taxi_trips;
  	```

- Stop database and pgAdmin dockers
  	```
	docker stop pg-database
	docker stop pgadmin
 	 ```

### - Setup Postgres and pgAdmin with Docker-Compose (.yaml file)

- Run it:
  	```
	docker-compose up
  	```

- Network list
  ```
  docker network ls
	```
  
- Check NetworkMode being used by the database
  ```
	docker inspect garzoomcamp2024_pgdatabase_1 | grep NetworkMode
  ```
						
- Load data to pgdatabase (yellow_taxi_trips table)
  
  ```
	URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"

	docker run -it --network=garzoomcamp2024_default \
		taxi_ingest:v001 \
			--user=root \
			--password=root \
			--host=garzoomcamp2024_pgdatabase_1 \
			--port=5432 \
			--db=ny_taxi \
			--table_name=yellow_taxi_trips \
			--url=${URL}
  ```

- Check table
  ```
  docker exec -it garzoomcamp2024_pgdatabase_1 psql -U root -d ny_taxi --password
  Password:
  select count(*) from yellow_taxi_trips;
  ```

### - Next another table ingestion

- Build the image for taxi_ingest_2.sql (using Dockerfile).

  This image for upload green_taxi_trips table (ingest_data_2.py)
	
	- Modify Dockerfile:

		FROM python:3.9

		RUN apt-get install wget
		RUN pip install pandas sqlalchemy psycopg2

		WORKDIR /app
		COPY ingest_data_2.py ingest_data_2.py

		ENTRYPOINT [ "python", "ingest_data_2.py" ]

- Build image
  
		docker build -t taxi_ingest:v002 .

- Load data to pgdatabase (green_taxi_trips table)
	 ```
	URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-09.csv.gz"
	docker run -it --network=garzoomcamp2024_default \
		taxi_ingest:v002 \
			--user=root \
			--password=root \
			--host=garzoomcamp2024_pgdatabase_1 \
			--port=5432 \
			--db=ny_taxi \
			--table_name=green_taxi_trips \
			--url=${URL}
  	```

- Check table
  ```
  docker exec -it 2_docker_sql_pgdatabase_1 psql -U root -d ny_taxi --password
  Password:
  select count(*) from green_taxi_trips ;
  ```


## HOMEWORK

Questions : https://courses.datatalks.club/de-zoomcamp-2024/homework/hw01

Homework 1: Pre-Requisites (Docker, Terraform, SQL) for Data Engineering Zoomcamp 2024
In this homework we'll prepare the environment and practice with Docker and SQL. More information here: https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/cohorts/2024/01-docker-terraform/homework.md If none of the options match, select the closest one.

Questions
Question 1. Docker tags


--delete

--rc

--rmc

--rm
Question 2. Docker run: version of wheel


0.42.0

1.0.0

23.0.1

58.1.0
Question 3. Count records


15767

15612

15859

89009
Question 4. Largest trip for each day


2019-09-18

2019-09-16

2019-09-26

2019-09-21
Question 5. Three biggest pickups


"Brooklyn" "Manhattan" "Queens"

"Bronx" "Brooklyn" "Manhattan"

"Bronx" "Manhattan" "Queens"

"Brooklyn" "Queens" "Staten Island"
Question 6. Largest tip


Central Park

Jamaica

JFK Airport

Long Island City/Queens Plaza
Question 7. Terraform

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following      symbols:   + create  Terraform will perform the following actions:    # google_bigquery_dataset.demo_dataset will be created   + resource "google_bigquery_dataset" "demo_dataset" {       + creation_time              = (known after apply)       + dataset_id                 = "demo_dataset"       + default_collation          = (known after apply)       + delete_contents_on_destroy = false       + effective_labels           = (known after apply)       + etag                       = (known after apply)       + id                         = (known after apply)       + is_case_insensitive        = (known after apply)       + last_modified_time         = (known after apply)       + location                   = "asia-southeast2"       + max_time_travel_hours      = (known after apply)       + project                    = "terraform-demo-411405"       + self_link                  = (known after apply)       + storage_billing_model      = (known after apply)       + terraform_labels           = (known after apply)     }    # google_storage_bucket.demo-bucket will be created   + resource "google_storage_bucket" "demo-bucket" {       + effective_labels            = (known after apply)       + force_destroy               = true       + id                          = (known after apply)       + location                    = "ASIA-SOUTHEAST2"       + name                        = "terraform-demo-411405-terra-bucket"       + project                     = (known after apply)       + public_access_prevention    = (known after apply)       + rpo                         = (known after apply)       + self_link                   = (known after apply)       + storage_class               = "STANDARD"       + terraform_labels            = (known after apply)       + uniform_bucket_level_access = (known after apply)       + url                         = (known after apply)        + lifecycle_rule {           + action {               + type = "AbortIncompleteMultipartUpload"             }           + condition {               + age                   = 1               + matches_prefix        = []               + matches_storage_class = []               + matches_suffix        = []               + with_state            = (known after apply)             }         }     }  Plan: 2 to add, 0 to change, 0 to destroy.  Do you want to perform these actions?   Terraform will perform the actions described above.   Only 'yes' will be accepted to approve.    Enter a value: yes  google_bigquery_dataset.demo_dataset: Creating... google_storage_bucket.demo-bucket: Creating... google_storage_bucket.demo-bucket: Creation complete after 2s [id=terraform-demo-411405-terra-bucket] google_bigquery_dataset.demo_dataset: Creation complete after 4s [id=projects/terraform-demo-411405/datasets/demo_dataset]  Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
Homework URL 
https://github.com/garjita63/GarZoomcamp2024
Learning in public links (optional) 
Time spent on lectures (hours) (optional) 
Time spent on homework (hours) (optional) 
Problems or comments (optional)
FAQ contribution (FAQ document, optional) 
Last submission at: January 22, 2024 15:14

DataTalks.Club, Course Management Platform on GitHub (version 20240122-161607-f062565)

Solutions : https://github.com/garjita63/de-zoomcamp-2024/blob/main/homework1.ipynb
