const express = require('express');
const cors = require('cors');
const helmet = require('helmet');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'OK',
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development',
    port: PORT
  });
});

// Hello endpoint
app.get('/hello', (req, res) => {
  res.json({
    message: 'Hi',
    timestamp: new Date().toISOString(),
    endpoint: '/hello'
  });
});

// API info endpoint
app.get('/api/info', (req, res) => {
  res.json({
    name: 'KIN241 Node.js API',
    version: '1.0.0',
    description: 'Simple Node.js application for Azure App Service',
    endpoints: [
      'GET /health - Health check',
      'GET /hello - Hello message',
      'GET /api/info - API information',
      'GET /api/status - Application status'
    ]
  });
});

// Status endpoint
app.get('/api/status', (req, res) => {
  res.json({
    status: 'running',
    uptime: process.uptime(),
    memory: process.memoryUsage(),
    platform: process.platform,
    nodeVersion: process.version
  });
});

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    message: 'Welcome to KIN241 Node.js Application',
    version: '1.0.0',
    endpoints: [
      '/health',
      '/hello',
      '/api/info',
      '/api/status'
    ]
  });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({
    error: 'Endpoint not found',
    requestedUrl: req.originalUrl,
    availableEndpoints: [
      '/',
      '/health',
      '/hello',
      '/api/info',
      '/api/status'
    ]
  });
});

// Error handler
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(500).json({
    error: 'Internal server error',
    message: err.message
  });
});

// Start server
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 KIN241 Node.js server is running on port ${PORT}`);
  console.log(`📱 Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log(`🌐 Health check: http://localhost:${PORT}/health`);
  console.log(`👋 Hello endpoint: http://localhost:${PORT}/hello`);
});

module.exports = app;
