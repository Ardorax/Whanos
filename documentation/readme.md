# Project Documentation

## Change Log
- [Joshua BRIONNE] - 2023-11-28 - First draft of the readme.md file

## Authors
- [Maxime DZIURA](mailto:maxime.dziura@epitech.eu)
- [Joshua BRIONNE](mailto:joshua.brionne@epitech.eu)
- [Valentin Dury](mailto:valentin.dury@epitech.eu)

## Table of Contents
- [Introduction](#introduction)
- [Project Overview](#project-overview)
- [Folder Structure](#folder-structure)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Images](#images-folder)
  - [images](#images-folder)
  - [jenkins](#jenkins-folder)
  - [kubernetes](#kubernetes-folder)
- [Jenkins](#jenkins-folder)
- [Configuration](#configuration)
- [Customization](#customization)
- [Contributing](#contributing)
- [License](#license)

## Introduction
Welcome to the documentation for the Whanos project, a collaborative effort by students in the 3rd year curriculum at Epitech. This project aims to establish a powerful DevOps infrastructure, allowing developers to automatically deploy applications into a cluster with ease just by pushing to a Git repository.

## Project Overview
The Whanos project involves the integration of Docker, Jenkins, Ansible, and Kubernetes to create an efficient and automated deployment pipeline. As part of the curriculum, this project serves as a hands-on learning experience, demonstrating the synergy of various DevOps tools.

## Folder Structure

```bash
    .
    |-- images
    |   |-- befunge
    |   |-- c
    |   |-- java
    |   |-- javascript
    |   |-- python
    |
    |-- jenkins
    |-- kubernetes
```

## Getting Started

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Jenkins](https://www.jenkins.io/doc/book/installing/)
- [Kubernetes](https://kubernetes.io/docs/tasks/tools/)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)


### Installation

1. Clone the repository
   ```bash
   git clone git@github.com:EpitechPromo2026/B-DOP-500-LYN-5-1-whanos-joshua.brionne.git
    ```
    ...

## images Folder

This folder contains the Dockerfiles for the various languages supported by the project. Each language has its own folder, which contains the Dockerfile**S** and any other files required to build the image.

Each folder contains in fact 2 dockerfiles, one with a standalone extension and one without. The standalone extension is used to build the image as a standalone container, while the other one is used as a base image if the user wants to add settings args during the build process.

> ℹ️ Every app is built inside an app folder

Here are the specificities of each language:

### BEFUNGE
**📁 Files:**
 - Dockerfile
 - Dockerfile.standalone
 - befunge_interpretor.py

**🐳 Base image:**
 - python:3.12-alpine

**📙 Explanation:**
 - Here, we created a set of dockerfile to contenerize the befunge language. The interpretor is written in python, so we use the python image as a base image. The interpretor is then copied into the image and the entrypoint is set to the interpretor.

---

### C
**📁 Files:**
 - Dockerfile
 - Dockerfile.standalone

**🐳 Base image:**
 - gcc:13.2

**📙 Explanation:**
 - Here, we created a set of dockerfile to contenerize the C language. The gcc image is used as a base image. The entrypoint is set to the gcc command. We then clean all the unecessary files. This is done by removing every files except the executable.

---

### JAVA
**📁 Files:**
 - Dockerfile
 - Dockerfile.standalone

**🐳 Base image:**
 - maven:3.9

**📙 Explanation:**
 - Here, we created a set of dockerfile to contenerize the java language. The maven image is used as a base image. The entrypoint is set to the maven command. We then clean all the unecessary files. This is done by removing every files except the **app.jar.**.
 > Here we have a small difference between the standalone and the non-standalone version. The standalone version is a double stage build. The first stage is used to build the app.jar and the second one is used to run the app.jar. The non-standalone version is a single stage build. It is used to build the app.jar and run it.

---

 ### JAVASCRIPT
**📁 Files:**
 - Dockerfile
 - Dockerfile.standalone

**🐳 Base image:**
 - node:20.9

**📙 Explanation:**
 - Here, we created a set of dockerfile to contenerize the javascript language. The node image is used as a base image. The entrypoint is set to the node command.

---

### PYTHON
**📁 Files:**
 - Dockerfile
 - Dockerfile.standalone

**🐳 Base image:** 
- python:3.12-alpine

**📙 Explanation:**
 - Here, we created a set of dockerfile to contenerize the python language. The python image is used as a base image. The entrypoint is set to the python command.

### jenkins Folder
...

### kubernetes Folder
...

## Configuration
...

## Customization
If you wish to customize the project, you can do so by adding your favorite language to the project. To do so, you will need to create a new folder in the images folder. This folder will contain the Dockerfile**S** and any other files required to build the image.

## Contributing
We welcome contributions to enhance the Whanos project. If you have suggestions, improvements, or bug fixes, feel free to:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a Pull Request

For major changes, please open an issue first to discuss proposed changes.

For more information, see [Contributing](./CONTRIBUTING.md).

## License
This project is part of the Epitech 3rd-year curriculum and is intended for educational purposes.
You are encouraged to explore and learn from the code. However, direct copying of the source code is not permitted for academic integrity reasons.
More information can be found in the [LICENSE](./LICENSE) file.

