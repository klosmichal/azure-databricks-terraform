terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.37.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.15.0"
    }
    databricks = {
      source = "databricks/databricks"
    }
    http = {
      source = "hashicorp/http"
      version = "~> 3.2.1"
    }
  }
  required_version = ">= 1.3.6"
}

data "azurerm_client_config" "current" {}

provider "azurerm" {
    features {}
}

provider "databricks" {
    azure_workspace_resource_id = azurerm_databricks_workspace.dbricksworkspace.id
}

provider "azuread" {
    tenant_id = data.azurerm_client_config.current.tenant_id
}

data "http" "ip" {
  url = "https://ifconfig.me/ip"
}