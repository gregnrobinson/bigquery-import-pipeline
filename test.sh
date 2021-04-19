PROJECT_ID="greg-playground-310720"

BQ_DATASET_EXISTS=$(bq ls --filter labels.name:owid_covid_dataset --project_id $PROJECT_ID)

if [ -n "$BQ_DATASET_EXISTS" ]; then
  echo "LOADING DATASET"
  bq load \
    --location=northamerica-northeast1 \
    --source_format=CSV \
    --autodetect \
    --replace owid_covid_dataset.complete_worldwide_csv \
    gs://owid-covid-data/owid-covid-data.csv
else
  echo "DATASET DOES NOT EXIST... CREATING..."
  bq mk \
    --location=northamerica-northeast1 \
    --dataset \
    --default_table_expiration 0 \
    --description "Complete Covid-19 CSV Dataset from OWID" \
    $PROJECT_ID:owid_covid_datase

  bq update --set_label name:owid_covid_dataset $PROJECT_ID:owid_covid_datase
  
  echo "LOADING DATASET"
  bq load \
    --location=northamerica-northeast1 \
    --source_format=CSV \
    --autodetect \
    --replace owid_covid_dataset.complete_worldwide_csv \
  gs://owid-covid-data/owid-covid-data.csv
fi