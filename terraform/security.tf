resource "azurerm_network_security_group" "mySecGroup" {
  name = "sshtraffic"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
      name = "SSH"
      priority = 1001
      direction = "Inbound"
      access = "Allow"
      protocol = "Tcp"
      source_port_range = "*"
      destination_port_range = "22"
      source_address_prefix = "*"
      destination_address_prefix = "*"
  }

  tags = {
      environment = "CP2"
  }
}

resource "azurerm_subnet_network_security_group_association" "mySecGroupAssociation1" {
  subnet_id = azurerm_subnet.mySubnet.id
  network_security_group_id = azurerm_network_security_group.mySecGroup.id
}