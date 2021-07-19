pipeline {
    agent any
    // Prepare Docker Image tag 
    environment{
        DOCKER_TAG = getDockerTag()
        BRANCH_NAME = getGitBranch()
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
                ansiblePlaybook extras: "-e release_tag=${env.DOCKER_TAG}", playbook: 'ansible/deploy.yml',inventory: "ansible/${env.BRANCH_NAME}.inventory"
            }
        }
    }
}
// Capture git branch
def getGitBranch(){
    def git_branch_name  = sh script: 'echo ${BRANCH_NAME}', returnStdout: true
    return git_branch_name
}

// Capture docker image tab with combination of git_commit, branch and build number
def getDockerTag(){
    def commit_id  = sh script: 'git rev-parse --short HEAD', returnStdout: true
    commit_id  = commit_id.trim()
    def git_branch_name  = getGitBranch ()
    build_number=sh script: 'echo ${BUILD_NUMBER}', returnStdout: true
    def tag =git_branch_name+"_"+commit_id+"_"+build_number
    return tag
}

// Prepare env specific DATAFILE
def getDATAFILE(){
    def git_branch_name  = getGitBranch ()
    file = 'Questions.json'
    if (git_branch_name.equals("staging"))
    {
        file = 'Questions-test.json'
    }
    return file
}
