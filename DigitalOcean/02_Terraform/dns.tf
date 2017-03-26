# Add a record to the domain
resource "digitalocean_domain" "dns" {
  count =  "${var.docker_server_count > 0 ? 1 : 0}"
  name = "${var.my_domain}"
  ip_address = "${length(digitalocean_droplet.docker.*.ipv4_address) > 0 ? element(concat(digitalocean_droplet.docker.*.ipv4_address, list("")), 0) : "192.168.0.1"}"
}

# Add a record to the domain
resource "digitalocean_record" "docker" {
  count = "${var.docker_server_count}"
  domain = "${digitalocean_domain.dns.name}"
  type = "A"
  name =  "do${format("%02d", count.index)}"
  value = "${element(digitalocean_droplet.docker.*.ipv4_address, count.index)}"
}

# Add a record to the domain
resource "digitalocean_record" "internal-docker" {
  count = "${var.docker_server_count}"
  domain = "${digitalocean_domain.dns.name}"
  type = "A"
  name =  "ido${format("%02d", count.index)}"
  value = "${element(digitalocean_droplet.docker.*.ipv4_address_private, count.index)}"
}
