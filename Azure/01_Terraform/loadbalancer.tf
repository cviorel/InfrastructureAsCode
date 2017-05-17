
resource "azurerm_public_ip" "cluster_lb" {
  name                         = "ClusterPublicIPForLB"
  location = "${var.az_we}"
  resource_group_name = "${azurerm_resource_group.cluster.name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_lb" "cluster" {
  name                = "ClusterLoadBalancer"
  location = "${var.az_we}"
  resource_group_name = "${azurerm_resource_group.cluster.name}"

  frontend_ip_configuration {
    name                 = "ClusterPublicIPAddress"
    public_ip_address_id = "${azurerm_public_ip.cluster_lb.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "cluster" {
  resource_group_name = "${azurerm_resource_group.cluster.name}"
  loadbalancer_id     = "${azurerm_lb.cluster.id}"
  name                = "ClusterBackEndAddressPool"
}
