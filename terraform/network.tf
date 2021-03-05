# Red Virtual con IPs 10.0.0.0/16
resource "azurerm_virtual_network" "myNet" {
    name = "kubernetesnet"
    address_space = [ "10.0.0.0/16" ]
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    tags = {
        environment = "CP2"
    }
}

# Subred con IPs 10.0.1.0/24
resource "azurerm_subnet" "mySubnet" {
  name = "terraformsubnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.myNet.name
  address_prefixes = ["10.0.1.0/24"]
}

# Creacion de 1 IP publica por cada VM
resource "azurerm_public_ip" "myPublicIp" {
  name = "vmip${var.vms[count.index]}"
  count = length(var.vms)
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method = "Dynamic"
  sku = "Basic"

  tags = {
      environment = "CP2"
  }
}

# Creacion de 1 interfaz de red por cada VM
resource "azurerm_network_interface" "myNic" {
  name = "nic-${var.vms[count.index]}"
  count = length(var.vms)
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name = "ipconf-${var.vms[count.index]}"
    subnet_id = azurerm_subnet.mySubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.1.${count.index + 10}"
    public_ip_address_id = azurerm_public_ip.myPublicIp[count.index].id
  }

  tags = {
      environment = "CP2"
  }
}