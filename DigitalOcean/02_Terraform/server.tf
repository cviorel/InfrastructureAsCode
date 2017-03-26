provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_droplet" "docker" {
  count = "${var.docker_server_count}"
  image = "${var.image}"
  name = "do${format("%02d", count.index)}.${var.my_domain}"
  private_networking = true
  ipv6 = false
  region = "${var.region}"
  size = "${var.size}"
  ssh_keys = [
    "${var.ssh_key_fingerprint}"
  ]
}
