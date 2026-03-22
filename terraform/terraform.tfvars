aws_region      = "us-east-1"
cluster_name    = "quotes-eks"
cluster_version = "1.29"

vpc_cidr = "10.0.0.0/16"

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24",
  "10.0.3.0/24",
]

private_subnet_cidrs = [
  "10.0.4.0/24",
  "10.0.5.0/24",
  "10.0.6.0/24",
]

availability_zones = [
  "us-east-1a",
  "us-east-1b",
  "us-east-1c",
]

node_instance_type = "t3.medium"
node_desired_count = 3
node_min_count  = 2
node_max_count  = 5
node_disk_size_gb  = 30

argocd_chart_version = "6.7.3"

github_repo_url  = "https://github.com/kedarkk28/quotes-app"

github_repo_path = "k8s-manifests"

prometheus_stack_chart_version = "58.3.0"

prometheus_retention    = "15d"

prometheus_storage_size = "20Gi"

grafana_storage_size    = "5Gi"

grafana_admin_password  = "admin1234"
