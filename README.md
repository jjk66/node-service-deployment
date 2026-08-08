# Node.js Service Deployment Project
Docker roadmaps Project to deploy a node.js service located at:
```bash
https://roadmap.sh/projects/nodejs-service-deployment
```

## Requirements
Need to have the following setup:
- Setup a DigitalOcean droplet using Terraform
- Setup the server using Ansible including installing Node.js and npm
- Create a simple Node.js service that just has a / route which returns Hello, world!
- Push the codebase to GitHub repository

## Modified Requirements for DigitalOcean droplet
Use Docker containers inplace of the DigitalOcean droplet
- Create a Dockerfile
  - use ubuntu
  - install SSH server, python and curl/sudu utilities
  - set rootpassword
  - expose port 22 for SSH access
  - start ssh daemon
- Create the image
  - name: local-droplet
- Create the container
  - name: my-ansible-node
  - set container port 22 to local port 2222

## Task 1 - Manual Ansible deployment
Setup an ansible role to called ```app``` to:
- connect to the server
- clone clone the repository
- install dependencies
- build the application
- start the application
Create a playbook to use the role to get the appliction up and running on port 8080
- use this command: ```ansible-playbook node_service.yml --tags app```
- you should access the application using the public IP of the server

## Task 2 - Automate Deployment using github actions
Write a GitHub Action workflow to:
- deploy the application
  - option 1: Use the ansible-playbook command to run the playbook to deploy the application
  - option 2: Use SSH to connect and deploy the application
    - use rsync
    - use GitHub Actions: web-factory/ssh-agent, appleboy/ssh-action

## Task 1 Instructions

### Pre-requisite Clone this repo
Clone the repo from here using this command:
```bash
git clone https://github.com/jjk66/node-service-deployment.git
cd node-service-deployment
```

## Create fake droplet application server
### Build local-droplet image
```bash
docker build -t local-droplet .
```
### Build the local-droplet container
Port forward port 22 from container to local port 2222 and use port 8080 from container to local port 8080
```bash
docker run -d --name my-ansible-node -p 2222:22 -p 8080:8080 local-droplet
```
### Ping test to local-droplet
Use ansible to test the local-droplet container
```bash
ansible webservers -i ./inventories -m ping
```

## Use ansible playbook to install to the local droplet container
### Run the node service playbook to install the application and start the application
```
ansible-playbook -i inventories/hosts.yml node_service.yml --tags app
```
### Verify application is running
```
curl localhost:8080
--> Hello World from your local Docker droplet!
```

## Task 2 instructions

### Use GitHub Workflow
This workflow will build local droplet image and container and then run the ansible playbook to install and start the Node application.

It will verify the container is ready and after the playbook runs a verification will curl the local host on port 8080 to make sure the application is running.

The final action is to destroy the container.