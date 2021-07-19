pipeline {
    agent any
    // Prepare Docker Image tag 
    environment{
        DOCKER_TAG = getDockerTag()
        FILE_NAME = getDATAFILE()
    }

    stages{

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
                sh 'docker build . -t praveeshmoorkoth/mylab:${DOCKER_TAG} --build-arg DATA_FILE_VAR=${FILE_NAME}'
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
                ansiblePlaybook extras: "-e release_tag=${env.DOCKER_TAG}", playbook: 'ansible/deploy.yml',inventory: "ansible/${BRANCH_NAME}.inventory"
            }
        }
    }
}
// Capture docker image tab with combination of git_commit, branch and build number
def getDockerTag(){
    def commit_id  = sh script: 'git rev-parse --short HEAD', returnStdout: true
    commit_id  = commit_id.trim()
    def tag =${BRANCH_NAME}+"_"+commit_id+"_"+${BUILD_NUMBER}
    return tag
}

// Prepare env specific DATAFILE
def getDATAFILE(){
    def git_branch_name  = ${BRANCH_NAME}
    file = 'Questions.json'
    if (git_branch_name.equals("staging"))
    {
        file = 'Questions-test.json'
    }
    return file
}
