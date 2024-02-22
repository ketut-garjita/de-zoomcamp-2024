Source : https://docs.getdbt.com/guides/bigquery?step=1

## 1. Introduction

In this quickstart guide, you'll learn how to use dbt Cloud with BigQuery. It will show you how to:

- Create a Google Cloud Platform (GCP) project.
- Connect dbt Cloud to BigQuery.
- Clone taxi_rides_ny respository (https://github.com/DataTalksClub/data-engineering-zoomcamp/tree/eea22141328d3961aaaec49601598ebaa7a44689/04-analytics-engineering/taxi_rides_ny) into local machine.
- Delet all files under analyses, macros, models, seeds and snapshots directories in dbt cloud IDE
- Copy all files from repository cloned in local machine to the dbt cloud IDE
- Modify models as required
- Run: dbt seed, dbt run, dbt test (or dbt build to execute 3 steps above together)
- Generate documentation for the project and save

**Course learning video** : [dbt Fundamental](https://courses.getdbt.com/courses/fundamentals).

**Prerequisites​**

- You have a [dbt Cloud account](https://www.getdbt.com/signup/).
- You have a [Google account](https://support.google.com/accounts/answer/27441?hl=en).
- You can use a personal or work account to set up BigQuery through [Google Cloud Platform (GCP)](https://cloud.google.com/free).

**Related contents**

- Learn more with [dbt Courses](https://courses.getdbt.com/collections)
- [CI jobs](https://docs.getdbt.com/docs/deploy/continuous-integration)
- [Deploy jobs](https://docs.getdbt.com/docs/deploy/deploy-jobs)
- [Job notifications](https://docs.getdbt.com/docs/deploy/job-notifications)
- [Source freshness](https://docs.getdbt.com/docs/deploy/source-freshness)


## 2. Create a new GCP project​

- Go to the [BigQuery Console](https://console.cloud.google.com/bigquery) after you log in to your Google account. If you have multiple Google accounts, make sure you’re using the correct one.
- Create a new project from the [Manage resources](https://console.cloud.google.com/projectcreate?previousPage=%2Fcloud-resource-manager%3Fwalkthrough_id%3Dresource-manager--create-project%26project%3D%26folder%3D%26organizationId%3D%23step_index%3D1&walkthrough_id=resource-manager--create-project) page. For more information, refer to [Creating a project](https://cloud.google.com/resource-manager/docs/creating-managing-projects#creating_a_project) in the Google Cloud docs. GCP automatically populates the Project name field for you. You can change it to be more descriptive for your use. For example, dbt Learn - BigQuery Setup.


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

Now that the service account has been created we need to add and download a JSON key, go to the keys section, select "create new key". Select key type JSON and once you click on create it will get inmediately downloaded for you to use.

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/681ad12d-b37c-4165-9041-f1752f189228)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/731c1445-e5f6-4a09-97cf-ec0b0c171dca)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/df3a851c-41df-425b-abec-ac3e1c40dc14)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/df246baf-2a23-479d-82ca-efb6ea394b24)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/970d66b2-66b2-4c1a-8582-fe7fe0108c62)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/79c89797-6acf-44b8-973b-9e2d19950014)


## 3. Generate BigQuery credentials
In order to let dbt connect to your warehouse, you'll need to generate a keyfile. This is analogous to using a database username and password with most other data warehouses.

- Start the GCP credentials wizard. Make sure your new project is selected in the header. If you do not see your account or project, click your profile picture to the right and verify you are using the correct email account. For Credential Type:
   - From the Select an API dropdown, choose BigQuery API
   - Select Application data for the type of data you will be accessing
   - Click Next to create a new service account.
     
- Create a service account for your new project from the Service accounts page. For more information, refer to Create a service account in the Google Cloud docs. As an example for this guide, you can:
   - Type dbt-user as the Service account name
   - From the Select a role dropdown, choose BigQuery Job User and BigQuery Data Editor roles and click Continue
   - Leave the Grant users access to this service account fields blank
   - Click Done

- Create a service account key for your new project from the Service accounts page. For more information, refer to Create a service account key in the Google Cloud docs. When downloading the JSON file, make sure to use a filename you can easily remember. For example, dbt-user-creds.json. For security reasons, dbt Labs recommends that you protect this JSON file like you would your identity credentials; for example, don't check the JSON file into your version control software.

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/9513fb3e-c62e-49dd-9244-89e5e9f1f826)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/25f8d093-ed03-49f7-b989-f8d7680dc723)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/a9ed94d2-8d51-4479-bf9e-c07462dc33f5)


## 4. Connect dbt Cloud to BigQuery​

- Create a new project in dbt Cloud. From Account settings (using the gear menu in the top right corner), click + New Project.
- Enter a project name and click Continue.
- For the warehouse, click BigQuery then Next to set up your connection.
- Click Upload a Service Account JSON File in settings.
- Select the JSON file you downloaded in Generate BigQuery credentials and dbt Cloud will fill in all the necessary fields.
- Click Test Connection. This verifies that dbt Cloud can access your BigQuery account.
- Click Next if the test succeeded. If it failed, you might need to go back and regenerate your BigQuery credentials.


**Create a dbt cloud account from their website (free for solo developers)**

   https://www.getdbt.com/pricing

   ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/ecfc1202-4369-4f08-8d68-cae28b75c9d0)
   ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/b3894c65-5142-4d25-96bd-9fbefe792ade)


**Once you have logged in into dbt cloud you will be prompt to create a new project**

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


## 5. Set up a dbt Cloud managed repository

When you develop in dbt Cloud, you can leverage Git to version control your code.

To connect to a repository, you can either set up a dbt Cloud-hosted managed repository or directly connect to a supported git provider. Managed repositories are a great way to trial dbt without needing to create a new repository. In the long run, it's better to connect to a supported git provider to use features like automation and continuous integration.

To set up a managed repository:

- Under "Setup a repository", select Managed.
- Type a name for your repo such as bbaggins-dbt-quickstart
- Click Create. It will take a few seconds for your repository to be created and imported.
- Once you see the "Successfully imported repository," click Continue.

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/a6cea510-ecc7-4ef9-8f57-2133d4fdea4c)


