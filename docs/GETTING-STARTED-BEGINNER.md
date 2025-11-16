# Getting Started: Complete Beginner's Guide to Development

**From zero to productive developer: A comprehensive guide for those new to software development**

## Welcome!

This guide is designed for people with low to medium technical backgrounds who want to set up their computer for software development. By the end of this guide, you'll be able to:

✅ Set up a professional development environment
✅ Write and run code in multiple programming languages
✅ Use version control with Git and GitHub
✅ Work with APIs and online tools
✅ Build and run containers
✅ Deploy applications to servers
✅ Collaborate with other developers

**Time Required**: 2-4 hours for complete setup
**Skill Level**: Beginner-friendly (no prior experience required)

---

## Table of Contents

- [Part 1: Understanding the Basics](#part-1-understanding-the-basics)
- [Part 2: Choosing Your Setup Path](#part-2-choosing-your-setup-path)
- [Part 3: Windows Setup](#part-3-windows-setup)
- [Part 4: Linux Setup](#part-4-linux-setup)
- [Part 5: macOS Setup](#part-5-macos-setup)
- [Part 6: Essential Development Tools](#part-6-essential-development-tools)
- [Part 7: Your First Projects](#part-7-your-first-projects)
- [Part 8: Using GitHub](#part-8-using-github)
- [Part 9: Working with APIs](#part-9-working-with-apis)
- [Part 10: Containers and Docker](#part-10-containers-and-docker)
- [Part 11: AI Development Tools](#part-11-ai-development-tools)
- [Part 12: Next Steps](#part-12-next-steps)

---

## Part 1: Understanding the Basics

### What is Software Development?

Software development is the process of creating applications, websites, and programs that run on computers and devices. As a developer, you'll write **code** (instructions for computers) using **programming languages**.

### Key Concepts (Simple Explanations)

**Programming Language**: A language that humans can write and computers can understand. Examples:
- **Python**: Great for beginners, AI, data science
- **JavaScript**: Powers websites and web applications
- **Rust**: Fast and safe for system programming
- **Go**: Simple and efficient for servers

**Code Editor / IDE**: A special text editor for writing code. Think of it like Microsoft Word, but for programmers. Popular options:
- **VS Code** (Visual Studio Code): Free, most popular, works everywhere
- **Cursor**: VS Code with AI assistance built-in
- **PyCharm**: Specialized for Python

**Terminal / Command Line**: A text-based way to control your computer. Instead of clicking icons, you type commands. Example:
```bash
# Instead of clicking through folders, you type:
cd Documents/Projects
```

**Git**: A system that tracks changes to your code over time. Like "track changes" in Word, but much more powerful.

**GitHub**: A website where developers store and share code. Think of it like Google Drive or Dropbox, but specifically for code.

**API (Application Programming Interface)**: A way for different programs to talk to each other. Example: A weather app uses a weather API to get current temperature data.

**Container**: A package that includes your application and everything it needs to run. Like a shipping container, it works the same way everywhere.

**Docker**: The most popular tool for creating and running containers.

**Package Manager**: A tool that installs software for you. Examples:
- **Windows**: Chocolatey, winget
- **macOS**: Homebrew
- **Linux**: apt, yum, dnf

### What You'll Need

**Hardware** (minimum):
- Computer with 8GB RAM (16GB+ recommended)
- 50GB free disk space (SSD preferred)
- Internet connection

**Software** (we'll install together):
- Code editor (VS Code)
- Programming languages (Python, Node.js, etc.)
- Git
- Terminal emulator
- Docker (optional but recommended)

---

## Part 2: Choosing Your Setup Path

### Which Operating System Are You Using?

**Windows Users**: You have two excellent options:
1. **WSL2** (Windows Subsystem for Linux) - **Recommended**
   - Best of both worlds: Windows for daily use, Linux for development
   - Full access to Windows and Linux tools
   - Better performance for development
   - Follow: [Part 3 - Windows Setup](#part-3-windows-setup)

2. **Native Windows Development**
   - Use Windows tools directly
   - Good for Windows-specific development
   - Simpler if you don't need Linux
   - Follow: [Part 3 - Windows Setup](#part-3-windows-setup) (Native Windows section)

**Linux Users**:
- You're already on the best platform for development!
- Follow: [Part 4 - Linux Setup](#part-4-linux-setup)

**macOS Users**:
- macOS is Unix-based and great for development
- Follow: [Part 5 - macOS Setup](#part-5-macos-setup)

### Understanding the Development Environment

Your "development environment" is all the tools and settings on your computer that help you write code. Think of it like setting up a workshop with the right tools before starting a project.

---

## Part 3: Windows Setup

### Step 1: Check Your Windows Version

1. Press **Windows Key + R**
2. Type `winver` and press Enter
3. Check your version:
   - **Windows 10**: Need version 2004 or newer (Build 19041+)
   - **Windows 11**: Any version works

**If you have an older version**: Update Windows through Settings → Windows Update

### Step 2: Enable Virtualization in BIOS

**Why?** WSL2, Docker, and virtual machines need this feature enabled.

**How to check if it's already enabled:**
1. Press **Ctrl+Shift+Esc** to open Task Manager
2. Go to "Performance" tab
3. Click "CPU"
4. Look for "Virtualization": Should say "Enabled"

**If disabled or not shown:**
1. Restart your computer
2. Press the BIOS key during startup (usually **Del**, **F2**, or **F10**)
   - The screen will show which key to press (look for "Press DEL to enter Setup")
3. Find the virtualization setting (see detailed guide: [BIOS-VIRTUALIZATION-GUIDE.md](BIOS-VIRTUALIZATION-GUIDE.md))
4. Enable it and save

**Don't worry!** The BIOS guide has step-by-step instructions for every major computer brand.

### Step 3A: WSL2 Setup (Recommended)

**What is WSL2?** It lets you run Linux inside Windows, giving you access to both Windows and Linux tools.

**Installation (Simple Method)**:
1. Open PowerShell as Administrator:
   - Press **Windows Key**
   - Type `PowerShell`
   - Right-click "Windows PowerShell"
   - Click "Run as administrator"

2. Type this command and press Enter:
   ```powershell
   wsl --install
   ```

3. Restart your computer when prompted

4. After restart, Ubuntu will open automatically:
   - Create a username (lowercase, no spaces)
   - Create a password (you won't see it while typing - this is normal!)
   - Remember these! You'll need them often.

**Verify it worked:**
```powershell
# In PowerShell
wsl --status
# Should show: Default Version: 2
```

**For detailed optimization**, see: [WSL2-ADVANCED-SETUP.md](WSL2-ADVANCED-SETUP.md)

### Step 3B: Native Windows Setup (Alternative)

**If you prefer Windows-only development:**

1. Install Chocolatey (package manager):
   ```powershell
   # In PowerShell as Administrator
   Set-ExecutionPolicy Bypass -Scope Process -Force
   [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
   iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
   ```

2. Restart PowerShell

3. Install essential tools:
   ```powershell
   choco install git vscode python nodejs make -y
   ```

### Step 4: Install Windows Terminal (Both Paths)

**Windows Terminal** is a modern, powerful terminal for Windows.

```powershell
# Method 1: Microsoft Store (easiest)
# Open Microsoft Store, search "Windows Terminal", click Install

# Method 2: PowerShell
winget install Microsoft.WindowsTerminal
```

**Set as default:**
1. Open Windows Terminal
2. Press **Ctrl + ,** (comma) to open Settings
3. Set "Default profile" to "PowerShell" or "Ubuntu" (if using WSL2)

---

## Part 4: Linux Setup

### Step 1: Identify Your Linux Distribution

```bash
# Check your distribution
cat /etc/os-release
```

Common distributions:
- **Ubuntu** / **Debian**: Use `apt` package manager
- **Fedora** / **Red Hat** / **CentOS**: Use `dnf` package manager
- **Arch Linux**: Use `pacman` package manager

### Step 2: Update Your System

**Ubuntu / Debian:**
```bash
sudo apt update
sudo apt upgrade -y
```

**Fedora / RHEL:**
```bash
sudo dnf update -y
```

**What's `sudo`?** It means "Super User DO" - it runs commands with administrator privileges. You'll be asked for your password.

### Step 3: Install Essential Development Tools

**Ubuntu / Debian:**
```bash
# Build tools
sudo apt install -y build-essential git curl wget

# Python
sudo apt install -y python3 python3-pip python3-venv

# Optional: Set python command to python3
echo "alias python=python3" >> ~/.bashrc
echo "alias pip=pip3" >> ~/.bashrc
source ~/.bashrc
```

**Fedora / RHEL:**
```bash
# Build tools
sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y git curl wget

# Python
sudo dnf install -y python3 python3-pip
```

### Step 4: Install Node.js (using nvm)

**nvm** (Node Version Manager) lets you install and switch between Node.js versions easily.

```bash
# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Reload shell configuration
source ~/.bashrc  # or source ~/.zshrc if using zsh

# Install Node.js LTS (Long Term Support)
nvm install --lts

# Verify installation
node --version
npm --version
```

---

## Part 5: macOS Setup

### Step 1: Install Xcode Command Line Tools

These provide essential development tools for macOS.

```bash
# Install Command Line Tools
xcode-select --install

# Click "Install" when the dialog appears
```

### Step 2: Install Homebrew

**Homebrew** is the package manager for macOS (like an App Store for developers).

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Follow the instructions to add Homebrew to your PATH

# Verify installation
brew --version
```

### Step 3: Install Essential Tools

```bash
# Install Git
brew install git

# Install Python
brew install python

# Install Node.js
brew install node

# Or use nvm for Node.js (recommended):
brew install nvm
# Then follow the instructions to set up nvm
# Install Node.js LTS:
nvm install --lts
```

---

## Part 6: Essential Development Tools

### 1. Git - Version Control

**What does Git do?**
- Tracks changes to your code
- Lets you collaborate with others
- Allows you to "undo" mistakes
- Enables working on features without breaking your main code

**Install Git:**
- **Windows**: Already installed if you followed Part 3
- **Linux**: Already installed if you followed Part 4
- **macOS**: Already installed if you followed Part 5

**Configure Git (Everyone needs to do this):**

Open your terminal and run:
```bash
# Set your name (will appear in your commits)
git config --global user.name "Your Name"

# Set your email (should match your GitHub email)
git config --global user.email "your.email@example.com"

# Set default branch name to 'main'
git config --global init.defaultBranch main

# Make Git use VS Code as default editor (optional)
git config --global core.editor "code --wait"

# Verify your settings
git config --list
```

**Basic Git Commands (You'll use these a lot):**

```bash
# Initialize a new Git repository
git init

# Check status of your files
git status

# Add files to staging (prepare for commit)
git add filename.txt        # Add specific file
git add .                   # Add all files

# Commit (save) your changes
git commit -m "Describe what you changed"

# View commit history
git log

# Create a new branch
git branch feature-name

# Switch to a branch
git checkout feature-name

# Create and switch to new branch (shortcut)
git checkout -b feature-name

# Merge a branch into current branch
git merge feature-name
```

### 2. GitHub Setup

**Create a GitHub Account:**
1. Go to [github.com](https://github.com)
2. Click "Sign up"
3. Follow the registration process
4. Verify your email

**Set Up SSH Keys (Recommended for easy authentication):**

```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your.email@example.com"

# Press Enter to accept default location
# Enter a passphrase (or leave empty for no passphrase)

# Start SSH agent
eval "$(ssh-agent -s)"

# Add your SSH key
ssh-add ~/.ssh/id_ed25519

# Copy your public key to clipboard
# Windows (WSL2):
cat ~/.ssh/id_ed25519.pub | clip.exe

# Linux:
cat ~/.ssh/id_ed25519.pub | xclip -selection clipboard
# (Install xclip first: sudo apt install xclip)

# macOS:
pbcopy < ~/.ssh/id_ed25519.pub

# If above don't work, just display it and copy manually:
cat ~/.ssh/id_ed25519.pub
```

**Add SSH Key to GitHub:**
1. Go to GitHub → Settings (click your profile picture → Settings)
2. Click "SSH and GPG keys" on the left
3. Click "New SSH key"
4. Give it a title (e.g., "My Laptop")
5. Paste your public key
6. Click "Add SSH key"

**Test Connection:**
```bash
ssh -T git@github.com
# Should say: "Hi username! You've successfully authenticated..."
```

### 3. GitHub CLI (Optional but helpful)

**Install:**
```bash
# Windows (PowerShell)
winget install GitHub.cli

# Linux (Ubuntu/Debian)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list
sudo apt update
sudo apt install gh

# macOS
brew install gh
```

**Authenticate:**
```bash
gh auth login
# Follow the prompts
# Choose: GitHub.com → HTTPS or SSH → Login with a web browser
```

### 4. Visual Studio Code (Code Editor)

**Install:**
- **Windows**: Download from [code.visualstudio.com](https://code.visualstudio.com/)
- **Linux**:
  ```bash
  # Ubuntu/Debian
  sudo snap install code --classic

  # Or download .deb from website
  ```
- **macOS**:
  ```bash
  brew install --cask visual-studio-code
  ```

**Essential VS Code Extensions (Install these):**
1. Open VS Code
2. Click Extensions icon (left sidebar, 4 squares)
3. Search and install:
   - **Python** (by Microsoft)
   - **Pylance** (Python language support)
   - **JavaScript and TypeScript** (usually built-in)
   - **ESLint** (JavaScript linter)
   - **Prettier** (Code formatter)
   - **GitLens** (Enhanced Git features)
   - **Docker** (if you'll use Docker)
   - **Remote - WSL** (if using WSL2)
   - **GitHub Copilot** (AI code assistant - requires subscription)
   - **Path Intellisense** (Autocomplete file paths)
   - **Auto Rename Tag** (HTML/XML tag editing)

**Configure VS Code:**
```json
// Press Ctrl+, (comma) to open settings
// Click the "{}" icon to edit settings.json
// Add these settings:

{
  "editor.fontSize": 14,
  "editor.tabSize": 2,
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "files.autoSave": "afterDelay",
  "terminal.integrated.defaultProfile.windows": "Ubuntu (WSL)",  // If using WSL2
  "git.autofetch": true,
  "python.linting.enabled": true,
  "python.linting.pylintEnabled": true,
  "eslint.enable": true
}
```

### 5. Programming Languages

#### Python

**Check if installed:**
```bash
python3 --version
# or
python --version
```

**If not installed:**
- **Windows**: `choco install python` or download from [python.org](https://python.org)
- **Linux**: Usually pre-installed, or `sudo apt install python3`
- **macOS**: `brew install python`

**Install pip packages:**
```bash
# Upgrade pip
python -m pip install --upgrade pip

# Common packages
pip install requests  # HTTP library
pip install flask     # Web framework
pip install django    # Web framework
pip install numpy     # Math/science
pip install pandas    # Data analysis
pip install pytest    # Testing
```

**Create virtual environment (best practice):**
```bash
# Navigate to your project folder
cd ~/projects/myproject

# Create virtual environment
python -m venv venv

# Activate it:
# Windows:
venv\Scripts\activate

# Linux/macOS/WSL:
source venv/bin/activate

# Your prompt will show (venv)

# Install packages in this environment
pip install flask

# Deactivate when done
deactivate
```

#### Node.js & npm

**Install using nvm (recommended):**
```bash
# Install nvm (if not already installed)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Reload shell
source ~/.bashrc  # or ~/.zshrc

# Install Node.js LTS
nvm install --lts

# Verify
node --version
npm --version

# Update npm
npm install -g npm@latest
```

**Common npm packages:**
```bash
# Install globally
npm install -g typescript    # TypeScript compiler
npm install -g nodemon       # Auto-restart on file changes
npm install -g create-react-app  # React app generator
npm install -g @vue/cli      # Vue.js CLI

# In a project (creates package.json):
npm init -y

# Install packages locally
npm install express  # Web framework
npm install axios    # HTTP client
npm install jest     # Testing framework
```

#### Rust (Optional, for system programming)

```bash
# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Reload shell
source ~/.bashrc

# Verify
rustc --version
cargo --version

# Create new project
cargo new hello-rust
cd hello-rust

# Run project
cargo run
```

### 6. Docker (For Containers)

**Why Docker?**
- Run applications in isolated environments
- Ensure "it works on my machine" actually works everywhere
- Easy deployment
- Manage complex dependencies

**Install Docker Desktop:**
- **Windows**: Download from [docker.com](https://www.docker.com/products/docker-desktop/)
  - During installation, enable WSL2 backend
- **macOS**: Download from [docker.com](https://www.docker.com/products/docker-desktop/)
- **Linux**: Follow official guide at [docs.docker.com](https://docs.docker.com/engine/install/)

**Verify installation:**
```bash
docker --version
docker compose version

# Test Docker
docker run hello-world
```

**If using WSL2:**
1. Open Docker Desktop
2. Settings → General → "Use WSL 2 based engine" (should be checked)
3. Settings → Resources → WSL Integration
4. Enable for your distribution (Ubuntu)

---

## Part 7: Your First Projects

### Project 1: Hello World (Python)

```bash
# Create project folder
mkdir -p ~/projects/hello-python
cd ~/projects/hello-python

# Create Python file
nano hello.py  # or: code hello.py (if using VS Code)
```

**Add this code (hello.py):**
```python
# This is a comment - Python ignores this line

# Print to console
print("Hello, World!")

# Variables
name = "Your Name"
age = 25

# String formatting
print(f"My name is {name} and I am {age} years old.")

# Function
def greet(person_name):
    return f"Hello, {person_name}!"

# Call function
message = greet("Alice")
print(message)
```

**Run it:**
```bash
python hello.py
```

### Project 2: Hello World (Node.js)

```bash
# Create project folder
mkdir -p ~/projects/hello-nodejs
cd ~/projects/hello-nodejs

# Initialize npm project
npm init -y

# Create JavaScript file
nano hello.js  # or: code hello.js
```

**Add this code (hello.js):**
```javascript
// This is a comment - JavaScript ignores this line

// Print to console
console.log("Hello, World!");

// Variables
const name = "Your Name";
let age = 25;

// Template literals
console.log(`My name is ${name} and I am ${age} years old.`);

// Function
function greet(personName) {
  return `Hello, ${personName}!`;
}

// Call function
const message = greet("Alice");
console.log(message);
```

**Run it:**
```bash
node hello.js
```

### Project 3: Simple Web Server (Python Flask)

```bash
# Create project
mkdir -p ~/projects/flask-app
cd ~/projects/flask-app

# Create virtual environment
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Install Flask
pip install flask

# Create app file
code app.py
```

**Add this code (app.py):**
```python
from flask import Flask, render_template_string

app = Flask(__name__)

# Home page route
@app.route('/')
def home():
    html = """
    <!DOCTYPE html>
    <html>
    <head>
        <title>My First Web App</title>
        <style>
            body { font-family: Arial; max-width: 600px; margin: 50px auto; }
            h1 { color: #333; }
        </style>
    </head>
    <body>
        <h1>Hello from Flask!</h1>
        <p>This is my first web application.</p>
        <a href="/about">About</a>
    </body>
    </html>
    """
    return render_template_string(html)

# About page route
@app.route('/about')
def about():
    return "<h1>About Page</h1><p>This is the about page.</p>"

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
```

**Run it:**
```bash
python app.py

# Open browser to: http://localhost:5000
```

### Project 4: Simple Web Server (Node.js Express)

```bash
# Create project
mkdir -p ~/projects/express-app
cd ~/projects/express-app

# Initialize npm
npm init -y

# Install Express
npm install express

# Create app file
code app.js
```

**Add this code (app.js):**
```javascript
const express = require('express');
const app = express();
const port = 3000;

// Home page route
app.get('/', (req, res) => {
  const html = `
    <!DOCTYPE html>
    <html>
    <head>
        <title>My First Node App</title>
        <style>
            body { font-family: Arial; max-width: 600px; margin: 50px auto; }
            h1 { color: #333; }
        </style>
    </head>
    <body>
        <h1>Hello from Express!</h1>
        <p>This is my first Node.js web application.</p>
        <a href="/about">About</a>
    </body>
    </html>
  `;
  res.send(html);
});

// About page route
app.get('/about', (req, res) => {
  res.send('<h1>About Page</h1><p>This is the about page.</p>');
});

// Start server
app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`);
});
```

**Run it:**
```bash
node app.js

# Open browser to: http://localhost:3000
```

---

## Part 8: Using GitHub

### Your First Repository

**Create a new repository on GitHub:**
1. Go to [github.com](https://github.com)
2. Click the "+" icon (top right) → "New repository"
3. Repository name: `hello-world`
4. Description: "My first project"
5. Public or Private: Choose "Public"
6. Check "Add a README file"
7. Click "Create repository"

**Clone repository to your computer:**
```bash
# Using HTTPS:
git clone https://github.com/YOUR-USERNAME/hello-world.git

# Using SSH (if you set up SSH keys):
git clone git@github.com:YOUR-USERNAME/hello-world.git

# Navigate into the repository
cd hello-world
```

### Make Changes and Push

```bash
# Create a new file
echo "# Hello World Project" > README.md
echo "This is my first GitHub project." >> README.md

# Check status
git status

# Add files to staging
git add README.md

# Commit changes
git commit -m "Initial commit: Add README"

# Push to GitHub
git push origin main

# Check on GitHub - you should see your changes!
```

### Working with Branches

**Good practice: Never work directly on main branch**

```bash
# Create and switch to new branch
git checkout -b add-hello-script

# Create a Python script
cat > hello.py << 'EOF'
print("Hello from Python!")
print("This script runs from my GitHub project.")
EOF

# Add and commit
git add hello.py
git commit -m "Add hello.py script"

# Push branch to GitHub
git push -u origin add-hello-script

# Create Pull Request on GitHub:
# 1. Go to your repository on GitHub
# 2. Click "Compare & pull request" button
# 3. Add title and description
# 4. Click "Create pull request"
# 5. Review changes
# 6. Click "Merge pull request"
# 7. Click "Confirm merge"
# 8. Delete branch (optional)

# Update local main branch
git checkout main
git pull origin main
```

### Common Git Workflows

**Before you start work:**
```bash
# Make sure you're on main
git checkout main

# Pull latest changes
git pull origin main

# Create feature branch
git checkout -b feature/new-feature

# Work on your feature...
# ...make changes...

# Add and commit frequently
git add .
git commit -m "Describe your changes"
```

**When done:**
```bash
# Push your branch
git push -u origin feature/new-feature

# Create Pull Request on GitHub
# Ask for code review (if working with others)
# Merge when approved
```

**After merge:**
```bash
# Switch back to main
git checkout main

# Pull latest (includes your merged changes)
git pull origin main

# Delete local feature branch (optional)
git branch -d feature/new-feature
```

---

## Part 9: Working with APIs

### What are APIs?

**API (Application Programming Interface)**: A way for different software to communicate.

**Example**: Weather API
- You ask: "What's the weather in New York?"
- API responds: "Sunny, 75°F"

### Using curl (Command Line)

**Install curl** (usually pre-installed):
```bash
# Test if installed
curl --version

# Install if needed:
# Windows: choco install curl
# Linux: sudo apt install curl
# macOS: brew install curl
```

**Make API requests:**
```bash
# Simple GET request
curl https://api.github.com

# Pretty print JSON
curl https://api.github.com | python -m json.tool

# Save response to file
curl https://api.github.com > github-api.json

# GET request with headers
curl -H "Accept: application/json" https://api.github.com

# POST request (send data)
curl -X POST -H "Content-Type: application/json" \
  -d '{"name":"test"}' \
  https://httpbin.org/post
```

### Using Python with APIs

```python
# Install requests library first: pip install requests

import requests

# GET request
response = requests.get('https://api.github.com')

# Check status code
print(f"Status: {response.status_code}")  # 200 means success

# Get JSON data
data = response.json()
print(data)

# Access specific fields
if 'current_user_url' in data:
    print(f"Current user URL: {data['current_user_url']}")

# GET with parameters
params = {'q': 'python', 'sort': 'stars'}
response = requests.get('https://api.github.com/search/repositories', params=params)
repos = response.json()
print(f"Found {repos['total_count']} repositories")

# POST request
payload = {'name': 'John', 'email': 'john@example.com'}
response = requests.post('https://httpbin.org/post', json=payload)
print(response.json())

# Headers (for authentication)
headers = {'Authorization': 'token YOUR_GITHUB_TOKEN'}
response = requests.get('https://api.github.com/user', headers=headers)
user_data = response.json()
print(user_data)
```

### Using JavaScript with APIs

```javascript
// In Node.js (install axios: npm install axios)
const axios = require('axios');

// GET request
axios.get('https://api.github.com')
  .then(response => {
    console.log('Status:', response.status);
    console.log('Data:', response.data);
  })
  .catch(error => {
    console.error('Error:', error.message);
  });

// With async/await (modern way)
async function fetchData() {
  try {
    const response = await axios.get('https://api.github.com');
    console.log('Status:', response.status);
    console.log('Data:', response.data);
  } catch (error) {
    console.error('Error:', error.message);
  }
}

fetchData();

// POST request
async function postData() {
  const payload = { name: 'John', email: 'john@example.com' };
  const response = await axios.post('https://httpbin.org/post', payload);
  console.log(response.data);
}

postData();
```

### Using Postman (GUI Tool)

**Install Postman:**
- Download from [postman.com](https://www.postman.com/downloads/)
- Or: `choco install postman` (Windows), `brew install --cask postman` (macOS)

**Using Postman:**
1. Open Postman
2. Click "+" to create new request
3. Enter URL: `https://api.github.com`
4. Click "Send"
5. See response in bottom panel
6. Save request for later use

**Benefits of Postman:**
- Visual interface (easier than command line)
- Save and organize requests
- Test APIs before writing code
- Share API collections with team

---

## Part 10: Containers and Docker

### Understanding Containers

**What's a Container?**
- A package with your app and all its dependencies
- Runs the same way on any computer
- Isolated from other apps

**Docker vs Virtual Machine:**
- **VM**: Simulates entire computer (slow, heavy)
- **Container**: Shares host OS kernel (fast, lightweight)

### Docker Basics

**Key Concepts:**
- **Image**: A template (like a class in programming)
- **Container**: A running instance of an image (like an object)
- **Dockerfile**: Instructions to build an image
- **Docker Hub**: Library of pre-made images

**Basic Docker Commands:**
```bash
# Check Docker is running
docker --version

# Pull an image from Docker Hub
docker pull nginx

# List images
docker images

# Run a container
docker run -d -p 8080:80 --name my-nginx nginx
# -d: Run in background
# -p 8080:80: Map port 80 to 8080
# --name: Give it a name

# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# Stop a container
docker stop my-nginx

# Start a stopped container
docker start my-nginx

# Remove a container
docker rm my-nginx

# Remove an image
docker rmi nginx

# View container logs
docker logs my-nginx

# Execute command in running container
docker exec -it my-nginx /bin/bash
# -it: Interactive terminal
# Type 'exit' to leave
```

### Create Your First Dockerfile

**Example: Python Web App**

```bash
# Create project
mkdir -p ~/projects/docker-flask-app
cd ~/projects/docker-flask-app
```

**Create app.py:**
```python
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return "<h1>Hello from Docker!</h1><p>This app runs in a container.</p>"

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
```

**Create requirements.txt:**
```
flask==3.0.0
```

**Create Dockerfile:**
```dockerfile
# Start from Python base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements file
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app.py .

# Expose port
EXPOSE 5000

# Run the application
CMD ["python", "app.py"]
```

**Build and run:**
```bash
# Build image
docker build -t my-flask-app .

# Run container
docker run -d -p 5000:5000 --name flask-container my-flask-app

# Open browser to: http://localhost:5000

# View logs
docker logs flask-container

# Stop and remove
docker stop flask-container
docker rm flask-container
```

### Docker Compose (Multiple Containers)

**What's Docker Compose?**
- Run multi-container applications
- Define services in YAML file
- Start everything with one command

**Example: Web App + Database**

Create `docker-compose.yml`:
```yaml
version: '3.8'

services:
  # Database service
  db:
    image: postgres:15
    environment:
      POSTGRES_USER: myuser
      POSTGRES_PASSWORD: mypassword
      POSTGRES_DB: mydb
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  # Web application service
  web:
    build: .
    ports:
      - "5000:5000"
    depends_on:
      - db
    environment:
      DATABASE_URL: postgresql://myuser:mypassword@db:5432/mydb

volumes:
  postgres_data:
```

**Commands:**
```bash
# Start all services
docker-compose up

# Start in background
docker-compose up -d

# View logs
docker-compose logs

# Stop all services
docker-compose down

# Stop and remove volumes
docker-compose down -v

# Rebuild and start
docker-compose up --build
```

---

## Part 11: AI Development Tools

### GitHub Copilot (AI Code Assistant)

**What is it?**
- AI that suggests code as you type
- Like autocomplete, but understands context
- Helps write code faster

**Setup:**
1. Get GitHub Copilot subscription (free for students/open-source)
2. In VS Code, install "GitHub Copilot" extension
3. Sign in with GitHub account
4. Start coding - Copilot will suggest completions

**Tips:**
- Write comments describing what you want, Copilot will suggest code
- Press Tab to accept suggestions
- Press Esc to dismiss

### Claude Code (This Repository's AI)

**Using Claude Code with this template:**
```bash
# Clone this repository
git clone https://github.com/YOUR-USERNAME/universal-project-template.git
cd universal-project-template

# Claude can help you:
# - Review code
# - Find bugs
# - Suggest improvements
# - Explain code

# See AI-AGENT-WORKFLOWS.md for detailed usage
```

### ChatGPT / Claude for Learning

**How to use AI for learning:**
```
Example prompts:

"Explain what a REST API is in simple terms"
"Show me how to create a simple Python function"
"What's the difference between == and === in JavaScript?"
"Debug this code: [paste your code]"
"How do I deploy a Flask app to Heroku?"
```

**⚠️ Important:**
- AI can make mistakes - always verify code
- Don't blindly copy-paste - understand what it does
- Use AI to learn, not replace learning
- Never share sensitive data (passwords, API keys) with AI

---

## Part 12: Next Steps

### Continue Learning

**Programming:**
- [FreeCodeCamp](https://www.freecodecamp.org/) - Interactive coding lessons
- [The Odin Project](https://www.theodinproject.com/) - Full-stack web development
- [Python.org Tutorial](https://docs.python.org/3/tutorial/) - Official Python guide
- [MDN Web Docs](https://developer.mozilla.org/) - Web development reference

**Git & GitHub:**
- [GitHub Skills](https://skills.github.com/) - Interactive tutorials
- [Git Handbook](https://guides.github.com/introduction/git-handbook/)
- [Oh Shit, Git!?!](https://ohshitgit.com/) - Common Git problems and solutions

**Docker:**
- [Docker Get Started](https://docs.docker.com/get-started/)
- [Docker Curriculum](https://docker-curriculum.com/)

**APIs:**
- [Postman Learning Center](https://learning.postman.com/)
- [Public APIs](https://github.com/public-apis/public-apis) - Free APIs to practice with

### Practice Projects

**Beginner:**
1. **Todo App**: Create, read, update, delete tasks
2. **Weather App**: Fetch and display weather data from API
3. **Personal Website**: Portfolio or blog with HTML/CSS/JavaScript
4. **Calculator**: Command-line or web-based calculator

**Intermediate:**
1. **Blog with Database**: Full CRUD application with user authentication
2. **REST API**: Build your own API with Express or Flask
3. **Chat Application**: Real-time chat with WebSockets
4. **Automation Script**: Automate a repetitive task

**Advanced:**
1. **E-commerce Site**: Product catalog, cart, checkout
2. **Social Media Clone**: User profiles, posts, comments, likes
3. **DevOps Pipeline**: CI/CD with GitHub Actions, Docker, deployment
4. **Microservices**: Multiple services communicating via APIs

### Join Communities

**Online Communities:**
- [Stack Overflow](https://stackoverflow.com/) - Q&A for programmers
- [Dev.to](https://dev.to/) - Developer community and blog
- [Reddit r/learnprogramming](https://reddit.com/r/learnprogramming)
- [Discord**: Many programming Discord servers (e.g., The Programmer's Hangout)

**Find a Mentor or Study Group:**
- Local meetups (meetup.com)
- Coding bootcamp communities
- GitHub discussions
- Twitter coding community (#100DaysOfCode)

### Build Your Portfolio

1. **Create GitHub profile README**:
   - Showcase your skills and projects
   - Pin your best repositories

2. **Deploy Projects**:
   - Netlify (static sites)
   - Vercel (Next.js, React, etc.)
   - Heroku (full-stack apps)
   - GitHub Pages (documentation, portfolio)

3. **Write Blog Posts**:
   - Document what you learn
   - Helps solidify knowledge
   - Shows expertise to employers

4. **Contribute to Open Source**:
   - Find "good first issue" labels on GitHub
   - Start with documentation improvements
   - Progress to code contributions

---

## Troubleshooting Common Issues

### Command Not Found

```bash
# Error: command not found

# Solution: Install the tool or check PATH
# Check if it's installed:
which python3
which node
which docker

# If not found, install it (see relevant section above)

# If installed but not found, add to PATH:
# Add to ~/.bashrc or ~/.zshrc:
export PATH="/path/to/tool:$PATH"

# Reload shell:
source ~/.bashrc
```

### Permission Denied

```bash
# Error: Permission denied

# Solution 1: Use sudo (for system operations)
sudo apt install package-name

# Solution 2: Fix file permissions
chmod +x script.sh

# Solution 3: Fix ownership
sudo chown -R $USER:$USER /path/to/directory
```

### Port Already in Use

```bash
# Error: Address already in use

# Solution: Find and kill process using port
# Linux/macOS/WSL:
sudo lsof -i :5000  # Find process on port 5000
kill -9 PID         # Kill process by ID

# Windows:
netstat -ano | findstr :5000  # Find PID
taskkill /PID PID /F          # Kill process
```

### Git Authentication Failed

```bash
# Error: Authentication failed

# Solution 1: Use personal access token (for HTTPS)
# GitHub → Settings → Developer settings → Personal access tokens
# Use token as password when prompted

# Solution 2: Use SSH (recommended)
# See "GitHub Setup" section above

# Solution 3: Update credentials
git config --global credential.helper cache  # Remember for 15 min
git config --global credential.helper store  # Store permanently (less secure)
```

### Docker Not Starting

```bash
# Error: Cannot connect to Docker daemon

# Solution 1: Start Docker Desktop (Windows/macOS)
# Open Docker Desktop application

# Solution 2: Start Docker service (Linux)
sudo systemctl start docker
sudo systemctl enable docker  # Start on boot

# Solution 3: Check if user is in docker group (Linux)
sudo usermod -aG docker $USER
# Log out and back in
```

---

## Summary: Your Development Toolbox

After completing this guide, you now have:

✅ **Development Environment**: Windows/Linux/macOS set up for coding
✅ **Version Control**: Git and GitHub for code management
✅ **Programming Languages**: Python, Node.js, and optionally Rust
✅ **Code Editor**: VS Code with essential extensions
✅ **Package Managers**: npm, pip, cargo, Chocolatey/Homebrew
✅ **API Skills**: Making HTTP requests with curl, Python, JavaScript
✅ **Container Knowledge**: Docker basics and Docker Compose
✅ **AI Tools**: Copilot, Claude, ChatGPT for assistance
✅ **First Projects**: Working examples in multiple languages

### Quick Reference Commands

```bash
# Git
git status
git add .
git commit -m "message"
git push origin main

# Python
python app.py
pip install package-name
python -m venv venv
source venv/bin/activate

# Node.js
node app.js
npm install package-name
npm init -y
npm start

# Docker
docker build -t name .
docker run -d -p 8080:80 name
docker ps
docker logs container-name
docker-compose up -d

# VS Code
code .  # Open current directory
code filename.py  # Open specific file
```

---

## Additional Resources from This Repository

- **[BIOS-VIRTUALIZATION-GUIDE.md](BIOS-VIRTUALIZATION-GUIDE.md)** - Enable virtualization in BIOS
- **[WINDOWS-OPTIMIZATION.md](WINDOWS-OPTIMIZATION.md)** - Optimize Windows for development
- **[WSL2-ADVANCED-SETUP.md](WSL2-ADVANCED-SETUP.md)** - Advanced WSL2 configuration
- **[DEV-ENV-WINDOWS.md](DEV-ENV-WINDOWS.md)** - Detailed Windows setup
- **[DEV-ENV-LINUX.md](DEV-ENV-LINUX.md)** - Detailed Linux setup
- **[GIT-WORKFLOW.md](GIT-WORKFLOW.md)** - Git best practices
- **[AI-AGENT-WORKFLOWS.md](AI-AGENT-WORKFLOWS.md)** - AI-assisted development
- **[CI-CD-PIPELINE.md](CI-CD-PIPELINE.md)** - Automated testing and deployment
- **[SECURITY-AND-COMPLIANCE.md](SECURITY-AND-COMPLIANCE.md)** - Security best practices

---

## Congratulations! 🎉

You've completed the beginner's guide to software development. You now have a professional development environment and the knowledge to start building real projects.

**Remember:**
- Learning to code takes time - be patient with yourself
- Build projects that interest you - passion drives learning
- Google/Stack Overflow are your friends - every developer uses them
- Join communities - programming is more fun with others
- Practice regularly - consistency beats intensity

**Happy coding!** 🚀

---

**Last Updated**: November 2024
**For**: Complete beginners to intermediate developers
**Feedback**: Open an issue on GitHub if you have questions or suggestions!
