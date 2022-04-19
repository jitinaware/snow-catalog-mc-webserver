locals {
  location            = data.terraform_remote_state.backend.outputs.az_location
  rg_name = data.terraform_remote_state.backend.outputs.az_rg_name
  
  subnet_id = data.terraform_remote_state.backend.outputs.az_subnet_1_id
}

resource "azurerm_public_ip" "azvm_pub_ip" {
  name                = "azvm_pub_ip"
  resource_group_name = local.rg_name
  location            = local.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "azvm_nic" {
  name                = "azvm_nic"
  location            = local.location
  resource_group_name = local.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = local.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.azvm_pub_ip.id
  }
}

resource "azurerm_network_security_group" "azvmnsg" {
  name                = "ssh_nsg"
  location            = local.location
  resource_group_name = local.rg_name

  security_rule {
    name                       = "allow_ssh_sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  network_interface_id      = azurerm_network_interface.azvm_nic.id
  network_security_group_id = azurerm_network_security_group.azvmnsg.id
}

resource "azurerm_linux_virtual_machine" "azvm_vm" {
  name                = "azvm"
  resource_group_name = local.rg_name
  location            = local.location
  size                = "Standard_B2s"
  network_interface_ids = [
    azurerm_network_interface.azvm_nic.id,
  ]

  admin_username = "azureuser"
  admin_ssh_key {
    username   = "azureuser"
    public_key = var.az_ssh_pubkey
    }
  

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7_9-gen2"
    version   = "latest"
  }
}



