#!/bin/bash

# Security Report Generator
# Consolidates all security scan results into a single report

REPORT_DIR="security/reports"
REPORT_FILE="$REPORT_DIR/security-report-$(date +%Y%m%d-%H%M%S).md"

# Create reports directory
mkdir -p "$REPORT_DIR"

echo "📊 Generating security report..."

# Start report
cat > "$REPORT_FILE" << 'EOF'
# Security Scan Report

**Generated:** $(date '+%Y-%m-%d %H:%M:%S')

## Summary

| Category | Status | Details |
|----------|--------|---------|
EOF

# Initialize counters
CRITICAL_COUNT=0
HIGH_COUNT=0
MEDIUM_COUNT=0
LOW_COUNT=0

# Check if npm audit reports exist
if [ -f "security/npm-audit-report.json" ]; then
  echo "Analyzing npm audit results..."
  
  # Parse npm audit JSON (requires jq, fallback to basic check)
  if command -v jq &> /dev/null; then
    CRITICAL_COUNT=$(jq '.metadata.vulnerabilities.critical // 0' security/npm-audit-report.json)
    HIGH_COUNT=$(jq '.metadata.vulnerabilities.high // 0' security/npm-audit-report.json)
    MEDIUM_COUNT=$(jq '.metadata.vulnerabilities.moderate // 0' security/npm-audit-report.json)
    LOW_COUNT=$(jq '.metadata.vulnerabilities.low // 0' security/npm-audit-report.json)
    
    echo "| npm audit | $([ $CRITICAL_COUNT -eq 0 ] && echo "✅ Pass" || echo "❌ Fail") | Critical: $CRITICAL_COUNT, High: $HIGH_COUNT, Medium: $MEDIUM_COUNT, Low: $LOW_COUNT |" >> "$REPORT_FILE"
  else
    echo "| npm audit | ⚠️ Check manually | jq not installed |" >> "$REPORT_FILE"
  fi
else
  echo "| npm audit | ⚠️ Not run | Report not found |" >> "$REPORT_FILE"
fi

# Add sections for other scans
cat >> "$REPORT_FILE" << 'EOF'

## Vulnerability Details

### Critical Issues
EOF

if [ $CRITICAL_COUNT -gt 0 ]; then
  echo "Found $CRITICAL_COUNT critical vulnerabilities" >> "$REPORT_FILE"
  echo "" >> "$REPORT_FILE"
  echo "**Action required:** Fix immediately before deployment" >> "$REPORT_FILE"
else
  echo "No critical vulnerabilities found ✅" >> "$REPORT_FILE"
fi

cat >> "$REPORT_FILE" << 'EOF'

### High Priority Issues
EOF

if [ $HIGH_COUNT -gt 0 ]; then
  echo "Found $HIGH_COUNT high priority vulnerabilities" >> "$REPORT_FILE"
  echo "" >> "$REPORT_FILE"
  echo "**Action required:** Fix within 48 hours" >> "$REPORT_FILE"
else
  echo "No high priority vulnerabilities found ✅" >> "$REPORT_FILE"
fi

cat >> "$REPORT_FILE" << 'EOF'

## Recommendations

1. **Immediate Actions:**
   - Review and fix critical vulnerabilities
   - Update vulnerable dependencies
   - Check for security patches

2. **Short-term Actions:**
   - Address high priority issues
   - Review security configurations
   - Update security documentation

3. **Long-term Actions:**
   - Implement automated security updates
   - Schedule regular security audits
   - Enhance monitoring and alerting

## Remediation Steps

```bash
# Fix npm vulnerabilities
cd backend
npm audit fix

# Force fix (may include breaking changes)
npm audit fix --force

# Update specific packages
npm update <package-name>
```

## Security Best Practices

- [ ] All secrets stored in environment variables
- [ ] Dependencies regularly updated
- [ ] Security scanning in CI/CD pipeline
- [ ] HTTPS enabled in production
- [ ] Database connections encrypted
- [ ] API rate limiting configured
- [ ] Security headers implemented
- [ ] Monitoring and alerting active

## Additional Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Node.js Security Best Practices](https://nodejs.org/en/docs/guides/security/)
- [npm audit documentation](https://docs.npmjs.com/cli/v8/commands/npm-audit)
- [Docker Security Best Practices](https://docs.docker.com/develop/security-best-practices/)

---

**Next scan scheduled:** Weekly (Monday 8:00 AM UTC)
EOF

echo "✅ Security report generated: $REPORT_FILE"
echo ""
echo "Report summary:"
echo "  Critical: $CRITICAL_COUNT"
echo "  High: $HIGH_COUNT"
echo "  Medium: $MEDIUM_COUNT"
echo "  Low: $LOW_COUNT"

# Return appropriate exit code
if [ $CRITICAL_COUNT -gt 0 ]; then
  echo ""
  echo "❌ Critical vulnerabilities found - immediate action required"
  exit 1
elif [ $HIGH_COUNT -gt 0 ]; then
  echo ""
  echo "⚠️  High priority vulnerabilities found - fix within 48 hours"
  exit 0
else
  echo ""
  echo "✅ No critical or high priority vulnerabilities"
  exit 0
fi
