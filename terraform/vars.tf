variable "location" {
  type = string
  description = "Azure region where infraestrucutre will be created."
  default = "West Europe"
}

variable "vm_size" {
  type = string
  description = "VM size"
  default = "Standard_D1_v2" # 3.5 GB, 1 CPU
  # Standard_D2_v2 --> Si D1 no es suficiente por CPU o RAM
}

variable "vms" {
  description = "VMs to create"
  type = list(string)
  default = ["master", "worker0", "worker1", "nfs"]
}
