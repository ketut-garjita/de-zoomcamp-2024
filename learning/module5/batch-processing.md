## 5.1 Introduction

  ### Introduction to Batch Processing

  Batch jobs are routines that are run in regular intervals. 

  The most common types of batch jobs are either :
  - daily
  - two times a day
  - hourly
  - every 5 mnutes
  - etc..

  ### Introduction to Apache Spark

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


### Java

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
  
### Apache Spark

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


### GCP Cloud

#### Create a project

IAM & Admin > New Project
    
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/291a1c47-d692-45eb-a306-594a7c39507f)

#### Create Service Account
    
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/aa6511f9-3e60-470f-8b78-ef339b91ccd4)

Region : asia-southeast2
    
Zone : asia-southeast2-a
   
Assign Roles like this:
    
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/a9dcadaa-5aba-491e-bb77-0e884a936f7b)

#### Create Bucket
     
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/61388a27-3d6c-4042-be22-a97866aa1ed2)
     
- Try copy file into bucket
  ```
  gsutil cp green_tripdata_2020-01.csv.gz gs://<bucket name>
  ```
       
#### Create Dataproc Cluster
    
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

#### Create VM Instance

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/7134b60c-7206-4ad9-bf71-3f4f9e058f7d)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/7621eabe-376a-4b01-9ee5-e549ad51b7b9)

Start VM Instance, and copy & save External IP. This external IP would be used to open spark master browser in local machine, i.e. https://<VM Instance External IP>:8080
           
#### Open port 8080 (for spark master), 7077 (for spark worker)
     
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

**Step 2 : Creating a Spark session**

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


**Step 2 : Reading CSV File**

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

  <code style="color:green">df.show()</code> or <code style="color:green">df.head()</code> --> contents of the dataframe

  <code style="color:green">df.schema</code> or <code style="color:green">df.printSchema()</code> --> dataframe schema

**Step 3 : Check the inferred schema through df.schema**

```
from pyspark.sql import types
schema = types.StructType(
    [
        types.StructField('hvfhs_license_num', types.StringType(), True),
        types.StructField('dispatching_base_num', types.StringType(), True),
        types.StructField('pickup_datetime', types.TimestampType(), True),
        types.StructField('dropoff_datetime', types.TimestampType(), True),
        types.StructField('PULocationID', types.IntegerType(), True),
        types.StructField('DOLocationID', types.IntegerType(), True),
        types.StructField('SR_Flag', types.IntegerType(), True)
    ]
)

df = spark.read \
    .option("header", "true") \
    .option("inferSchema",True) \
    .csv('fhvhv_tripdata_2021-01.csv.gz')

df.schema
```

**Step 4 : Save DataFrame as parquet**

As explained by the instructor, it is not good to have a smaller number of files than CPUs (because only a subset of CPUs will be used and the remaining will be idle). For such, we first use the repartition method and then save the data as parquet. Suppose we have 8 cores, then we can repartition our dataset into 24 parts.

```
df = df.repartition(24)
df.write.parquet('fhvhv/2021/01/')
```
```
!ls -lh fhvhv/2021/01/
```
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/b9017838-2674-4c83-af08-9072690ed012)


### 5.3.2 Spark DataFrames

Create a dataframe from the parquet files.
```
df = spark.read.parquet('fhvhv/2021/01/')
```
Check the schema
```
df.printSchema()
```
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/dfc5030f-21da-44bf-88a9-9e899edb7a46)

select() with filter()
```
df.select('pickup_datetime', 'dropoff_datetime', 'PULocationID', 'DOLocationID') \
    .filter(df.hvfhs_license_num == 'HV0003')
```

**Actions vs. Transformations**

Action : code that is executed immediately (such as: show(), take(), head(), write(), etc.)

Transformations : code that is lazy, i.e., not executed immediately (suchs as: selecting columns, data filtering, joins and groupby operations)

**Spark SQL Functions**

Spark has many predefined SQL-like functions.
```
def crazy_stuff(base_num):
    num = int(base_num[1:])
    if num % 7 == 0:
        return f's/{num:03x}'
    elif num % 3 == 0:
        return f'a/{num:03x}'
    return f'e/{num:03x}'

crazy_stuff_udf = F.udf(crazy_stuff, returnType=types.StringType())

df \
    .withColumn('pickup_date', F.to_date(df.pickup_datetime)) \
    .withColumn('dropoff_date', F.to_date(df.dropoff_datetime)) \
    .withColumn('base_id', crazy_stuff_udf(df.dispatching_base_num)) \
    .select('base_id', 'pickup_date', 'dropoff_date', 'PULocationID', 'DOLocationID') \
    .show()
```

###  5.3.3 (Optional) Preparing Yellow and Green Taxi Data

See : 

https://github.com/garjita63/de-zoomcamp-2024/blob/main/learning/module5/04_pyspark_yellow.ipynb

https://github.com/garjita63/de-zoomcamp-2024/blob/main/learning/module5/04_pyspark_green.ipynb


### 5.3.4 SQL with Spark

