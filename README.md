# GCP & Kubernetes Minecraft Infrastructure

## 📋 Project Overview
This project automates the deployment of a **Minecraft Server** on **Google Cloud Platform (GCP)** using **Terraform** and **Google Kubernetes Engine (GKE)**.
It demonstrates modern **DevOps practices**: Infrastructure as Code (IaC), Containerization, and Cloud Orchestration.

## Architecture
[ USER ] -> [ LOAD BALANCER IP ] -> [ GKE CLUSTER ] -> [ MINECRAFT CONTAINER ]

### Tech Stack
* **Cloud:** Google Cloud Platform (GCP)
* **IaC:** Terraform
* **Orchestration:** Kubernetes (GKE)
* **Compute:** Spot Instances (e2-medium) for cost optimization
* **Networking:** Custom VPC & Firewall Rules
* **Scripting:** Python (Status Checks)

## How to Deploy

### 1. Provision Infrastructure
```bash
cd terraform
terraform init
# Create a secret file
echo 'project_id = "YOUR_PROJECT_ID"' > terraform.tfvars
terraform apply
```

### 2. Deploy Application
```bash
# Connect kubectl to GKE
gcloud container clusters get-credentials minecraft-cluster --zone europe-central2-a

# Apply Manifests
kubectl apply -f ../k8s/minecraft.yaml

# Get Public IP
kubectl get service minecraft-lb

# Check if the port is open
python3 ../scripts/check_server.py 34.118.121.102
```







