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
                                name: 'Deployment Type'
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
                    export GITHUB_TOKEN=${githubToken}
                }
                sh "./install-cluster.sh -t flux -f ${GITHUB_ACCOUNT}"
            }
        }

    }
}