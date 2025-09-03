#!/bin/bash

# KIN241 Node.js App - Complete Deployment Script
# Author: Bang Tran

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 KIN241 Node.js App - Complete Deployment Script${NC}"
echo -e "${BLUE}=================================================${NC}"

# Step 1: Test locally
echo -e "${YELLOW}🧪 Step 1: Testing locally...${NC}"
chmod +x test-local.sh
./test-local.sh

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Local testing passed${NC}"
else
    echo -e "${RED}❌ Local testing failed. Exiting.${NC}"
    exit 1
fi

# Step 2: Build and push Docker image
echo -e "${YELLOW}🔨 Step 2: Building and pushing Docker image...${NC}"
chmod +x build-and-push.sh
./build-and-push.sh

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Docker image built and pushed${NC}"
else
    echo -e "${RED}❌ Docker build/push failed. Exiting.${NC}"
    exit 1
fi

# Step 3: Deploy to Azure App Service
echo -e "${YELLOW}📱 Step 3: Deploying to Azure App Service...${NC}"
chmod +x deploy-to-azure.sh
./deploy-to-azure.sh

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Azure deployment completed${NC}"
else
    echo -e "${RED}❌ Azure deployment failed. Exiting.${NC}"
    exit 1
fi

# Step 4: Update parameters file
echo -e "${YELLOW}📝 Step 4: Updating parameters file...${NC}"
chmod +x update-image.sh
./update-image.sh

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Parameters file updated${NC}"
else
    echo -e "${RED}❌ Parameters file update failed${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Complete deployment finished successfully!${NC}"
echo -e "${BLUE}📱 Your Node.js app is now running on Azure App Service${NC}"
echo -e "${BLUE}🔗 You can access it through Application Gateway and Front Door${NC}"
echo -e "${BLUE}📊 Next step: Deploy the updated infrastructure with Bicep${NC}"
