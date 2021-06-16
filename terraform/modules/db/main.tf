resource "azurerm_sql_server" "devops" {
  name                = "${var.project}-${var.db_name}-${var.db_type}"
  location            = var.location
  resource_group_name = var.resource_group_name
  
  /*
  sku {
    name     = var.sku_name
    capacity = var.sku_capacity
    tier     = var.sku_tier
    family   = var.sku_family
  }
  */
  /*
  storage_profile {
    storage_mb            = var.storage_mb
    backup_retention_days = var.backup_retention_days
    geo_redundant_backup  = "Disabled"
  }
  */
    
  administrator_login          = var.db_useradmin
  administrator_login_password = var.db_password
  version                      = var.db_version
  # ssl_enforcement              = "Enabled"
}

