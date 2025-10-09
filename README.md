# TrendApp Deployment Project
Application deployed kubernetes Loadbalancer ARN- ae94166f7eca44aa29696b0da43b8479-1706104608.ap-south-1.elb.amazonaws.com
## **Project Overview**
Deploy a React application on AWS using Docker, Terraform, Jenkins CI/CD, Kubernetes (EKS), and DockerHub, with end-to-end automated build, deployment, and monitoring.
•	Main Focus Areas:
1.	Version Control (Git/GitHub)
2.	Containerization (Docker)
3.	Infrastructure as Code (Terraform)
4.	CI/CD (Jenkins pipeline)
5.	Kubernetes Orchestration (EKS)
6.	Monitoring (Prometheus/Grafana or alternative open-source)

Step-by-Step Conceptual Explanation
1. Version Control
•	Theory: Git is used to manage code changes, track history, and collaborate. GitHub is a remote repository hosting service.
•	Concept: Every time a developer pushes code, CI/CD triggers automated builds and deployments.
2. Dockerization
•	Theory: Docker packages an application and its dependencies into a single portable container image. This ensures consistency across environments.
•	Concept: Containerization eliminates “it works on my machine” issues.
3. Infrastructure with Terraform
•	Theory: Terraform is an IaC (Infrastructure as Code) tool to provision cloud resources declaratively.
•	Concept: You define resources like VPC, EC2, IAM users, EKS cluster in .tf files and Terraform applies them automatically.
4. CI/CD with Jenkins
•	Theory: CI/CD pipelines automate testing, building, and deployment, reducing manual errors.
•	Concept: Jenkins monitors GitHub repo → triggers pipeline → builds Docker image → pushes to DockerHub → deploys to EKS.
5. Kubernetes Deployment
•	Theory: Kubernetes automates container orchestration, scaling, and deployment.
•	Concept: Deployment YAML defines desired app state, Service YAML exposes it via LoadBalancer.
6. Monitoring
•	Theory: Monitoring tools track app/cluster health, metrics, and logs.
•	Concept: Prometheus collects metrics, Grafana visualizes dashboards. Alerts notify issues proactively.

Steps:
Dockerizing the App: We need to containerize this app using Docker. Now, because this is a static build, we don’t need Node.js inside our container. Instead, we’ll use Nginx to serve these files. So in our Dockerfile, we start from a Nginx image, remove the default content, copy all our static files to the Nginx directory, expose port 80, and start Nginx. Once we build this Docker image, we can run it locally using docker run and access the app in the browser on port 3000. The idea here is that Docker packages everything together, so it doesn’t matter what machine we run it on—the app behaves the same.
Commands:
docker build -t trend-app:latest .
docker run -p 3000:3000 trend-app:latest

Pushing Docker Image to DockerHub: Once our Docker image is ready, we push it to DockerHub, which is basically a cloud storage for Docker images. Why do we do this? Because later Kubernetes needs to pull this image to deploy our app. So we tag the image with our DockerHub username and push it. This way, the image is available publicly or privately for our deployment pipeline. Think of DockerHub as a library where our app image sits ready to be used.
Commands:
docker login
docker tag trend-app:latest <dockerhub-username>/trend-app:latest
docker push <dockerhub-username>/trend-app:latest

Provisioning AWS Infrastructure with Terraform: Now, before deploying the app, we need some infrastructure on AWS. Instead of manually creating a VPC, EC2, or IAM users, we use Terraform, which lets us write all the resources as code. With a few commands like terraform init, terraform plan, and terraform apply, AWS creates everything for us. init prepares Terraform, plan shows what it will do, and apply actually provisions the resources. The cool thing is, we can destroy and rebuild this infrastructure anytime without manually clicking anything.
Commands:
terraform init
terraform plan
terraform apply

Setting up Jenkins CI/CD Pipeline: With the infrastructure ready, let’s automate the deployment. Jenkins is our automation tool here. We’ll create a pipeline that does everything: checkout the code from GitHub, build the Docker image, push it to DockerHub, and deploy it to Kubernetes. The idea is simple: once you push any update to GitHub, Jenkins automatically picks it up and deploys it, so we don’t have to do it manually every time. In the pipeline, we also use credentials for DockerHub so we don’t expose passwords. This is all about automation and safety.

Kubernetes Deployment: Next comes Kubernetes. We’ll deploy our Nginx container using a Deployment, which manages the number of app copies (pods) running. We also create a Service of type LoadBalancer, which exposes our app to the internet. Once deployed, Kubernetes ensures that even if one pod fails, another one runs, keeping the app available. We can check the pods with kubectl get pods and find the LoadBalancer URL with kubectl get svc. Students, this is where you’ll see the app running in a real cluster, just like production.
Commands:
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl get pods
kubectl get svc

Monitoring: Finally, it’s important to know if our app and cluster are healthy. We can use Prometheus and Grafana to monitor CPU, memory, pod status, and even get alerts if something goes wrong. For example, we can port-forward Grafana to localhost and see dashboards. Monitoring helps us detect problems early and ensures the app is reliable.
Commands:
kubectl apply -f prometheus.yml
kubectl port-forward svc/grafana 3000:3000

Version Control Best Practices: A quick note on version control: we use .gitignore to ignore unnecessary files like local configs or .kube directories. Similarly, .dockerignore ensures we don’t include unnecessary files in our Docker image. These small steps help keep our repo and Docker images clean. Always commit meaningful changes with proper messages so that our CI/CD pipeline runs smoothly.
Commands:
git add .
git commit -m "Initial commit with Docker & Kubernetes setup"
git push origin main

Recap:
Let’s recap the full flow. First, the developer pushes the static app to GitHub. GitHub triggers Jenkins automatically. Jenkins builds the Docker image, pushes it to DockerHub, and deploys it to Kubernetes on AWS EKS. The LoadBalancer exposes the app to the internet so users can access it, and monitoring ensures the app stays healthy. The whole process is automated, consistent, and production-ready. That’s the power of CI/CD, containerization, and Kubernetes working together.
