
variable "aws_region" {
  description = "The AWS region where all resources will be created. e.g. us-east-1"
  type        = string
}

variable "cluster_name" {
  description = "Name given to the EKS cluster and used as a prefix for related resources"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version to run on the EKS cluster. e.g. 1.29"
  type        = string
}


variable "vpc_cidr" {
  description = "The IP range for the entire VPC. All subnets are carved from this block."
  type        = string
}

variable "public_subnet_cidrs" {
  description = <<EOT
List of CIDR blocks for public subnets (one per Availability Zone).
Public subnets are used for the NAT Gateway and Load Balancers.
These must be smaller blocks that fit inside vpc_cidr.
EOT
  type = list(string)
}

variable "private_subnet_cidrs" {
  description = <<EOT
List of CIDR blocks for private subnets (one per Availability Zone).
Worker nodes run here — they are NOT directly reachable from the internet.
These must be smaller blocks that fit inside vpc_cidr.
EOT
  type = list(string)
}

variable "availability_zones" {
  description = "List of AZs to spread subnets across. Must match the number of subnet CIDRs above."
  type = list(string)
}


variable "node_instance_type" {
  description = "EC2 instance type for worker nodes. t3.medium = 2 vCPU / 4GB RAM (minimum for K8s)."
  type   = string
}

variable "node_desired_count" {
  description = "How many worker nodes to run normally"
  type        = number
}

variable "node_min_count" {
  description = "Minimum number of worker nodes (cluster autoscaler will not go below this)"
  type        = number
}

variable "node_max_count" {
  description = "Maximum number of worker nodes (cluster autoscaler will not go above this)"
  type        = number
}

variable "node_disk_size_gb" {
  description = "Size of the root EBS disk on each worker node, in GB"
  type        = number
}


variable "argocd_chart_version" {
  description = "Version of the ArgoCD Helm chart to install. See: https://artifacthub.io/packages/helm/argo/argo-cd"
  type        = string
}

variable "github_repo_url" {
  description = "Full HTTPS URL of your GitHub repo. ArgoCD watches this for changes. e.g. https://github.com/yourname/quotes-app"
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
