pipeline {
    agent any
    
    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        TF_IN_AUTOMATION = "true"
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo "Building VPN Infrastructure from branch: ${env.BRANCH_NAME}"
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
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }
        
        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }
        
        stage('Verify Infrastructure') {
            steps {
                echo 'Verifying VPN infrastructure deployment...'
                sh '''
                    echo "VPC Created:"
                    terraform output vpc_id
                    echo "Public Subnets:"
                    terraform output public_subnet_ids
                    echo "Private Subnets:"
                    terraform output private_subnet_ids
                '''
            }
        }
        
        stage('Wait for Testing') {
            steps {
                echo 'Infrastructure deployed. Waiting 5 minutes for testing...'
                sh 'sleep 300'
            }
        }
        
        stage('Terraform Destroy') {
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
            echo 'VPN infrastructure pipeline completed successfully!'
        }
        failure {
            echo 'VPN infrastructure pipeline failed!'
        }
    }
}
