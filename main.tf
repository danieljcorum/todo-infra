provider "google" {
  // Run to set gcloud creds: gcloud auth application-default login
  project     = "hip-runner-276102"
  region      = "us-east4"
}

terraform {
  backend "gcs" {
    bucket = "tf-state-bucket-thorben"
    prefix = "dcorum/terraform.tfstate"
  }
}

resource "google_storage_bucket" "todo-code" {
  name          = "dcorum-todo-app"
  location      = "US-EAST4"
}

resource "google_app_engine_standard_app_version" "todo-app" {
  version_id = "v4"
  service = "new"
  runtime = "nodejs10"

  entrypoint {
    shell = "node ./server.js"
  }

  deployment {
    zip {
      source_url = "https://storage.googleapis.com/${google_storage_bucket.todo-code.name}/todo.zip"
    }
  }

  env_variables = {
    port = "8080"
  }

  delete_service_on_destroy = true
}
