# Input variables for Terraform configuration
# These values should be set in Terraform Cloud workspace or via CLI

variable "render_api_key" {
  description = "API key for Render authentication"
  type        = string
  sensitive   = true
  
  validation {
    condition     = length(var.render_api_key) > 0
    error_message = "Render API key must not be empty."
  }
}

variable "database_url" {
  description = "PostgreSQL connection string from Railway"
  type        = string
  sensitive   = true
  
  validation {
    condition     = can(regex("^postgresql://", var.database_url))
    error_message = "Database URL must be a valid PostgreSQL connection string."
  }
}

variable "repo_url" {
  description = "GitHub repository URL for auto-deployment"
  type        = string
  default     = "https://github.com/LeonarDPeace/Final_DevOps_Proyecto"
  
  validation {
    condition     = can(regex("^https://github.com/", var.repo_url))
    error_message = "Repository URL must be a valid GitHub URL."
  }
}

variable "environment" {
  description = "Deployment environment (production, staging, development)"
  type        = string
  default     = "production"
  
  validation {
    condition     = contains(["production", "staging", "development"], var.environment)
    error_message = "Environment must be production, staging, or development."
  }
}
