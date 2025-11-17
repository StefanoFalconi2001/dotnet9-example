# .NET 9 Modular Blazor Application with AWS EKS and Terraform

This project is an example implementation of a .NET 9 Blazor Web App using a modular micro-frontend architecture with Razor Class Libraries, deployed to a Kubernetes cluster on AWS EKS provisioned using Terraform.
The system uses AWS ECR for container images, ALB Ingress for public routing, and OIDC/IRSA for secure authentication between GitHub Actions and AWS.

---

## 1. Project Overview

The solution contains:

- Host → The main .NET 9 Blazor Web App.
- IndexModule → A standalone Razor Class Library acting as a micro-frontend module.
- AWS Infrastructure created using Terraform:
  - VPC
  - IAM Roles and Policies
  - OIDC provider for authentication
  - EKS cluster
  - ECR repositories (backend + frontend)
  - ALB Controller for ingress
- Kubernetes Manifests:
  - namespace.yaml
  - frontend-deployment.yaml
  - frontend-service.yaml
  - backend-deployment.yaml
  - backend-service.yaml
  - ingress.yaml

The frontend communicates with the backend via internal Kubernetes networking, and the frontend is exposed publicly through an AWS Application Load Balancer.

---

## 2. Creating the .NET 9 Modular Blazor Application

### Create solution

dotnet new sln

### Create the Host (main Blazor app)

dotnet new blazor -o Host
dotnet sln add Host

### Create a micro-frontend module using Razor Class Library

dotnet new razorclasslib -o IndexModule
dotnet sln add IndexModule

### Modify IndexModule

Delete:

- Component1.razor
- ExampleJsInterop

Create new component:
IndexModule/Home.razor

@page "/"
<PageTitle>Home</PageTitle>

<h1>Hello, world!</h1>
Welcome to your new app. External Module test

### Add module reference to Host

dotnet add Host/Host.csproj reference ../IndexModule/IndexModule.csproj

### Register module routing (Host)

In App.razor, modify the <Router>:

<Router AppAssembly="typeof(Program).Assembly"
        AdditionalAssemblies="new[] { typeof(IndexModule.Home).Assembly }">

### Register assemblies in Program.cs

app.MapRazorComponents<App>()
.AddInteractiveServerRenderMode()
.AddAdditionalAssemblies(typeof(IndexModule.Home).Assembly);

### Run application

dotnet build
dotnet run --project Host

---

## 3. AWS Infrastructure With Terraform

Terraform provisions the complete AWS environment.

### Resources Created

- VPC (public/private subnets)
- ECR Repositories:
  - frontend repository
  - backend repository
- IAM:
  - IRSA roles for GitHub Actions
  - EKS cluster role
  - Node group roles
- OIDC Provider:
  Enables GitHub Actions authentication without long-term AWS keys.
- EKS Cluster
- ALB Controller installed via Helm
- Permissions for pods to interact with AWS resources

---

## 4. GitHub Actions (Image Build + Push to ECR)

Currently, the workflow:

- Authenticates using OIDC + IRSA
- Builds backend image
- Pushes to ECR
- No Continuous Deployment yet

Example permissions:
contents: read
id-token: write

Build and push:
docker build -t $IMAGE_URI ./src/ApiService
docker push $IMAGE_URI

---

## 5. Kubernetes Structure

All manifests live inside the /k8s folder.

### Contents

- namespace.yaml  
  Creates isolated namespace for the project.

- frontend-deployment.yaml  
  Deploys the Blazor Host app image from ECR.

- frontend-service.yaml  
  Exposes frontend internally for ALB.

- backend-deployment.yaml  
  Deploys backend API container.

- backend-service.yaml  
  ClusterIP service consumed by frontend.

- ingress.yaml  
  Exposes the frontend publicly using AWS ALB.

### Communication Flow

Frontend → backend-service → Backend Pod  
Public traffic → ALB → Ingress → Frontend Pod

---

## 6. System Architecture (High-Level)

GitHub Actions (OIDC → IRSA → AWS temporary auth)
|
Push images to ECR
|
EKS Cluster
|
Kubernetes Namespace
├─ Frontend Deployment + Service
├─ Backend Deployment + Service
└─ Ingress (AWS ALB)
|
AWS ALB
|
Users

---

## 7. CI/CD Status

- CI (build + push) → Implemented
- CD (deploy to EKS) → Not implemented yet
  Future options: GitHub Actions deploy step, ArgoCD, FluxCD

---

## 8. Summary

This project demonstrates:

✓ Modular .NET 9 Blazor with Razor Class Library micro-frontends  
✓ AWS Infrastructure fully defined with Terraform  
✓ EKS cluster hosting the application  
✓ Secure authentication using OIDC + IRSA  
✓ Kubernetes deployment with ALB ingress  
✓ GitHub Actions pushing images to ECR

Continuous Deployment is not active yet — only image build and push.

---

END OF README
