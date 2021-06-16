# Specify the provider and access details
################################################################################

provider "azurerm" {
  version = ">=2.0.0"
  features {}
}

# Terraform Backend
################################################################################

terraform {

#    backend "local" {}
    
  backend "azurerm" {
    resource_group_name  = "terraform_state"
    storage_account_name = "terrastate"
    container_name       = "terrastate"
    key                  = "azure.terraform.tfstate"
  }
  
}

# Create Resource Group
################################################################################
resource "azurerm_resource_group" "devops" {
  name     = "${var.env}-${var.project}-RG"
  location = var.az_region
}

# Create Security Group
################################################################################
resource "azurerm_network_security_group" "devops" {
  name                = "${var.project}-NSG"
  location            = azurerm_resource_group.devops.location
  resource_group_name = azurerm_resource_group.devops.name
}

# Create VNET
################################################################################
 # Change vars of subnets {var.web-az1a-subnet-cidr}

resource "azurerm_virtual_network" "devops" {
  name                = "${var.project}-VNET"
  location            = azurerm_resource_group.devops.location
  resource_group_name = azurerm_resource_group.devops.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["8.8.8.8"]

  tags = {
    environment = var.env
  }
}

## Create Subnet
################################################################################

resource "azurerm_subnet" "devopsapp" {
  name                 = "${var.project}-${var.env}-app-subnet"
  resource_group_name  = azurerm_resource_group.devops.name
  virtual_network_name = azurerm_virtual_network.devops.name
  address_prefix       = "10.0.1.0/24"
  
}

resource "azurerm_subnet" "devopsweb" {
  name                 = "${var.project}-${var.env}-web-subnet"
  resource_group_name  = azurerm_resource_group.devops.name
  virtual_network_name = azurerm_virtual_network.devops.name
  address_prefix       = "10.0.2.0/24"
  
}

resource "azurerm_subnet" "devopsdb" {
  name                 = "${var.project}-${var.env}-db-subnet"
  resource_group_name  = azurerm_resource_group.devops.name
  virtual_network_name = azurerm_virtual_network.devops.name
  address_prefix       = "10.0.3.0/24"

}

resource "azurerm_subnet" "devopspublic" {
  name                 = "${var.project}-${var.env}-public-subnet"
  resource_group_name  = azurerm_resource_group.devops.name
  virtual_network_name = azurerm_virtual_network.devops.name
  address_prefix       = "10.0.4.0/24"

}

## Create Route
################################################################################
resource "azurerm_route_table" "devops" {
  name                          = "${var.project}-${var.env}-route"
  location                      = azurerm_resource_group.devops.location
  resource_group_name           = azurerm_resource_group.devops.name
  disable_bgp_route_propagation = false

  route {
    name           = "route1"
    address_prefix = "10.0.0.0/16"
    next_hop_type  = "vnetlocal"
  }

  tags = {
    environment = var.env
  }
}

## Create Whitist SG
################################################################################

module "whitelistsg" {
 source = "./modules/whitelist-sg"
 wsg_name = "whitelistsg"
 project = var.project
 location= var.location
 resource_group_name = "${azurerm_resource_group.devops.name}"
 #protocol = "${var.protocol}"
 #source_address_prefixes = ${var.ip_whitelist} 
 #source_port_range = "${var.port_range}"
 #destination_address_prefix = "${var.destination_address}"
}


## Public IP
################################################################################
##Added in Bastion module


## Storage Account for Diagnostics
################################################################################

resource "random_id" "randomId" {
    keepers = {
        resource_group = "${azurerm_resource_group.devops.name}"
    }
    
    byte_length = 8
}


resource "azurerm_storage_account" "devops" {
    name                = "diag${random_id.randomId.hex}"
    resource_group_name = azurerm_resource_group.devops.name
    location            = var.az_region
    account_replication_type = "LRS"
    account_tier = "Standard"

    tags = {
        environment = var.env
    }
}



## Create Vms
################################################################################
## bastion / app with asg

module "bastion" {
 source = "./modules/bastion"
 vm_name = "bastion"
 project = var.project
 location= var.location
 resource_group_name = azurerm_resource_group.devops.name
 vm_size = var.vm_size
 vmtype = var.vmtype
 vmsku = var.vmsku
 vm_useradmin = var.vm_useradmin
 public_key = var.public_key
 env = var.env
 #network_interface = azurerm_network_interface.devops.id
 primary_blob_endpoint = azurerm_storage_account.devops.primary_blob_endpoint
 network_security_group = module.whitelistsg.network_security_group_id
 subnet_id = azurerm_subnet.devopspublic.id
}

module "app" {
 source = "./modules/vm"
 vm_name = "app"
 project = var.project
 location= var.location
 resource_group_name = azurerm_resource_group.devops.name
 vm_size = var.vm_size
 vmtype = var.vmtype
 vmsku = var.vmsku
 vm_useradmin = var.vm_useradmin
 public_key = var.public_key
 env = var.env
 #network_interface = azurerm_network_interface.devops.id
 primary_blob_endpoint = azurerm_storage_account.devops.primary_blob_endpoint
 network_security_group = azurerm_network_security_group.devops.id
 subnet_id = azurerm_subnet.devopsapp.id
}
  
  
## Create Database
################################################################################
## Oracle DB 


module "db" {
 source = "./modules/db"
 db_name = "db"
 db_type = "sql"
 project = var.project
 location= var.location
 resource_group_name = azurerm_resource_group.devops.name
 sku_name = "B_Gen5_2"
 sku_capacity = "2"
 sku_tier = "Basic"
 sku_family  = "Gen5"
 storage_mb  = "5120"
 backup_retention_days = "7"
 geo_redundant_backup  = "Disabled"
 db_useradmin= var.db_useradmin
 db_password = var.db_password
 db_version = "12.0"

}

## Alert metrics
################################################################################
## 
module "alert_1" {
 source = "./modules/alerts"
 resource_group_name = "${var.env}-${var.project}-RG"
 location = var.location
 alert_name = "Test1"
 #criteria = ""
 environment = var.env
}

module "alert_2" {
 source = "./modules/alerts"
 resource_group_name = "${var.env}-${var.project}-RG"
 location = var.location
 alert_name = "Test2"
 #criteria = ""
 environment = var.env
}  
  
  
## Backup Vms
################################################################################
## 

module "app-backup" {
 source = "./modules/backup"
 vm_id = module.app.vm_id
 project = var.project
 location= var.location
 resource_group_name = azurerm_resource_group.devops.name
 backup_frequency = "Daily"
 backup_time = "23:00"
}


## Azure CDN
################################################################################
module "cdn" {
 source = "./modules/cdn"
 project = var.project
 location= var.location
 resource_group_name = "${var.env}-${var.project}-RG"
 environment = var.env
}



## Services Networking 
################################################################################
# Express Route # Queue # DNS Record
  
module "service_networking" {
 source = "./modules/service-networking"
 project = var.project
 location= var.location
 resource_group_name = "${var.env}-${var.project}-RG"
 environment = var.env
  
}  

## Fornt End
################################################################################
# Front Door # Appservices
  
module "frontend" {
 source = "./modules/serverless"
 project = var.project
 location= var.location
 resource_group_name = "${var.env}-${var.project}-RG"
 environment = var.env   
}  
