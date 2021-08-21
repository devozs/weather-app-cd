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
                                choices: ['ONE', 'TWO'],
                                name: 'PARAMETER_01'
                            ),
                            booleanParam(
                                defaultValue: true,
                                description: '',
                                name: 'BOOLEAN'
                            ),
                            text(
                                defaultValue: '''
                                this is a multi-line
                                string parameter example
                                ''',
                                 name: 'MULTI-LINE-STRING'
                            ),
                            string(
                                defaultValue: 'scriptcrunch',
                                name: 'STRING-PARAMETER',
                                trim: true
                            )
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