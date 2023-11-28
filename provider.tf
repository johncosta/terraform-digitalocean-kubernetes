terraform {
  required_version = "~> v1.5.0"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.28.0"
    }
  }
}
