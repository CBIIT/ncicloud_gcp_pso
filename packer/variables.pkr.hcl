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

variable "project_id" {
  description = "The GCP Project ID."
  type        = string
}

variable "source_image_family" {
  description = "Source image family name."
  type        = string
}

variable "ssh_username" {
  description = "SSH user name."
  type        = string
}

variable "zone" {
  description = "GCP Zone, that will be used for launched instance."
  type        = string
}

variable "image_name" {
  description = "Image name."
  type        = string
  default     = "packer"
}

variable "image_family" {
  description = "Image family name."
  type        = string
}

variable "network" {
  description = "VPC name, that will be used for launched instance."
  type        = string
}

variable "subnetwork" {
  description = "Subnet name, that will be used for launched instance."
  type        = string
}

variable "network_project_id" {
  description = "The project ID for the network and subnetwork to use for launched instance."
  type        = string
}

variable "omit_external_ip" {
  description = "If true, the instance will not have an external IP. use_internal_ip must be true if this property is true."
  type        = bool
  default     = false
}

variable "use_internal_ip" {
  description = "If true, use the instance's internal IP instead of its external IP during building."
  type        = bool
  default     = false
}