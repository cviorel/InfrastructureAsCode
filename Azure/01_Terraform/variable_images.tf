variable "ubuntu" {
  description = "Default LTS"
  type = "map"
  default = {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "16.04.0-DAILY-LTS"
    version = "latest"
  }
}
