terraform {
  required_version = ">= 1.5.1"

  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.116.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.53.1"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = "53f3dc0a-512f-4399-817d-c4a55242d086"
  features {}
}

provider "azurerm" {
  alias           = "hub"
  subscription_id = var.hub_subscription_id
  tenant_id       = "53f3dc0a-512f-4399-817d-c4a55242d086"
  features {}
}
# The purpose of this provider is to connect to a subscription where storage of monitoring resources will be centralized
provider "azurerm" {
  alias           = "monitoring"
  subscription_id = var.azure_provider_monitoringstore.subscription_id
  tenant_id       = "53f3dc0a-512f-4399-817d-c4a55242d086"
  features {}
}

provider "azuread" {
  tenant_id = var.azure_provider_monitoringstore.tenant_id
}