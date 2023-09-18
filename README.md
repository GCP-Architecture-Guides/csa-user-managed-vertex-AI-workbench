# SecureVertexWorkbench


This is not an officially supported Google product.
This code creates a secure demo environment for Vertex AI Workbench. This demo code is not built for production workload. 


# Demo Guide
This Cloud Security Architecture uses terraform to setup Vertex AI Wrokbench demo in a project and underlying infrastructure using Google Cloud Services like [VPC Service Controls](https://cloud.google.com/vpc-service-controls), [Cloud Firewall](https://cloud.google.com/firewall), [Identity and Access Management](https://cloud.google.com/iam), [Cloud Compute Engine](https://cloud.google.com/compute) and [Cloud Logging](https://cloud.google.com/logging).


## Demo Architecture Diagram
The image below describes the architecture of CSA Vertex AI Workbench demo to deploy a secure Workbench instance for development purposes.

![Architecture Diagram](./SecureVertexWorkbench.png)



## What resources are created?
Main resources:
- Project
- Organization Policies
- IAM Service Accounts
- Virtual Privacte Cloud Network and Cloud Firewalls
- VPC Service Control Permieter
- Cloud Storage Bucket
- Vertex AI Workbench Instance




## How to deploy?
The following steps should be executed in Cloud Shell in the Google Cloud Console. 

### 1. Get the code
Clone this github repository go to the root of the repository.

``` 
git clone https://github.com/GCP-Architecture-Guides/csa-user-managed-vertex-AI-workbench.git
cd csa-user-managed-vertex-AI-workbench
```

### 2. Deploy the infrastructure using Terraform


From the root folder of this repo, run the following commands:

```
export TF_VAR_organization_id=[YOUR_ORGANIZATION_ID]
export TF_VAR_billing_account=[YOUR_PROJECT_ID]
export TF_VAR_folder_id=[PARENT_FOLDER_FOR_PROJECT] 
export TF_VAR_vpc_sc_users=["user:NAME@ORG-DOMAIN.com"]
terraform init
terraform apply
terraform apply --refresh-only
```

To find your organization id, run the following command: 
```
gcloud projects get-ancestors [ANY_PROJECT_ID]
```



**Note:** All the other variables are give a default value. If you wish to change, update the corresponding variables in variable.tf file.



## How to clean-up?

From the root folder of this repo, run the following command:
```
terraform destroy
```
**Note:** If you get an error while destroying, it is likely due to delay in VPC-SC destruction rollout. Just execute terraform destroy again, to continue clean-up.
