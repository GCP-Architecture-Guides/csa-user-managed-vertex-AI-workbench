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


terraform {
  required_version = ">= 0.13"
}


provider "google-beta" {
  alias                 = "service"
  user_project_override = true
  billing_project       = google_project.vertex-project.project_id
}