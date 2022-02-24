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

variable "metric_name" {
  description = "Logging metric name."
  type        = string
}

variable "metric_filter" {
  description = "Logs filter which is used to match log entries."
  type        = string
}

variable "metric_descriptor_display_name" {
  description = "Metric descriptor display name."
  type        = string
  default     = null
}

variable "alert_policy_display_name" {
  description = "Alert policy display name."
  type        = string
}

variable "alert_policy_conditions_display_name" {
  description = "Alert policy conditions display name."
  type        = string
  default     = null
}

variable "notification_channel_names" {
  description = "Notification channel names."
  type        = list(string)
}

variable "resource_type" {
  description = "Resource type for filter."
  type        = string
  default     = "resource.type=\"global\""
}