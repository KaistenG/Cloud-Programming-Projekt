
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  subscription_id = "221b02a8-00e5-4b5e-82fe-e22383354732" #auslesbar in az account show, unter "id:"
}

#Erstellen der Ressourcengruppe, in der die erstellen Ressourcen gesammelt werden
resource "azurerm_resource_group" "cpp-rg" { #cloudprogrammingprojekt
  name     = "cpp-resources"
  location = "germanywestcentral" #germanywestcentral wegen Azure for Students Abonnement
}

#Storage Account, da mit Azure for Students keine direkte statische Website genutzt werden kann
resource "azurerm_storage_account" "cpp-sa" {
  name                     = "cppstorageaccount253" #253 wegen eigener Name
  resource_group_name      = azurerm_resource_group.cpp-rg.name
  location                 = azurerm_resource_group.cpp-rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }

  tags = {
    environment = "dev"
  }
}

resource "azurerm_storage_blob" "cpp-blob-index" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.cpp-sa.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "../website/index.html" #"../ um aus dem terraform directory ins richtige zu wechseln beim ausführen
  content_type           = "text/html"
}

resource "azurerm_storage_blob" "cpp-blob-error" {
  name                   = "404.html"
  storage_account_name   = azurerm_storage_account.cpp-sa.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "../website/404.html"
  content_type           = "text/html"
}
