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

###
#LOG BASED METRIC
###
resource "google_logging_metric" "logging_metric" {
  name   = var.metric_name
  filter = var.metric_filter
  metric_descriptor {
    metric_kind  = "DELTA"
    value_type   = "INT64"
    unit         = "1"
    display_name = var.metric_descriptor_display_name
  }
  project = var.project_id
}
###
#ALERTS
###
resource "google_monitoring_alert_policy" "monitoring_alert_policy" {
  project      = var.project_id
  display_name = var.alert_policy_display_name
  combiner     = "OR"
  conditions {
    display_name = var.alert_policy_conditions_display_name
    condition_threshold {
      filter     = "metric.type=\"logging.googleapis.com/user/${google_logging_metric.logging_metric.id}\" AND ${var.resource_type}"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        cross_series_reducer = "REDUCE_COUNT"
        per_series_aligner   = "ALIGN_RATE"
      }
      duration        = "0s"
      threshold_value = 0.0
      trigger {
        count = 1
      }
    }
  }
  alert_strategy {
    auto_close = "1800s"
  }
  notification_channels = var.notification_channel_names
  depends_on = [
    google_logging_metric.logging_metric
  ]
}