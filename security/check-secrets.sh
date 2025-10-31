#!/bin/bash

# Custom script to check for hard-coded secrets in source code
# Prevents sensitive data from being committed to the repository

echo "🔍 Scanning for hard-coded secrets..."

# Patterns to search for
PATTERNS=(
  "API_KEY"
  "SECRET_KEY"
  "PASSWORD"
  "PRIVATE_KEY"
  "AWS_SECRET"
  "DATABASE_URL"
  "JWT_SECRET"
  "POSTGRES_PASSWORD"
  "access_token"
  "client_secret"
)

# Directories to exclude
EXCLUDE_DIRS="node_modules|.git|.env.example|README.md|security"

# Initialize error flag
FOUND_SECRETS=0

# Check each pattern
for pattern in "${PATTERNS[@]}"; do
  echo "Checking for: $pattern"
  
  # Search in source files (excluding node_modules, .git, etc.)
  results=$(grep -r --exclude-dir={node_modules,.git} \
    --include="*.js" \
    --include="*.jsx" \
    --include="*.ts" \
    --include="*.tsx" \
    --include="*.json" \
    --include="*.yaml" \
    --include="*.yml" \
    -i "$pattern" . | grep -v ".env.example" | grep -v "README.md" | grep -v "security/")
  
  if [ ! -z "$results" ]; then
    echo "⚠️  Found potential hard-coded $pattern:"
    echo "$results"
    FOUND_SECRETS=1
  fi
done

# Check for exposed .env files
if [ -f ".env" ]; then
  echo "⚠️  Warning: .env file found in repository root"
  echo "   Make sure .env is in .gitignore"
fi

# Final result
if [ $FOUND_SECRETS -eq 1 ]; then
  echo ""
  echo "❌ Security issue: Found hard-coded secrets or sensitive data."
  echo "   Please use environment variables instead."
  exit 1
else
  echo ""
  echo "✅ No hard-coded secrets found."
  exit 0
fi
