provider "google" {
  project = "refrigerator-poetry"
  region  = "us-east4"
}

resource "google_project_iam_policy" "project" {
  project     = "refrigerator-poetry"
  policy_data = data.google_iam_policy.fridge.policy_data
}

resource "google_cloud_run_service" "default" {
  autogenerate_revision_name = true
  location                   = "us-east4"
  name                       = "refrigerator-poetry"
  template {
    spec {
      container_concurrency = 80
      service_account_name = google_service_account.fridge.email
      timeout_seconds       = 299

      containers {
        image = "us.gcr.io/refrigerator-poetry/refrigerator-forum/refrigerator-poetry:cd0bb5b5cc945f8e5ec495d957fac488f0647518"

        ports {
          container_port = 8080
        }

        resources {
          limits = {
            "cpu"    = "1000m"
            "memory" = "256Mi"
          }
          requests = {}
        }
      }
    }
  }

  timeouts {}

  traffic {
    latest_revision = true
    percent         = 100
  }
}

resource "google_sql_database_instance" "instance" {
  name             = "refrigerator-db"
  region           = "us-east4"
  database_version = "POSTGRES_13"
  settings {
    tier = "db-f1-micro"
  }

  deletion_protection = "true"
}

resource "google_service_account" "fridge" {
  account_id   = "refrigerator-poetry"
  display_name = "refrigerator-poetry"
}

data "google_iam_policy" "fridge" {
  binding {
    role = "roles/cloudsql.client"
    members = [
      "serviceAccount:${google_service_account.fridge.email}"
    ]
  }
}


resource "google_secret_manager_secret" "dbpassword" {
  secret_id = "postgres-password"
  replication {
    user_managed {
      replicas {
        location = "us-east4"
      }
    }
  }
}


resource "google_secret_manager_secret" "railsmaster" {
  secret_id = "rails-master-key"
  replication {
    user_managed {
      replicas {
        location = "us-east4"
      }
    }
  }
}

resource "google_secret_manager_secret_iam_binding" "binding" {
  project   = "refrigerator-poetry"
  secret_id = google_secret_manager_secret.railsmaster.secret_id
  role      = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.fridge.email}"
  ]
}
resource "google_secret_manager_secret_iam_binding" "binding2" {
  project   = "refrigerator-poetry"
  secret_id = google_secret_manager_secret.dbpassword.secret_id
  role      = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.fridge.email}"
  ]
}
