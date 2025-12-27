# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-us-demo"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-us-demo"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# App Service Plan (Free tier)
resource "azurerm_service_plan" "app_plan" {
  name                = "asp-free-us"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

# Random integer for unique web app name
resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

# Linux Web App
resource "azurerm_linux_web_app" "web_app" {
  name                = "fastapi-demo-us-${random_integer.rand.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.app_plan.id

  site_config {
    application_stack {
      python_version = "3.10"
    }
  }
}
