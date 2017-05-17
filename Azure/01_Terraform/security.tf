resource "azurerm_network_security_group" "cluster" {
  name = "cluster-sg"
  location = "${var.az_we}"
  resource_group_name = "${azurerm_resource_group.cluster.name}"

  security_rule {
    name = "ssh-access-rule"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_address_prefix = "*"
    source_port_range = "*"
    destination_address_prefix = "*"
    destination_port_range = "22"
  }

  security_rule {
    name = "internal-access-rule"
    priority = 200
    direction = "Inbound"
    access = "Allow"
    protocol = "*"
    source_address_prefix = "10.0.0.0/8"
    source_port_range = "*"
    destination_address_prefix = "*"
    destination_port_range = "*"
  }

  security_rule {
    name = "internal-access-docker-rule"
    priority = 240
    direction = "Inbound"
    access = "Allow"
    protocol = "*"
    source_address_prefix = "10.0.0.0/8"
    source_port_range = "*"
    destination_address_prefix = "*"
    destination_port_range = "2376"
  }


  security_rule {
    name = "internal-access-docker-swarm-rule"
    priority = 250
    direction = "Inbound"
    access = "Allow"
    protocol = "*"
    source_address_prefix = "*"
    source_port_range = "*"
    destination_address_prefix = "*"
    destination_port_range = "4000"
  }

  security_rule {
    name = "tinc-access-rule"
    priority = 300
    direction = "Inbound"
    access = "Allow"
    protocol = "*"
    source_address_prefix = "*"
    source_port_range = "*"
    destination_address_prefix = "*"
    destination_port_range = "655"
  }

  security_rule {
    name = "rancher-access-ipsec-rule"
    priority = 400
    direction = "Inbound"
    access = "Allow"
    protocol = "*"
    source_address_prefix = "*"
    source_port_range = "*"
    destination_address_prefix = "*"
    destination_port_range = "4500"
  }

  security_rule {
    name = "rancher-access-ipsec2-rule"
    priority = 500
    direction = "Inbound"
    access = "Allow"
    protocol = "*"
    source_address_prefix = "*"
    source_port_range = "*"
    destination_address_prefix = "*"
    destination_port_range = "500"
  }

  security_rule {
    name = "http-access-rule"
    priority = 1100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_address_prefix = "*"
    source_port_range = "*"
    destination_address_prefix = "*"
    destination_port_range = "80"
  }

  security_rule {
    name = "http-access-8080-rule"
    priority = 1150
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_address_prefix = "*"
    source_port_range = "*"
    destination_address_prefix = "*"
    destination_port_range = "8080"
  }

  security_rule {
    name = "https-access-rule"
    priority = 1200
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_address_prefix = "*"
    source_port_range = "*"
    destination_address_prefix = "*"
    destination_port_range = "443"
  }

  security_rule {
    name = "docker-access-rule"
    priority = 1300
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_address_prefix = "*"
    source_port_range = "*"
    destination_address_prefix = "*"
    destination_port_range = "2376"
  }

  //  security_rule {
  //    name = "block-all-tcp-rule"
  //    priority = 4001
  //    direction = "Inbound"
  //    access = "Deny"
  //    protocol = "Udp"
  //    source_address_prefix = "*"
  //    source_port_range = "*"
  //    destination_address_prefix = "*"
  //    destination_port_range = "*"
  //  }
  //
  //  security_rule {
  //    name = "block-all-udp-rule"
  //    priority = 4000
  //    direction = "Inbound"
  //    access = "Deny"
  //    protocol = "Tcp"
  //    source_address_prefix = "*"
  //    source_port_range = "*"
  //    destination_address_prefix = "*"
  //    destination_port_range = "*"
  //  }

  security_rule {
    name = "allow-ping-rule"
    priority = 4096
    direction = "Inbound"
    access = "Allow"
    protocol = "*"
    source_address_prefix = "*"
    source_port_range = "*"
    destination_address_prefix = "*"
    destination_port_range = "*"
  }
}
