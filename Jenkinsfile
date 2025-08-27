pipeline {
	agent any
	tools {
		nodejs 'NodeJS'
	}
	// environment {
	// 	SONAR_PROJECT_KEY = 'node-app'
	// 	SONAR_SCANNER_HOME = tool 'SonarQubeScanner'
	// 	DOCKER_HUB_CREDENTIALS_ID = 'jen-dockerhub'
	// 	DOCKER_HUB_REPO = 'marcel2630/jenkin-app'
	// }

	stages {
		stage('Checkout Github'){
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
		stage('Build Docker Image'){
			steps {
				sh 'docker.build("nodeimage"+"$BUILD_NUMBER")'
			}
		}
		// stage('Push Image to DockerHub'){
		// 	steps {
		// 		script {
		// 			docker.withRegistry('https://registry.hub.docker.com', "${DOCKER_HUB_CREDENTIALS_ID}"){
		// 				dockerImage.push('latest')
		// 			}
		// 		}
		// 	}
		// }
		// stage('SonarQube Analysis'){
		// 	steps {
		// 		withCredentials([string(credentialsId: 'node-token', variable: 'SONAR_TOKEN')]) {
				   
		// 			withSonarQubeEnv('SonarQube') {
		// 				sh """
        //           		${SONAR_SCANNER_HOME}/bin/sonar-scanner \
        //           		-Dsonar.projectKey=${SONAR_PROJECT_KEY} \
        //             	-Dsonar.sources=. \
        //            		-Dsonar.host.url=https://da4ff1cf6208.ngrok-free.app \
        //             	-Dsonar.login=${SONAR_TOKEN}
        //             	"""
		// 			}	
		// 		}
		// 	}
		// }
	}
	post {
		success {
			echo 'Build completed succesfully!'
		}
		failure {
			echo 'Build failed. Check logs.'
		}
	}
}
