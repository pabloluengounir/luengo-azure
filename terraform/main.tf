terraform {
  required_providers {
      azurerm = {
          source = "hashicorp/azurerm"
          version = "=2.46.1"
      }
  }
}

provider "azurerm" {
    features {}
    subscription_id = "e1e77243-7152-44ac-b403-de283ff0fcc5"
    client_id = "b0ad4983-88f6-48c6-b439-dd1539c88414"
    client_secret = "fDuHGcCPeslc-SV7bpN~Y1Q9ykPcwuVl.2"
    tenant_id = "899789dc-202f-44b4-8472-a6d40f9eb440"
}

resource "azurerm_resource_group" "rg" {
  name = "kubernetes_rg"
  location = var.location

  tags = {
      environment = "CP2"
  }
}

resource "azurerm_storage_account" "stAccount" {
  name = "luengostaccountcp2"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  account_tier = "Standard"
  account_replication_type = "LRS"

  tags = {
      environment = "CP2"
  }
}