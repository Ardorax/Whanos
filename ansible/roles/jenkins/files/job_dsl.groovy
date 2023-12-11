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
            shell("docker build -t whanos-${language} -f /var/lib/jenkins/images/${language}/Dockerfile.base .")
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
        stringParam("GITHUB_NAME", "", "Github repository owner/name (e.g. 'epitech/whanos')")
        stringParam("GITUB_BRANCH", "" , "Github branch (e.g. 'master')")
        stringParam("DISPLAY_NAME", "" , "Display name for the job (e.g. 'Whanos')")
        credentialsParam("GITHUB_CREDENTIALS") {
            type("com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey")
            description("Ssh credentials for github private repository")
            defaultValue("")
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
                        remote {
                            github("${GITHUB_NAME}", "ssh", "github.com")
                            branch("${GITUB_BRANCH}")
                            credentials("${GITHUB_CREDENTIALS}")
                        }
                    }
                }
                steps {
                    shell("/bin/bash /var/lib/jenkins/job.sh ${DISPLAY_NAME}")
                }
            }
            '''.stripIndent())
        }
    }
}