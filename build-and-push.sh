#!/bin/bash

# KIN241 Node.js App - Build and Push to Azure Container Registry
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

echo -e "${BLUE}🚀 KIN241 Node.js App - Build and Push Script${NC}"
echo -e "${BLUE}===============================================${NC}"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker is not running. Please start Docker and try again.${NC}"
    exit 1
fi

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
echo ""

# Login to Azure Container Registry
echo -e "${YELLOW}🔐 Logging in to Azure Container Registry...${NC}"
az acr login --name ${ACR_NAME}
echo -e "${GREEN}✅ Successfully logged in to ACR${NC}"

# Build Docker image
echo -e "${YELLOW}🔨 Building Docker image...${NC}"
docker build -t ${IMAGE_NAME}:${TAG} .
echo -e "${GREEN}✅ Docker image built successfully${NC}"

# Tag image for ACR
echo -e "${YELLOW}🏷️  Tagging image for ACR...${NC}"
docker tag ${IMAGE_NAME}:${TAG} ${FULL_IMAGE_NAME}
echo -e "${GREEN}✅ Image tagged successfully${NC}"

# Push image to ACR
echo -e "${YELLOW}📤 Pushing image to Azure Container Registry...${NC}"
docker push ${FULL_IMAGE_NAME}
echo -e "${GREEN}✅ Image pushed successfully to ACR${NC}"

# Verify image in ACR
echo -e "${YELLOW}🔍 Verifying image in ACR...${NC}"
az acr repository show --name ${ACR_NAME} --image ${IMAGE_NAME}:${TAG}
echo -e "${GREEN}✅ Image verified in ACR${NC}"

echo ""
echo -e "${GREEN}🎉 Success! Your Node.js app has been built and pushed to ACR.${NC}"
echo -e "${BLUE}📱 You can now deploy it to Azure App Service using:${NC}"
echo -e "   Image: ${FULL_IMAGE_NAME}"
echo -e "   Port: 3000"
echo -e "   Health Check: /health"
echo -e "   Hello Endpoint: /hello"
