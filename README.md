# Table of Contents
- [Overview](#overview)
- [Setup](#setup)
  * [Set The Requried Permissions](#requried-permissions)
  * [Link a repository containing the `./cloudbuild.yaml` file.](#link-a-repository-containing-the---cloudbuildyaml--file)
  * [Run the pipeline.](#run-the-pipeline)
- [Reference](#reference)

# Overview

Ths project is used to import an online dataset to a new or existing dataset in BigQuery. The pipeline will first download a dataset from a url that is provided and upload the dataset to GCS. Finally, the pipeline loads the dataset from GCS to BigQuery. The pipeline will create all the depdnacies if they don't already exist. If the BigQuery dataset and Bucket exist, the pipeline will only import the new dataset to BigQuery.

# Setup

## Requried Permissions

Start by enabling the clodubuild API so the default service account for CloudBuild is generated.

```sh
gcloud services enable cloudbuild.googleapis.com --project ${PROJECT_ID} > /dev/null
```

Assign the following permissions to the default service account for CloudBuild. The service account will be in the format `<PROJEC_NUMBER>@cloudbuild.gserviceaccount.com`.

  - BigQuery Admin
  - Cloud Build Service Account
  - Service Account User
  - Service Usage Admin
  - Storage Admin

Modify the substitutions in the `./cloudbuild.yaml` file to match your requirements.

```sh
substitutions:
    _LOCATION: northamerica-northeast1
    _BQ_DATASET_URL: https://covid.ourworldindata.org/data/owid-covid-data.csv
    _BQ_DATASET_NAME: owid_covid_dataset
    _BQ_DATASET_FORMAT: CSV
    _BQ_DATASET_DESCRIPTION: Complete Covid-19 CSV Dataset from OWID
    _BQ_TABLE_NAME: complete_worldwide_csv
    _GCS_BUCKET_NAME: owid-covid-data
    _GCS_FILE_NAME: owid-covid-data.csv
```

## Link a repository containing the `./cloudbuild.yaml` file.

Either fork this repostiroy of create your own with the `./cloudbuild.yaml` file in it.

Go to the GCP ***console > Cloud Build > Triggers*** to connect your repository and add the trigger details matching expression. The default configuration is a push or merge to the main branch will trigger the pipeline.

## Run the pipeline.

Trigger the pipeline by matching your trigger condition and thats it. 

When the pipeline loads the dataset it replaces the table with the new dataset. If you want to append data to a table replace `--replace` with `--schema_update_option` and assign one of the following values:

- ALLOW_FIELD_ADDITION: Allow new fields to be added
- ALLOW_FIELD_RELAXATION: Allow relaxing REQUIRED fields to NULLABLE

## Setup Pipeline Schedule

Setup a CRON schedule to automatically add a new dataset to BigQuery when it becomes available.

In order to set the schedule it is requried to use the app engine default service account `0@appspot.gserviceaccount.com`. If you have never used app engine, enable the API using the following command:

```sh
gcloud services enable appengine.googleapis.com --project ${PROJECT_ID}
```

Add the following permissions to `0@appspot.gserviceaccount.com`

- Cloud Build Service Account
- Cloud Scheduler Service Agent

Create a CloudBuild schedule using the following command:

```sh
gcloud scheduler jobs create http bigquery-dataset-import --schedule "0 12 * * *" \
   --http-method=post \
   --uri=https://cloudbuild.googleapis.com/v1/projects/${PROJECT_ID}/triggers/${TRIGGER_ID}:run \
   --oauth-service-account-email=${PROJECT_ID}0@appspot.gserviceaccount.com \
   --oauth-token-scope=https://www.googleapis.com/auth/cloud-platform
```

Adjust the CRON schedule. If your like me and always forget the format, go to [Crontab Guru](https://crontab.guru/) and determine the CRON format for your desired execution frequency.

# Reference

- https://cloud.google.com/bigquery/docs/datasets#bq
- https://cloud.google.com/iam/docs/understanding-roles-
- https://cloud.google.com/bigquery/docs/reference/bq-cli-reference
- https://cloud.google.com/storage/docs/gsutil/commands/cp
- https://cloud.google.com/scheduler/docs



