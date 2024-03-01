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
  ``` 










### 1.3 GCP Cloud

