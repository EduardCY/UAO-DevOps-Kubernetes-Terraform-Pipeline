# Output values from Terraform deployment
# These values are useful for CI/CD pipelines and manual verification

output "backend_url" {
  description = "Public URL of the backend API service"
  value       = "https://${render_web_service.backend.service_url}"
}

output "frontend_url" {
  description = "Public URL of the frontend application"
  value       = "https://${render_web_service.frontend.service_url}"
}

output "backend_service_id" {
  description = "Render service ID for backend (useful for API calls)"
  value       = render_web_service.backend.id
}

output "frontend_service_id" {
  description = "Render service ID for frontend (useful for API calls)"
  value       = render_web_service.frontend.id
}

output "deployment_region" {
  description = "Region where services are deployed"
  value       = render_web_service.backend.region
}

output "environment" {
  description = "Current deployment environment"
  value       = var.environment
}
