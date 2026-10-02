# ============================================================
# SUBNET
# ============================================================

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-ansible"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = ["10.0.4.0/24"]
}


# ============================================================
# NSG
# ============================================================

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-ansible"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "${var.my_public_ip}/32"
    destination_address_prefix = "*"
  }
}


# ============================================================
# ASSOCIATION NSG AU SUBNET
# ============================================================

resource "azurerm_subnet_network_security_group_association" "nsg_subnet" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}


# ============================================================
# PUBLIC IP
# ============================================================

resource "azurerm_public_ip" "public_ip" {
  name                = "public-ip-ansible"
  resource_group_name = var.resource_group_name
  location            = var.location

  allocation_method = "Static"
  sku               = "Standard"
}


# ============================================================
# NETWORK INTERFACE
# ============================================================

resource "azurerm_network_interface" "nic" {
  name                = "nic-ansible"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}


# ============================================================
# SSH KEY
# ============================================================

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


# ============================================================
# VM
# ============================================================

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "ansible-vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_D2s_v3"

  admin_username = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.private_key.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
