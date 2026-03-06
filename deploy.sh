#!/bin/bash
# Quick deployment script for Zonex Check-In System to Cloudflare Pages

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Zonex 2026 Check-In System${NC}"
echo -e "${BLUE}Cloudflare Pages Deployment${NC}"
echo -e "${BLUE}========================================${NC}"

# Get current directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHECKIN_DIR="$SCRIPT_DIR"

echo -e "\n${YELLOW}Step 1: Verify checkin folder contents${NC}"
if [ ! -f "$CHECKIN_DIR/index.html" ]; then
    echo -e "${RED}Error: index.html not found in checkin folder${NC}"
    exit 1
fi

echo -e "${GREEN}✓ index.html found${NC}"

if [ -d "$CHECKIN_DIR/node_modules" ]; then
    echo -e "${YELLOW}Removing node_modules...${NC}"
    rm -rf "$CHECKIN_DIR/node_modules"
fi

echo -e "\n${YELLOW}Step 2: Check backend URL configuration${NC}"
BACKEND_URL=$(grep -oP "const BACKEND_URL = '\K[^']*" "$CHECKIN_DIR/index.html")

if [ -z "$BACKEND_URL" ] || [ "$BACKEND_URL" = "https://your-backend-url.com" ]; then
    echo -e "${YELLOW}⚠ Warning: BACKEND_URL not configured${NC}"
    echo -e "${YELLOW}Please update BACKEND_URL in index.html before deploying${NC}"
    echo -e "${YELLOW}Currently set to: ${BACKEND_URL}${NC}"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo -e "${GREEN}✓ BACKEND_URL configured: ${BACKEND_URL}${NC}"
fi

echo -e "\n${YELLOW}Step 3: Files ready for deployment${NC}"
echo -e "${GREEN}✓ Checkin folder is ready to push to Cloudflare Pages${NC}"

echo -e "\n${BLUE}========================================${NC}"
echo -e "${BLUE}Next Steps:${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "1. Push changes to GitHub:"
echo -e "   ${YELLOW}git add .${NC}"
echo -e "   ${YELLOW}git commit -m 'Update check-in system'${NC}"
echo -e "   ${YELLOW}git push${NC}"
echo ""
echo -e "2. Connect to Cloudflare Pages:"
echo -e "   - Go to https://pages.cloudflare.com"
echo -e "   - Click 'Create a project'"
echo -e "   - Select 'Connect to Git'"
echo -e "   - Choose your repository"
echo -e "   - Build output directory: ${YELLOW}checkin${NC}"
echo -e "   - Deploy!"
echo ""
echo -e "3. Update backend CORS:"
echo -e "   - Add your Cloudflare Pages URL to backend CORS origins"
echo -e "   - Example: https://your-project.pages.dev"
echo ""
echo -e "4. Test the system:"
echo -e "   - Access: https://your-project.pages.dev/index.html"
echo -e "   - Scan QR codes or enter Registration IDs"
echo ""
echo -e "${GREEN}For help, see CLOUDFLARE-DEPLOYMENT.md${NC}"
