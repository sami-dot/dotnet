pipeline {
  agent {
    label 'kr-jenkins-slave01'
  }

  environment {
    VERSION = "1.0.${BUILD_NUMBER}"
    NEXUS_URL = "http://10.1.96.4:8098"
    NEXUS_REPO = "static-repo"
    DOTNET_PROJECT_PATH = "./SimpleIISApp"          // Adjust if needed
    ZIP_NAME = "SimpleApp-${VERSION}.zip"
    ZIP_PATH = "${WORKSPACE}/${ZIP_NAME}"
  }

  stages {
    stage('Build and Publish') {
      steps {
        dir("${DOTNET_PROJECT_PATH}") {
          sh 'dotnet restore'
          sh 'dotnet publish -c Release -o publish'
        }
      }
    }

    stage('Zip Publish Output') {
      steps {
        dir("${DOTNET_PROJECT_PATH}/publish") {
          sh "zip -r ${ZIP_PATH} *"
        }
      }
    }

    stage('Upload to Nexus') {
      steps {
        echo "📦 Uploading ${ZIP_NAME} to Nexus..."
        sh """
          curl -u admin:admin123 \\
            --upload-file ${ZIP_PATH} \\
            ${NEXUS_URL}/repository/${NEXUS_REPO}/${ZIP_NAME}
        """
      }
    }

    stage('Trigger Remote Deployment') {
      steps {
        echo "🚀 Triggering deployment on IIS server..."
        sshagent (credentials: ['your-ssh-credential-id']) {
          sh """
            ssh -o StrictHostKeyChecking=no Admin1@10.1.96.4 \\
              powershell.exe -ExecutionPolicy Bypass -File C:/deployment/deploy-dotnet.ps1 -version ${VERSION}
          """
        }
      }
    }
  }

  post {
    success {
      echo "✅ Deployment pipeline finished successfully."
    }
    failure {
      echo "❌ Deployment pipeline failed."
    }
  }
}
