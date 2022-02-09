# Sample Terraform Script

These sample scripts

1. Create the foundations project to store terraform state files in GCS buckets.
2. Create two projects with custom roles and GCP group binding.
3. Create Global Load Balancer (GLB) with User Managed Certificate in Secret Manager.

## Custom IAM Role Sample

### Foundations Project Setup

**Note: Skip this section if a foundation project to hold terraform state buckets is not required.**

1. Go to `terraform\environments\foundations` folder.
2. Comment all lines in `backend.tf` file.
3. Run `terraform init` command.
4. Run `terraform plan` command and inspect all the GCP resources that will be created/udpated/deleted.
5. Run `terraform apply` command to apply changes to GCP.
6. Run `terraform output bootstrap_tf_gcs_bucket` to get the name of GCS bucket created for bootstrap project.
7. Update the bucket name in `backend.tf` file and uncomment all lines.
8. Run `terraform output tf-gcs-project-factory` to get the name of GCS bucket created for factory project(s).
9. Update the bucket name in `terraform\environments\project-factory\backend.tf` file.

### Project Factory Setup

1. Go to `terraform\environments\project-factory` folder.
2. If **Foundations Project Setup** section was skipped then comment all lines in `backend.tf` file.
3. Run `terraform init` command.
4. Run `terraform plan` command and inspect all the GCP resources that will be created/udpated/deleted.
5. Run `terraform apply` command to apply changes to GCP.

## GLB with User Managed Certificate in Secret Manager Sample

### Certificate Setup

1. Set the project id, replace <PROJECT_ID> with your project id.

    ```sh
    export PROJECT=<PROJECT_ID>
    gcloud config set project ${PROJECT}
    ```

2. Enable the required services in the project.

    ```sh
    gcloud services enable compute.googleapis.com
    gcloud services enable dns.googleapis.com
    gcloud services enable secretmanager.googleapis.com
    ```

3. Execute the commands below to create secrets in Secret Manager.
   * Run `cd terraform\environments\secret-manager` command to go to `terraform\environments\secret-manager` folder.
   * Run `terraform init` command.
   * Run `terraform plan` command and inspect all the GCP resources that will be created/udpated/destroyed.
   * Run `terraform apply` command to apply changes to GCP.

4. Create the private key and certificate using openssl.

    ```bash
    openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 \
    -subj "/CN=foo.endpoints.${PROJECT}.cloud.goog/O=${PROJECT} Inc" \
    -keyout keys/foo.endpoints.${PROJECT}.cloud.goog.key \
    -out keys/foo.endpoints.${PROJECT}.cloud.goog.crt
    ```

5. Add a secret version from the contents of a Cert and Key file created in prevoius step.

    ```bash
    gcloud secrets versions add tls-private-key --data-file=keys/foo.endpoints.${PROJECT}.cloud.goog.key
    gcloud secrets versions add tls-public-cert --data-file=keys/foo.endpoints.${PROJECT}.cloud.goog.crt
    ```

### Load Balancer Setup

1. Create a global static IP for the Google Cloud Load Balancer.

    ```sh
    gcloud compute addresses create ingress-ip --global
    ```

2. Get the static IP address.

    ```bash
    export GCLB_IP=$(gcloud compute addresses describe ingress-ip --global --format=json | jq -r '.address')
    echo ${GCLB_IP}
    ```

3. Go to `terraform\environments\load-balancer` folder by executing `cd terraform\environments\load-balancer` command.

4. Edit the `dns-spec.yaml` file and update ```$PROJECT-ID``` with your project id and ```$GCLB_IP``` with public IP that was created to step # 2.  
Note: To create a stable, human-friendly mapping to IP address, a public DNS record is required. Cloud Endpoints DNS provides a free Google-managed DNS record for a public IP.

5. Deploy the ```dns-spec.yaml``` file in your Cloud project.  
    The YAML specification defines the public DNS record in the form of foo.endpoints.PROJECT-ID.cloud.goog, where PROJECT-ID is your unique project number.

    ```sh
    gcloud endpoints services deploy dns-spec.yaml
    ```

6. Execute the terraform commands below to create Load Balancer with private Key and Certificate stored in Secret Manager.
   * Run `terraform init` command.
   * Run `terraform plan` command and inspect all the GCP resources that will be created/udpated/destroyed.
   * Run `terraform apply` command to apply changes to GCP.
