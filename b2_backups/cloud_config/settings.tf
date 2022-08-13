terraform {
  required_version = "~>1.2"

  backend "local" {
    path = "state.tfstate"
  }

  required_providers {
    b2 = {
      source  = "Backblaze/b2"
      version = "0.8.1"
    }
  }
}

provider "b2" {}