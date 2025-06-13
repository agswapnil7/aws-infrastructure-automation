# Automated S3 Bucket Deployment via Terraform + Jenkins

## What is Being Tested/Proved?
- Infrastructure as Code (IaC) for S3 bucket creation and configuration
- Jenkins Multibranch Pipeline automation with parameter-driven actions
- Secure S3 bucket configuration with encryption and access controls
- AWS resource management via Terraform with proper tagging
- Parameter-driven deployment/destruction workflow

## Tools & Technologies
- **Terraform** (AWS provider with random provider)
- **Jenkins** (Multibranch Pipeline with parameters)
- **AWS S3** (Storage service with security features)
- **GitHub** (Source control with branching strategy)

## S3 Configuration Features

### 🔹 Security Hardened
- **Server-side encryption** (AES-256)
- **Public access blocked** (all public access restrictions enabled)
- **Versioning enabled** for data protection
- **Secure bucket policies** applied

### 🔹 Automated Naming
- **Unique bucket names** using random suffix
- **Collision-free** naming across AWS regions
- **Consistent naming convention**: `terraform-jenkins-s3-{random}`

### 🔹 Sample Content
- **Test object creation** to verify bucket functionality
- **Timestamped content** for build tracking
- **Proper tagging** for resource management

## Success Criteria
- Jenkins pipeline creates S3 bucket with unique name
- Bucket configured with encryption and versioning
- Public access properly blocked for security
- Sample object uploaded successfully
- Parameter-driven destroy capability works
- Proper resource tagging applied

## File Structure
```
s3-deployment/
├── main.tf          # S3 bucket Terraform configuration
├── Jenkinsfile      # Parameterized pipeline script
├── README.md        # This documentation
└── output.txt        # Output from jenkins console
```

## Pipeline Parameters

The Jenkins pipeline supports two actions via parameters:

| Parameter | Description | Action |
|-----------|-------------|---------|
| `apply` | Deploy S3 bucket | Creates bucket with all configurations |
| `destroy` | Remove S3 bucket | Destroys bucket and all contents |

## How to Reproduce

### Prerequisites
- Jenkins with Multibranch Pipeline plugin
- AWS credentials configured in Jenkins
- Terraform installed on Jenkins agent
- GitHub repository with this branch

### Step 1: Jenkins Multibranch Setup
1. Multibranch Pipeline job automatically discovers this branch
2. AWS credentials must be configured:
   - `aws-access-key-id` (Secret text)
   - `aws-secret-access-key` (Secret text)

### Step 2: Execute Pipeline

#### For Deployment:
1. Click "Build with Parameters" 
2. Select `ACTION = apply`
3. Click "Build"
4. Monitor console output

#### For Cleanup:
1. Click "Build with Parameters"
2. Select `ACTION = destroy` 
3. Click "Build"
4. Confirm resource removal

### Step 3: Pipeline Stages (Apply Mode)
1. **Checkout**: Pulls latest code from s3-deployment branch
2. **Terraform Init**: Initializes providers and backend
3. **Terraform Validate**: Validates configuration syntax
4. **Terraform Plan**: Creates execution plan for resources
5. **Terraform Apply**: Creates S3 bucket and configurations
6. **Verify S3 Bucket**: Lists bucket contents and properties

### Step 4: Pipeline Stages (Destroy Mode)
1. **Checkout**: Pulls latest code from s3-deployment branch  
2. **Terraform Init**: Initializes providers and backend
3. **Terraform Destroy**: Removes all S3 resources

## Expected Console Output

### Successful Apply Output:
```bash
Building S3 Infrastructure from branch: s3-deployment

Terraform has been successfully initialized!
Terraform configuration is valid.

Plan: 5 to add, 0 to change, 0 to destroy.

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:
bucket_name = "terraform-jenkins-s3-a1b2c3d4"
bucket_arn = "arn:aws:s3:::terraform-jenkins-s3-a1b2c3d4"
bucket_region = "us-east-1"

Bucket Name: terraform-jenkins-s3-a1b2c3d4
Bucket ARN: arn:aws:s3:::terraform-jenkins-s3-a1b2c3d4
Listing bucket contents:
2024-06-13 10:30:45     156 sample/jenkins-terraform-test.txt
```

### Successful Destroy Output:
```bash
Building S3 Infrastructure from branch: s3-deployment

Terraform has been successfully initialized!

Plan: 0 to add, 0 to change, 5 to destroy.

Destroy complete! Resources: 5 destroyed.
```

## S3 Bucket Configuration Details

### Resource Components Created:
1. **S3 Bucket** with unique random naming
2. **Bucket Versioning** (Enabled)
3. **Server-Side Encryption** (AES-256)
4. **Public Access Block** (All restrictions enabled)
5. **Sample Object** with timestamp content

### Security Settings:
```hcl
# Public Access Block
block_public_acls       = true
block_public_policy     = true  
ignore_public_acls      = true
restrict_public_buckets = true

# Server-Side Encryption
sse_algorithm = "A
