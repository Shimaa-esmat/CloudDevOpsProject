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


