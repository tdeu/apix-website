#!/bin/bash

# APIX AI - Hackathon Website Deployment Script
# Automates deployment to various hosting platforms

echo "🚀 APIX AI - Hackathon Website Deployment"
echo "========================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to display menu
show_menu() {
    echo -e "${BLUE}Choose deployment option:${NC}"
    echo "1. 🌐 Deploy to GitHub Pages"
    echo "2. 🔥 Deploy to Netlify"
    echo "3. ⚡ Deploy to Vercel"
    echo "4. 🖥️  Start local development server"
    echo "5. 📦 Create deployment package"
    echo "6. ✅ Validate website files"
    echo "7. 🔧 Setup project for development"
    echo "8. ❌ Exit"
    echo ""
}

# Function to check if git is initialized
check_git() {
    if [ ! -d ".git" ]; then
        echo -e "${YELLOW}Git repository not initialized. Initializing...${NC}"
        git init
        git add .
        git commit -m "Initial commit: APIX AI hackathon website"
        echo -e "${GREEN}✅ Git repository initialized${NC}"
    else
        echo -e "${GREEN}✅ Git repository exists${NC}"
    fi
}

# Deploy to GitHub Pages
deploy_github_pages() {
    echo -e "${BLUE}🌐 Deploying to GitHub Pages...${NC}"
    
    check_git
    
    echo ""
    echo "To complete GitHub Pages deployment:"
    echo "1. Create a new repository on GitHub"
    echo "2. Add remote origin:"
    echo "   git remote add origin https://github.com/USERNAME/REPO-NAME.git"
    echo "3. Push to GitHub:"
    echo "   git branch -M main"
    echo "   git push -u origin main"
    echo "4. Enable GitHub Pages in repository settings"
    echo "5. Your site will be live at: https://USERNAME.github.io/REPO-NAME"
    echo ""
    
    read -p "Do you want to add a remote origin now? (y/n): " add_remote
    if [ "$add_remote" = "y" ] || [ "$add_remote" = "Y" ]; then
        read -p "Enter GitHub repository URL: " repo_url
        git remote add origin "$repo_url"
        echo -e "${GREEN}✅ Remote origin added${NC}"
        
        read -p "Push to GitHub now? (y/n): " push_now
        if [ "$push_now" = "y" ] || [ "$push_now" = "Y" ]; then
            git branch -M main
            git add .
            git commit -m "Deploy APIX AI hackathon website"
            git push -u origin main
            echo -e "${GREEN}✅ Pushed to GitHub! Enable Pages in repository settings.${NC}"
        fi
    fi
}

# Deploy to Netlify
deploy_netlify() {
    echo -e "${BLUE}🔥 Deploying to Netlify...${NC}"
    
    if ! command -v netlify &> /dev/null; then
        echo -e "${YELLOW}Netlify CLI not found. Installing...${NC}"
        npm install -g netlify-cli
    fi
    
    echo "Logging into Netlify..."
    netlify login
    
    echo "Deploying site..."
    netlify deploy --prod --dir .
    
    echo -e "${GREEN}✅ Deployed to Netlify!${NC}"
}

# Deploy to Vercel
deploy_vercel() {
    echo -e "${BLUE}⚡ Deploying to Vercel...${NC}"
    
    if ! command -v vercel &> /dev/null; then
        echo -e "${YELLOW}Vercel CLI not found. Installing...${NC}"
        npm install -g vercel
    fi
    
    echo "Deploying to Vercel..."
    vercel --prod
    
    echo -e "${GREEN}✅ Deployed to Vercel!${NC}"
}

# Start local development server
start_local_server() {
    echo -e "${BLUE}🖥️  Starting local development server...${NC}"
    
    # Check which tools are available
    if command -v python3 &> /dev/null; then
        echo "Starting Python HTTP server on http://localhost:8000"
        python3 -m http.server 8000
    elif command -v python &> /dev/null; then
        echo "Starting Python HTTP server on http://localhost:8000"
        python -m http.server 8000
    elif command -v node &> /dev/null; then
        if command -v npx &> /dev/null; then
            echo "Starting Node.js server on http://localhost:3000"
            npx serve . -p 3000
        else
            echo "Installing serve package..."
            npm install -g serve
            serve . -p 3000
        fi
    elif command -v php &> /dev/null; then
        echo "Starting PHP server on http://localhost:8000"
        php -S localhost:8000
    else
        echo -e "${RED}❌ No suitable server found. Please install Python, Node.js, or PHP${NC}"
        echo "Or simply open index.html in your web browser"
    fi
}

# Create deployment package
create_package() {
    echo -e "${BLUE}📦 Creating deployment package...${NC}"
    
    # Create timestamp for unique filename
    timestamp=$(date +"%Y%m%d_%H%M%S")
    package_name="apix-ai-website_${timestamp}.zip"
    
    # Create zip package excluding unnecessary files
    zip -r "$package_name" . -x "*.git*" "*.DS_Store" "deploy.sh" "node_modules/*" "*.log"
    
    echo -e "${GREEN}✅ Package created: $package_name${NC}"
    echo "Upload this file to any web hosting service"
}

