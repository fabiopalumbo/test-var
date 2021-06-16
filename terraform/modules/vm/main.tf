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
        # public_ip_address_id          = var.public_ip
    }

    tags = {
        environment = "${var.env}"
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


  storage_data_disk {
    name              = "${var.project}-${var.vm_name}-DataDisk"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "50"
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

## VM scale set
/*
resource "azurerm_lb_backend_address_pool" "bpepool" {
 resource_group_name = azurerm_resource_group.vmss.name
 loadbalancer_id     = azurerm_lb.vmss.id
 name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "vmss" {
 resource_group_name = azurerm_resource_group.vmss.name
 loadbalancer_id     = azurerm_lb.vmss.id
 name                = "ssh-running-probe"
 port                = var.application_port
}

resource "azurerm_lb_rule" "lbnatrule" {
   resource_group_name            = azurerm_resource_group.vmss.name
   loadbalancer_id                = azurerm_lb.vmss.id
   name                           = "http"
   protocol                       = "Tcp"
   frontend_port                  = var.application_port
   backend_port                   = var.application_port
   backend_address_pool_id        = azurerm_lb_backend_address_pool.bpepool.id
   frontend_ip_configuration_name = "PublicIPAddress"
   probe_id                       = azurerm_lb_probe.vmss.id
}

resource "azurerm_virtual_machine_scale_set" "vmss" {
 name                = "vmscaleset"
 location            = var.location
 resource_group_name = azurerm_resource_group.vmss.name
 upgrade_policy_mode = "Manual"

 sku {
   name     = "Standard_DS1_v2"
   tier     = "Standard"
   capacity = 2
 }

 storage_profile_image_reference {
   publisher = "Canonical"
   offer     = "UbuntuServer"
   sku       = "16.04-LTS"
   version   = "latest"
 }

 storage_profile_os_disk {
   name              = ""
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "Standard_LRS"
 }

 storage_profile_data_disk {
   lun          = 0
   caching        = "ReadWrite"
   create_option  = "Empty"
   disk_size_gb   = 10
 }

 os_profile {
   computer_name_prefix = "vmlab"
   admin_username       = var.admin_user
   admin_password       = var.admin_password
   custom_data          = file("web.conf")
 }

 os_profile_linux_config {
   disable_password_authentication = false
 }

 network_profile {
   name    = "terraformnetworkprofile"
   primary = true

   ip_configuration {
     name                                   = "IPConfiguration"
     subnet_id                              = azurerm_subnet.vmss.id
     load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id]
     primary = true
   }
 }

 tags = var.tags
}
*/
