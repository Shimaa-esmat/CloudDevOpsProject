terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.24"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"  
}

module "network" {
  source = "./modules/network"
}

module "server" {
  source       = "./modules/server"
  docker_image = var.docker_image
  replicas     = var.replicas
  node_port    = var.node_port
}

