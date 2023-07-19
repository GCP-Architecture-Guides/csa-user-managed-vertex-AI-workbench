##  Copyright 2023 Google LLC
##  
##  Licensed under the Apache License, Version 2.0 (the "License");
##  you may not use this file except in compliance with the License.
##  You may obtain a copy of the License at
##  
##      https://www.apache.org/licenses/LICENSE-2.0
##  
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.


##  This code creates demo environment for CSA Vertex AI Notebook with DLP Integration  ##
##  This demo code is not built for production workload ##

resource "google_storage_bucket" "bucket" {
  project                     = google_project.vertex-project.project_id
  name                        = google_project.vertex-project.project_id
  location                    = var.region #default" us-central1
  force_destroy               = true
  uniform_bucket_level_access = true
  depends_on                  = [google_project_service.gcp_apis]
}

resource "google_storage_bucket_iam_binding" "bucket_iam" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.sa.email}"
  ]
}


resource "null_resource" "delete_storage_objects" {
  triggers = {
    bucket_name = google_storage_bucket.bucket.name
    project     = google_project.vertex-project.project_id
  }


  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
    gcloud storage rm gs://${self.triggers.bucket_name}/*
    EOT
  }

  depends_on = [google_storage_bucket.bucket]

}


resource "google_storage_bucket" "notebook_bucket" {
  project                     = google_project.vertex-project.project_id
  name                        = "notebook-${google_project.vertex-project.project_id}-${random_id.random_suffix.hex}"
  location                    = var.region #default" us-central1
  force_destroy               = true
  uniform_bucket_level_access = true
  depends_on                  = [google_project_service.gcp_apis]
}

resource "google_storage_bucket_iam_binding" "notebook_bucket_iam" {
  bucket = google_storage_bucket.notebook_bucket.name
  role   = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.sa.email}"
  ]
}


# Add startup file to bucket
resource "google_storage_bucket_object" "notebook" {
  name       = "install_script.sh"
  bucket     = google_storage_bucket.notebook_bucket.name
  source     = "${path.module}/assets/install_script.sh"
  depends_on = [google_storage_bucket.notebook_bucket]
}