## Public IP
resource "azurerm_public_ip" "devops" {
    name                         = "${var.project}-${var.vm_name}-PublicIP"
    location                     = var.location
    resource_group_name          = var.resource_group_name
    allocation_method            = "Dynamic"

    tags = {
        environment = var.env
    }
}

## Virtual Network Interface
resource "azurerm_network_interface" "devops" {
    name                = "${var.project}-${var.vm_name}-NIC"
    location            = var.location
    resource_group_name = var.resource_group_name
    #network_security_group_id = var.network_security_group

    ip_configuration {
        name                          = "${var.project}-${var.vm_name}-NICConfiguration"
        subnet_id                     = var.subnet_id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.devops.id
    }

    tags = {
        environment = var.env
    }
}


## Virtual Machine Creation

resource "azurerm_virtual_machine" "devops" {
    name                  = "${var.project}-${var.vm_name}-VM"
    location              = var.location
    resource_group_name   = var.resource_group_name
    network_interface_ids = [azurerm_network_interface.devops.id]
    vm_size               = var.vm_size

    storage_os_disk {
        name              = "${var.project}-${var.vm_name}-Disk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "RedHat"
        offer     = var.vmtype
        sku       = var.vmsku
        version   = "latest"
    }

    os_profile {
        computer_name  = "${var.vm_name}VM"
        admin_username = var.vm_useradmin
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/${var.vm_useradmin}/.ssh/authorized_keys"
            key_data = var.public_key
        }
    }

    boot_diagnostics {
        enabled     = "true"
        storage_uri = var.primary_blob_endpoint
    }

   delete_os_disk_on_termination = true
   delete_data_disks_on_termination = true

    tags = {
        environment = var.env
    }
}


data "azurerm_public_ip" "devops" {
  name                = azurerm_public_ip.devops.name
  resource_group_name = var.resource_group_name
  depends_on          = [azurerm_virtual_machine.devops]
}

