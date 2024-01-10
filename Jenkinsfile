pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        S3_BUCKET_NAME = credentials('my-secret-s3-bucket-name')
        S3_SECRET_KEY_ZIP = credentials('s3-secret-key-zip	')
        OPENWEATHER_API_KEY = credentials('OPENWEATHER_API_KEY_ID')
        AWS_DEFAULT_REGION    = 'us-east-1' 
    }

    stages {

        stage('Install AWS CLI') {
            steps {
                script {
                    // Check if AWS CLI is installed and install if not
                    sh '''
                        if ! type "aws" > /dev/null; then
                            rm -f awscliv2.zip*
                            rm -fr aws
                            curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
                            unzip awscliv2.zip &>/dev/null
                            sudo ./aws/install &>/dev/null
                        fi
                        aws --version
                    '''
                }
            }
        }

        stage('Configure AWS CLI') {
            steps {
                script {
                    // Configure AWS CLI using environment variables
                    sh '''
                        aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                        aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                        aws configure set default.region $AWS_DEFAULT_REGION
                    '''
                }
            }
        }        

        stage('Replace API Key Placeholder') {
            steps {          
                script {
                    // Using double quotes for variable expansion
                    sh "sed -i 's/OPENWEATHER_API_KEY_REPLACE_ME/${OPENWEATHER_API_KEY}/' serverless.yml"
                    sh "sed -i 's/your_s3_bucket_name/${S3_BUCKET_NAME}/' main.tf"
                    sh "sed -i 's/your_s3_key.zip/${S3_SECRET_KEY_ZIP}/' main.tf"
                }   
            }
        }

        stage('Setup Terraform') {
            steps {
                sh '''
                    rm -f terraform_1.0.0_linux_amd64.zip*
                    wget https://releases.hashicorp.com/terraform/1.0.0/terraform_1.0.0_linux_amd64.zip
                    unzip -f terraform_1.0.0_linux_amd64.zip  &>/dev/null
                    chmod +x terraform
                    sudo mv terraform /usr/local/bin
                '''
            }
        }

        stage('Install NVM and Setup Node.js') {
            steps {
                sh '''
                  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash &>/dev/null
                  . ~/.nvm/nvm.sh &>/dev/null
                  nvm install 20.11.0 &>/dev/null
                  nvm use 20.11.0 &>/dev/null
                '''
            }
        }

        stage('Initialize Terraform') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Apply Terraform Infrastructure') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Build NodeJS API') {
            steps {
                sh 'npm install'
                sh 'npm install -g serverless'
                sh 'npm run build'
            }
        }

        stage('Deploy to AWS Lambda') {
            steps {
                sh 'serverless deploy'
            }
        }

        stage('Create API Gateway') {
            steps {
                sh 'terraform apply -target=aws_api_gateway_rest_api.api -auto-approve'
            }
        }

        stage('Cleanup') {
            steps {
                sh 'terraform destroy -auto-approve'
            }
            post {
                always {
                    deleteDir()
                }
            }
        }
    }
}
