#!/bin/bash

# KIN241 Node.js App - Local Testing Script
# Author: Bang Tran

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧪 KIN241 Node.js App - Local Testing Script${NC}"
echo -e "${BLUE}=============================================${NC}"

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js is not installed. Please install Node.js 18 or later.${NC}"
    exit 1
fi

# Check Node.js version
NODE_VERSION=$(node --version)
echo -e "${GREEN}✅ Node.js version: ${NODE_VERSION}${NC}"

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm is not installed. Please install npm.${NC}"
    exit 1
fi

# Install dependencies
echo -e "${YELLOW}📦 Installing dependencies...${NC}"
npm install
echo -e "${GREEN}✅ Dependencies installed${NC}"

# Test endpoints
echo -e "${YELLOW}🧪 Testing endpoints...${NC}"

# Start the server in background
echo -e "${BLUE}🚀 Starting server...${NC}"
npm start &
SERVER_PID=$!

# Wait for server to start
sleep 5

# Test health endpoint
echo -e "${YELLOW}🔍 Testing /health endpoint...${NC}"
if curl -s http://localhost:3000/health | grep -q "OK"; then
    echo -e "${GREEN}✅ /health endpoint working${NC}"
else
    echo -e "${RED}❌ /health endpoint failed${NC}"
fi

# Test hello endpoint
echo -e "${YELLOW}👋 Testing /hello endpoint...${NC}"
if curl -s http://localhost:3000/hello | grep -q "Hi"; then
    echo -e "${GREEN}✅ /hello endpoint working${NC}"
else
    echo -e "${RED}❌ /hello endpoint failed${NC}"
fi

# Test root endpoint
echo -e "${YELLOW}🏠 Testing / endpoint...${NC}"
if curl -s http://localhost:3000/ | grep -q "Welcome"; then
    echo -e "${GREEN}✅ / endpoint working${NC}"
else
    echo -e "${RED}❌ / endpoint failed${NC}"
fi

# Test API info endpoint
echo -e "${YELLOW}📊 Testing /api/info endpoint...${NC}"
if curl -s http://localhost:3000/api/info | grep -q "KIN241"; then
    echo -e "${GREEN}✅ /api/info endpoint working${NC}"
else
    echo -e "${RED}❌ /api/info endpoint failed${NC}"
fi

# Stop the server
echo -e "${BLUE}🛑 Stopping server...${NC}"
kill $SERVER_PID
wait $SERVER_PID 2>/dev/null

echo ""
echo -e "${GREEN}🎉 Local testing completed!${NC}"
echo -e "${BLUE}📱 All endpoints are working correctly.${NC}"
echo -e "${BLUE}🚀 You can now build and deploy to Azure.${NC}"
