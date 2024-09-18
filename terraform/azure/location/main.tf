data "azurerm_client_config" "current" {}

locals {
  location = {
    id : var.id
    description : var.description
    type : "azure"
    region : var.region
    engine : var.engine,
    image : { type : var.image_type, java : var.java_version }
    size : var.size
    subscription : data.azurerm_client_config.current.subscription_id
    network-id : "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${var.virtual_network}"
    subnet-name : var.subnet_name
    associate-public-ip : var.associate_public_ip
    system-properties : var.system_properties
    java-home : var.java_home
    jvm-options : var.jvm_options,
  }
}
