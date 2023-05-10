terraform {
  required_providers {
    morpheus = {
      source  = "gomorpheus/morpheus"
      version = "0.9.0"

    }
  }
}
provider "morpheus" {
  url          = "https://YOURMORPHEUSSERVERIP"
  access_token = "YOURACCESSTOKEN"
}
