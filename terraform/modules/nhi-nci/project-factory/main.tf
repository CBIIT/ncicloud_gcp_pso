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

# This module
#   * Creates a project
#   * Creates custom role(s) in project passed in custom_roles variables
#      - Custom role(s) permissions are defined in locals.tf file in this module
#   * Creates IAM binding between custom roles(s) and GCP group(s) passed in custom_roles variables

resource "random_id" "suffix" {
  byte_length = 2
}

# Create a project
module "project-factory" {
  source          = "../../../modules/cloud-foundation-fabric/modules/project"
  name            = "${var.project_id}-${random_id.suffix.hex}"
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
}

# Create custom role(s) in project and bind custom role(s) with GCP groups
module "project-custom-role" {
  source               = "../../../modules/terraform-google-iam/modules/custom_role_iam/"
  for_each             = var.custom_roles
  target_level         = "project"
  target_id            = module.project-factory.name
  role_id              = each.key
  base_roles           = local.custom_roles[each.key].base_roles
  permissions          = local.custom_roles[each.key].permissions
  excluded_permissions = local.custom_roles[each.key].excluded_permissions
  members              = each.value
}