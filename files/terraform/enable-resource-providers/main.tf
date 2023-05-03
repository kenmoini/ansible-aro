provider "azurerm" {
  features {}

  skip_provider_registration = true
}

resource "azurerm_resource_provider_registration" "subscription" {
  name = "Microsoft.Subscription"
}
resource "azurerm_resource_provider_registration" "quota" {
  name = "Microsoft.Quota"
}
resource "azurerm_resource_provider_registration" "containerregistry" {
  name = "Microsoft.ContainerRegistry"
}
resource "azurerm_resource_provider_registration" "authorization" {
  name = "Microsoft.Authorization"
}
resource "azurerm_resource_provider_registration" "network" {
  name = "Microsoft.Network"
}
resource "azurerm_resource_provider_registration" "storage" {
  name = "Microsoft.Storage"
}
resource "azurerm_resource_provider_registration" "compute" {
  name = "Microsoft.Compute"
}
resource "azurerm_resource_provider_registration" "redhatopenShift" {
  name = "Microsoft.RedHatOpenShift"
}

