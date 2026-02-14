variable "docker_image" {
  description = "Docker image to deploy"
  default     = "shimaaesmat/gp-ivolve:latest"
}

variable "replicas" {
  description = "Number of pod replicas"
  default     = 2
}

variable "node_port" {
  description = "NodePort for the Flask service"
  default     = 30007
}
