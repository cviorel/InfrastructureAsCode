resource "azurerm_public_ip" "cluster" {
  count = "${var.server_count}"

  name = "tf-we-cluster${format("%02d", count.index)}-ip01"
  location = "${var.az_we}"
  resource_group_name = "${azurerm_resource_group.cluster.name}"
  public_ip_address_allocation = "static"

}

resource "azurerm_network_interface" "cluster" {
  count = "${var.server_count}"

  name = "tfwecluster01cluster${format("%02d", count.index)}int01"
  location = "${var.az_we}"
  resource_group_name = "${azurerm_resource_group.cluster.name}"
  network_security_group_id = "${azurerm_network_security_group.cluster.id}"

  ip_configuration {
    name = "tf-we-test01-cluster${format("%02d", count.index)}-int01"
    subnet_id = "${azurerm_subnet.cluster_sub_01.id}"
    public_ip_address_id = "${element(azurerm_public_ip.cluster.*.id, count.index)}"
    private_ip_address_allocation = "dynamic"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.cluster.id}"]
  }
}


resource "azurerm_virtual_machine" "cluster" {
  count = "${var.server_count}"

  name = "doc${format("%02d", count.index)}.we.tulun.tv"
  location = "${var.az_we}"
  resource_group_name = "${azurerm_resource_group.cluster.name}"
  network_interface_ids = [
    "${element(azurerm_network_interface.cluster.*.id, count.index)}"
  ]
  vm_size = "${var.az_server_co_4c_8g_ps}"
  availability_set_id = "${azurerm_availability_set.cluster.id}"

  delete_os_disk_on_termination = true

  //  storage_image_reference {
  //    publisher = "${var.ubuntu.publisher}"
  //    offer = "${var.ubuntu.offer}"
  //    sku = "${var.ubuntu.sku}"
  //    version = "${var.ubuntu.version}"
  //  }

  storage_os_disk {
    name = "cluster${format("%02d", count.index)}osdisk01"
    vhd_uri = "${azurerm_storage_account.cluster_slow.primary_blob_endpoint}${azurerm_storage_container.cluster_images_slow_vhds.name}/cluster${format("%02d", count.index)}osdisk01.vhd"
    image_uri = "${var.base_image_slow}"
    caching = "ReadWrite"
    create_option = "FromImage"
    os_type = "linux"
  }

  storage_data_disk {
    name = "cluster${format("%02d", count.index)}datadisk01"
    vhd_uri = "${azurerm_storage_account.cluster_slow.primary_blob_endpoint}${azurerm_storage_container.cluster_images_slow_vhds.name}/cluster${format("%02d", count.index)}datadisk01.vhd"
    create_option = "Empty"
    disk_size_gb = 1023
    lun = 0
  }

  storage_data_disk {
    name = "cluster${format("%02d", count.index)}datadisk02"
    vhd_uri = "${azurerm_storage_account.cluster_slow.primary_blob_endpoint}${azurerm_storage_container.cluster_images_slow_vhds.name}/cluster${format("%02d", count.index)}datadisk02.vhd"
    create_option = "Empty"
    disk_size_gb = 1023
    lun = 1
  }

  storage_data_disk {
    name = "cluster${format("%02d", count.index)}datadisk03"
    vhd_uri = "${azurerm_storage_account.cluster_slow.primary_blob_endpoint}${azurerm_storage_container.cluster_images_slow_vhds.name}/cluster${format("%02d", count.index)}datadisk03.vhd"
    create_option = "Empty"
    disk_size_gb = 1023
    lun = 2
  }

  os_profile {
    computer_name = "clust${format("%02d", count.index)}.we.tulun.tv"
    admin_username = "remote"
    admin_password = "p2N3epsYH$kh"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path = "/home/remote/.ssh/authorized_keys"
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6Rd38ao7rX8M1mUrm4sOleWZIBLhpgBUBc2PxuqGS0Rf4UBrxT2/nE/R0EosnSYuFJJF26TJ/L15mwTIgqhXGN1Z92NgYplZzeSBQW7/lhq79n7CBXrLI3RemUoH879De2/wMFHnHwTrrLc4H/JdPsrwmROnsD4qnNWNOzwCQnXjKvkNEQd+2kzeFO/TdqIydmA5PthFLgVv3w0HVMgRJQRLmSTli2spxDmiTfR71pfRdh8MHJgIPObT3EzlhYkJCk2avT0kIGZPD0PTMpT9G5qFCjqE6fzwtV8ld2ytp0Q2It7ldbhfXOhb+7akMoHecxmTZanirTvu7qJwQHM9Z timhaak@silver.local"
    }
  }
}
