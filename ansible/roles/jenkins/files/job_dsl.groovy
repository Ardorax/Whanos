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
        stringParam("GITHUB_NAME", "", "Github repository owner/name (e.g. 'epitech/whanos')")
        stringParam("GITUB_BRANCH", "" , "Github branch (e.g. 'master')")
        stringParam("DISPLAY_NAME", "" , "Display name for the job (e.g. 'Whanos')")
        stringParam("GITHUB_TOKEN", "" , "Github token for private repositories (leave it empty for public repositories)")
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
                        branch("${GITUB_BRANCH}")
                        remote {
                            url("https://${GITHUB_TOKEN}@github.com/${GITHUB_NAME}")
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