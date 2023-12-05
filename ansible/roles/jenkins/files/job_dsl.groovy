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
                    github("${GITHUB_NAME}", "${GITUB_BRANCH}")
                }
                steps {
                    shell("sh /var/lib/jenkins/job.sh ${DISPLAY_NAME}")
                }
            }
            '''.stripIndent())
        }
    }
}