output "ips" {
  value = "${join(",", digitalocean_droplet.docker.*.ipv4_address)}"
}

output "dns" {
  value = "${join(",", digitalocean_record.docker.*.fqdn)}"
}

output "iternal-dns" {
  value = "${join(",", digitalocean_record.internal-docker.*.fqdn)}"
}
