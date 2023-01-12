output "internal_ip_address_vm_1" {
  description = "Internal IP address of the first VM"
  value = module.ya_instance_1.internal_ip_address_vm
}

output "external_ip_address_vm_1" {
  description = "External IP address of the first VM "
  value = module.ya_instance_1.external_ip_address_vm
}

output "internal_ip_address_vm_2" {
  description = "Internal IP address of the second VM"
  value = module.ya_instance_2.internal_ip_address_vm
}

output "external_ip_address_vm_2" {
  description = "External IP address of the second VM "
  value = module.ya_instance_2.external_ip_address_vm
}
