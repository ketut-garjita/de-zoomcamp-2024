## 5.1 Introduction

### 5.1.1 Introduction to Batch Processing

Batch jobs are routines that are run in regular intervals. 

The most common types of batch jobs are either :
- daily
- two times a day
- hourly
- every 5 mnutes
- etc..


### 5.1.2 Introduction to Apache Spark

- What is Spark?

  Apache Spark is an open-source, distributed processing system used for big data workloads. It utilizes in-memory caching, and optimized query execution for fast analytic queries against data of any size. It provides development APIs in Java, Scala, Python and R, and supports code reuse across multiple workloads—batch processing, interactive queries, real-time analytics, machine learning, and graph processing.

- Spark Architecture
  
  Spark applications run as independent sets of processes on a cluster as described in the below diagram:

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/565bc6e3-ba5c-403c-9a1d-907b609fc382)

  These set of processes are coordinated by the SparkContext object in your main program (called the driver program). SparkContext connects to several types of cluster managers (either Spark’s own standalone cluster manager, Mesos or YARN), which allocate resources across applications.

  Once connected, Spark acquires executors on nodes in the cluster, which are processes that run computations and store data for your application.

  Next, it sends your application code (defined by JAR or Python files passed to SparkContext) to the executors. Finally, SparkContext sends tasks to the executors to run.
 
- Core Components
  
  The following diagram gives the clear picture of the different components of Spark:

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/67749334-9716-46c9-bb25-0c79ef4b5e8c)


- How does Apache Spark work?

  Hadoop MapReduce is a programming model for processing big data sets with a parallel, distributed algorithm. Developers can write massively parallelized operators, without having to worry about work distribution, and fault tolerance. However, a challenge to MapReduce is the sequential multi-step process it takes to run a job. With each step, MapReduce reads data from the cluster, performs operations, and writes the results back to HDFS. Because each step requires a disk read, and write, MapReduce jobs are slower due to the latency of disk I/O.

  Spark was created to address the limitations to MapReduce, by doing processing in-memory, reducing the number of steps in a job, and by reusing data across multiple parallel operations. With Spark, only one-step is needed where data is read into memory, operations performed, and the results written back—resulting in a much faster execution. Spark also reuses data by using an in-memory cache to greatly speed up machine learning algorithms that repeatedly call a function on the same dataset. Data re-use is accomplished through the creation of DataFrames, an abstraction over Resilient Distributed Dataset (RDD), which is a collection of objects that is cached in memory, and reused in multiple Spark operations. This dramatically lowers the latency making Spark multiple times faster than MapReduce, especially when doing machine learning, and interactive analytics.


- Key differences: Apache Spark vs. Apache Hadoop

  Outside of the differences in the design of Spark and Hadoop MapReduce, many organizations have found these big data frameworks to be complimentary, using them together to solve a broader business challenge.

  Hadoop is an open source framework that has the Hadoop Distributed File System (HDFS) as storage, YARN as a way of managing computing resources used by different applications, and an implementation of the MapReduce programming model as an execution engine. In a typical Hadoop implementation, different execution engines are also deployed such as Spark, Tez, and Presto.

  Spark is an open source framework focused on interactive query, machine learning, and real-time workloads. It does not have its own storage system, but runs analytics on other storage systems like HDFS, or other popular stores like Google Cloud Storage, Google BigQuery, Amazon Redshift, Amazon S3, and others. Spark on Hadoop leverages YARN to share a common cluster and dataset as other Hadoop engines, ensuring consistent levels of service, and response.

- What are the benefits of Apache Spark?

  There are many benefits of Apache Spark to make it one of the most active projects in the Hadoop ecosystem. These include:

  - Fast

    Through in-memory caching, and optimized query execution, Spark can run fast analytic queries against data of any size.

  - Developer friendly

    Apache Spark natively supports Java, Scala, R, and Python, giving you a variety of languages for building your applications. These APIs make it easy for your developers, because they hide the complexity of distributed processing behind simple, high-level operators that dramatically lowers the amount of code required.

  - Multiple workloads

    Apache Spark comes with the ability to run multiple workloads, including interactive queries, real-time analytics, machine learning, and graph processing. One application can combine multiple workloads seamlessly.

