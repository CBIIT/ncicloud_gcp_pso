# Foundations Module

This sample module creates the Log based Metric and Alerts.

## Example

```hcl
module "log_based_alert_iam" {
  source                     = "../../modules/nhi-nci/log-based-alerts"
  project_id                 = <project-id>
  notification_channel_names = <notification-channel-names>
}
```

<!-- BEGIN TFDOC -->
## Variables

| name | description | type | required | default |
|---|---|:---: |:---:|:---:|
| project_id | Project id. | `string` | ✓ |  |
| notification_channel_names | Notification channel names. | `list(string)` | ✓ |  |
<!-- END TFDOC -->