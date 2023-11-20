folder('Whanos base images') {
    description('Whanos base images folder')
    displayName('Whanos base images')
}

folder('Projects') {
    description('Projects folder')
    displayName('Projects')
}

freeStyleJob('Whanos base images/whanos-c') {
    wrappers {
        preBuildCleanup()
    }
    steps {
        shell("docker build -t whanos-c < - /images/c/Dockerfile.base")
        shell("docker tag whanos-c localhost:5000/whanos-c")
        shell("docker push localhost:5000/whanos-c")
        shell("docker rmi whanos-c")
    }
    triggers {
        upstream('Build all base images', 'SUCCESS')
    }
}

freeStyleJob('Whanos base images/whanos-java') {
    wrappers {
        preBuildCleanup()
    }
    steps {
        shell("docker build -t whanos-java < - /images/java/Dockerfile.base")
        shell("docker tag whanos-java localhost:5000/whanos-java")
        shell("docker push localhost:5000/whanos-java")
        shell("docker rmi whanos-java")
    }
    triggers {
        upstream('Build all base images', 'SUCCESS')
    }
}

freeStyleJob('Whanos base images/whanos-javascript') {
    wrappers {
        preBuildCleanup()
    }
    steps {
        shell("docker build -t whanos-javascript < - /images/javascript/Dockerfile.base")
        shell("docker tag whanos-javascript localhost:5000/whanos-javascript")
        shell("docker push localhost:5000/whanos-javascript")
        shell("docker rmi whanos-javascript")
    }
    triggers {
        upstream('Build all base images', 'SUCCESS')
    }
}

freeStyleJob('Whanos base images/whanos-python') {
    wrappers {
        preBuildCleanup()
    }
    steps {
        shell("docker build -t whanos-python < - /images/python/Dockerfile.base")
        shell("docker tag whanos-python localhost:5000/whanos-python")
        shell("docker push localhost:5000/whanos-python")
        shell("docker rmi whanos-python")
    }
    triggers {
        upstream('Build all base images', 'SUCCESS')
    }
}

freeStyleJob('Whanos base images/whanos-befunge') {
    wrappers {
        preBuildCleanup()
    }
    steps {
        shell("docker build -t whanos-befunge < - /images/befunge/Dockerfile.base")
        shell("docker tag whanos-befunge localhost:5000/whanos-befunge")
        shell("docker push localhost:5000/whanos-befunge")
        shell("docker rmi whanos-befunge")
    }
    triggers {
        upstream('Build all base images', 'SUCCESS')
    }
}

freeStyleJob('Whanos base images/Build all base images') {}

freeStyleJob('Link-project') (
    wrappers {
        preBuildCleanup()
    }
    parameters {
        stringParam("GITUB_REPO", "" , "Github repository owner/name (e.g. 'epitech/whanos')")
    }
)