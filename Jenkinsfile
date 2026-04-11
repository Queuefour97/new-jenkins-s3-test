pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        TF_IN_AUTOMATION   = 'true'
        SNYK_ORG           = credentials('snyk-org-slug')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

         

    //     stage('Snyk IaC Scan Test') {
    // steps {
    //     withCredentials([string(credentialsId: 'snyk-token', variable: 'SNYK_TOKEN')]) {
    //         withEnv(["PATH+SNYK=${tool 'snyk'}"]) {
    //             sh 'snyk auth ${SNYK_TOKEN}'
    //             sh 'snyk iac test --org=${SNYK_ORG} || true'
    //         }
    //     }
    }
}


        stage('Snyk IaC Scan Monitor') {
            steps {
                snykSecurity(
                    snykInstallation: 'snyk',
                    snykTokenId: 'snyk-api-token',
                    additionalArguments: '--iac --report --org=$SNYK_ORG --severity-threshold=high',
                    failOnIssues: true,
                    monitorProjectOnBuild: false
                )
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-iam-user-creds'
                ]]) {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-iam-user-creds'
                ]]) {
                    sh 'terraform plan'
                }
            }
        }

    stage('Terraform Apply') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-iam-user-creds'
                ]]) {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Optional Destroy') {
            steps {
                script {
                    def destroyChoice = input(
                        message: 'Do you want to run terraform destroy?',
                        ok: 'Submit',
                        parameters: [
                            choice(
                                name: 'DESTROY',
                                choices: ['no', 'yes'],
                                description: 'Select yes to destroy resources'
                            )
                        ]
                    )

                    if (destroyChoice == 'yes') {
                        withCredentials([[
                            $class: 'AmazonWebServicesCredentialsBinding',
                            credentialsId: 'aws-iam-user-creds'
                        ]]) {
                            sh 'terraform destroy -auto-approve'
                        }
                    } else {
                        echo "Skipping destroy"
                    }
                }
            }
        }
    }
}
