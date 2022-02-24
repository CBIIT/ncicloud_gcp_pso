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
  iam_metric_filter          = "protoPayload.methodName:\"setIamPolicy\" AND NOT protoPayload.authenticationInfo.principalEmail = (\"farrukhhashmi1@google.com\" OR \"hashmisf@gmail.com\")"
  vpc_metric_filter          = "(protoPayload.methodName:\"compute.networks\" OR protoPayload.methodName:\"compute.subnetworks\") AND NOT (protoPayload.methodName:\"get\" OR protoPayload.methodName:\"list\") AND NOT protoPayload.authenticationInfo.principalEmail = (\"farrukhhashmi1@google.com\" OR \"hashmisf@gmail.com\") AND resource.type=(\"gce_network\" OR \"gce_subnetwork\")"
}

# Log based alert for IAM roles/permission changes
module "log_based_alert_iam" {
  source                               = "../logging-metric-alert"
  project_id                           = var.project_id
  notification_channel_names           = var.notification_channel_names
  metric_name                          = "iam_roles_permission_changed_custom_metric"
  metric_filter                        = local.iam_metric_filter
  metric_descriptor_display_name       = "Custom Metric - IAM role/permission changed"
  alert_policy_display_name            = "IAM role/permission changed"
  alert_policy_conditions_display_name = "IAM role/permission changed"
}

# Log based alert for VPC/Subnet changes
module "log_based_alert_vpc" {
  source                               = "../logging-metric-alert"
  project_id                           = var.project_id
  notification_channel_names           = var.notification_channel_names
  metric_name                          = "vpc_added_deleted_modified_custom_metric"
  metric_filter                        = local.vpc_metric_filter
  metric_descriptor_display_name       = "Custom Metric - VPC added/deleted/modified"
  alert_policy_display_name            = "VPC added/deleted/modified"
  alert_policy_conditions_display_name = "VPC added/deleted/modified"
}