resource "azurerm_resource_group" "rg" {
  name     = "${var.env}-rg"
  location = var.region
}
