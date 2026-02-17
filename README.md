<p align="center">
  <img src="app/static/logos/nti-logo.png" height="100"/>
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="app/static/logos/ivolve-logo.png" height="100"/>
</p>

# CloudDevOpsProject

This repository demonstrates a Cloud DevOps workflow including containerization, Kubernetes orchestration, infrastructure provisioning using Terraform (locally with Minikube), Configuration Management with Ansible, Continuous Integration with Jenkins and Continuous Deployment with ArgoCD.

---

## . Containerization with Docker

- Application source code cloned from: [FinalProject](https://github.com/Ibrahim-Adel15/FinalProject.git)
- Dockerfile created in the app project root:

```dockerfile
FROM python:3.10-slim
WORKDIR /app
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app/ .
EXPOSE 5000
CMD ["python", "app.py"]
```

### Built Docker image:

```bash
docker build -t gp-ivolve .
```

### Verified Docker image and Pushed to Docker Hub:

```bash
docker images
```

Running container:

![dockerimage](/Screenshots/dockerimage.png)

```bash
docker run -p 5000:5000 gp-ivolve
```

![dockerrun](/Screenshots/dockerrun.png)

```bash
docker tag gp-ivolve shimaaesmat/gp-ivolve:latest
docker push shimaaesmat/gp-ivolve:latest
```

## 2. Container Orchestration with Kubernetes

Minikube cluster used for local deployment.

### Created Kubernetes namespace: ivolve.

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: ivolve
```

### Deployment configuration (k8s/deployment.yaml):

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: gp-deployment
  namespace: ivolve
spec:
  replicas: 2
  selector:
    matchLabels:
      app: flask
  template:
    metadata:
      labels:
        app: flask
    spec:
      containers:
      - name: flask
        image: gp-ivolve
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 5000
```

### Service configuration (k8s/service.yaml):

```yaml
apiVersion: v1
kind: Service
metadata:
  name: gp-service
  namespace: ivolve
spec:
  type: NodePort
  selector:
    app: flask
  ports:
    - port: 5000
      targetPort: 5000
      nodePort: 30007
```

### Applied all Kubernetes resources:

```bash
kubectl apply -f k8s/
```

![applyresource](/Screenshots/applyresource.png)

### Minikube Service Access

automatically

```bash
minikube service gp-service -n ivolve
```

![minikubeautomatically](/Screenshots/automatically.png)

manually

```bash
minikube ip
kubectl get svc -n ivolve
```

![minikubemanually](/Screenshots/manually.png)

---

## 3. Infrastructure Provisioning with Terraform (Minikube)

Note: Original task required AWS infrastructure provisioning (VPC, EC2, S3 Backend, CloudWatch).
Since AWS account was not available, Terraform was implemented locally using Kubernetes provider with Minikube while maintaining:
> Modular structure

> Infrastructure as Code principles

> Reusable Terraform modules

#### Objectives:

> Create Kubernetes Namespace (ivolve)

> Create Deployment for Flask Application

> Create NodePort Service

> Use Terraform Modules (Network & Server)

#### Prepare the toolbox

Initializes Terraform project folder
Downloads the provider plugins needed (e.g., Kubernetes provider for Minikube).
Prepares Terraform to understand configuration and modules.

```bash
terraform init
```

#### Check what is about to build

Shows a preview of what Terraform will do if eun apply
Checks configuration against the current state of infrastructure.
Catch mistakes before making changes.

```bash
terraform plan
```

#### Applies the changes to infrastructure.

Creates resources in Minikube (namespace, deployment, service).
Uses the Terraform state to track what exists so next time it can manage updates.

```bash
terraform apply
```

![terraforminit](/Screenshots/terraforminit.png)
![terraformplan](/Screenshots/terraformplan.png)
![terraformapply](/Screenshots/terraformapply.png)
![terraformvalid](/Screenshots/terraforminit.png)


```bash
terraform output
```

![terraformoutput](/Screenshots/terraformoutput.png)

---

## 4. Configuration Management with Ansible

Ansible is used to configure the local Minikube/Ubuntu environment automatically instead of AWS EC2.

 - Install required packages
 - Install Jenkins
 - Use Ansible Roles
 - Use Static Inventory (Local VM instead of AWS Dynamic Inventory)


##### Run Playbook 

```bash
ansible-playbook playbook.yaml
```

![playbookansible](/Screenshots/playbookansible.png)


#### Verification

Docker Version

```bash
docker --version
```

![dockeransible](/Screenshots/dockeransible.png)

Java Version

```bash
java --version
```

![javaansible](/Screenshots/javaansible.png)

Jenkins Service Status

```bash
sudo systemctl status jenkins
```

![Jenkinstatus](/Screenshots/Jenkinstatus.png)
![Jenkinsansible](/Screenshots/Jenkinsansible.png)

> Note: AWS EC2 was not available in this environment.

> Therefore, Ansible was implemented on a local Ubuntu VM

> with static inventory while maintaining role-based structure.

---

## 5. Continuous Integration with Jenkins

This step sets up a Jenkins pipeline to automate building, scanning, and pushing the Docker image, updating Kubernetes manifests, and deploying to the Minikube cluster.

- Build the Docker image.
- Scan the Docker image.
- Push the image to Docker Hub.
- Delete the local image to save space.
- Update Kubernetes manifests.
- Apply the manifests to the Minikube cluster.
- Use a Jenkins Shared Library for reusable pipeline steps.

#### Jenkins Pipeline

```Jenkinsfile
@Library('shared-library') _

pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "shimaaesmat/gp-ivolve:latest"
        NAMESPACE = "ivolve"
    }

    stages {

        stage('Build Image') {
            steps {
                script { buildImage(DOCKER_IMAGE) }
            }
        }

        stage('Scan Image') {
            steps {
                script { scanImage(DOCKER_IMAGE) }
            }
        }

        stage('Push Image') {
            steps {
                script { pushImage(DOCKER_IMAGE) }
            }
        }

        stage('Delete Local Image') {
            steps {
                script { deleteImage(DOCKER_IMAGE) }
            }
        }

        stage('Update Manifests') {
            steps {
                script { updateManifest(DOCKER_IMAGE) }
            }
        }

        stage('Deploy to K8s') {
            steps {
                script { deployK8s(NAMESPACE) }
            }
        }
    }
}
```

#### Shared Library Structure

The vars/ directory contains reusable pipeline functions

```markdown
shared-library/
└── vars/
    ├── buildImage.groovy
    ├── scanImage.groovy
    ├── pushImage.groovy
    └── deployK8s.groovy
```

Each .groovy file contains a function that can be called in the pipeline to keep your Jenkinsfile clean and maintainable

#### CI/CD Workflow Diagram

Developer Push → Jenkins Pipeline → Docker Build → Trivy Scan → DockerHub → Update K8s Manifests → Deploy to Minikube

![scan image](/Screenshots/scanimage.png)
![CI/CD Workflow](/Screenshots/CICDWorkflow.png)
