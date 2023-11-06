pipeline {
    agent {
        docker {
            image 'danischm/aac:0.5.3'
            label 'digidev'
            args '-u root'
        }
    }

    environment { 
        WEBEX_TOKEN = credentials('WEBEX_TOKEN')
        WEBEX_ROOM_ID = "Y2lzY29zcGFyazovL3VzL1JPT00vNTFmMGNmODAtYjI0My0xMWU5LTljZjUtNWY0NGQ2ZTlmYWY0"
        GIT_COMMIT_MESSAGE = "${sh(returnStdout: true, script: 'git config --global --add safe.directory "*" && git log -1 --pretty=%B ${GIT_COMMIT}').trim()}"
        GIT_COMMIT_AUTHOR = "${sh(returnStdout: true, script: 'git show -s --pretty=%an').trim()}"
        GIT_EVENT = "${(env.CHANGE_ID != null) ? 'Pull Request' : 'Push'}"
    }

    options {
        disableConcurrentBuilds()
        newContainerPerStage()
    }

    stages {
        stage('Publish Documentation') {
            when {
                branch "master"
            }
            steps {
                build job: "/netascode/netascode/master", wait: false
                sh 'pip install --upgrade mkdocs mkdocs-material'
                sh 'python3 docs/sdwan-doc.py'
                sh 'mkdocs build'
                sshagent(credentials: ['VIELAB_HOST_SSH']) {
                    sh '''
                        [ -d ~/.ssh ] || mkdir ~/.ssh && chmod 0700 ~/.ssh
                        ssh-keyscan -t rsa,dsa digitize-delivery.cisco.com >> ~/.ssh/known_hosts
                        scp -r site/ danischm@digitize-delivery.cisco.com:/www/sdwan/
                    '''
                }
            }
        }
    }
    
    post {
        always {
            sh "BUILD_STATUS=${currentBuild.currentResult} python .ci/webex-notification-jenkins.py"
        }
    }
}
