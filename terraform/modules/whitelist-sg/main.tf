resource "azurerm_network_security_group" "devopswsg" {
  name                = "${var.project}-WHITELIST-SG"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "devopswsg-inbound" {
  name                        = "${var.project}-WHITELIST-IP-INBOUND"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefixes     = ["0.0.0.0"]
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.devopswsg.name
}

resource "azurerm_network_security_rule" "devopswsg-outbound" {
  name                        = "${var.project}-WHITELIST-IP-OUTBOUND"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefixes     = ["0.0.0.0"]
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.devopswsg.name
}
