output "sql_server_name" {
  value       = azurerm_sql_server.devops.name
}

output "sql_server_location" {
  value       = azurerm_sql_server.devops.location
}

output "sql_server_version" {
  value       = azurerm_sql_server.devops.version
}

output "sql_server_fqdn" {
  value       = azurerm_sql_server.devops.fully_qualified_domain_name
}

#output "network_interface_private_ip" {
#  value       = azurerm_sql_server.devops.network_interface_private_ip
#}


