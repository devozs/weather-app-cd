pipeline {
    agent any

    environment {
        REGISTRY = "devozs"
        IMAGE_TAG = "latest"
    }

    stages {
        stage('SCM') {
            steps {
              git branch: 'dev', url: 'https://github.com/devozs/weather-app-cd'
            }
        }

        stage('Install tools') {
            steps {
                sh "./setup-prerequisites.sh"
            }
        }

        stage('Docker Pull') {
            steps {
                withCredentials([string(credentialsId: 'docker-hub', variable: 'dockerHubPassword')]) {
                    sh "docker login -u ${REGISTRY} -p ${dockerHubPassword}"
                }
                sh "docker pull ${REGISTRY}/weather-app:${IMAGE_TAG}"
            }
        }
    }
}