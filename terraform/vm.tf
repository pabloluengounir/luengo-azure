resource "azurerm_linux_virtual_machine" "myVM" {
  name                            = "${var.vms[count.index]}-vm"
  count                           = length(var.vms)
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = var.vm_size
  admin_username                  = "adminLuengo"
  network_interface_ids           = [azurerm_network_interface.myNic[count.index].id]
  disable_password_authentication = true

  #usuario y key para acceder mediante SSh a la maquina
  admin_ssh_key {
    username   = "adminLuengo"
    public_key = file("../id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  plan {
    name      = "centos-8-stream-free"
    product   = "centos-8-stream-free"
    publisher = "cognosys"
  }

  # imagen a utilizar por la maquina
  source_image_reference {
    publisher = "cognosys"
    offer     = "centos-8-stream-free"
    sku       = "centos-8-stream-free"
    version   = "1.2019.0810"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.stAccount.primary_blob_endpoint
  }

  tags = {
    environment = "CP2"
  }
}

# Definicion de un disco duro adicional que luego sera añadido a las maquinas
resource "azurerm_managed_disk" "nfsMD" {
  name                 = "data-${var.vms[count.index]}"
  count                = length(var.vms)
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 32
}

# Asignacion de un disco duro a una maquina virtual
resource "azurerm_virtual_machine_data_disk_attachment" "nfsDA" {
  count              = length(var.vms)
  managed_disk_id    = azurerm_managed_disk.nfsMD[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.myVM[count.index].id
  lun                = "0"
  caching            = "ReadWrite"
}
