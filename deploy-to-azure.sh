#!/bin/bash

# KIN241 Node.js App - Deploy to Azure App Service
# Author: Bang Tran

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
ACR_NAME="kin241registry"
IMAGE_NAME="kin241-nodejs-app"
TAG="latest"
FULL_IMAGE_NAME="${ACR_NAME}.azurecr.io/${IMAGE_NAME}:${TAG}"
RESOURCE_GROUP="DxF2002Tenant-staging"
APP_SERVICE_NAME="app-officialhrpoke-kinyu-japaneast-002"

echo -e "${BLUE}🚀 KIN241 Node.js App - Deploy to Azure Script${NC}"
echo -e "${BLUE}================================================${NC}"

# Check if Azure CLI is logged in
if ! az account show > /dev/null 2>&1; then
    echo -e "${RED}❌ Azure CLI is not logged in. Please run 'az login' first.${NC}"
    exit 1
fi

echo -e "${YELLOW}📋 Configuration:${NC}"
echo -e "   ACR Name: ${ACR_NAME}"
echo -e "   Image Name: ${IMAGE_NAME}"
echo -e "   Tag: ${TAG}"
echo -e "   Full Image: ${FULL_IMAGE_NAME}"
echo -e "   Resource Group: ${RESOURCE_GROUP}"
echo -e "   App Service: ${APP_SERVICE_NAME}"
echo ""

# Check if App Service exists
echo -e "${YELLOW}🔍 Checking if App Service exists...${NC}"
if ! az webapp show --name ${APP_SERVICE_NAME} --resource-group ${RESOURCE_GROUP} > /dev/null 2>&1; then
    echo -e "${RED}❌ App Service '${APP_SERVICE_NAME}' not found in resource group '${RESOURCE_GROUP}'${NC}"
    exit 1
fi
echo -e "${GREEN}✅ App Service found${NC}"

# Get ACR credentials
echo -e "${YELLOW}🔐 Getting ACR credentials...${NC}"
ACR_USERNAME=$(az acr credential show --name ${ACR_NAME} --query "username" -o tsv)
ACR_PASSWORD=$(az acr credential show --name ${ACR_NAME} --query "passwords[0].value" -o tsv)
echo -e "${GREEN}✅ ACR credentials retrieved${NC}"

# Update App Service container configuration
echo -e "${YELLOW}📱 Updating App Service container configuration...${NC}"
az webapp config container set \
    --name ${APP_SERVICE_NAME} \
    --resource-group ${RESOURCE_GROUP} \
    --docker-custom-image-name ${FULL_IMAGE_NAME} \
    --docker-registry-server-url https://${ACR_NAME}.azurecr.io \
    --docker-registry-server-user ${ACR_USERNAME} \
    --docker-registry-server-password ${ACR_PASSWORD}

echo -e "${GREEN}✅ Container configuration updated${NC}"

# Update App Service app settings
echo -e "${YELLOW}⚙️  Updating App Service app settings...${NC}"
az webapp config appsettings set \
    --name ${APP_SERVICE_NAME} \
    --resource-group ${RESOURCE_GROUP} \
    --settings \
    WEBSITES_PORT=3000 \
    NODE_ENV=production \
    PORT=3000 \
    DOCKER_ENABLE_CI=true \
    WEBSITES_ENABLE_APP_SERVICE_STORAGE=false

echo -e "${GREEN}✅ App settings updated${NC}"

# Restart App Service
echo -e "${YELLOW}🔄 Restarting App Service...${NC}"
az webapp restart --name ${APP_SERVICE_NAME} --resource-group ${RESOURCE_GROUP}
echo -e "${GREEN}✅ App Service restarted${NC}"

# Wait for App Service to be ready
echo -e "${YELLOW}⏳ Waiting for App Service to be ready...${NC}"
sleep 30

# Check App Service status
echo -e "${YELLOW}🔍 Checking App Service status...${NC}"
APP_STATUS=$(az webapp show --name ${APP_SERVICE_NAME} --resource-group ${RESOURCE_GROUP} --query "properties.state" -o tsv)
echo -e "${GREEN}✅ App Service status: ${APP_STATUS}${NC}"

# Get App Service URL
APP_URL=$(az webapp show --name ${APP_SERVICE_NAME} --resource-group ${RESOURCE_GROUP} --query "properties.defaultHostName" -o tsv)
echo -e "${GREEN}🌐 App Service URL: https://${APP_URL}${NC}"

echo ""
echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"
echo -e "${BLUE}📱 Your Node.js app is now running on Azure App Service${NC}"
echo -e "${BLUE}🔗 Health Check: https://${APP_URL}/health${NC}"
echo -e "${BLUE}👋 Hello Endpoint: https://${APP_URL}/hello${NC}"
echo -e "${BLUE}📊 API Info: https://${APP_URL}/api/info${NC}"
echo -e "${BLUE}📈 Status: https://${APP_URL}/api/status${NC}"
