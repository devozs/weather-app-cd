pipeline {
    agent any

    environment {
        REGISTRY = "devozs"
        IMAGE_TAG = "latest"
    }

    parameters {
        choice(choices: "${envList}", name: 'DEPLOYMENT_ENVIRONMENT', description: 'please choose the environment you want to deploy?')
        booleanParam(name: 'SECURITY_SCAN',defaultValue: false, description: 'container vulnerability scan')
    }

    stages {
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

        stage('Clean Previous Deployment') {
            steps {
                sh "kind delete cluster --name kind"
                withCredentials([string(credentialsId: 'docker-hub', variable: 'dockerHubPassword')]) {
                    sh "docker login -u ${REGISTRY} -p ${dockerHubPassword}"
                }
                sh "docker pull ${REGISTRY}/weather-app:${IMAGE_TAG}"
            }
        }
    }
}