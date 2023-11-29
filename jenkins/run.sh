docker run --name jenkins --rm -v `pwd`:/var/jenkinsData -p 8080:8080 --env ADMIN_PASSWORD=admin jenkins:custumJenkins
