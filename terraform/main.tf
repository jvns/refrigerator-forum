provider "google" {
 project     = "refrigerator-poetry"
 region      = "us-east4"
}

resource "google_cloud_run_service" "default" {
  name     = "refrigerator-poetry"
  location = "us-east4"

  template {
    spec {
      containers {
        image = "us.gcr.io/refrigerator-poetry/refrigerator-forum/refrigerator-poetry"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_sql_database_instance" "instance" {
  name   = "fridge-db"
  region = "us-east4"
  database_version = "POSTGRES_13"
  settings {
    tier = "db-f1-micro"
  }

  deletion_protection  = "true"
}

resource "google_service_account" "fridge" {
  account_id   = "refrigerator-poetry"
  display_name = "refrigerator-poetry"
}

data "google_iam_policy" "fridge" {
  binding {
    role = "roles/cloudsql.editor"
members = []
  }
}

resource "google_service_account_iam_policy" "fridge-account-iam" {
  service_account_id = google_service_account.fridge.name
  policy_data        = data.google_iam_policy.fridge.policy_data
}
