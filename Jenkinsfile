pipeline {
    agent any
	tools {
		nodejs 'NodeJS'
	}

    environment {
        DOCKER_IMAGE = "marcel2630/jenkin-app"
        DOCKER_TAG   = "latest"
        SONAR_PROJECT_KEY = 'jenkins-docker'
		SONAR_SCANNER_HOME = tool 'SonarQubeScanner'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/marholop/Simple_NodeJS_App.git'
            }
        }

        stage('Install node dependencies'){
			steps {
				sh 'npm install'
			}
		}

		stage('Tests'){
			steps {
				sh 'npm test'
			}
		}

        stage('Trivy FileSystem Scan') {
            steps {
                sh "trivy fs --format table -o trivy-fs-report.html ."
            }
        }

		stage('SonarQube Analysis'){
			steps {
				withCredentials([string(credentialsId: 'node-token', variable: 'SONAR_TOKEN')]) {
				   
					withSonarQubeEnv('SonarQube') {
						sh """
                  		${SONAR_SCANNER_HOME}/bin/sonar-scanner \
                  		-Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                    	-Dsonar.sources=. \
                   		-Dsonar.host.url=https://048e9d4cb33f.ngrok-free.app \
                    	-Dsonar.login=${SONAR_TOKEN}
                    	"""
					}	
				}
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
                // sh "trivy image $DOCKER_IMAGE:$DOCKER_TAG"
				sh "trivy image --exit-code 1 --severity CRITICAL --no-progress $DOCKER_IMAGE:$DOCKER_TAG"
				// sh 'trivy --severity HIGH,CRITICAL --no-progress image --format table -o trivy-scan-report.txt ${DOCKER_HUB_REPO}:latest'
				// sh 'trivy image --severity HIGH,CRITICAL --no-progress --format table -o trivy-scan-report.txt $DOCKER_IMAGE:$DOCKER_TAG'
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

        // stage('Deploy to Kubernetes') {
        //     steps {
        //         script {
        //             sh "kubectl set image deployment/myapp myapp=$DOCKER_IMAGE:$DOCKER_TAG -n default"
        //         }
        //     }
        // }
    }
    post {
        always {
            cleanWs()
        }
    }
}
