# Variable para definir la zona horario de los recursos
variable "location" {
  type = string
  description = "Azure region where infraestrucutre will be created."
  default = "West Europe"
}

# Variable para indicar a las VMs de que tipo son
variable "vm_size" {
  type = string
  description = "VM size"
  default = "Standard_D1_v2" # 3.5 GB, 1 CPU
  # Standard_D2_v2 --> Seria recomdable usar este tipo de maquinas
  # para que no haya problemas de recursos, pero por el tipo de cuenta
  # no es posible
}

# Numero y nombres de las maquinas virtuales a levantar
variable "vms" {
  description = "VMs to create"
  type = list(string)
  default = ["master", "worker0", "worker1", "nfs"]
}
