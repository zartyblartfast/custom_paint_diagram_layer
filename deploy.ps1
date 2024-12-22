# Enhanced Deployment Script for Flutter Web App to GitHub Pages (PowerShell)

# Define variables
# The URL where your site will be published
$DeployedURL = "https://zartyblartfast.github.io/custom_paint_diagram_layer"

# The base href for GitHub Pages - must match repository name and have leading/trailing slashes
$BaseHref = "/custom_paint_diagram_layer/"

# Git branch configuration
$SourceBranch = "main"              # Source branch containing your Flutter app code
$GhPagesBranch = "gh-pages"         # Branch where the built web app will be deployed

# Flutter build configuration
$FlutterMainFile = "devtest\main.dart"  # Entry point for your Flutter application
$BuildDir = "devtest\build\web"         # Directory where Flutter will output the web build

# Files that must exist in the build output
$RequiredFiles = @(
    "index.html",      # Main HTML file
    "assets",          # Directory containing app assets
    "main.dart.js",    # Compiled Dart code
    "manifest.json"    # Web app manifest
)

# External directory for temporary build files (must be outside project directory)
$ExternalTempDir = "C:\Users\clive\VSC\FlutterBuildTemp"

# Set to $true to skip the cleanup prompt at the end of deployment
$SkipCleanup = $false

# Working directory management
$ProjectRoot = (Get-Location).Path   # Store the starting directory
Push-Location                        # Remember where we started

# Display configuration summary
Write-Host "`nDeployment Configuration Summary:" -ForegroundColor Cyan
Write-Host "--------------------------------" -ForegroundColor Cyan
Write-Host "Project Root:`t`t$ProjectRoot" -ForegroundColor Yellow
Write-Host "Build Directory:`t`t$BuildDir" -ForegroundColor Yellow
Write-Host "Source Branch:`t`t$SourceBranch" -ForegroundColor Yellow
Write-Host "Deploy Branch:`t`t$GhPagesBranch" -ForegroundColor Yellow
Write-Host "Main Flutter File:`t$FlutterMainFile" -ForegroundColor Yellow
Write-Host "External Temp Dir:`t$ExternalTempDir" -ForegroundColor Yellow
Write-Host "Base Href:`t`t$BaseHref" -ForegroundColor Yellow
Write-Host "Deployed URL:`t`t$DeployedURL" -ForegroundColor Yellow
Write-Host "Skip Cleanup:`t`t$SkipCleanup" -ForegroundColor Yellow
Write-Host "`nRequired Files:" -ForegroundColor Yellow
$RequiredFiles | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
Write-Host "--------------------------------`n" -ForegroundColor Cyan

# Configuration confirmation
$configConfirmation = Read-Host "Please review the configuration above. Continue? (y/n)"
if ($configConfirmation -ne 'y') {
    Write-Host "Operation cancelled by user." -ForegroundColor Yellow
    Pop-Location
    exit 0
}

# Function definitions
function Abort {
    Write-Error "Error: $($args[0])"
    # Attempt to switch back to the starting branch if an error occurs
    if ($StartingBranch) {
        git checkout $StartingBranch
    }
    Pop-Location
    exit 1
}

function Verify-ExternalTempDir {
    param (
        [string]$TempDir,
        [string]$ProjectPath
    )
    
    Write-Host "Verifying external temp directory..." -ForegroundColor Yellow
    
    # Check if directory exists
    if (-not (Test-Path $TempDir)) {
        Abort "External temp directory does not exist at: $TempDir"
    }
    
    # Check if it's outside project directory
    if ((Resolve-Path $TempDir).Path.StartsWith((Resolve-Path $ProjectPath).Path)) {
        Abort "Temp directory must be outside the project directory"
    }
    
    Write-Host "External temp directory verified." -ForegroundColor Green
}

# Step 1: Verify external temp directory
Verify-ExternalTempDir -TempDir $ExternalTempDir -ProjectPath $ProjectRoot

# Step 2: Ensure Flutter build files are in .gitignore
Write-Host "Checking .gitignore configuration..." -ForegroundColor Yellow
$GitIgnorePath = ".gitignore"
$RequiredIgnores = @(
    "**/windows/flutter/generated_plugin_registrant.cc",
    "**/windows/flutter/generated_plugin_registrant.h",
    "**/windows/flutter/generated_plugins.cmake"
)

if (-not (Test-Path $GitIgnorePath)) {
    Write-Host "Creating .gitignore file..." -ForegroundColor Green
    New-Item -ItemType File -Path $GitIgnorePath | Out-Null
}

$CurrentIgnores = Get-Content $GitIgnorePath
$NeedToUpdate = $false

foreach ($ignore in $RequiredIgnores) {
    if ($CurrentIgnores -notcontains $ignore) {
        $NeedToUpdate = $true
        break
    }
}

