## Setup dbt cloud with BigQuery

### Create a BigQuery service account


#### Create New Project

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/6a03b9b6-e8c2-405f-8436-00d0a453edbf)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/0685a35a-70a9-42aa-82ca-01c994932ef3)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/e7427b66-388e-4cae-bc70-5b7aa0dbf229)


#### Enable BigQuery API

https://console.cloud.google.com/apis/library?project=dtc-de-dbt-bigquery-414501&supportedpurview=project

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/2db3fc8a-7eb6-4e7e-b2af-ab8a450eb3a4)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/1c47e26d-23df-4e56-b832-c65eccef938e)


#### Open the [BigQuery credential wizard](https://console.cloud.google.com/projectselector2/apis/credentials/wizard?supportedpurview=project) to create a service account in your taxi project

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/d46725d2-2240-49fe-ac60-7cbe53bd06a8)
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/efe2733d-c668-4c25-b925-e84ab1a3f69f)

You can either grant the specific roles the account will need or simply use bq admin, as you'll be the sole user of both accounts and data.

https://console.cloud.google.com/apis/credentials?project=dtc-de-dbt-bigquery-414501&supportedpurview=project

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/f86c9128-4055-4c9b-b936-ebd4cb60a25d)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/5cd1c4d0-e347-4373-a35e-702c159ac404)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/9513fb3e-c62e-49dd-9244-89e5e9f1f826)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/25f8d093-ed03-49f7-b989-f8d7680dc723)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/a9ed94d2-8d51-4479-bf9e-c07462dc33f5)


Now that the service account has been created we need to add and download a JSON key, go to the keys section, select "create new key". Select key type JSON and once you click on create it will get inmediately downloaded for you to use.

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/681ad12d-b37c-4165-9041-f1752f189228)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/731c1445-e5f6-4a09-97cf-ec0b0c171dca)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/df3a851c-41df-425b-abec-ac3e1c40dc14)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/540a028f-f0d5-4bc5-8c4d-7d1ddf3bdd3d)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/df246baf-2a23-479d-82ca-efb6ea394b24)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/970d66b2-66b2-4c1a-8582-fe7fe0108c62)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/79c89797-6acf-44b8-973b-9e2d19950014)


## Create a dbt cloud project

1. Create a dbt cloud account from their website (free for solo developers)

   https://www.getdbt.com/pricing

   ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/ecfc1202-4369-4f08-8d68-cae28b75c9d0)
   ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/b3894c65-5142-4d25-96bd-9fbefe792ade)





3. Once you have logged in into dbt cloud you will be prompt to create a new project

You are going to need:

- access to your data warehouse (bigquery - set up in weeks 2 and 3)
- admin access to your repo, where you will have the dbt project.

*Note: For the sake of showing the creation of a project from scratch I've created a new empty repository just for this week project.*


https://cloud.getdbt.com/244669/projects/348761/setup

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/a2e87d94-f221-4907-8390-cb390827aa0a)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/992b91ee-2a21-4be9-bf89-f0d1b5a109f8)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/39f00f6b-ccbd-4b7f-a49a-e16036539946)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/cfc59392-e08a-4f3e-a816-25681fa1dead)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/9074222b-4c23-4cee-97b8-59ef2dac0069)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/3c62b4e3-0265-4b78-8665-6b83da66670d)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/4c682103-099e-4e7e-acb9-c7ae73bea7b6)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/68e288aa-4370-47da-8c83-eb1162d86d09)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/02c2f62b-ce3e-4d5c-a263-e5ac5151bce2)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/ef1f2763-7612-4828-8ed4-7496fd552e92)


