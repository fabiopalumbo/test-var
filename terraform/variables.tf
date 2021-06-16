## General ENV

variable "env" {default = "dev"}
variable "project" {default = "demo"}

## Resource Group

variable "location" {
  default = "Ireland"
}

## Azure region

variable "az_region" {default = "Ireland"}

## VMS
variable "vm_size" {
  default = "Standard_D1_v2"
}
variable "vmtype" {
  default = "RHEL"
}
variable "vmsku" {
  default = "7.4"
}
 
variable "vm_name" {
  default = "test"
}

variable "disk_size" {
  default = 30
}

variable "vm_useradmin" {
  default     = "daeda"
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "public_key" {
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCohXWgFUTuzH1Jmbo+TB+b85kR/7D/0Lvx/m38hNUGPfJRZCvdkAALOgfVnAWt66Q7V1VJ7q9VJhwiDgVjI08qE6FBdOk1mrvyXaqo00zHIRjpZGKcMHZgzDx6n/r89IUKSOr7/ATHNY98xpARB5RKgHyspQlmXzC+tJcRLDzLnTh2Zmu7GQSU+BLmIpTv3/9pzItbgFREw6xhxCg31E+FTGuDDPzW5SXCYiWS8u9XBbmx/asdnU/r0OuOvLeA5gX7YBU/PdCxO8uCoC6C4Fk2t3a6caG60NYuHYUDF5Ou83DHy+m74K2rPFYSbmMWdwiNhjIngUmsMwffBFQu0puX my-east1"
}

## DB Vars SQL

variable "db_name" {
  default     = "test"
}

variable "db_version" {
  default     = "12.0"
}

variable "db_useradmin" {
  default     = "admindb"
}

variable "db_password" {
  default     = "H@Sh1CoR3!"
}

variable "db_type" {
  default     = "sql"
}

## Vnet
variable "vnet_name" {
  description   = "vnet_name"
  default       = "demo-devops-vnet"
}

## Subnets

variable "az_suffix_1" {default = "a"}
variable "az_suffix_2" {default = "b"}

variable "web-az1a-subnet-cidr" {
  description   = "web-az1a-subnet-cidr"
  default       = "10.200.0.0/27"
}

variable "web-az1b-subnet-cidr" {
  description   = "web-az1b-subnet-cidr"
  default       = "10.200.0.32/27"
}

variable "app-az1a-subnet-cidr" {
  description   = "app-az1a-subnet-cidr"
  default       = "10.200.0.64/27"
}

variable "app-az1b-subnet-cidr" {
  description   = "app-az1b-subnet-cidr"
  default       = "10.200.0.96/27"
}

variable "db-az1a-subnet-cidr" {
  description   = "db-az1a-subnet-cidr"
  default       = "10.200.0.128/27"
}

variable "db-az1b-subnet-cidr" {
  description   = "db-az1b-subnet-cidr"
  default       = "10.200.0.160/27"
}

## Load Balancer

variable "web-lb-name" {
  description   = "web-lb-name"
  default       = "devops-lb"
}


## Whitelist SG

variable "ip_whitelist" {
  description   = "ip_whitelist"
  default       = ["0.0.0.0"]
}


