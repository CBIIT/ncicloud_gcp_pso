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

# Bootstrap Terraform state GCS buckets
module "tf-gcs-bootstrap" {
  source        = "../../../modules/cloud-foundation-fabric/modules/gcs"
  project_id    = module.tf-project.project_id
  name          = "tf-bootstrap-${random_id.suffix.hex}"
  prefix        = "${var.prefix}"
  location      = var.gcs_defaults.location
  storage_class = var.gcs_defaults.storage_class
}

module "tf-gcs-bootstrap-data-owners" {
  source          = "../../../modules/terraform-google-iam/modules/storage_buckets_iam"
  storage_buckets = [module.tf-gcs-bootstrap.name]
  mode            = "additive"

  bindings = {
    "roles/storage.objectAdmin" = var.iam_terraform_owners
  }
}

module "tf-gcs-bootstrap-bucket-owners" {
  source          = "../../../modules/terraform-google-iam/modules/storage_buckets_iam"
  storage_buckets = [module.tf-gcs-bootstrap.name]
  mode            = "authoritative"

  bindings = {
    "roles/storage.admin" = []
  }
}

# Bootstrap project factory state GCS buckets
module "tf-gcs-project-factory" {
  source        = "../../../modules/cloud-foundation-fabric/modules/gcs"
  project_id    = module.tf-project.project_id
  name          = "project-factory-${random_id.suffix.hex}"
  prefix        = "${var.prefix}"
  location      = var.gcs_defaults.location
  storage_class = var.gcs_defaults.storage_class
}

module "tf-gcs-project-factory-data-owners" {
  source          = "../../../modules/terraform-google-iam/modules/storage_buckets_iam"
  storage_buckets = [module.tf-gcs-project-factory.name]
  mode            = "additive"

  bindings = {
    "roles/storage.objectAdmin" = var.iam_terraform_owners
  }
}

module "tf-gcs-project-factory-bucket-owners" {
  source          = "../../../modules/terraform-google-iam/modules/storage_buckets_iam"
  storage_buckets = [module.tf-gcs-project-factory.name]
  mode            = "authoritative"

  bindings = {
    "roles/storage.admin" = []
  }
}