if ($NeedToUpdate) {
    Write-Host "Adding Flutter build files to .gitignore..." -ForegroundColor Green
    "`n# Windows Flutter generated files" | Add-Content $GitIgnorePath
    $RequiredIgnores | Add-Content $GitIgnorePath
    
    # Remove these files from git tracking if they exist
    foreach ($ignore in $RequiredIgnores) {
        $file = $ignore -replace '\*\*/', ''
        if (Test-Path $file) {
            git rm --cached $file 2>$null
        }
    }
    
    git add $GitIgnorePath
    git commit -m "Add Windows Flutter generated files to .gitignore" 2>$null
}

# Store the starting branch
$StartingBranch = git branch --show-current

# Check for uncommitted changes in gh-pages branch if it exists
Write-Host "Checking gh-pages branch for uncommitted changes..." -ForegroundColor Yellow
$GhPagesExists = git show-ref refs/heads/$GhPagesBranch 2>$null
if ($GhPagesExists) {
    # Store current branch
    $CurrentBranch = git branch --show-current
    
    # Check gh-pages branch
    git checkout $GhPagesBranch
    $UncommittedChanges = git status --porcelain
    git checkout $CurrentBranch
    
    if ($UncommittedChanges) {
        Write-Error "There are uncommitted changes in the gh-pages branch. Please commit or stash them first."
        exit 1
    }
}

# Step 3: Verify working directory is the project root
Write-Host "Verifying working directory is the project root..." -ForegroundColor Yellow
if (-not (Test-Path -Path ".git")) {
    Abort "This script must be run from the root directory of a Git repository. Aborting."
}
if (-not (Test-Path -Path $FlutterMainFile)) {
    Abort "File '$FlutterMainFile' not found. Please ensure you are in the correct project directory. Aborting."
}

# Step 4: Verify Flutter is installed
Write-Host "Checking if Flutter is installed..." -ForegroundColor Yellow
if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Abort "Flutter is not installed or not in the PATH. Please install it and try again."
}

# Step 5: Verify source branch exists
Write-Host "Checking if branch '$SourceBranch' exists..." -ForegroundColor Yellow
$SourceBranchExists = git show-ref refs/heads/$SourceBranch 2>$null
if (-not $SourceBranchExists) {
    Abort "Source branch '$SourceBranch' does not exist. Please specify a valid branch and try again."
}

# Step 6: Verify we're starting from the source branch
Write-Host "Verifying current branch is '$SourceBranch'..." -ForegroundColor Yellow
if ($StartingBranch -ne $SourceBranch) {
    Abort "You are not on the '$SourceBranch' branch. Please switch to '$SourceBranch' and try again."
}

# Step 7: Check for uncommitted changes
Write-Host "Checking for uncommitted changes..." -ForegroundColor Yellow
if ((git status --porcelain).Length -gt 0) {
    Abort "There are uncommitted changes in your repository. Please commit or stash them before running this script."
}

# Confirmation before major operations
$confirmation = Read-Host "This script will deploy to GitHub Pages. Continue? (y/n)"
if ($confirmation -ne 'y') {
    Write-Host "Operation cancelled by user." -ForegroundColor Yellow
    exit 0
}

# Step 8: Build the Flutter web app
Write-Host "Building the Flutter web app..." -ForegroundColor Green
Push-Location "devtest"
flutter build web -t main.dart --base-href $BaseHref
if (!(Test-Path -Path "build\web")) {
    Pop-Location
    Abort "Build directory 'build\web' not found after building. Aborting."
}
Pop-Location

# Step 9: Verify build contains required files
Write-Host "Verifying build output contains required files..." -ForegroundColor Yellow
foreach ($File in $RequiredFiles) {
    if (-not (Test-Path -Path (Join-Path "devtest\build\web" $File))) {
        Abort "Required file '$File' not found in build output. Aborting."
    }
}

# Step 10: Copy build files to external temp directory
$TempBuildDir = Join-Path $ExternalTempDir "gh-pages-build"
Write-Host "`nStep 10: Copying Flutter web build files to temp directory" -ForegroundColor Green
Write-Host "From: $BuildDir" -ForegroundColor Yellow
Write-Host "To: $TempBuildDir" -ForegroundColor Yellow

Write-Host "`nAbout to clear contents of temp directory: $TempBuildDir" -ForegroundColor Yellow
$confirmation = Read-Host "Do you want to continue? (y/n)"
if ($confirmation -ne 'y') {
    Write-Host "Operation cancelled by user." -ForegroundColor Yellow
    exit 0
}
Get-ChildItem -Path $TempBuildDir -Recurse | Remove-Item -Force -Recurse

