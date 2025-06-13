# AWS VPN Infrastructure Deployment via Terraform + Jenkins

## What is Being Tested/Proved?
- Automated VPN infrastructure creation with multiple subnets across AZs
- **No Elastic IPs used** - NAT instances provide internet access for private subnets
- Certificate-based VPN authentication setup
- Jenkins Multibranch Pipeline automation with testing and cleanup
- Infrastructure as Code (IaC) best practices

## Tools & Technologies
- **Terraform** (AWS provider)
- **Jenkins** (Multibranch Pipeline)
- **AWS Services**: VPC, Subnets, NAT Instances, Security Groups, Route Tables
- **GitHub** (Source control with branching strategy)

## Architecture Overview
```
VPC (10.0.0.0/16)
├── Public Subnets (3 AZs)
│   ├── 10.0.1.0/24 (us-east-1a)
│   ├── 10.0.2.0/24 (us-east-1b)
│   └── 10.0.3.0/24 (us-east-1c)
├── Private Subnets (3 AZs)  
│   ├── 10.0.101.0/24 (us-east-1a)
│   ├── 10.0.102.0/24 (us-east-1b)
│   └── 10.0.103.0/24 (us-east-1c)
├── Internet Gateway
├── NAT Instances (3 - one per AZ, no EIPs)
└── Route Tables (public + private)
```

## Success Criteria
- Jenkins pipeline deploys VPN infrastructure successfully
- 3 public subnets created across different AZs
- 3 private subnets created across different AZs  
- NAT instances provide internet access (no Elastic IPs)
- Proper routing configured between subnets
- Infrastructure automatically destroyed after testing
- Zero ongoing AWS costs after pipeline completion

## File Structure
```
vpn-deployment/
├── main.tf          # VPN infrastructure Terraform code
├── Jenkinsfile      # Pipeline with apply, verify, and destroy stages
├── README.md        # This documentation
└── output.txt       # Output from Jenkins console
```

## Key Features

### 🔹 Multi-AZ Deployment
- Subnets deployed across 3 Availability Zones for high availability
- Fault-tolerant architecture with redundant NAT instances

### 🔹 No Elastic IP Usage
- Cost-efficient NAT instances instead of NAT Gateways with EIPs
- Automatic public IP assignment for NAT instances via subnet settings

### 🔹 Automated Pipeline
- Jenkins Multibranch Pipeline automatically discovers this branch
- Terraform state management and cleanup
- Built-in verification and testing phases

## How to Reproduce

### Prerequisites
- Jenkins with Multibranch Pipeline plugin
- AWS credentials configured in Jenkins
- Terraform installed on Jenkins agent
- GitHub repository with this branch

### Step 1: Jenkins Setup
1. Create Multibranch Pipeline job pointing to your GitHub repo
2. Ensure AWS credentials are configured:
   - `aws-access-key-id` (Secret text)
   - `aws-secret-access-key` (Secret text)

### Step 2: Trigger Build
1. Jenkins automatically scans for branches with Jenkinsfiles
2. Build will trigger automatically or manually via "Build Now"
3. Monitor console output for deployment progress

### Step 3: Pipeline Stages
1. **Checkout**: Pulls latest code from vpn-deployment branch
2. **Terraform Init**: Initializes Terraform backend and providers
3. **Terraform Validate**: Validates Terraform syntax
4. **Terraform Plan**: Creates execution plan
5. **Terraform Apply**: Deploys AWS infrastructure
6. **Verify Infrastructure**: Outputs VPC and subnet details
7. **Wait for Testing**: 5-minute pause for manual verification
8. **Terraform Destroy**: Cleans up all resources

### Step 4: Expected Output
```bash
VPC Created: vpc-xxxxxxxxx
Public Subnets: ["subnet-xxxxxxxx", "subnet-xxxxxxxx", "subnet-xxxxxxxx"]
Private Subnets: ["subnet-xxxxxxxx", "subnet-xxxxxxxx", "subnet-xxxxxxxx"]  
NAT Instance IDs: ["i-xxxxxxxxx", "i-xxxxxxxxx", "i-xxxxxxxxx"]
```

## Manual Verification (Optional)
During the 5-minute wait period, you can manually verify:

```bash
# Check VPC
aws ec2 describe-vpcs --vpc-ids <vpc-id>

# Check subnets
aws ec2 describe-subnets --filters "Name=vpc-id,Values=<vpc-id>"

# Check NAT instances
aws ec2 describe-instances --filters "Name=tag:Name,Values=nat-instance-*"

# Verify routing
aws ec2 describe-route-tables --filters "Name=vpc-id,Values=<vpc-id>"
```

## Security Configuration
- **NAT Security Group**: Allows HTTP/HTTPS from VPC CIDR
- **Source/Destination Check**: Disabled on NAT instances for routing
- **Private Subnets**: No direct internet access, routes through NAT instances

## Cost Optimization
- **t2.micro instances** for NAT (Free Tier eligible)
- **No Elastic IPs** (saves $0.005/hour per EIP)
- **Automatic cleanup** prevents ongoing charges
- **Regional deployment** minimizes data transfer costs

## Troubleshooting

### Common Issues:
1. **IAM Permissions**: Ensure Jenkins has adequate AWS permissions
2. **Terraform State**: State conflicts if multiple builds run simultaneously  
3. **Resource Limits**: AWS account limits on VPCs/subnets per region
4. **AMI Availability**: NAT AMI may vary by region

### Debug Commands:
```bash
# Check Terraform logs
terraform plan -detailed-exitcode

# Validate AWS connectivity
aws sts get-caller-identity

# Check resource quotas
aws ec2 describe-account-attributes
```

## Branch-Specific Notes
- This pipeline runs only on the `vpn-deployment` branch
- Each branch in the multibranch setup runs independently
- Jenkins automatically creates separate job for this branch
- Console output shows branch-specific build information

## Auto-Cleanup Features
The pipeline includes automatic resource cleanup to prevent AWS charges:
- **5-minute testing window** for manual verification
- **Automatic terraform destroy** at pipeline end
- **Workspace cleanup** removes temporary files
- **State file cleanup** prevents conflicts

This ensures zero ongoing costs while providing complete infrastructure testing capability.
