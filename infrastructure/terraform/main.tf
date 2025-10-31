# Main Terraform configuration for deploying CRUD app to Render
# This file defines the infrastructure resources needed for the application

terraform {
  required_version = ">= 1.0"
  
  # Use Terraform Cloud for remote state management
  cloud {
    organization = "devops-crud-org"
    
    workspaces {
      name = "crud-devops-prod"
    }
  }
  
  required_providers {
    render = {
      source  = "render-oss/render"
      version = "~> 1.0"
    }
  }
}

# Configure the Render provider
provider "render" {
  api_key = var.render_api_key
}

# Backend Web Service
resource "render_web_service" "backend" {
  name               = "crud-backend"
  plan               = "free"
  region             = "oregon"
  runtime            = "docker"
  repo_url           = var.repo_url
  branch             = "main"
  root_directory     = "backend"
  dockerfile_path    = "backend/Dockerfile"
  
  # Environment variables for backend
  env_vars = {
    NODE_ENV     = "production"
    PORT         = "3000"
    DATABASE_URL = var.database_url
  }
  
  # Health check configuration
  health_check_path = "/healthz"
  
  # Auto-deploy on push to main branch
  auto_deploy = true
}

# Frontend Web Service
resource "render_web_service" "frontend" {
  name               = "crud-frontend"
  plan               = "free"
  region             = "oregon"
  runtime            = "docker"
  repo_url           = var.repo_url
  branch             = "main"
  root_directory     = "frontend"
  dockerfile_path    = "frontend/Dockerfile"
  
  # Environment variables for frontend
  env_vars = {
    REACT_APP_API_URL = "https://${render_web_service.backend.service_url}"
  }
  
  # Health check configuration
  health_check_path = "/health"
  
  # Auto-deploy on push to main branch
  auto_deploy = true
  
  # Depends on backend being created first
  depends_on = [render_web_service.backend]
}
