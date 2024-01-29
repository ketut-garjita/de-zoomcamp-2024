# DTC (Data Talks Club) Data Engineering Zoomcamp 2024
### Week 1 : 01-docker-terraform

## LEARNING

## 1_terraform_gcp

### Pre-Requisites

Terraform client installation: https://www.terraform.io/downloads
- Put terraform.exe file in Terraform Home or in $PATH environment
  
Cloud Provider account: https://console.cloud.google.com/
- Create New Project
- Create Project Service Account (IAM & Admin --> Service Account)
- Assign Roles : BigQuery Admin, Compute Admin, Storage Admin
- Create new key, then upload and save to local directory


### Terraform file structure
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/3d39b819-4cab-4f11-a844-49491e3d1555)


### main.tf

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

### variables.tf

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


### Execution
#### Refresh service-account's auth-token for this session
```
gcloud auth application-default login
```

#### Initialize state file (.tfstate)
```
terraform init
```
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/a5bc06c5-4a54-450f-85d3-c19bef2a9dd5)

#### Check changes to new infra plan
```
terraform plan
```
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/9ade04cd-e767-464b-86a7-e46314b2198c)

#### Create new infra
```
terraform apply
```
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/8d7c612f-2866-4d6c-8017-7635da52b469)

Check bucket on google storage

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/cee940d8-399b-4d5d-8ec1-1fe89cff39c6)

#### Delete infra after your work, to avoid costs on any running services
```
terraform destroy
```
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/9a51f967-bb04-4044-8e5f-f867149a388f)


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
- Data ingestion - Run the script with Docker
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

### Test connection Postgres through Jupyter Notebook
- https://github.com/garjita63/de-zoomcamp-2024/blob/19a4fb71b4a210688ba01a08e36814a6ae43f2b4/pg-test-connection.ipynb
  
### Test Upload Data to Postgres through Jupyter Notebook
- https://github.com/garjita63/de-zoomcamp-2024/blob/8eaba2cfb8770032ff8352bfadebc7127f9f4b1a/upload-data.ipynb
  
  

## HOMEWORK

Questions : https://courses.datatalks.club/de-zoomcamp-2024/homework/hw01

Solution : https://github.com/garjita63/de-zoomcamp-2024/blob/a1607fbef5d5d4b7ffc1a05209bdd43e8f4d5d3a/HW-01-solution.ipynb
