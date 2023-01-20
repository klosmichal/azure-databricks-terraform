resource "azurerm_key_vault" "kv" {
  name                      = "${var.env}-kv"
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled  = false
  sku_name                  = "standard"
  enable_rbac_authorization = true

  network_acls {
    default_action = "Deny"
    bypass = "AzureServices"
    ip_rules                   = [data.http.ip.response_body]
    virtual_network_subnet_ids = [azurerm_subnet.subnet.id, azurerm_subnet.public.id, azurerm_subnet.private.id]
  }
}

resource "azurerm_role_assignment" "keyvault_azuredatabricks" {
   scope                = azurerm_key_vault.kv.id
   role_definition_name = "Key Vault Administrator"
   principal_id         = var.AzureDatabricks_app_id
 }

resource "azurerm_key_vault_secret" "tenant-id" {
  name         = "tenant-id"
  value        = data.azurerm_client_config.current.tenant_id
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "client-id" {
  name         = "${var.kv-client-id-secret-name}"
  value        = azuread_service_principal.this.application_id
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "client-secret" {
  name         = "${var.kv-client-secret-secret-name}"
  value        = azuread_service_principal_password.this.value
  key_vault_id = azurerm_key_vault.kv.id
}