Batch jobs can be expressed as SQL queries, and Spark can run them.

See :

https://github.com/garjita63/de-zoomcamp-2024/blob/main/learning/module5/06_spark_sql.ipynb


## 5.4  Spark Internals

### 5.4.1  Anatomy of a Spark Cluster

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/aefe64d8-d64c-4441-a35a-72757dc1ec5a)

Apache Spark is considered as a powerful complement to Hadoop, big data’s original technology. Spark is a more accessible, powerful, and capable big data tool for tackling various big data challenges. It has become mainstream and the most in-demand big data framework across all major industries. Spark has become part of the Hadoop since 2.0. And is one of the most useful technologies for Python Big Data Engineers.

#### Architecture

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/05ef400d-12dc-4b0c-ba09-cdb0c7c1c6a1)

The components of the spark application are:
- Driver
- Application Master
- Spark Context
- Cluster Resource Manager(aka Cluster Manager)
- Executors
- 
Spark uses a master/slave architecture with a central coordinator called Driver and a set of executable workflows called Executors that are located at various nodes in the cluster.

##### Driver

The Driver(aka driver program) is responsible for converting a user application to smaller execution units called tasks and then schedules them to run with a cluster manager on executors. The driver is also responsible for executing the Spark application and returning the status/results to the user.

Spark Driver contains various components – DAGScheduler, TaskScheduler, BackendScheduler and BlockManager. They are responsible for the translation of user code into actual Spark jobs executed on the cluster.

Other Driver properties:
- can run in an independent process or on one of the work nodes for High Availability (HA);
- stores metadata about all Resilient Distributed Databases and their partitions;
- is created after the user sends the Spark application to the cluster manager (YARN in our case);
- runs in its own JVM;
- optimizes logical DAG transformations and, if possible, combines them in stages and determines the best location for execution of this DAG;
- creates Spark WebUI with detailed information about the application;

##### Application Master

Application Master is a framework-specific entity charged with negotiating resources with ResourceManager(s) and working with NodeManager(s) to perform and monitor application tasks. Each application running on the cluster has its own, dedicated Application Master instance.

Spark Master is created simultaneously with Driver on the same node (in case of cluster mode) when a user submits the Spark application using spark-submit.

The Driver informs the Application Master of the executor's needs for the application, and the Application Master negotiates the resources with the Resource Manager to host these executors.

In offline mode, the Spark Master acts as Cluster Manager.

##### Spark Context

Spark Context is the main entry point into Spark functionality, and therefore the heart of any Spark application. It allows Spark Driver to access the cluster through its Cluster Resource Manager and can be used to create RDDs, accumulators and broadcast variables on the cluster. Spark Context also tracks executors in real-time by sending regular heartbeat messages.

Spark Context is created by Spark Driver for each Spark application when it is first submitted by the user. It exists throughout the lifetime of the Spark application.

Spark Context stops working after the Spark application is finished. For each JVM only one Spark Context can be active. You must stop()activate Spark Context before creating a new one.

##### Cluster Resource Manager

Cluster Manager in a distributed Spark application is a process that controls, governs, and reserves computing resources in the form of containers on the cluster. These containers are reserved by request of Application Master and are allocated to Application Master when they are released or available.

Once the containers are allocated by Cluster Manager, the Application Master transfers the container resources back to the Spark Driver, and the Spark Driver is responsible for performing the various steps and tasks of the Spark application.

SparkContext can connect to different types of Cluster Managers. Now the most popular types are YARN, Mesos, Kubernetes or even Nomad. There is also Spark's own standalone cluster manager.

Fun fact is that Mesos was also developed by the creator of Spark.

##### Executors

Executors are the processes at the worker's nodes, whose job is to complete the assigned tasks. These tasks are executed on the worker nodes and then return the result to the Spark Driver.

Executors are started once at the beginning of Spark Application and then work during all life of the application, this phenomenon is known as "Static Allocation of Executors". However, users can also choose to dynamically allocate executors where they can add or remove executors to Spark dynamically to match the overall workload (but this can affect other applications running on the cluster). Even if one Spark executor crashes, the Spark application can continue to work.

Performers provide storage either in-memory for RDD partitions that are cached (locally) in Spark applications (via BlockManager) or on disk while using localCheckpoint.

Other executor properties:
- stores data in a cache in a JVM heap or on disk
- reads data from external sources
- writes data to external sources
- performs all data processing

