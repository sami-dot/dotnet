pipeline {
  agent {
    label 'kr-jenkins-slave01'
  }

  environment {
    VERSION = "1.0.${BUILD_NUMBER}"
    FILE_NAME = "SimpleApp-${VERSION}.tar.gz"
    NEXUS_URL = "http://10.1.96.4:8098"
    NEXUS_REPO = "dotnet-repo"
  }

  stages {
    stage('Clean Previous Build') {
      steps {
        sh 'rm -rf publish'
      }
    }

    stage('Publish .NET App') {
      steps {
        sh '''
          dotnet publish -c Release -o publish
          tar -czf ${FILE_NAME} -C publish .
        '''
      }
    }

    stage('Upload to Nexus') {
      steps {
        sh """
          curl -u admin:admin123 --upload-file ${FILE_NAME} ${NEXUS_URL}/repository/${NEXUS_REPO}/${FILE_NAME}
        """
      }
    }

    stage('Deploy to IIS via PowerShell') {
      steps {
        sshagent(credentials: ['your-ssh-credential-id']) {
          sh """
            ssh -o StrictHostKeyChecking=no Admin1@10.1.96.4 powershell.exe -ExecutionPolicy Bypass -File C:/deployment/deploy-dotnet.ps1 -version ${VERSION}
          """
        }
      }
    }
  }
}
