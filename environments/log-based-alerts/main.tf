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
}

#Notification Channel
module "security_notification_channel" {
  source        = "../../modules/nhi-nci/notification_channel"
  project_id    = local.project_id
  display_name  = "Security Notification"
  email_address = local.notification_email_address
}

# Log based alert for IAM roles/permission changes
module "log_based_alert_iam" {
  source                     = "../../modules/nhi-nci/log-based-alerts"
  project_id                 = local.project_id
  notification_channel_names = [module.security_notification_channel.name]
}