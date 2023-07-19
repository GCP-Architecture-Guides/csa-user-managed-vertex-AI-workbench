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


resource "time_sleep" "vpc_access_policy_wait" {

  create_duration  = "30s"
  destroy_duration = "60s"
  depends_on = [resource.null_resource.set_secure_boot,
    google_storage_bucket.notebook_bucket,
    google_storage_bucket.bucket,
    null_resource.delete_storage_objects,
  ]
}

resource "google_access_context_manager_access_policy" "access_context_manager_policy" {
  provider   = google-beta.service
  parent     = "organizations/${var.organization_id}"
  title      = "${var.policy_name}_policy"
  scopes     = ["projects/${google_project.vertex-project.number}"]
  depends_on = [time_sleep.vpc_access_policy_wait]
}


resource "google_access_context_manager_access_level" "access_level" {
  provider = google-beta.service
  parent   = "accessPolicies/${google_access_context_manager_access_policy.access_context_manager_policy.name}"
  #"accessPolicies/${google_access_context_manager_access_policy.access-policy.name}"
  name  = "accessPolicies/${google_access_context_manager_access_policy.access_context_manager_policy.name}/accessLevels/${var.policy_name}_levels"
  title = "${var.policy_name}_levels"
  basic {
    conditions {
      members = var.vpc_sc_users
      regions = var.enforced_regional_access
    }
  }
  depends_on = [google_access_context_manager_access_policy.access_context_manager_policy]
}


resource "time_sleep" "vpc_sc_wait" {
  depends_on = [
    google_access_context_manager_access_policy.access_context_manager_policy,
    google_access_context_manager_access_level.access_level,
  ]
  create_duration  = "90s"
  destroy_duration = "180s"
}


resource "google_access_context_manager_service_perimeter" "service_perimeter" {
  provider    = google-beta.service
  parent      = "accessPolicies/${google_access_context_manager_access_policy.access_context_manager_policy.name}"
  name        = "accessPolicies/${google_access_context_manager_access_policy.access_context_manager_policy.name}/servicePerimeters/${var.perimeter_name}"
  description = "Perimeter_${var.perimeter_name}"
  title       = var.perimeter_name
  status {
    restricted_services = var.restricted_services
    access_levels       = [google_access_context_manager_access_level.access_level.name]
    resources           = ["projects/${google_project.vertex-project.number}"]
  }
  depends_on = [time_sleep.vpc_sc_wait]
}


resource "time_sleep" "vpc_sc_apply_wait" {
  depends_on = [
    google_access_context_manager_service_perimeter.service_perimeter,
  ]
  create_duration = "30s"
  #  destroy_duration = "90s"
} 