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

# To create the foundations project to store terraform state file
module "nhi-nci-foundations" {
  source               = "../../modules/nhi-nci/foundations"

  billing_account_id   = "01CB51-83915C-46BCF2"
  root_node            = "folders/171339314200" # nhi-nci-poc
  prefix               = "nhi-nci"
  iam_terraform_owners = ["user:farrukhhashmi@google.com"]
}