## 6. Initialize your dbt project​ and start developing

Now that you have a repository configured, you can initialize your project and start development in dbt Cloud:

- Click Start developing in the IDE. It might take a few minutes for your project to spin up for the first time as it establishes your git connection, clones your repo, and tests the connection to the warehouse.

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/5de47ed9-3f9d-4740-8125-fc8434e1081a)

- Above the file tree to the left, click Initialize dbt project. This builds out your folder structure with example models.

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/b62158aa-4091-42bd-a5aa-b7197bae375e)

- Make your initial commit by clicking Commit and sync. Use the commit message initial commit and click Commit. This creates the first commit to your managed repo and allows you to open a branch where you can add new dbt code.

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/fbfad3d0-f74e-4047-a459-977146be6495)

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/0a65f4d9-4d32-4050-890b-0ca45879750b)

- You can now directly query data from your warehouse and execute dbt run.
  

## 7. Build first model

We will use an existing [taxi_rides_ny repository](https://github.com/DataTalksClub/data-engineering-zoomcamp/tree/eea22141328d3961aaaec49601598ebaa7a44689/04-analytics-engineering/taxi_rides_ny) from DTC DE Zoomcamp.

- Delete all files under analyses, macros, models, seeds and snapshots directories in dbt cloud IDE
- Copy all files from repository cloned in local machine to the dbt cloud IDE
- Modify models as required

File explorer structure would be like this:

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/1153911d-2e89-4ca1-962f-695677278c07)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/ceae0f12-d8d8-4519-996c-8d85bc09495b)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/06bed8ee-db83-438f-a1ea-802fa2706c08)


## 8. Project Models Testing

Adding tests to a project helps validate that models.

File name : models/core/schema.yml

```
version: 2

models:
  - name: dim_zones
    description: >
      List of unique zones idefied by locationid. 
      Includes the service zone they correspond to (Green or yellow).

  - name: dm_monthly_zone_revenue
    description: >
      Aggregated table of all taxi trips corresponding to both service zones (Green and yellow) per pickup zone, month and service.
      The table contains monthly sums of the fare elements used to calculate the monthly revenue. 
      The table contains also monthly indicators like number of trips, and average trip distance. 
    columns:
      - name: revenue_monthly_total_amount
        description: Monthly sum of the the total_amount of the fare charged for the trip per pickup zone, month and service.
        tests:
            - not_null:
                severity: error
      
  - name: fact_trips
    description: >
      Taxi trips corresponding to both service zones (Green and yellow).
      The table contains records where both pickup and dropoff locations are valid and known zones. 
      Each record corresponds to a trip uniquely identified by tripid. 
    columns:
      - name: tripid
        data_type: string
        description: "unique identifier conformed by the combination of vendorid and pickyp time"

      - name: vendorid
        data_type: int64
        description: ""

      - name: service_type
        data_type: string
        description: ""

      - name: ratecodeid
        data_type: int64
        description: ""

      - name: pickup_locationid
        data_type: int64
        description: ""

      - name: pickup_borough
        data_type: string
        description: ""

      - name: pickup_zone
        data_type: string
        description: ""

      - name: dropoff_locationid
        data_type: int64
        description: ""

      - name: dropoff_borough
        data_type: string
        description: ""

      - name: dropoff_zone
        data_type: string
        description: ""

      - name: pickup_datetime
        data_type: timestamp
        description: ""

      - name: dropoff_datetime
        data_type: timestamp
        description: ""

      - name: store_and_fwd_flag
        data_type: string
        description: ""

      - name: passenger_count
        data_type: int64
        description: ""

      - name: trip_distance
        data_type: numeric
        description: ""

      - name: trip_type
        data_type: int64
        description: ""

      - name: fare_amount
        data_type: numeric
        description: ""

      - name: extra
        data_type: numeric
        description: ""

      - name: mta_tax
        data_type: numeric
        description: ""

      - name: tip_amount
        data_type: numeric
        description: ""

      - name: tolls_amount
        data_type: numeric
        description: ""

      - name: ehail_fee
        data_type: numeric
        description: ""

      - name: improvement_surcharge
        data_type: numeric
        description: ""

      - name: total_amount
        data_type: numeric
        description: ""

      - name: payment_type
        data_type: int64
        description: ""

      - name: payment_type_description
        data_type: string
        description: ""
   ```

