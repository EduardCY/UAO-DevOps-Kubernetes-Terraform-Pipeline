#!/bin/bash

# Performance Benchmarking Script
# Tracks pipeline execution times and generates performance reports

BENCHMARK_DIR="performance/benchmarks"
BENCHMARK_FILE="$BENCHMARK_DIR/benchmark-$(date +%Y%m%d-%H%M%S).json"

mkdir -p "$BENCHMARK_DIR"

echo "⏱️  Starting performance benchmark..."

# Start timer
START_TIME=$(date +%s)

# Benchmark categories
declare -A BENCHMARKS

# Function to benchmark a command
benchmark_command() {
  local name=$1
  local command=$2
  
  echo "Benchmarking: $name"
  local cmd_start=$(date +%s)
  
  eval "$command" > /dev/null 2>&1
  local exit_code=$?
  
  local cmd_end=$(date +%s)
  local duration=$((cmd_end - cmd_start))
  
  BENCHMARKS["$name"]=$duration
  echo "  ✓ Completed in ${duration}s"
  
  return $exit_code
}

# Benchmark: Dependency Installation
echo ""
echo "📦 Benchmarking dependency installation..."
benchmark_command "npm_install_backend" "cd backend && npm ci"
benchmark_command "npm_install_frontend" "cd frontend && npm ci"

# Benchmark: Linting
echo ""
echo "🔍 Benchmarking linting..."
benchmark_command "eslint_backend" "cd backend && npm run lint -- --quiet"
benchmark_command "eslint_frontend" "cd frontend && npm run lint -- --quiet"

# Benchmark: Testing
echo ""
echo "🧪 Benchmarking tests..."
benchmark_command "test_backend" "cd backend && npm test -- --silent"

# Benchmark: Build
echo ""
echo "🏗️  Benchmarking builds..."
benchmark_command "build_frontend" "cd frontend && npm run build"

# Benchmark: Docker Build
echo ""
echo "🐳 Benchmarking Docker builds..."
benchmark_command "docker_build_backend" "docker build -t backend:benchmark ./backend"
benchmark_command "docker_build_frontend" "docker build -t frontend:benchmark ./frontend"

# End timer
END_TIME=$(date +%s)
TOTAL_DURATION=$((END_TIME - START_TIME))

# Generate JSON report
cat > "$BENCHMARK_FILE" << EOF
{
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "total_duration": $TOTAL_DURATION,
  "benchmarks": {
EOF

# Add benchmark results
first=true
for key in "${!BENCHMARKS[@]}"; do
  if [ "$first" = true ]; then
    first=false
  else
    echo "," >> "$BENCHMARK_FILE"
  fi
  echo "    \"$key\": ${BENCHMARKS[$key]}" >> "$BENCHMARK_FILE"
done

cat >> "$BENCHMARK_FILE" << EOF

  },
  "summary": {
    "fastest": "$(echo "${BENCHMARKS[@]}" | tr ' ' '\n' | sort -n | head -1)",
    "slowest": "$(echo "${BENCHMARKS[@]}" | tr ' ' '\n' | sort -n | tail -1)",
    "average": "$(echo "${BENCHMARKS[@]}" | tr ' ' '\n' | awk '{sum+=$1} END {print int(sum/NR)}')"
  }
}
EOF

# Display summary
echo ""
echo "📊 Performance Benchmark Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Total Duration: ${TOTAL_DURATION}s"
echo ""
echo "Individual Benchmarks:"
for key in "${!BENCHMARKS[@]}"; do
  echo "  • $key: ${BENCHMARKS[$key]}s"
done
echo ""
echo "Report saved to: $BENCHMARK_FILE"

# Compare with previous benchmark if exists
PREVIOUS_BENCHMARK=$(ls -t "$BENCHMARK_DIR"/*.json 2>/dev/null | sed -n '2p')
if [ -f "$PREVIOUS_BENCHMARK" ]; then
  echo ""
  echo "📈 Comparison with previous run:"
  
  if command -v jq &> /dev/null; then
    PREV_TOTAL=$(jq -r '.total_duration' "$PREVIOUS_BENCHMARK")
    DIFF=$((TOTAL_DURATION - PREV_TOTAL))
    
    if [ $DIFF -lt 0 ]; then
      echo "  ✅ Improved by ${DIFF#-}s (faster)"
    elif [ $DIFF -gt 0 ]; then
      echo "  ⚠️  Slower by ${DIFF}s"
    else
      echo "  ➡️  No change"
    fi
  else
    echo "  ℹ️  Install jq for detailed comparison"
  fi
fi

exit 0
