# Create a Cloud Build image factory using Packer

This guide shows you how to create an image factory using Cloud Build and Packer by HashiCorp. The image factory automatically creates new images from Cloud Source Repositories each time a new code is pushed to the repository.

## Note

* This guide uses Cloud Build default pools. Click [here](https://cloud.google.com/build/docs/private-pools/private-pools-overview#overview_of_default_pools_and_private_pools) to see an overview of default pools and private pools.
* If Cloud Build private pools are required:
  * Follow links in [Usefull Links](#useful-links) section to create/use Cloud Build private pools.
  * Set `_OMIT_EXTERNAL_IP` and `_USE_INTERNAL_IP` variables of Cloud Build trigger to `true` in [Create the build trigger for the image factory source repository](#create-the-build-trigger-for-the-image-factory-source-repository) section.
* Packer creates a temporary GCE instance and SSH into instance to customize it for custom image(s). Packer build will fail if a firewall rule to allow SSH for Cloud Build does not exist.
* You can run commands in this guide using Cloud Shell in the Cloud Console, or you can use gcloud on your local computer if you have installed the Cloud SDK.

## Prerequisites

* A GCP project.
* A Firewall rule to allow SSH (tcp:22) for Cloud Build.

## Set Environmental Variable

In this section, you will set the environmental variables for repository name and project id, that will be used in commands later.

Replace `<Repository-Name>` with repository name that will be created to host image factory artifacts, `<Project-Id>` with your project id and `<Network-Project-Id>` with your network project id.

**Note:** `<Network-Project-Id>` should be Shared VPC Host project id, if using Shared VPC otherwise it should be same as `<Project-Id>`.

```bash
REPO_NAME="<Repository-Name>"
NETWORK_PROJECT="<Network-Project-Id>"
PROJECT="<Project-Id>"
gcloud config set project $PROJECT
```

## Enable the required services

In this section, you enable the Google Cloud APIs required for this guide.

```bash
gcloud services enable sourcerepo.googleapis.com \
cloudapis.googleapis.com compute.googleapis.com \
servicemanagement.googleapis.com storage-api.googleapis.com \
cloudbuild.googleapis.com
```

## Give the Cloud Build service account permissions through IAM roles

In this section, you will find the Cloud Build service account and add the roles required to build an image.

```bash
CLOUD_BUILD_ACCOUNT=$(gcloud projects get-iam-policy $PROJECT --filter="(bindings.role:roles/cloudbuild.builds.builder)"  --flatten="bindings[].members" --format="value(bindings.members[])")

gcloud projects add-iam-policy-binding $PROJECT \
--member $CLOUD_BUILD_ACCOUNT \
--role roles/compute.instanceAdmin.v1

gcloud projects add-iam-policy-binding $PROJECT \
--member $CLOUD_BUILD_ACCOUNT \
--role roles/iam.serviceAccountUser

gcloud projects add-iam-policy-binding $PROJECT \
--member $CLOUD_BUILD_ACCOUNT \
--role roles/iap.tunnelResourceAccessor
```

## Create the repository in Cloud Source Repositories for image factory

In this section, you will create repository to host your Cloud Build configuration file, Packer template, and application file.

```bash
gcloud source repos create $REPO_NAME
```

## Copy the files for this guide to a new working directory and initialize Git repository

In this section, you will download the files to your local environment and initialize Git in the working directory.

1. Create and go to a new working directory:

    ```bash
    cd ~
    mkdir nci-poc-image-factory
    cd nci-poc-image-factory
    ```

2. Download the tutorial scripts:

    ```bash
    curl -L https://raw.githubusercontent.com/CBIIT/ncicloud_gcp_pso/main/packer/cloudbuild.yaml >cloudbuild.yaml

    curl -L https://raw.githubusercontent.com/CBIIT/ncicloud_gcp_pso/main/packer/main.pkr.hcl >main.pkr.hcl

    curl -L https://raw.githubusercontent.com/CBIIT/ncicloud_gcp_pso/main/packer/variables.pkr.hcl >variables.pkr.hcl

    curl -L https://raw.githubusercontent.com/CBIIT/ncicloud_gcp_pso/main/packer/index.html >index.html
    ```

3. Initialize a Git repository in the working directory:

    ```bash
    git init
    ```

## Create the build trigger for the image factory source repository

In this section, you will create a webhook/build-trigger to tell Cloud Build to pull down your committed files and start the build process automatically.

Replace `<Network>` with VPC name, `<SubNetwork>` with subnet name and `<Zone>` with GCP Zone, where temporary GCE instance will be created by Packer.

**Note:** Sample terraform code to create Cloud Build Trigger can be found [here](https://github.com/CBIIT/ncicloud_gcp_pso/blob/main/terraform/environments/cloudbuild-trigger/main.tf).

```bash
gcloud beta builds triggers create cloud-source-repositories \
--name=$REPO_NAME-trigger \
--repo=$REPO_NAME \
--branch-pattern=.* \
--build-config=cloudbuild.yaml \
--substitutions _IMAGE_FAMILY=nci-image-family-poc,_IMAGE_NAME=nci-debian-poc-image,_NETWORK_PROJECT_ID=$NETWORK_PROJECT,_NETWORK=<Network>,_SUBNETWORK=<SubNetwork>,_ZONE=<Zone>,_PROJECT_ID=$PROJECT,_SOURCE_IMAGE_FAMILY=debian-10,_SSH_USER=packer,_OMIT_EXTERNAL_IP=false,_USE_INTERNAL_IP=false
```

## Add the Packer Cloud Build image to your project

In this section, you will download the builder from the community repository and submit it to your project to create a Docker image that contains the Packer binaries. This Docker image will be used by Cloud Build to run Packer container.

```bash
project_dir=$(pwd)
mkdir tmp
cd /tmp
git clone https://github.com/GoogleCloudPlatform/cloud-builders-community.git
cd cloud-builders-community/packer
gcloud builds submit --config cloudbuild.yaml
cd $project_dir
rm -rf tmp
```

## Add your repository as a remote repository and push

In this section, you will configure the local Git instance to use the repository that you created.

1. (If running locally, not in Cloud Shell) Set up your Google credentials for Git:

    ```bash
    gcloud init && git config --global credential.https://source.developers.google.com.helper gcloud.sh
    ```

2. Add the repository as a remote:

    ```bash
    git remote add $REPO_NAME"_remote" https://source.developers.google.com/p/$PROJECT/r/$REPO_NAME
    ```

3. Add your files, and push them to your repository:

    ```bash
    git add .
    git commit -m "First image."
    git push $REPO_NAME"_remote"
    ```

## View build progress

Open the [**Cloud Build** page](https://console.cloud.google.com/cloud-build), find the build that is in progress, and click the link to view its progress.

## Cleaning up

1. Delete the Packer Cloud Build image:

    ```bash
    gcloud container images delete --quiet gcr.io/$PROJECT/packer  --force-delete-tags
    ```

2. Delete the Cloud Build trigger:

    ```bash
    gcloud beta builds triggers delete $REPO_NAME-trigger
    ```

3. Delete the repository:

    ```bash
    gcloud source repos delete --quiet $REPO_NAME
    ```

## Useful Links

* [Download Packer](https://www.packer.io/downloads)
* [Cloud Build - Private Pools](https://cloud.google.com/build/docs/private-pools/private-pools-overview)
* [Cloud Build - Set up Private Pool Environment](https://cloud.google.com/build/docs/private-pools/set-up-private-pool-environment)
* [Cloud Build - Create/Manage Private Pools](https://cloud.google.com/build/docs/private-pools/create-manage-private-pools)
