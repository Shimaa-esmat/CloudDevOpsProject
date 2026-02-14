variable "docker_image" {
  description = "Docker image for the Flask app"
  type        = string
}

variable "replicas" {
  description = "Number of replicas for the deployment"
  type        = number
  default     = 1
}

variable "node_port" {
  description = "NodePort to expose the service"
  type        = number
  default     = 30007
}

variable "namespace" {
  description = "Kubernetes namespace for the deployment"
  type        = string
  default     = "ivolve"
}