# Validate website files
validate_files() {
    echo -e "${BLUE}✅ Validating website files...${NC}"
    echo ""
    
    # Check required files
    required_files=("index.html" "styles.css" "script.js")
    all_good=true
    
    for file in "${required_files[@]}"; do
        if [ -f "$file" ]; then
            echo -e "${GREEN}✅ $file exists${NC}"
        else
            echo -e "${RED}❌ $file missing${NC}"
            all_good=false
        fi
    done
    
    echo ""
    
    # Check HTML syntax (basic)
    if command -v htmlhint &> /dev/null; then
        echo "Checking HTML syntax..."
        htmlhint index.html
    else
        echo "Install htmlhint for HTML validation: npm install -g htmlhint"
    fi
    
    # Check CSS syntax (basic)
    if [ -f "styles.css" ]; then
        echo "Checking CSS file size..."
        css_size=$(wc -c < styles.css)
        echo "CSS file size: $css_size bytes"
        
        if [ $css_size -gt 100000 ]; then
            echo -e "${YELLOW}⚠️  CSS file is quite large. Consider optimization.${NC}"
        else
            echo -e "${GREEN}✅ CSS file size is good${NC}"
        fi
    fi
    
    # Check for common issues
    echo ""
    echo "Checking for common issues..."
    
    if grep -q "localhost" index.html; then
        echo -e "${YELLOW}⚠️  Found localhost references in HTML${NC}"
    fi
    
    if grep -q "127.0.0.1" index.html; then
        echo -e "${YELLOW}⚠️  Found 127.0.0.1 references in HTML${NC}"
    fi
    
    if [ "$all_good" = true ]; then
        echo -e "${GREEN}✅ All validations passed!${NC}"
    else
        echo -e "${RED}❌ Some files are missing. Please check the setup.${NC}"
    fi
}

# Setup project for development
setup_development() {
    echo -e "${BLUE}🔧 Setting up project for development...${NC}"
    
    # Create package.json if it doesn't exist
    if [ ! -f "package.json" ]; then
        echo "Creating package.json..."
        cat > package.json << EOF
{
  "name": "apix-ai-hackathon-website",
  "version": "1.0.0",
  "description": "APIX AI hackathon website for Hedera Africa Hackathon 2025",
  "main": "index.html",
  "scripts": {
    "start": "serve . -p 3000",
    "dev": "serve . -p 3000 --live",
    "build": "echo 'No build process needed for static site'",
    "deploy:netlify": "netlify deploy --prod --dir .",
    "deploy:vercel": "vercel --prod",
    "validate": "htmlhint index.html && echo 'Validation complete'"
  },
  "keywords": ["hackathon", "hedera", "ai", "blockchain", "website"],
  "author": "APIX AI Team",
  "license": "MIT",
  "devDependencies": {
    "serve": "^14.0.0",
    "htmlhint": "^1.1.4"
  }
}
EOF
        echo -e "${GREEN}✅ package.json created${NC}"
    fi
    
    # Install development dependencies
    if command -v npm &> /dev/null; then
        echo "Installing development dependencies..."
        npm install
        echo -e "${GREEN}✅ Dependencies installed${NC}"
    else
        echo -e "${YELLOW}⚠️  npm not found. Install Node.js for full development setup${NC}"
    fi
    
    # Create .gitignore if it doesn't exist
    if [ ! -f ".gitignore" ]; then
        echo "Creating .gitignore..."
        cat > .gitignore << EOF
# Dependencies
node_modules/
npm-debug.log*

# Build outputs
dist/
build/

# Environment
.env
.env.local

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
*.log

# Deployment packages
*.zip
*.tar.gz
EOF
        echo -e "${GREEN}✅ .gitignore created${NC}"
    fi
    
    check_git
    
    echo -e "${GREEN}✅ Development setup complete!${NC}"
    echo ""
    echo "Available commands:"
    echo "  npm start     - Start development server"
    echo "  npm run dev   - Start server with live reload"
    echo "  npm run validate - Validate HTML/CSS"
    echo "  ./deploy.sh   - Run this deployment script"
}

# Main menu loop
while true; do
    show_menu
    read -p "Enter your choice (1-8): " choice
    echo ""
    
    case $choice in
        1) deploy_github_pages ;;
        2) deploy_netlify ;;
        3) deploy_vercel ;;
        4) start_local_server ;;
        5) create_package ;;
        6) validate_files ;;
        7) setup_development ;;
        8) 
            echo -e "${GREEN}🎉 Good luck with your hackathon submission!${NC}"
            echo "🏆 May APIX AI win Track 4: AI & DePIN!"
            exit 0 
            ;;
        *)
            echo -e "${RED}❌ Invalid option. Please choose 1-8.${NC}"
            echo ""
            ;;
    esac
    
    echo ""
    echo "Press any key to continue..."
    read -n 1
    echo ""
    echo ""
done