terraform {
  required_version = "~>1.2"

  backend "remote" {
    hostname = "app.terraform.io"
    organization = "shchuko"

    workspaces {
      name = "parents-home-nas"
    }
  }

  required_providers {
    b2 = {
      source  = "Backblaze/b2"
      version = "0.8.1"
    }
  }
}

provider "b2" {}