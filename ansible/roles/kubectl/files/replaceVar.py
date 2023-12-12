#!/bin/python3

import yaml
import sys
import random

def parseFile(filename):
    with open(filename, 'r') as f:
        configFile = yaml.safe_load(f)
    return configFile

def openBaseConfig():
    with open('app.service.yaml', 'r') as f:
        redisService = yaml.safe_load(f)
    with open('app.deployment.yaml', 'r') as f:
        redisDeploy = yaml.safe_load(f)
    return redisService, redisDeploy

def replaceReplicas(redisDeploy, config):
    if 'replicas' in config['deployment'] and config['deployment']['replicas'] != None:
        redisDeploy['spec']['replicas'] = config['deployment']['replicas']
    return redisDeploy

def replaceresources(redisDeploy, config):
    if 'resources' in config['deployment'] and config['deployment']['resources'] != None:
        if 'limits' in config['deployment']['resources'] and config['deployment']['resources']['limits'] != None:
            if 'cpu' in config['deployment']['resources']['limits'] and config['deployment']['resources']['limits']['cpu'] != None:
                redisDeploy['spec']['template']['spec']['containers'][0]['resources']['limits']['cpu'] = config['deployment']['resources']['limits']['cpu']
            if 'memory' in config['deployment']['resources']['limits'] and config['deployment']['resources']['limits']['memory'] != None:
                redisDeploy['spec']['template']['spec']['containers'][0]['resources']['limits']['memory'] = config['deployment']['resources']['limits']['memory']
        if 'requests' in config['deployment']['resources'] and config['deployment']['resources']['requests'] != None:
            if 'cpu' in config['deployment']['resources']['requests'] and config['deployment']['resources']['requests']['cpu'] != None:
                redisDeploy['spec']['template']['spec']['containers'][0]['resources']['requests']['cpu'] = config['deployment']['resources']['requests']['cpu']
            if 'memory' in config['deployment']['resources']['requests'] and config['deployment']['resources']['requests']['memory'] != None:
                redisDeploy['spec']['template']['spec']['containers'][0]['resources']['requests']['memory'] = config['deployment']['resources']['requests']['memory']
    return redisDeploy

def getAllPorts(config):
    ports = []
    if 'ports' in config['deployment'] and config['deployment']['ports'] != None:
        for i in config['deployment']['ports']:
            ports.append(i)
    return ports

def replacePorts(redisDeploy, redisService, config):
    ports = getAllPorts(config)
    if len(ports) == 0:
        pass
    else:
        containerPorts = []
        targetPorts = []
        for i in ports:
            containerPorts.append({'containerPort': i})
            targetPorts.append({'port': i, 'targetPort': i})
        redisDeploy['spec']['template']['spec']['containers'][0]['ports'] = containerPorts
        redisService['spec']['ports'] = targetPorts
    return redisService, redisDeploy

def changeName(redisService, redisDeploy, name):
    redisService['metadata']['name'] = f"{name}-service"
    redisDeploy['metadata']['name'] = f"{name}-deployment"
    return redisService, redisDeploy

def replaceImage(redisDeploy, image):
    redisDeploy['spec']['template']['spec']['containers'][0]['image'] = image

def replaceLabels(redisService, redisDeploy, name):
    redisService['metadata']['labels']['app'] = name
    redisService['spec']['selector']['app'] = name
    redisDeploy['metadata']['labels']['app'] = name
    redisDeploy['spec']['selector']['matchLabels']['app'] = name
    redisDeploy['spec']['template']['metadata']['labels']['app'] = name
    redisDeploy['spec']['template']['spec']['containers'][0]['name'] = name
    return redisService, redisDeploy

def rollMe(redisDeploy):
    redisDeploy["metadata"]["annotations"]["rollme"] = str(random.randint(-2000000000, 2000000000))
    return redisDeploy

def replaceInFile(config):
    redisService, redisDeploy = openBaseConfig()
    changeName(redisService, redisDeploy, sys.argv[2])
    replaceImage(redisDeploy, sys.argv[3])
    replaceLabels(redisService, redisDeploy, sys.argv[2])
    redisDeploy = rollMe(redisDeploy)
    redisDeploy = replaceReplicas(redisDeploy, config)
    redisDeploy = replaceresources(redisDeploy, config)
    redisService, redisDeploy = replacePorts(redisDeploy, redisService, config)
    return redisService, redisDeploy

def main():
    configFile = parseFile(sys.argv[1])
    if not 'deployment' in configFile:
        print('No deployment section found in config')
        return 1
    (redisService, redisDeploy) = replaceInFile(configFile)
    with open('app.service.yaml', 'w') as f:
        yaml.dump(redisService, f)
    with open('app.deployment.yaml', 'w') as f:
        yaml.dump(redisDeploy, f)
    return 0

if __name__ == '__main__':
    sys.exit(main())