pipeline {
    agent any
    
    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        AWS_CREDENTIALS_ID = 'aws-creds' // Your existing AWS credentials in Jenkins
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Terraform Init & Validate') {
            steps {
                script {
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding', 
                         credentialsId: 'aws-creds',
                         accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                         secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']
                    ]) {
                        // Initialize and validate Terraform
                        sh 'terraform init'
                        sh 'terraform validate'
                    }
                }
            }
        }
        
        stage('Terraform Plan') {
            steps {
                script {
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding', 
                         credentialsId: 'aws-creds',
                         accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                         secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']
                    ]) {
                        // Create execution plan
                        sh 'terraform plan -out=tfplan'
                    }
                }
            }
        }
        
        stage('Deploy VPN Infrastructure') {
            steps {
                script {
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding', 
                         credentialsId: 'aws-creds',
                         accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                         secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']
                    ]) {
                        // Apply Terraform configuration
                        sh 'terraform apply -auto-approve tfplan'
                        
                        // Display outputs
                        sh 'terraform output'
                    }
                }
            }
        }
    }
    
    post {
        always {
            script {
                echo 'Cleaning up workspace...'
                deleteDir()
            }
        }
        success {
            echo 'VPN infrastructure pipeline completed successfully!'
        }
        failure {
            echo 'VPN infrastructure pipeline failed!'
        }
        cleanup {
            script {
                // Clean up Terraform files
                sh 'rm -f tfplan terraform.tfstate.backup'
            }
        }
    }
}