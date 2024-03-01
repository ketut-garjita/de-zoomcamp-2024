## 1. Installations

Check Linux version:

```
lsb_release -a
```
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/f8baee72-7a37-4310-b432-e0377214ac05)



### 1.1 Java

- Download the following Java 11.0.22 version from link https://www.oracle.com/id/java/technologies/downloads/#java11/

**jdk-11.0.22_linux-x64_bin.tar.gz**

- Unzip (untar) file
  ```
  tar –xvzf jdk-11.0.22_linux-x64_bin.tar.gz
  ```

- Check Java version
  ```
  java -version
  ```
  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/9bbc1eb1-3bc1-46a5-be14-a7b022224e91)

- Add JAVA_HOME & edit PATH to ~/.bashrc file

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/937407c0-167a-485a-87bc-b5c5ddaf71e5)

- source ~/.bashrc
  ```
  source ~/.bashrc
  ```
  
### 1.2 Apache Spark

- Download Apache Spark
  
  We suggest the following location for your download:

  https://dlcdn.apache.org/spark/spark-3.4.2/spark-3.4.2-bin-hadoop3.tgz

- Unzip (untar) file

  tar -xvzf spark-3.4.2-bin-hadoop3.tgz

- Add SPARK_HOME & edit PATH to ~/.bashrc
  
  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/c3a72508-ee0c-4abc-96eb-ded67dbea56f)
 
- Check spark, pyspark versions

  Scala
  ```
  spark-shell
  ```
  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/6b00f8d8-0749-4baa-b014-4b8cd78cd4b5)

  Python
  ```
  pyspark
  ```
  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/eb49e5fe-97f2-4a35-a026-eab283929b82)

  SQL
  ```
  spark-sql
  ```
  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/5690c6a5-5a87-46ce-955e-f4bc46f49bf0)
  
  R
  
  For sparkR, we have install R language before using sparkR.
  ```
  sudo apt install r-base
  ```
  Run sparkR
  ```
  sparkR
  ```
  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/08f00f2e-5a4e-4a68-890f-1c7f98ab83f5)


### 1.3 GCP Cloud

- Create a project
  - IAM & Admin > New Project
    
    ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/291a1c47-d692-45eb-a306-594a7c39507f)

  - Create Service Account
    
    ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/aa6511f9-3e60-470f-8b78-ef339b91ccd4)

    Region : asia-southeast2

    Zone : asia-southeast2-a

    Assign Roles like this:

    ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/a9dcadaa-5aba-491e-bb77-0e884a936f7b)

  - Create Bucket

    ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/61388a27-3d6c-4042-be22-a97866aa1ed2)

- Try copy file into bucket
    ```
    gsutil cp green_tripdata_2020-01.csv.gz gs://<bucket name>
    ```
  
  - Create Dataproc Cluster
 
    Using cosnole:
    
    ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/68dabfc4-87ae-4572-8987-5eab8d077a9a)

    Or using gcloud command:
    ```
    gcloud config set compute/region asia-southeast2
    gcloud config set compute/zone asia-southeast2-c
    
    CLUSTER=<cluster name>
    PROJECT=<project name>
    REGION=<rgeion name>
    ZONE=<zone name>
    
    gcloud dataproc clusters create ${CLUSTER} --project=${PROJECT} --region=${REGION} --zone=${ZONE} --single-node
    ```
    
- Open port 8080 (for spark master), 7077 (for spark worker)

  Using console

  Select project > Firewall policies > Create Firewall Policies

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/19881d70-8257-4a51-904a-384f3bb16ca8)

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/9d9cb793-ece3-405c-94ca-b0f82839619e)

  Using gcloud command
  ```
  gcloud config set project <project name>

  gcloud compute firewall-rules create allow-8088 --allow=tcp:8080 --description="Allow incoming traffic on TCP port 8080" --direction=INGRESS

  gcloud compute firewall-rules create allow-7077 --allow=tcp:7077 --description="Allow incoming traffic on TCP port 7077" --direction=INGRESS
  ```
    
    