Project Models Lineage Graph

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/6dff6a93-0d9c-42ab-a25e-ff006ae6ceba)

- Run dbt build, and confirm that all tests passed.

```
dbt build
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/3403ec75-9766-44e4-b416-040062600a09)


## 9. Generate Model Documentation for the Project

Adding documentation to project allows us to describe models in rich detail, and share that information with our team. Here, we're going to add some basic documentation to our project.


Run **dbt docs generate** to generate the documentation for your project. dbt introspects your project and your warehouse to generate a JSON file with rich documentation about your project.

```
dbt docs generate
```

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/cbec7fab-7690-4e31-a91d-ce88ef9ab11a)


- Click the book icon in the Develop interface to launch documentation in a new tab.

  Example for my doc:

  https://cloud.getdbt.com/accounts/244669/develop/5651504/docs/index.html#!/overview
  
![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/6499a6cb-980d-4ecb-af7b-92bdb316c832)



## 10. Commit changes

Now that we've built model, we need to commit the changes we made to the project so that the repository has latest code.

- Under Version Control on the left, click Commit and sync and add a message. For example, "Add taxi_rides_ny model, tests, docs."

- Click Merge this branch to main to add these changes to the main branch on your repo.
   
  
  ## 11. Deploy dbt

Use dbt Cloud's Scheduler to deploy your production jobs confidently and build observability into your processes. You'll learn to create a deployment environment and run a job in the following steps.

### Create a deployment environment

- In the upper left, select Deploy, then click Environments.
- Click Create Environment.
- In the Name field, write the name of your deployment environment. For example, "Production."
- In the dbt Version field, select the latest version from the dropdown.
- Under Deployment Credentials, enter the name of the dataset you want to use as the target, such as "Analytics". This will allow dbt to build and work with that dataset. For some data warehouses, the target dataset may be referred to as a "schema".
- Click Save.

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/de124e55-aab6-4cf3-b54b-66ff21ee34a8)


### Create and run a job

Jobs are a set of dbt commands that you want to run on a schedule. For example, dbt build.

As the jaffle_shop business gains more customers, and those customers create more orders, you will see more records added to your source data. Because you materialized the customers model as a table, you'll need to periodically rebuild your table to ensure that the data stays up-to-date. This update will happen when you run a job.

- After creating your deployment environment, you should be directed to the page for a new environment. If not, select Deploy in the upper left, then click Jobs.

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/87ba82c3-986d-41f4-be47-f58562bb1179)

- Click Create one and provide a name, for example, "Production run", and link to the Environment you just created.
- Scroll down to the Execution Settings section.
- Under Commands, add this command as part of your job if you don't see it:
dbt build
- Select the Generate docs on run checkbox to automatically generate updated project docs each time your job runs.
- For this exercise, do not set a schedule for your project to run — while your organization's project should run regularly, there's no need to run this example project on a schedule. Scheduling a job is sometimes referred to as deploying a project.
- Select Save, then click Run now to run your job.

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/f2abf315-5393-451b-baa3-ef2a0676c25f)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/db90ca71-409d-4433-94db-9ad0d53971ba)


- Click the run and watch its progress under "Run history."

  ![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/aef46f7f-8aac-4961-b8d5-6b7a52307220)

- Once the run is complete, click View Documentation to see the docs for your project.

https://cloud.getdbt.com/accounts/244669/runs/252607919/docs/#!/overview

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/27d45a15-7a68-410f-aa6c-bcf71c7a1705)

**Congratulations 🎉! You've just deployed your first dbt project!**





  

