output "service_url" {
  description = "URL to access Flask app on Minikube"
  value       = "http://$(minikube ip):${var.node_port}"
}

