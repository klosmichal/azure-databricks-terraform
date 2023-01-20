# Basic information
Terraform scripts that create sample environment for Azure Databricks. They set up Resource Group with Databricks workspace (premium tier). Additionally they:
- add Secret Scope based on created Key Vault
- mount demo Container from created Storage Account
- create cluster with recent LTS version of Spark and minimal available hardware configuration
- add Service Principal with proper permissions to necessary services
- set up all services in Virtual Network so that access from Internet is blocked (with exception of user's IP)

# Usage
1. Set up your Azure subscription and make sure that you have owner access for it and at least Application Administrator role in your Azure AD.
2. Git clone the repo. You can either clone it locally and install terraform on your machine or use [Azure Cloud Shell](https://azure.microsoft.com/en-us/get-started/azure-portal/cloud-shell/#overview).
3. Modify `variables.tf` script and set `env` value to something unique. It will be used as a prefix for all services that are set up. You can also change region that will be used or name of sample container that is created.
4. While in cloned repo directory run `terraform init`
5. After proper init run `terraform apply` to set up whole environment (it can take few minutes).
6. Enjoy! :)
