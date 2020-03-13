variable "ssh_key" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDP1hF48vfYotRqfUjVokEc4hVKu5tfLXC8rwWoL1wUJzjxHy8CwkLFVNQSEEY79aoZtFIRUQhvxjARiDAh68XQa/Gj9VEmhxLg6+iSPZGNs28FrQqSYZfOEwqNWQEal4l4U+HDfTdosszL4D+B3S5GGgxFAxDwBB93PXrbiyBCcplSNZ7qFWCF/p7j4m0dM2tNGCwLNWiJu8TeKRJMpD4sphMLi5jZuL6GknVnrdCm4FmwW2BOpeF2jxtIcAWEaXZyDY9JVHY7W655wjQj3Kgu+GdCSkPdoZZQTA0G4dtqyCWV4rtrH7tAjjjD9BEh/QT4v0Qxo0ndi3UNnpzA2ff3 chistyakov@v-5-314-d3782-241"
}

variable "public_ips" {
  type    = list(string)
  default = ["88.85.84.241/32"]
}
