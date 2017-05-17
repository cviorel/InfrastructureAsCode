resource "azurerm_resource_group" "cluster" {
  name = "tf-we-cluster"
  location = "${var.az_we}"
}

resource "azurerm_virtual_network" "cluster" {
  name = "tf-we-cluster-net"
  address_space = [
    "10.0.0.0/16"]
  location = "${var.az_we}"
  resource_group_name = "${azurerm_resource_group.cluster.name}"
}


resource "azurerm_subnet" "cluster_sub_01" {
  name = "tf-we-cluster-sub-01"
  resource_group_name = "${azurerm_resource_group.cluster.name}"
  virtual_network_name = "${azurerm_virtual_network.cluster.name}"
  address_prefix = "10.1.0.0/24"
}

resource "azurerm_storage_account" "cluster_slow" {
  name = "tfweclusterstoreslow"
  resource_group_name = "${azurerm_resource_group.cluster.name}"
  location = "${var.az_we}"
  account_type = "Standard_LRS"
}

resource "azurerm_storage_account" "cluster_fast" {
  name = "tfweclusterstorefast"
  location = "${var.az_we}"
  resource_group_name = "${azurerm_resource_group.cluster.name}"

  account_type = "Premium_LRS"
}

resource "azurerm_storage_container" "cluster_images_fast_vhds" {
  name = "vhds"
  resource_group_name = "${azurerm_resource_group.cluster.name}"
  storage_account_name = "${azurerm_storage_account.cluster_fast.name}"
  container_access_type = "private"
}

resource "azurerm_storage_container" "cluster_images_slow_images" {
  name = "images"
  resource_group_name = "${azurerm_resource_group.cluster.name}"
  storage_account_name = "${azurerm_storage_account.cluster_fast.name}"
  container_access_type = "private"
}

resource "azurerm_storage_container" "cluster_images_slow_vhds" {
  name = "vhds"
  resource_group_name = "${azurerm_resource_group.cluster.name}"
  storage_account_name = "${azurerm_storage_account.cluster_slow.name}"
  container_access_type = "private"
}

resource "azurerm_storage_container" "cluster_images_slow_images" {
  name = "images"
  resource_group_name = "${azurerm_resource_group.cluster.name}"
  storage_account_name = "${azurerm_storage_account.cluster_slow.name}"
  container_access_type = "private"
}

resource "azurerm_availability_set" "cluster" {
  name = "TF-WE-CLUSTER01-AVG01"
  location = "${var.az_we}"
  resource_group_name = "${azurerm_resource_group.cluster.name}"
}

