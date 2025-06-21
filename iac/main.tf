terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.4.0"
}

provider "azurerm" {
  features {}
}

data "template_file" "cloud_init" {
  template = file("${path.module}/templates/cloud-init.tpl")

  vars = {
    html_content = file("${path.module}/html/index.html")
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "waracle-rg"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "waracle-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "web-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "web-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow-http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_interface" "nic" {
  name                = "web-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web_public_ip.id
  }
}

resource "azurerm_public_ip" "web_public_ip" {
  name                = "web-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

resource "azurerm_linux_virtual_machine" "web_vm" {
  name                = "web-vm"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+W4LpiOzxAQ40KwOCzd+/6hezkXlgzfFGWT6FSnAbKZj6hE/kmP8cgc/vNuXSPKy0TiGcKboMowi2tDPCvEYzlSOoZIIyOragL1a9z9agsuzaTdBTiGVQgpAs2hnRu7fECssqWka3fxrce0OuHZ+q6O6CKBGMt2wVANd41n7ppTHMd7QVzIMyYgkXQh3HFFzVX/oap1sVDbVItlpUmc1SJqyCpy6dGpie59FUtoZwz574osTzowDCMU8C0vOkjkX5//oLZQjFWfrPpCrGYViukLrn5XbqAY15JJg7va/VEV9pxSFaMBtEZeRZ9a4RgocKWW2uWXGrdjsH9/Snho8j"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  custom_data = base64encode(data.template_file.cloud_init.rendered)
}


