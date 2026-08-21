pipeline {

    agent any

    environment {

        ARM_CLIENT_ID = credentials('azure-client-id')
        ARM_CLIENT_SECRET = credentials('azure-client-secret')
        ARM_TENANT_ID = credentials('azure-tenant-id')
        ARM_SUBSCRIPTION_ID = credentials('azure-subscription-id')
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Version') {
            steps {
                sh 'terraform version'
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                    terraform init
                '''
            }
        }

        stage('Terraform Format') {
            steps {
                sh '''
                    terraform fmt -check -recursive
                '''
            }
        }

        stage('Terraform Validate') {
            steps {
                sh '''
                    terraform validate
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                    terraform plan -out=tfplan
                '''
            }
        }

        stage('Approval') {
            steps {
                input message: 'Deploy Azure AKS infrastructure?', 
                      ok: 'Deploy'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh '''
                    terraform apply -auto-approve tfplan
                '''
            }
        }

        stage('Terraform Output') {
            steps {
                sh '''
                    terraform output
                '''
            }
        }

        stage('Azure Verification') {
            steps {
                sh '''
                    az account show

                    echo "Checking Resource Group..."
                    az group show --name RevaDevOps

                    echo "Checking ACR..."
                    az acr show \
                      --name racedevopsacr \
                      --resource-group RevaDevOps

                    echo "Checking AKS..."
                    az aks show \
                      --name racedevops_aks \
                      --resource-group RevaDevOps
                '''
            }
        }
    }

    post {

        success {
            echo 'Azure infrastructure deployed successfully.'
        }

        failure {
            echo 'Azure infrastructure deployment failed.'
        }
    }
}
