# Foundations Module

This sample module creates the notification channel.

## Example

```hcl
module "security_notification_channel" {
  source        = "../../modules/nhi-nci/notification_channel"
  project_id    = <project-id>
  display_name  = <display_name>
  email_address = <notification_email_address>
}
```

<!-- BEGIN TFDOC -->
## Variables

| name | description | type | required | default |
|---|---|:---: |:---:|:---:|
| project_id | Project id. | `string` | ✓ |  |
| display_name | Display name of notification channel. | `string` | ✓ |  |
| email_address | Email address where notification will be sent. | `string` | ✓ |  |

## Outputs

| name | description | sensitive |
|---|---|:---:|
| name | Notification channel name that was created. |  |
<!-- END TFDOC -->