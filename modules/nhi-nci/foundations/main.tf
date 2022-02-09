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

# Terraform foundation project
resource "random_id" "suffix" {
  byte_length = 2
}

module "tf-project" {
  source          = "../../../modules/cloud-foundation-fabric/modules/project"
  name            = "terraform-${random_id.suffix.hex}"
  parent          = var.root_node
  prefix          = var.prefix
  billing_account = var.billing_account_id

  services = concat(
    var.project_services,
    [
      "admin.googleapis.com",
      "bigquery.googleapis.com",
      "cloudbilling.googleapis.com",
      "cloudidentity.googleapis.com",
      "cloudresourcemanager.googleapis.com",
      "groupssettings.googleapis.com",
      "iam.googleapis.com",
      "serviceusage.googleapis.com",
    ]
  )
  iam_additive = {
    "roles/serviceusage.serviceUsageConsumer" = var.iam_terraform_owners
  }
}