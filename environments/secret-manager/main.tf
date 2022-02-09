/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  project_id      = "nhi-nci-lb-project-poc-dev"
  tls-private-key = {
    location = ["us-east4"]
    iam = {
      "roles/secretmanager.secretAccessor" = [
        "user:farrukhhashmi@google.com",
        # "serviceAccount:[service-account-name]@[project-id].iam.gserviceaccount.com",
      ]
      "roles/secretmanager.secretVersionAdder" = [
        "user:farrukhhashmi@google.com",
        # "group:[admin-group-name]@nih.gov"
      ]
      "roles/secretmanager.viewer" = [
        "user:farrukhhashmi@google.com",
        # "group:[admin-group-name]@nih.gov",
        # "serviceAccount:[service-account-name]@[project-id].iam.gserviceaccount.com",
      ]
    }
  }
  tls-public-cert = {
    location = ["us-east4"]
    iam = {
      "roles/secretmanager.secretAccessor" = [
        "user:farrukhhashmi@google.com",
        # "serviceAccount:[service-account-name]@[project-id].iam.gserviceaccount.com",
      ]
      "roles/secretmanager.secretVersionAdder" = [
        "user:farrukhhashmi@google.com",
        # "group:[admin-group-name]@nih.gov"
      ]
      "roles/secretmanager.viewer" = [
        "user:farrukhhashmi@google.com",
        # "group:[admin-group-name]@nih.gov",
        # "serviceAccount:[service-account-name]@[project-id].iam.gserviceaccount.com",
      ]
    }
  }
}

# Shared secrets
module "shared-secrets" {
  source     = "../../modules/cloud-foundation-fabric/modules/secret-manager"
  project_id = local.project_id
  secrets = {
    tls-private-key = local.tls-private-key.location
    tls-public-cert = local.tls-public-cert.location
  }
  iam = {
    tls-private-key = local.tls-private-key.iam
    tls-public-cert = local.tls-public-cert.iam
  }
}