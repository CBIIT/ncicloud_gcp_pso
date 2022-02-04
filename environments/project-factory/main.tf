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

# Using the project-factory module to
#   * Create project(s)
#   * Create custom role(s) in project
#   * Create IAM binding between custom roles(s) and GCP group(s)

module "nhi-nci-project-factory-a" {
  source             = "../../modules/nhi-nci/project-factory"

  billing_account_id = "01CB51-83915C-46BCF2"
  root_node          = "folders/171339314200" # nhi-nci-poc
  prefix             = "nhi-nci"
  project_id         = "test-project-a"
  custom_roles       =  {
    "custom_project_owner"  = ["group:nhi-nci-poc-project-a-owner@farrukh.joonix.net"],
    "custom_project_viewer" = ["group:nhi-nci-poc-project-a-viewer@farrukh.joonix.net"]
  }
}

module "nhi-nci-project-factory-b" {
  source             = "../../modules/nhi-nci/project-factory"

  billing_account_id = "01CB51-83915C-46BCF2"
  root_node          = "folders/171339314200" # nhi-nci-poc
  prefix             = "nhi-nci"
  project_id         = "test-project-b"
  custom_roles       =  {
    "custom_project_owner"  = ["group:nhi-nci-poc-project-b-owner@farrukh.joonix.net"],
    "custom_project_viewer" = ["group:nhi-nci-poc-project-b-viewer@farrukh.joonix.net"]
  }
}