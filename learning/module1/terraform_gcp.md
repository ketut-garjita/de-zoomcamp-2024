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
