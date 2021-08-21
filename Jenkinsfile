pipeline {
    agent any

    environment {
        REGISTRY = "devozs"
        IMAGE_TAG = "latest"
    }


    stages {
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
        stage('SCM') {
            steps {
              git branch: 'dev', url: 'https://github.com/devozs/weather-app-cd'
            }
        }

        stage('Clean Previous Deployment') {
            steps {
                sh "kind delete cluster --name kind"
            }
        }
    }
}