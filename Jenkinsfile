pipeline {
    agent any

    environment {
        GITHUB_ACCOUNT = "devozs"
        IMAGE_TAG = "latest"
    }


    stages {
        stage('SCM') {
            steps {
              git branch: 'dev', url: 'https://github.com/devozs/weather-app-cd'
            }
        }

        stage('Setup parameters') {
            steps {
                script {
                    properties([
                        parameters([
                            choice(
                                choices: ['manual', 'flux'],
                                name: 'DEPLOYMENT_TYPE'
                            ),
                        ])
                    ])
                }
            }
        }

        stage('Clean Previous Deployment') {
            steps {
                sh "kind delete cluster --name kind"
            }
        }

        stage('Deploy Cluster') {
            steps {
                withCredentials([string(credentialsId: 'github-token', variable: 'githubToken')]) {
                    sh "export GITHUB_TOKEN=${githubToken} && ./install-cluster.sh -t ${DEPLOYMENT_TYPE} -f ${GITHUB_ACCOUNT}"
                }
            }
        }

        stage('Test Deployment') {
            steps {
                sh "kubectl get pod -A"
                sh "sleep 10"
                sh "./verify-deployment.sh"
            }
        }

    }
}