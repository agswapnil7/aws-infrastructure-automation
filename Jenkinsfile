pipeline {
    agent any
    
    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        TF_IN_AUTOMATION = "true"
    }
    
    parameters {
        choice(
            name: 'ACTION',
            choices: ['apply', 'destroy'],
            description: 'Select Terraform action to perform'
        )
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo "Building S3 Infrastructure from branch: ${env.BRANCH_NAME}"
                checkout scm
            }
        }
        
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        
        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }
        
        stage('Terraform Plan') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }
        
        stage('Terraform Apply') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }
        
        stage('Verify S3 Bucket') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                echo 'Verifying S3 bucket creation...'
                sh '''
                    echo "Bucket Name:"
                    terraform output bucket_name
                    echo "Bucket ARN:"
                    terraform output bucket_arn
                    echo "Listing bucket contents:"
                    aws s3 ls s3://$(terraform output -raw bucket_name) --recursive
                '''
            }
        }
        
        stage('Terraform Destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                sh 'terraform destroy -auto-approve'
            }
        }
    }
    
    post {
        always {
            echo 'Cleaning up workspace...'
            deleteDir()
        }
        success {
            echo "S3 infrastructure pipeline (${params.ACTION}) completed successfully!"
        }
        failure {
            echo "S3 infrastructure pipeline (${params.ACTION}) failed!"
        }
    }
}