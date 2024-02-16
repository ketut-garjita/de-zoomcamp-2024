Source : https://docs.getdbt.com/guides/bigquery?step=1

## 1. Introduction

In this quickstart guide, you'll learn how to use dbt Cloud with BigQuery. It will show you how to:

- Create a Google Cloud Platform (GCP) project.
- Access sample data in a public dataset.
- Connect dbt Cloud to BigQuery.
- Take a sample query and turn it into a model in your dbt project. A model in dbt is a select statement.
- Add tests to your models.
- Document your models.
- Schedule a job to run.


VIDEOS FOR YOU
You can check out [dbt Fundamentals](https://courses.getdbt.com/courses/fundamentals) for free if you're interested in course learning with videos.


Prerequisites​

- You have a [dbt Cloud account](https://www.getdbt.com/signup/).
- You have a [Google account](https://support.google.com/accounts/answer/27441?hl=en).
- You can use a personal or work account to set up BigQuery through [Google Cloud Platform (GCP)](https://cloud.google.com/free).


Related content

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

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/540a028f-f0d5-4bc5-8c4d-7d1ddf3bdd3d)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/df246baf-2a23-479d-82ca-efb6ea394b24)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/970d66b2-66b2-4c1a-8582-fe7fe0108c62)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/79c89797-6acf-44b8-973b-9e2d19950014)


## 3. Create BigQuery datasets

- From the BigQuery Console, click Editor. Make sure to select your newly created project, which is available at the top of the page.
- Verify that you can run SQL queries. Copy and paste these queries into the Query Editor:

```
select * from `dbt-tutorial.jaffle_shop.customers`;
select * from `dbt-tutorial.jaffle_shop.orders`;
select * from `dbt-tutorial.stripe.payment`;
```

Click Run, then check for results from the queries. For example:

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/85292572-3e3d-4284-add7-ff82ff92d4ad)

- Create new datasets from the BigQuery Console. For more information, refer to Create datasets in the Google Cloud docs. Datasets in BigQuery are equivalent to schemas in a traditional database. On the Create dataset page:

Dataset ID — Enter a name that fits the purpose. This name is used like schema in fully qualified references to your database objects such as database.schema.table. As an example for this guide, create one for jaffle_shop and another one for stripe afterward.

Data location — Leave it blank (the default). It determines the GCP location of where your data is stored. The current default location is the US multi-region. All tables within this dataset will share this location.

Enable table expiration — Leave it unselected (the default). The default for the billing table expiration is 60 days. Because billing isn’t enabled for this project, GCP defaults to deprecating tables.

Google-managed encryption key — This option is available under Advanced options. Allow Google to manage encryption (the default).


![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/ef1f2763-7612-4828-8ed4-7496fd552e92)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/b2f47b13-858b-4ce3-8dd3-f218fa953fd9)

![image](https://github.com/garjita63/de-zoomcamp-2024/assets/77673886/5a20a98a-f32a-40ec-a9b9-21e79e0e56f9)


## 4. Generate BigQuery credentials
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


## 5. Connect dbt Cloud to BigQuery​

- Create a new project in dbt Cloud. From Account settings (using the gear menu in the top right corner), click + New Project.
- Enter a project name and click Continue.
- For the warehouse, click BigQuery then Next to set up your connection.
- Click Upload a Service Account JSON File in settings.
- Select the JSON file you downloaded in Generate BigQuery credentials and dbt Cloud will fill in all the necessary fields.
- Click Test Connection. This verifies that dbt Cloud can access your BigQuery account.
- Click Next if the test succeeded. If it failed, you might need to go back and regenerate your BigQuery credentials.





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



