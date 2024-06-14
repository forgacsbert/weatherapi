terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0" # Use the latest stable version
    }
  }
}

terraform {
  backend "azurerm" {
    resource_group_name  = "tf_rg_blobstore"
    storage_account_name = "tfstorageaccountfb"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

variable "imagebuild" {
  type        = string
  description = "latest value of the image build"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "tf_test" {
  name     = "tfmainrg"
  location = "Germany West Central"
}

resource "azurerm_container_group" "tfcg_test" {
  name                = "weatherapi"
  location            = azurerm_resource_group.tf_test.location
  resource_group_name = azurerm_resource_group.tf_test.name

  ip_address_type = "Public"
  dns_name_label  = "forgacsbertwa"
  os_type         = "Linux"

  container {
    name   = "weatherapi"
    image  = "forgacsbert/weatherapi:${var.imagebuild}"
    cpu    = "1"
    memory = "1"

    ports {
      port     = 8080
      protocol = "TCP"
    }
  }
}
