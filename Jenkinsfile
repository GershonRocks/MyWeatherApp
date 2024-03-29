pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        S3_BUCKET_NAME        = credentials('my-secret-s3-bucket-name') // Replace with your bucket name
        S3_SECRET_KEY_ZIP     = credentials('s3-secret-key-zip')   // Replace with your zip file name
        OPENWEATHER_API_KEY   = credentials('OPENWEATHER_API_KEY_ID')
        AWS_DEFAULT_REGION    = 'us-east-1'
    }

    stages {

        stage('Install AWS CLI') {
            steps {
                script {
                    sh '''
                        if ! type "aws" > /dev/null; then
                            rm -f awscliv2.zip*
                            rm -fr aws
                            curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
                            unzip awscliv2.zip &>/dev/null
                            rm -f awscliv2.zip
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
                    sh "sed -i 's/OPENWEATHER_API_KEY_REPLACE_ME/${OPENWEATHER_API_KEY}/' serverless.yml"
                    sh "sed -i 's/your_s3_bucket_name/${S3_BUCKET_NAME}/g' main.tf"
                    sh "sed -i 's/your_s3_key.zip/${S3_SECRET_KEY_ZIP}/' main.tf"
                }   
            }
        }

        stage('Setup Terraform') {
            steps {
                sh '''
                    rm -f terraform*.zip*
                    rm -fr terraform
                    wget https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip
                    unzip terraform_1.6.6_linux_amd64.zip
                    rm -f terraform_1.6.6_linux_amd64.zip
                    chmod +x terraform
                    sudo mv terraform /usr/local/bin
                '''
            }
        }


        stage('Install NVM and Setup Node.js') {
            steps {
                sh '''#!/bin/bash
                    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash &>/dev/null
                    rm -f install.sh
                    . ~/.nvm/nvm.sh &>/dev/null
                    nvm install 20.11.0 &>/dev/null
                    nvm use 20.11.0 &>/dev/null
                    rm -fr node_modules
                '''
            }
        }


        stage('Package Lambda Function') {
            steps {
                script {
                    sh "rm -f *.zip"
                    // Assuming all required files for Lambda are in the root directory of the project
                    sh "zip -r ${S3_SECRET_KEY_ZIP} src/*"
                }
            }
        }

        stage('Upload Lambda Package to S3') {
            steps {
                script {
                    // Check if S3 bucket exists, create if not
                    sh """
                        if ! aws s3 ls "s3://${S3_BUCKET_NAME}" ; then
                          aws s3 mb "s3://${S3_BUCKET_NAME}"
                        fi
                    """
                    // Upload to S3
                    sh "aws s3 cp ${S3_SECRET_KEY_ZIP} s3://${S3_BUCKET_NAME}/${S3_SECRET_KEY_ZIP}"
                }
            }
        }

        // stage('Deploy to AWS Lambda') {
        //     steps {
        //         sh '''#!/bin/bash
        //         nvm use 20.11.0 &>/dev/null
        //         serverless deploy
        //         '''
        //     }
        // }

        stage('Initialize Terraform') {
            steps {
                sh '''#!/bin/bash
                terraform init
                '''
            }
        }

        stage('Apply Terraform Infrastructure') {
            steps {
                sh '''#!/bin/bash
                terraform apply -auto-approve
                '''
            }
        }

        stage('Create API Gateway') {
            steps {
                sh '''#!/bin/bash
                terraform apply -target=aws_api_gateway_rest_api.api -auto-approve
                '''
            }
        }

        stage('Cleanup') {
            steps {
                sh '''#!/bin/bash
                terraform destroy -auto-approve
                '''
            }
        }
    }
}
