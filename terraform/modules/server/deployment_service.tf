resource "kubernetes_deployment" "flask_app" {
  metadata {
    name      = "gp-deployment"
    namespace = var.namespace   
  }

  spec {
    replicas = var.replicas
    selector {
      match_labels = {
        app = "flask"
      }
    }
    template {
      metadata {
        labels = {
          app = "flask"
        }
      }
      spec {
        container {
          name  = "flask"
          image = var.docker_image
          port {
            container_port = 5000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "flask_service" {
  metadata {
    name      = "gp-service"
    namespace = var.namespace   
  }

  spec {
    type = "NodePort"
    selector = {
      app = "flask"
    }
    port {
      port        = 5000
      target_port = 5000
      node_port   = var.node_port
    }
  }
}

