resource "azurerm_databricks_workspace" "dbricksworkspace" {
  name                        = "${var.env}-dbricks"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  sku                         = "premium"
  managed_resource_group_name = "${var.env}-dbricks-rg"

  public_network_access_enabled = true

  custom_parameters {
    no_public_ip        = true
    public_subnet_name  = azurerm_subnet.public.name
    private_subnet_name = azurerm_subnet.private.name
    virtual_network_id  = azurerm_virtual_network.vnet.id

    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.public.id
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.private.id
  }

  depends_on = [
    azurerm_subnet_network_security_group_association.public,
    azurerm_subnet_network_security_group_association.private,
  ]
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true

  depends_on = [
    azurerm_databricks_workspace.dbricksworkspace
  ]
}

data "databricks_node_type" "smallest" {
  min_cores  = 4
  depends_on = [
    azurerm_databricks_workspace.dbricksworkspace
  ]
}

resource "databricks_cluster" "dbricks_cluster" {
  cluster_name = "${var.env}-cluster"

  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = data.databricks_node_type.smallest.id
  num_workers             = 1
  autotermination_minutes = 20

  spark_conf = {
    "spark.databricks.pip.ignoreSSL":"true",
    "spark.databricks.delta.preview.enabled":"true"
  }
}


resource "databricks_secret_scope" "kv-secret-scope" {
  name = "kv-secret_scope"

  keyvault_metadata {
    resource_id = azurerm_key_vault.kv.id
    dns_name    = azurerm_key_vault.kv.vault_uri
  }
  depends_on = [
    azurerm_key_vault.kv
  ]
}

resource "databricks_service_principal" "sp" {
  application_id = azuread_application.this.application_id
  display_name   = "${var.env}_service_principal"
}

resource "databricks_mount" "this" {
  resource_id = azurerm_storage_container.this.resource_manager_id
  cluster_id = databricks_cluster.dbricks_cluster.id
  
  abfs {
    client_id              = azuread_application.this.application_id
    client_secret_scope    = databricks_secret_scope.kv-secret-scope.name
    client_secret_key      = "client-secret"
    initialize_file_system = true
  }
}