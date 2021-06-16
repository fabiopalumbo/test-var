output "vm_id" {
  description = "Virtual machine ids created."
  value       = azurerm_virtual_machine.devops.id
}


output "network_interface_private_ip" {
  description = "private ip addresses of the vm nics"
  value       = azurerm_network_interface.devops.private_ip_address
}

