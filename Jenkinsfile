pipeline {
    agent {
        docker {
            image 'danischm/nac:0.1.0'
            label 'digidev'
            args '-u root'
        }
    }

    environment {
        DD_GITHUB_TOKEN = credentials('DD_GITHUB_TOKEN')
        DD_INTERNAL_GITHUB_TOKEN = credentials('DD_INTERNAL_GITHUB_TOKEN')
        WEBEX_TOKEN = credentials('WEBEX_TOKEN')
        WEBEX_ROOM_ID = 'Y2lzY29zcGFyazovL3VzL1JPT00vNTFmMGNmODAtYjI0My0xMWU5LTljZjUtNWY0NGQ2ZTlmYWY0'
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
                branch 'master'
            }
            steps {
                build job: '/netascode/netascode/master', wait: false
            }
        }
    }

    post {
        always {
            script {
                if (env.BRANCH_NAME == 'master') {
                    sh 'cd scripts && python3 update_repos.py'
                }
            }
            sh "BUILD_STATUS=${currentBuild.currentResult} python .ci/webex-notification-jenkins.py"
        }
    }
}