- How deploying Apache Spark in the cloud works?

  Spark is an ideal workload in the cloud, because the cloud provides performance, scalability, reliability, availability, and massive economies of scale. ESG research found 43% of respondents considering cloud as their primary deployment for Spark. The top reasons customers perceived the cloud as an advantage for Spark are faster time to deployment, better availability, more frequent feature/functionality updates, more elasticity, more geographic coverage, and costs linked to actual utilization.



## 5.2 Installations

Check Linux version:

```
lsb_release -a
```
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/f8baee72-7a37-4310-b432-e0377214ac05)


### 5.2.1 Java

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
  
### 5.2.2 Apache Spark

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


### 5.2.3 GCP Cloud

#### 5.2.3.1 Create a project

IAM & Admin > New Project
    
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/291a1c47-d692-45eb-a306-594a7c39507f)

#### 5.2.3.2 Create Service Account
    
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/aa6511f9-3e60-470f-8b78-ef339b91ccd4)

Region : asia-southeast2
    
Zone : asia-southeast2-a
   
Assign Roles like this:
    
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/a9dcadaa-5aba-491e-bb77-0e884a936f7b)

#### 5.2.3.3 Create Bucket
     
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/61388a27-3d6c-4042-be22-a97866aa1ed2)
     
- Try copy file into bucket
  ```
  gsutil cp green_tripdata_2020-01.csv.gz gs://<bucket name>
  ```
       
#### 5.2.3.4 Create Dataproc Cluster
    
Using console:
         
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

#### 5.2.3.5 Create VM Instance

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/7134b60c-7206-4ad9-bf71-3f4f9e058f7d)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/7621eabe-376a-4b01-9ee5-e549ad51b7b9)

Start VM Instance, and copy & save External IP. This external IP would be used to open spark master browser in local machine, i.e. https://<VM Instance External IP>:8080
           
#### 5.2.3.6 Open port 8080 (for spark master), 7077 (for spark worker)
     
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


## 5.3 Spark SQL and DataFrames

### 5.3.1 First Look at Spark/PySpark

Note: if you're running Spark and Jupyter Notebook on a remote machine, you will need to redirect ports 8888 for Jupyter Notebook and 4040 for the Spark UI.

- Creating a Spark session

Import pyspark module
```
import pyspark
from pyspark.sql import SparkSession
```

Instantiate a Spark session, an object that we use to interact with Spark.
```
spark = SparkSession.builder \
    .master("local[*]") \
    .appName('test') \
    .getOrCreate()
```

  <code style="color:green">SparkSession</code> is the class of the object that we instantiate. builder is the builder method.
  
  <code style="color:green">master()</code> sets the Spark master URL to connect to. The local string means that Spark will run on a  local cluster. [*] means that Spark will run with as many CPU cores as possible.
  
  <code style="color:green">appName()</code> defines the name of our application/session. This will show in the Spark UI.
  
  <code style="color:green">getOrCreate()</code> will create the session or recover the object if it was previously created.

Once we've instantiated a session, we can access the Spark UI by browsing to localhost:4040. The UI will display all current jobs. Since we've just created the instance, there should be no jobs currently running.

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/c1d94b13-e4cc-4cf6-8711-0ceb22518b59)


- Reading CSV File

Similarlly to Pandas, Spark can read CSV files into dataframes, a tabular data structure. Unlike Pandas, Spark can handle much bigger datasets but it's unable to infer the datatypes of each column.
```
# Download csv compresses file
!wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhvhv/fhvhv_tripdata_2021-01.csv.gz
```
```
df = spark.read \
    .option("header", "true") \
    .csv('fhvhv_tripdata_2021-01.csv.gz')
```

  <code style="color:green">read()</code> reads the file.
  
  <code style="color:green">option()</code> contains options for the read method. In this case, we're specifying that the first line of the CSV file contains the column names.
  
  <code style="color:green">csv()</code> is for reading CSV files.

Check :

  <code style="color:green">df.show()</code> or <code style="color:green">df.head()</code> --> contents of the dataframe with 

  <code style="color:green">df.schema</code> or <code style="color:green">df.printSchema()</code> --> dataframe schema



     
