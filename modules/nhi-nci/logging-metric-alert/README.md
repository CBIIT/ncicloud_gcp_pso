# Foundations Module

This sample module creates the Log based Metric and Alerts.

## Example

```hcl
module "monitoring_alert_iam" {
  source                               = "../../modules/nhi-nci/monitoring_alert"
  project_id                           = <project-id>
  notification_channel_names           = <notification-channel-names>
  metric_name                          = "iam_roles_permission_changed_custom_metric"
  metric_filter                        = "protoPayload.methodName:\"setIamPolicy\""
  metric_descriptor_display_name       = "Custom Metric - IAM role/permission changed"
  alert_policy_display_name            = "IAM role/permission changed"
  alert_policy_conditions_display_name = "IAM role/permission changed"
}
```

<!-- BEGIN TFDOC -->
## Variables

| name | description | type | required | default |
|---|---|:---: |:---:|:---:|
| project_id | Project id. | `string` | ✓ |  |
| metric_name | Logging metric name. | `string` | ✓ |  |
| metric_filter | Logs filter which is used to match log entries. | `string` | ✓ |  |
| metric_descriptor_display_name | Metric descriptor display name. | `string` | ✓ |  |
| alert_policy_display_name | Alert policy display name. | `string` | ✓ |  |
| alert_policy_conditions_display_name | Alert policy conditions display name. | `string` | ✓ |  |
| notification_channel_names | Notification channel names. | `list(string)` | ✓ |  |
| *resource_type* | Optional Resource type for filter. | `string`|  | `resource.type=\"global\"`|
<!-- END TFDOC -->