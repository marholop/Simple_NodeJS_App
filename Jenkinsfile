pipeline {
    agent any
	tools {
		nodejs 'NodeJS'
	}

    environment {
        DOCKER_IMAGE = "marcel2630/jenkin-app"
        DOCKER_TAG   = "latest"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/marholop/Simple_NodeJS_App.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t $DOCKER_IMAGE:$DOCKER_TAG ."
                }
            }
        }

        stage('Scan with Trivy') {
            steps {
                script {
                    sh "trivy image --exit-code 1 --severity HIGH,CRITICAL $DOCKER_IMAGE:$DOCKER_TAG || true"
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                        sh "docker push $DOCKER_IMAGE:$DOCKER_TAG"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh "kubectl set image deployment/myapp myapp=$DOCKER_IMAGE:$DOCKER_TAG -n default"
                }
            }
        }
    }
}