```
from pyspark.sql import SparkSession
from pyspark.conf import SparkConf
from pyspark.context import SparkContext

appName = "PythonWordCount"
master = "local"

# initialization of spark context
conf = SparkConf().setAppName(appName).setMaster(master) 

sc = SparkContext(conf=conf)

spark = SparkSession.builder \
    .config(conf=sc.getConf()) \
    .getOrCreate()

# read data from text file, as a result we get RDD of lines
linesRDD = spark.sparkContext.textFile("/mnt/d/apache/spark-3.4.2-bin-hadoop3/README.md")

# from RDD of lines create RDD of lists of words 
wordsRDD = linesRDD.flatMap(lambda line: line.split(" "))

# from RDD of lists of words make RDD of words tuples where 
# the first element is a word and the second is counter, at the
# beginning it should be 1
wordCountRDD= wordsRDD.map(lambda word: (word, 1))

# combine elements with the same word value
resultRDD = wordCountRDD.reduceByKey(lambda a, b: a + b)

# write it back to folder
resultRDD.saveAsTextFile("PythonWordCount")
spark.stop()                            
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/45846cfe-831d-4927-83a5-fe87c1c39584)

1. When we send the Spark application in cluster mode, the spark-submit utility communicates with the Cluster Resource Manager to start the Application Master.

2. The Resource Manager is then held responsible for selecting the necessary container in which to run the Application Master. The Resource Manager then tells a specific Node Manager to launch the Application Master.

3. The Application Master registers with the Resource Manager. Registration allows the client program to request information from the Resource Manager, that information allows the client program to communicate directly with its own Application Master.

4. The Spark Driver then runs on the Application Master container (in case of cluster mode).

5. The driver implicitly converts user code containing transformations and actions into a logical plan called a DAG. All RDDs are created in the driver and do nothing until the action is called. At this stage, the driver also performs optimizations such as pipelining narrow transformations.

6. It then converts the DAG into a physical execution plan. After conversion to a physical execution plan, the driver creates physical execution units called tasks at each stage.

7. The Application Master now communicates with the Cluster Manager and negotiates resources. Cluster Manager allocates containers and asks the appropriate NodeManagers to run the executors on all selected containers. When executors run, they register with the Driver. This way, the Driver has a complete view of the artists.

8. At this point, the Driver will send tasks to executors via Cluster Manager based on the data placement.

9. The code of the user application is launched inside the container. It provides information (stage of execution, status) to the Application Master.

10. At this stage, we will start to execute our code. Our first RDD will be created by reading data in parallel from HDFS to different partitions on different nodes based on HDFS InputFormat. Thus, each node will have a subset of data.

11. After reading the data we have two map transformations which will be executed in parallel on each partition.

12. Next, we have a reduceByKey transformation, it is not a narrow transformation like map, so it will create an additional stage. It combines records with the same keys, then moves data between nodes (shuffle) and partitions to combine the keys of the same record.

13. We then perform an action — write back to HDFS which will trigger the entire DAG execution.

14. During the execution of the user application, the client communicates with the Application Master to obtain the application status.

15. When the application finishes executing and all of the necessary work is done, the Application Master disconnects itself from the Resource Manager and stops, freeing up its container for other purposes.


### 5.4.2 GroupBy in Spark

See:

https://github.com/garjita63/de-zoomcamp-2024/blob/main/learning/module5/07_groupby_join.ipynb


### 5.4.3 Joins in Spark

See:

https://github.com/garjita63/de-zoomcamp-2024/blob/main/learning/module5/07_groupby_join.ipynb


## 5.5 (Optional) Resilient Distributed Datasets

See :

https://github.com/garjita63/de-zoomcamp-2024/blob/main/learning/module5/08_rdds.ipynb


## 5.6 Running Spark in the Cloud

### 5.6.1 Connecting to Google Cloud Storage

See :

https://github.com/garjita63/de-zoomcamp-2024/blob/main/learning/module5/09_spark_gcs.ipynb

### 5.6.2 Creating a Local Spark Cluster
- Stop all kernels icnluding Jupyter Notebook conenctions
- Star Spark Master
  ```
  start-master.sh
  ```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/64d7a807-2592-451c-9865-e7743ed01ee1)

- Open WebUI : http://localhost:8080/

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/1f7da3bd-b035-4e31-b637-76904aa0e686)

- Start Worker
  ```
  start-worker.sh spark://Desktop-Gar.:7077
  ```

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/f9c436f5-a775-4a17-91d0-345408158f71)

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/d57c38f8-bad4-47e6-9bb7-ed4895003034)

  Change :
  ```
  # Instance a session

  spark = SparkSession.builder \
    .master("local[*]") \
    .appName('test') \
    .getOrCreate()
  ```
  into :
  ```
  # Instance a session

  spark = SparkSession.builder \
    .master("spark://Desktop-Gar.:7077") \
    .appName('test') \
    .getOrCreate()
  ```
  
  ```
  #  stop spark worker and spark master
  
  ./spark-3.2.1-bin-hadoop3.2/sbin/stop-worker.sh
  ./spark-3.2.1-bin-hadoop3.2/sbin/stop-master.sh
  ```

  ### 5.6.3 Setting up a Dataproc Cluster

  Step 1: create cluster

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/c7e31610-4ef0-4465-a28c-d642cf7b0e8e)

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/9d5763b6-ab39-4458-837b-1b0d2c804104)

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/38f5e3a9-7701-4df3-aba5-5a4a50cb7431)

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/2763f2b7-6444-4567-957e-18399bbaf541)

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/4930cf8d-7335-4507-b3cc-443a18be570e)


  ###  5.6.4 Connecting Spark to Big Query

  Step 1: in this lesson, we are going to write our results to BigQuer

  
