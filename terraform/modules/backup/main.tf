resource "azurerm_recovery_services_vault" "devops" {
  name                = "${var.project}-vault"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
}

/*
resource "azurerm_recovery_services_protection_policy_vm" "devops" {
  name                = "${var.project}-vault-policy"
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.devops.name

  backup {
    frequency = var.backup_frequency
    time      = var.backup_time
  }
 
  retention_daily {
    count = "7"
  }  
}

resource "azurerm_recovery_services_protected_vm" "vm1" {
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.devops.name
  source_vm_id        = var.vm_id
  backup_policy_id    = azurerm_recovery_services_protection_policy_vm.devops.id
}
*/
