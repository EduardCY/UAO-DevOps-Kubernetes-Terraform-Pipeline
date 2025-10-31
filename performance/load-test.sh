#!/bin/bash

# Load Testing Script
# Simulates traffic to test application performance

TARGET_URL="${1:-http://localhost:3000}"
DURATION="${2:-60}"
CONCURRENT_USERS="${3:-10}"
REPORT_FILE="performance/load-test-$(date +%Y%m%d-%H%M%S).txt"

echo "🚀 Load Testing Configuration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Target URL: $TARGET_URL"
echo "Duration: ${DURATION}s"
echo "Concurrent Users: $CONCURRENT_USERS"
echo ""

# Check if Apache Bench (ab) is installed
if ! command -v ab &> /dev/null; then
  echo "❌ Apache Bench (ab) not found"
  echo "Install with: sudo apt-get install apache2-utils"
  exit 1
fi

# Health check
echo "🔍 Checking endpoint health..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$TARGET_URL/health" 2>/dev/null)

if [ "$HTTP_CODE" != "200" ]; then
  echo "⚠️  Warning: Health check returned $HTTP_CODE"
  echo "Continuing with load test..."
fi

# Run load test
echo ""
echo "⏱️  Starting load test..."
echo ""

# Calculate total requests (duration * concurrent users)
TOTAL_REQUESTS=$((DURATION * CONCURRENT_USERS))

# Run Apache Bench
ab -n "$TOTAL_REQUESTS" \
   -c "$CONCURRENT_USERS" \
   -g "$REPORT_FILE.tsv" \
   -e "$REPORT_FILE.csv" \
   "$TARGET_URL/" > "$REPORT_FILE" 2>&1

# Parse results
echo ""
echo "📊 Load Test Results"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -f "$REPORT_FILE" ]; then
  # Extract key metrics
  REQUESTS_PER_SEC=$(grep "Requests per second:" "$REPORT_FILE" | awk '{print $4}')
  TIME_PER_REQUEST=$(grep "Time per request:" "$REPORT_FILE" | head -1 | awk '{print $4}')
  TRANSFER_RATE=$(grep "Transfer rate:" "$REPORT_FILE" | awk '{print $3}')
  FAILED_REQUESTS=$(grep "Failed requests:" "$REPORT_FILE" | awk '{print $3}')
  
  echo "✓ Requests per second: $REQUESTS_PER_SEC"
  echo "✓ Time per request: ${TIME_PER_REQUEST}ms"
  echo "✓ Transfer rate: ${TRANSFER_RATE} KB/sec"
  echo "✓ Failed requests: $FAILED_REQUESTS"
  echo ""
  
  # Display percentiles
  echo "Response Time Percentiles:"
  grep -A 5 "Percentage of the requests served" "$REPORT_FILE" | tail -5
  echo ""
  
  echo "📄 Full report saved to: $REPORT_FILE"
  
  # Performance assessment
  if [ "$FAILED_REQUESTS" = "0" ]; then
    echo "✅ Performance: All requests successful"
  else
    echo "⚠️  Performance: $FAILED_REQUESTS requests failed"
  fi
  
  # Throughput assessment
  if (( $(echo "$REQUESTS_PER_SEC > 100" | bc -l) )); then
    echo "✅ Throughput: Excellent (>100 req/s)"
  elif (( $(echo "$REQUESTS_PER_SEC > 50" | bc -l) )); then
    echo "⚠️  Throughput: Good (50-100 req/s)"
  else
    echo "❌ Throughput: Needs improvement (<50 req/s)"
  fi
else
  echo "❌ Load test failed - check configuration"
  exit 1
fi

exit 0
