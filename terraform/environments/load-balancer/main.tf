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
  project_id              = "nhi-nci-lb-project-poc-dev"
  rule_name               = "lb-poc"
  bucket_name             = "nih-nic-content-bucket-poc"
  ip_address              = "35.244.139.79"
  domain                  = "foo.endpoints.nhi-nci-lb-project-poc-dev.cloud.goog"
  public-cert-secret-name = "tls-public-cert"
  private-key-secret-name = "tls-private-key"
}

module "poc-lb" {
  source                  = "../../modules/nhi-nci/bucket-load-balancer"
  project_id              = local.project_id
  rule_name               = local.rule_name
  bucket_name             = local.bucket_name
  ip_address              = local.ip_address
  domain                  = local.domain
  public-cert-secret-name = local.public-cert-secret-name
  private-key-secret-name = local.private-key-secret-name
}