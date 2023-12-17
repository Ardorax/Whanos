folder('Whanos base images') {
    description('Whanos base images folder')
    displayName('Whanos base images')
}

folder('Projects') {
    description('Projects folder')
    displayName('Projects')
}

def languages = ['befunge', 'c', 'java', 'javascript', 'python']

languages.each { language ->
    freeStyleJob("Whanos base images/Build ${language} base image") {
        description("Build ${language} base image")
        displayName("Build ${language} base image")
        wrappers {
            preBuildCleanup()
        }
        steps {
            shell("docker build -t whanos-${language} -f /opt/images/${language}/Dockerfile.base .")
            // shell("docker tag whanos-${language} localhost:5000/whanos-${language}")
            // shell("docker push localhost:5000/whanos-${language}")
        }
        triggers {
            upstream('Whanos base images/Build all base images', 'SUCCESS')
        }
    }
}

freeStyleJob('Whanos base images/Build all base images') {}

freeStyleJob('link-project') {
    parameters {
        stringParam("GIT_URL", "", "Git repository clone url (e.g. 'https://github.com/user/project.git')")
        stringParam("BRANCH", "main" , "branch (e.g. 'main')")
        stringParam("DISPLAY_NAME", "" , "Display name for the job (e.g. 'Whanos')")
        credentialsParam('GIT_CRED') {
            type('com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl')
            required()
            description('A token to access private repositories')
        }
    }
    steps {
        dsl {
            text('''
            freeStyleJob("Projects/${DISPLAY_NAME}") {
                wrappers {
                    preBuildCleanup()
                }
                triggers {
                    scm("* * * * *")
                }
                scm {
                    git {
                        branch("${BRANCH}")
                        remote {
                            url("${GIT_URL}")
                            credentials("${GIT_CRED}")
                        }
                    }
                }
                steps {
                    shell("/bin/bash /opt/job.sh ${DISPLAY_NAME}")
                }
            }
            '''.stripIndent())
        }
    }
}