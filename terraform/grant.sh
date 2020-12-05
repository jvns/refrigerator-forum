gcloud sql add-iam-policy-binding refrigerator-db \
    --member=serviceAccount:refrigerator-poetry@refrigerator-poetry.iam.gserviceaccount.com --role=roles/cloudsql.client
