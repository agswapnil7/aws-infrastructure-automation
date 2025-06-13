### AWS Infrastructure Automation (VPN + S3)

This guide demonstrates how to set up a Jenkins Multibranch Pipeline for automated deployment of AWS VPN and S3 resources using Terraform across separate branches in a single GitHub repository.
Repository Structure
aws-infrastructure-automation/
├── main (default branch)
│   └── README.md (this file)
├── vpn-deployment
│   ├── main.tf
│   ├── Jenkinsfile
│   └── README.md
└── s3-deployment
    ├── main.tf
    ├── Jenkinsfile
    └── README.md
