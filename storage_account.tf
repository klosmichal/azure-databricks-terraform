resource "azurerm_storage_account" "sa" {
  name                          = "${var.env}adls"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  account_kind                  = "StorageV2"
  is_hns_enabled                = "true"

  network_rules {
    default_action             = "Deny"
    bypass                     = ["AzureServices"]
    ip_rules                   = [data.http.ip.response_body]
    virtual_network_subnet_ids = [azurerm_subnet.subnet.id, azurerm_subnet.public.id, azurerm_subnet.private.id]
  }
}

resource "azurerm_storage_container" "this" {
  name                  = "${var.container-name}"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

resource "azurerm_role_assignment" "storage_azuredatabricks" {
   scope                = azurerm_storage_account.sa.id
   role_definition_name = "Storage Blob Data Owner"
   principal_id         = var.AzureDatabricks_app_id
}

resource "azurerm_role_assignment" "storage_serviceprincipal" {
   scope                = azurerm_storage_account.sa.id
   role_definition_name = "Storage Blob Data Owner"
   principal_id         = azuread_service_principal.this.object_id
}
