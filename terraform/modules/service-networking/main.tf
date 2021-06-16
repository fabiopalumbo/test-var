## Express Route

resource "azurerm_express_route_circuit" "this" {
  name                  = "${var.environment}expressRoute1"
  resource_group_name   = var.resource_group_name
  location              = var.location
  service_provider_name = "Equinix"
  peering_location      = "Silicon Valley"
  bandwidth_in_mbps     = 50

  sku {
    tier   = "Standard"
    family = "MeteredData"
  }

  tags = {
    environment = "Production"
  }
}

# Queue
resource "azurerm_storage_account" "this_storage" {
  name                     = "${var.environment}storageacc"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_queue" "this_queue" {
  name                 = "${var.environment}queue"
  storage_account_name =  azurerm_storage_account.this_storage.name
}

## DNS
resource "azurerm_dns_zone" "this_dns" {
  name                = var.domain
  resource_group_name = var.resource_group_name
}

resource "azurerm_dns_a_record" "example" {
  name                = "test"
  zone_name           = azurerm_dns_zone.this_dns.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = ["10.0.180.17"]
}
