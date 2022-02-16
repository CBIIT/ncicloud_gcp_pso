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
  project_id                 = "nhi-nci-lb-project-poc-dev"
  notification_email_address = "farrukhhashmi@google.com"
  iam_metric_filter          = "protoPayload.methodName:\"setIamPolicy\" AND NOT protoPayload.authenticationInfo.principalEmail = (\"farrukhhashmi1@google.com\" OR \"hashmisf@gmail.com\")"
  vpc_metric_filter          = "(protoPayload.methodName:\"compute.networks\" OR protoPayload.methodName:\"compute.subnetworks\") AND NOT (protoPayload.methodName:\"get\" OR protoPayload.methodName:\"list\") AND NOT protoPayload.authenticationInfo.principalEmail = (\"farrukhhashmi1@google.com\" OR \"hashmisf@gmail.com\") AND resource.type=(\"gce_network\" OR \"gce_subnetwork\")"
}

#Notification Channel
resource "google_monitoring_notification_channel" "notification_channel" {
  display_name = "Security Notification"
  project      = local.project_id
  type         = "email"
  labels = {
    email_address = local.notification_email_address
  }
}

# Log based alert for IAM roles/permission changes
module "log_based_alert_iam" {
  source                               = "../../modules/nhi-nci/log-based-alerts"
  project_id                           = local.project_id
  notification_channel_name            = google_monitoring_notification_channel.notification_channel.name
  metric_name                          = "iam_roles_permission_changed_custom_metric"
  metric_filter                        = local.iam_metric_filter
  metric_descriptor_display_name       = "Custom Metric - IAM role/permission changed"
  alert_policy_display_name            = "IAM role/permission changed"
  alert_policy_conditions_display_name = "IAM role/permission changed"
}

# Log based alert for VPC/Subnet changes
module "log_based_alert_vpc" {
  source                               = "../../modules/nhi-nci/log-based-alerts"
  project_id                           = local.project_id
  notification_channel_name            = google_monitoring_notification_channel.notification_channel.name
  metric_name                          = "vpc_added_deleted_modified_custom_metric"
  metric_filter                        = local.vpc_metric_filter
  metric_descriptor_display_name       = "Custom Metric - VPC added/deleted/modified"
  alert_policy_display_name            = "VPC added/deleted/modified"
  alert_policy_conditions_display_name = "VPC added/deleted/modified"
}