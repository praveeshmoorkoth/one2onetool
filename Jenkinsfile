pipeline {
    agent any
    // Prepare Docker Image tag 
    environment{
        DOCKER_TAG = getDockerTag()
    }

    stages{

        // Checkout source code from git-repo.Credentials of the git repo is stored in GitCredentials  
        stage('scm-checkout'){
            steps{
                git credentialsId: 'GitCredentials', url: 'https://github.com/praveeshmoorkoth/one2onetool.git'
            }
        }

        // Run unit test cases  
        stage('unit-test') {
            steps{
                sh 'npm install --only=dev'
                sh 'npm test'
            }
        }

        // Build docker image
        stage('Build Docker Image'){
            steps{
                sh 'docker build . -t praveeshmoorkoth/mylab:${DOCKER_TAG}'
            }
        }

        // Push docker image to docker-hub
        stage('Push Docker Image'){
            steps{
                withCredentials([string(credentialsId: 'docker-pwd', variable: 'dockerHubPwd')]) {
                sh "docker login -u praveeshmoorkoth -p ${dockerHubPwd}"
                }
                sh 'docker push praveeshmoorkoth/mylab:${DOCKER_TAG}'
            }
        }

        // Deploy the docker image to a specific env
        stage('Deploy the docker image'){
            steps{
                ansiblePlaybook extras: "-e tag=${env.DOCKER_TAG}", playbook: 'ansible/deploy.yml',inventory: 'ansible/{env.BRANCH_NAME}.inventory'
            }
        }
    }

}

def getDockerTag(){
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}
