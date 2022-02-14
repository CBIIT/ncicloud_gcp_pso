# Bucket Load Balancer Module

This sample module allows creation of a Global Load Balancer (GLB) with User Managed Certificate in Secret Manager.

## Example

```hcl
module "poc-lb" {
  source      = "../../modules/nhi-nci/bucket-load-balancer"

  project_id  = <project-id>
  rule_name   = <rule-name>
  bucket_name = <backend-bucket-name>
  ip_address  = <public-ip-address>
  domain      = <domain-name>
}
```

<!-- BEGIN TFDOC -->
## Variables

| name | description | type | required | default |
|---|---|:---: |:---:|:---:|
| project_id | Project id. | `string` | ✓ |  |
| rule_name | Global forwarding rule name. | `string` | ✓ |  |
| bucket_name | Backend GCS bucket name. | `string` | ✓ |  |
| ip_address | Public IP address. | `string` | ✓ |  |
| domain | Domain name. | `string` | ✓ |  |
| private-key-secret-name | Private key secret name. | `string` | ✓ |  |
| public-cert-secret-name | Public certificate secret name. | `string` | ✓ |  |
| enable_cdn | Enable CDN. | `string` |  | true |
<!-- END TFDOC -->