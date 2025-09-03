#!/bin/bash

# KIN241 Node.js App - Update Image and Parameters
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
PARAMETERS_FILE="../environments/staging/main.parameters.json"

echo -e "${BLUE}🚀 KIN241 Node.js App - Update Image and Parameters${NC}"
echo -e "${BLUE}===================================================${NC}"

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
echo -e "   Parameters File: ${PARAMETERS_FILE}"
echo ""

# Build and push Docker image
echo -e "${YELLOW}🔨 Building and pushing Docker image...${NC}"
chmod +x build-and-push.sh
./build-and-push.sh

# Update parameters file with new image
echo -e "${YELLOW}📝 Updating parameters file...${NC}"
if [ -f "$PARAMETERS_FILE" ]; then
    # Create backup
    cp "$PARAMETERS_FILE" "${PARAMETERS_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${GREEN}✅ Backup created${NC}"
    
    # Update image in parameters file
    sed -i.bak "s|DOCKER|kin241registry.azurecr.io/kin241-nextjs-app:latest|DOCKER|kin241registry.azurecr.io/kin241-nodejs-app:latest|g" "$PARAMETERS_FILE"
    
    # Remove backup file
    rm -f "${PARAMETERS_FILE}.bak"
    
    echo -e "${GREEN}✅ Parameters file updated with new image${NC}"
else
    echo -e "${RED}❌ Parameters file not found: ${PARAMETERS_FILE}${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}🎉 Image update completed successfully!${NC}"
echo -e "${BLUE}📱 New image: ${FULL_IMAGE_NAME}${NC}"
echo -e "${BLUE}📝 Parameters file updated${NC}"
echo -e "${BLUE}🚀 You can now deploy the updated infrastructure${NC}"
