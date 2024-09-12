pipeline {
	agent any

	stages {
		stage('Checkout Github'){
			steps {
				git branch: 'main', credentialsId: 'github-cred', url: 'https://github.com/iQuantC/Simple_NodeJS_App.git'
			}
		}
		
		stage('Install node dependencies'){
			steps {
				sh 'npm install'
			}
		}
	
	}

}