Write-Host "`nFiles to be copied from: $BuildDir" -ForegroundColor Yellow
Get-ChildItem -Path $BuildDir -Recurse | ForEach-Object {
    Write-Host "  $($_.FullName.Replace($BuildDir, ''))"
}
Write-Host "`nThese files will be copied to: $TempBuildDir" -ForegroundColor Yellow

$confirmation = Read-Host "Do you want to proceed with copying these files? (y/n)"
if ($confirmation -ne 'y') {
    Write-Host "Operation cancelled by user." -ForegroundColor Yellow
    exit 0
}

Write-Host "`nCopying files..." -ForegroundColor Green
Copy-Item -Recurse "$BuildDir\*" $TempBuildDir -Force -ErrorAction Stop
Write-Host "Files successfully copied to: $TempBuildDir" -ForegroundColor Green

# Step 11: Check if gh-pages branch exists
Write-Host "Checking if branch '$GhPagesBranch' exists..." -ForegroundColor Green
$BranchExists = git show-ref refs/heads/$GhPagesBranch 2>$null
if (-not $BranchExists) {
    Write-Host "Branch '$GhPagesBranch' not found. Creating it..."
    git branch $GhPagesBranch
    if ($LASTEXITCODE -ne 0) {
        Abort "Failed to create '$GhPagesBranch' branch."
    }
}

# Step 12: Switch to gh-pages branch
Write-Host "Switching to branch '$GhPagesBranch'..." -ForegroundColor Green
git checkout $GhPagesBranch
if ($LASTEXITCODE -ne 0) {
    Abort "Failed to switch to '$GhPagesBranch' branch."
}

# Confirm we are on the correct branch
$CurrentBranch = git branch --show-current
if ($CurrentBranch -ne $GhPagesBranch) {
    Abort "Failed to switch to '$GhPagesBranch'. Current branch: '$CurrentBranch'. Aborting."
}

# Step 13: Clean up old files safely (exclude .git and .gitignore)
Write-Host "Cleaning up old files in '$GhPagesBranch' branch..." -ForegroundColor Green
Get-ChildItem -Force | Where-Object {
    # Never touch .git directory
    if ($_.Name -eq ".git") { return $false }
    # Keep .gitignore
    if ($_.Name -eq ".gitignore") { return $false }
    # Remove everything else at root level
    return $true
} | ForEach-Object {
    Write-Host "Removing $($_.Name)..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $_.FullName -ErrorAction Stop
}

# Step 14: Copy new build files from temp directory
Write-Host "Copying build files from temp directory to '$GhPagesBranch' branch..." -ForegroundColor Green
Copy-Item -Recurse "$TempBuildDir\*" . -Force -ErrorAction Stop

# Step 15: Commit and push changes with timestamp
$Timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
Write-Host "Committing and pushing changes to '$GhPagesBranch' branch..." -ForegroundColor Green
git add .
git commit -m "Update web app - $Timestamp"
if ($LASTEXITCODE -ne 0) {
    Write-Host "No changes to commit."
}

git push origin $GhPagesBranch
if ($LASTEXITCODE -ne 0) {
    Abort "Failed to push changes to '$GhPagesBranch'. Aborting."
}

# Step 16: Switch back to source branch
Write-Host "Switching back to branch '$SourceBranch'..." -ForegroundColor Green
git checkout $SourceBranch
if ($LASTEXITCODE -ne 0) {
    Abort "Failed to switch back to '$SourceBranch' branch. Please check manually."
}

# Confirm we are on the correct branch
$CurrentBranch = git branch --show-current
if ($CurrentBranch -ne $SourceBranch) {
    Abort "Failed to switch back to '$SourceBranch'. Current branch: '$CurrentBranch'. Aborting."
}

# Step 17: Optional cleanup of generated files
if (-not $SkipCleanup) {
    Write-Host "Performing optional cleanup of generated files..." -ForegroundColor Yellow
    if ((Read-Host "Do you want to clean up generated files? (y/n)") -eq "y") {
        $AbsoluteBuildDir = Join-Path $ProjectRoot $BuildDir
        if (Test-Path $AbsoluteBuildDir) {
            Remove-Item -Recurse -Force $AbsoluteBuildDir -ErrorAction Stop
            Write-Host "Cleaned up generated files." -ForegroundColor Green
        } else {
            Write-Host "Build directory not found at: $AbsoluteBuildDir" -ForegroundColor Yellow
            Write-Host "It may have already been cleaned up." -ForegroundColor Green
        }
    }
} else {
    Write-Host "Skipping cleanup of generated files." -ForegroundColor Yellow
}

# Success message with deployed URL
Write-Host "Deployment to GitHub Pages completed successfully!" -ForegroundColor Green
Write-Host "You can view your site at: $DeployedURL" -ForegroundColor Cyan

# Restore original directory
Pop-Location
