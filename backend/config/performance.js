// Performance Configuration for Production
// Optimizations for Node.js backend

module.exports = {
  // Cluster mode for multi-core utilization
  cluster: {
    enabled: process.env.CLUSTER_MODE === 'true',
    workers: process.env.CLUSTER_WORKERS || 'auto', // 'auto' uses all CPU cores
  },

  // Connection pooling
  database: {
    pool: {
      min: parseInt(process.env.DB_POOL_MIN) || 2,
      max: parseInt(process.env.DB_POOL_MAX) || 10,
      acquireTimeoutMillis: 30000,
      idleTimeoutMillis: 30000,
    },
  },

  // Caching configuration
  cache: {
    enabled: process.env.CACHE_ENABLED !== 'false',
    ttl: parseInt(process.env.CACHE_TTL) || 300, // 5 minutes default
    checkPeriod: 60, // Check expired keys every 60 seconds
  },

  // Rate limiting
  rateLimit: {
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: process.env.RATE_LIMIT_MAX || 100, // Limit each IP to 100 requests per windowMs
    standardHeaders: true,
    legacyHeaders: false,
  },

  // Compression
  compression: {
    enabled: true,
    level: 6, // Compression level (0-9)
    threshold: 1024, // Only compress responses > 1KB
  },

  // Keep-alive settings
  keepAlive: {
    enabled: true,
    timeout: 65000, // 65 seconds
    maxConnections: 100,
  },

  // Monitoring
  metrics: {
    enabled: process.env.METRICS_ENABLED !== 'false',
    path: '/metrics',
    collectDefaultMetrics: true,
  },

  // Performance thresholds
  thresholds: {
    responseTime: {
      warning: 1000, // 1 second
      critical: 3000, // 3 seconds
    },
    memoryUsage: {
      warning: 200 * 1024 * 1024, // 200MB
      critical: 400 * 1024 * 1024, // 400MB
    },
    cpuUsage: {
      warning: 70, // 70%
      critical: 90, // 90%
    },
  },
};
