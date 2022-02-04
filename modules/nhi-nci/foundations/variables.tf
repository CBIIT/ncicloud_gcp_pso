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

variable "billing_account_id" {
  description = "Billing account for projects."
  type        = string
}

variable "gcs_defaults" {
  description = "Defaults use for the state GCS buckets."
  type        = map(string)
  default = {
    location      = "NAM4"
    storage_class = "STANDARD"
  }
}

variable "iam" {
  description = "IAM bindings for the top-level folder in {ROLE => [MEMBERS]} format."
  type        = map(list(string))
  default     = {}
}

variable "prefix" {
  description = "Optional prefix used for GCS bucket names to ensure uniqueness."
  type        = string
  default     = null
}

variable "root_node" {
  description = "Root node in folders/folder_id or organizations/org_id format."
  type        = string
}

variable "project_services" {
  description = "Service APIs enabled by default in new projects."
  type        = list(string)
  default     = []
}

variable "iam_terraform_owners" {
  description = "Terraform project owners, in IAM format."
  type        = list(string)
  default     = []
}