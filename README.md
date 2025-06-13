# Jenkins Multibranch Pipeline Setup: AWS Infrastructure Automation (VPN + S3)

This repository demonstrates a Jenkins **Multibranch Pipeline** setup for automating the deployment of AWS infrastructure using **Terraform**. The deployments are separated into two branches/folders — one for setting up a **VPN** and the other for **S3** — each with its own Terraform configuration and `Jenkinsfile`.

---

##  Project Overview

- **vpn-deployment/**: Contains Terraform code and pipeline for provisioning a VPN on AWS.
- **s3-deployment/**: Contains Terraform code and pipeline for provisioning an S3 bucket on AWS.

Each deployment path has:
- A `main.tf` file to define the Terraform resources.
- A `Jenkinsfile` to automate the deployment process via Jenkins.
- A `README.md` explaining that specific deployment module.

---

## Jenkins Multibranch Pipeline

This setup uses Jenkins' **Multibranch Pipeline** feature to automatically detect and run pipelines for each branch/directory based on its `Jenkinsfile`.

> Ensure Jenkins has access to this GitHub repository and is configured to scan branches or folders with `Jenkinsfile`.

---

## Tools & Technologies

- AWS
- Terraform
- Jenkins (Multibranch Pipeline)
- Git & GitHub

---
