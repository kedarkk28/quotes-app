
variable "aws_region" {
  description = "The AWS region where all resources will be created"
  type        = string
}

variable "cluster_name" {
  description = "Name given to the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version to run on the EKS cluster."
  type        = string
}


variable "vpc_cidr" {
  description = "The IP range for the entire VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = List of CIDR blocks for public subnets.
  type = list(string)
}

variable "private_subnet_cidrs" {
  description = List of CIDR blocks for private subnets.
  type = list(string)
}

variable "availability_zones" {
  description = "List of AZs to spread subnets across."
  type = list(string)
}


variable "node_instance_type" {
  description = "EC2 instance type for worker nodes."
  type   = string
}

variable "node_desired_count" {
  description = "How many worker nodes to run normally"
  type        = number
}

variable "node_min_count" {
  description = "Minimum number of worker nodes"
  type        = number
}

variable "node_max_count" {
  description = "Maximum number of worker nodes"
  type        = number
}

variable "node_disk_size_gb" {
  description = "Size of the root EBS disk on each worker node"
  type        = number
}


variable "argocd_chart_version" {
  description = "Version of the ArgoCD Helm chart to install"
  type        = string
}

variable "github_repo_url" {
  description = "Full HTTPS URL of your GitHub repo. ArgoCD watches this for changes."
  type        = string
}

variable "github_repo_path" {
  description = "Folder inside your GitHub repo that contains the Kubernetes YAML files."
  type        = string
}

variable "prometheus_stack_chart_version" {
  description = "Version of the kube-prometheus-stack Helm chart."
  type        = string
}

variable "prometheus_retention" {
  description = "How long Prometheus keeps metrics data."
  type        = string
}

variable "prometheus_storage_size" {
  description = "Size of the EBS disk for Prometheus metrics storage. "
  type        = string
}

variable "grafana_admin_password" {
  description = "Password for the Grafana admin user."
  type        = string
  sensitive   = true   
}

variable "grafana_storage_size" {
  description = "Size of the EBS disk for Grafana persistent storage."
  type        = string
}
