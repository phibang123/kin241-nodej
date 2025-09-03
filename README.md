# KIN241 Node.js Application

A simple Node.js application built with Express.js for deployment to Azure App Service.

## 🚀 Features

- **Express.js** web framework
- **Health check** endpoint (`/health`)
- **Hello** endpoint (`/hello`) - responds with "Hi"
- **API information** endpoint (`/api/info`)
- **Application status** endpoint (`/api/status`)
- **Docker** containerization
- **Azure App Service** deployment ready

## 📋 Prerequisites

- Node.js 18 or later
- npm or yarn
- Docker (for containerization)
- Azure CLI (for deployment)
- Azure Container Registry (ACR)

## 🛠️ Installation

1. **Clone the repository:**
   ```bash
   git clone <your-repo-url>
   cd kin241-nodejs-app
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

## 🧪 Local Development

### Start development server:
```bash
npm run dev
```

### Start production server:
```bash
npm start
```

### Test locally:
```bash
chmod +x test-local.sh
./test-local.sh
```

## 🐳 Docker

### Build Docker image:
```bash
chmod +x build-and-push.sh
./build-and-push.sh
```

### Run Docker container locally:
```bash
npm run docker:run
```

## 🚀 Deployment to Azure

### Deploy to Azure App Service:
```bash
chmod +x deploy-to-azure.sh
./deploy-to-azure.sh
```

## 📱 API Endpoints

| Endpoint | Method | Description | Response |
|----------|--------|-------------|----------|
| `/` | GET | Welcome message | JSON with app info |
| `/health` | GET | Health check | Status OK |
| `/hello` | GET | Hello message | "Hi" response |
| `/api/info` | GET | API information | Endpoints list |
| `/api/status` | GET | Application status | Runtime info |

## 🔧 Configuration

### Environment Variables:
- `PORT`: Server port (default: 3000)
- `NODE_ENV`: Environment (development/production)

### Azure App Service Settings:
- `WEBSITES_PORT`: 3000
- `NODE_ENV`: production
- `DOCKER_ENABLE_CI`: true
- `WEBSITES_ENABLE_APP_SERVICE_STORAGE`: false

## 📊 Health Check

The application includes a health check endpoint at `/health` that returns:
```json
{
  "status": "OK",
  "timestamp": "2025-01-03T09:42:55.110Z",
  "environment": "production",
  "port": 3000
}
```

## 🔒 Security

- **Helmet.js** for security headers
- **CORS** enabled for cross-origin requests
- **Non-root user** in Docker container
- **Input validation** and error handling

## 📁 Project Structure

```
kin241-nodejs-app/
├── server.js              # Main application file
├── package.json           # Dependencies and scripts
├── Dockerfile             # Docker configuration
├── .dockerignore          # Docker ignore file
├── build-and-push.sh     # Build and push to ACR
├── deploy-to-azure.sh    # Deploy to Azure App Service
├── test-local.sh         # Local testing script
└── README.md             # This file
```

## 🚀 Quick Start

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Test locally:**
   ```bash
   ./test-local.sh
   ```

3. **Build and push to ACR:**
   ```bash
   ./build-and-push.sh
   ```

4. **Deploy to Azure:**
   ```bash
   ./deploy-to-azure.sh
   ```

## 🔍 Troubleshooting

### Common Issues:

1. **Port already in use:**
   - Change `PORT` in environment variables
   - Kill existing processes on port 3000

2. **Docker build fails:**
   - Ensure Docker is running
   - Check Dockerfile syntax

3. **Azure deployment fails:**
   - Verify Azure CLI login
   - Check resource group and app service names
   - Ensure ACR exists and is accessible

## 📞 Support

For issues and questions:
- Check the logs in Azure App Service
- Review the deployment scripts
- Contact the development team

## 📄 License

MIT License - see LICENSE file for details.

---

**Built with ❤️ by Bang Tran for KIN241 Infrastructure Construction**
