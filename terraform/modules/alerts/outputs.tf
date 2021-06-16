output "action_group_id" {
  description = "Notification Action Group ID"
  value       = azurerm_monitor_action_group.main.id
}

output "action_group_name" {
  description = "Notification Action Group name"
  value       = azurerm_monitor_action_group.main.name
}
/*
output "activity_log_alerts" {
  description = "Activity log alerts attributes"
  value       = azurerm_monitor_activity_log_alert.activity_log_alert
}
*/
