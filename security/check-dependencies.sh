#!/bin/bash

# Dependency vulnerability checker
# Checks npm and Docker base images for known vulnerabilities

echo "🔍 Checking dependencies for vulnerabilities..."

# Check npm dependencies
echo ""
echo "📦 Scanning npm dependencies..."
cd backend || exit 1

# Run npm audit
npm audit --audit-level=moderate --json > ../security/npm-audit-report.json

if [ $? -ne 0 ]; then
  echo "⚠️  Found vulnerabilities in npm dependencies"
  npm audit --audit-level=moderate
  
  # Show fixable vulnerabilities
  echo ""
  echo "Attempting to fix vulnerabilities..."
  npm audit fix --dry-run
  
  VULN_EXIT=1
else
  echo "✅ No vulnerabilities found in npm dependencies"
  VULN_EXIT=0
fi

cd ..

# Check Docker base images
echo ""
echo "🐳 Checking Docker base images..."

# Extract base images from Dockerfiles
BASE_IMAGES=$(grep -h "FROM" backend/Dockerfile frontend/Dockerfile 2>/dev/null | awk '{print $2}' | sort -u)

echo "Base images found:"
echo "$BASE_IMAGES"

# Return appropriate exit code
if [ $VULN_EXIT -eq 1 ]; then
  echo ""
  echo "❌ Vulnerabilities found. Please review and fix."
  exit 1
else
  echo ""
  echo "✅ Dependency check completed successfully."
  exit 0
fi
