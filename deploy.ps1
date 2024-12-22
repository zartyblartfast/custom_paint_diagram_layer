# Enhanced Deployment Script for Flutter Web App to GitHub Pages (PowerShell)

# Define variables
$ProjectRoot = (Get-Location).Path
$BuildDir = "devtest\build\web"
$GhPagesBranch = "gh-pages"
$SourceBranch = "main"
$FlutterMainFile = "devtest\main.dart"
$RequiredFiles = @("index.html", "assets", "main.dart.js", "manifest.json")
Push-Location  # Remember where we started
$ExternalTempDir = "C:\Users\clive\VSC\FlutterBuildTemp"  # External directory for build files
$SkipCleanup = $false  # Set to $true to skip the cleanup prompt
$DeployedURL = "https://zartyblartfast.github.io/custom_paint_diagram_layer"

# Check external temp directory
Write-Host "Verifying external temp directory..." -ForegroundColor Yellow
if (-not (Test-Path $ExternalTempDir)) {
    Write-Error "External temp directory does not exist at: $ExternalTempDir"
    exit 1
}

# Check if it's actually external to project directory
if ((Resolve-Path $ExternalTempDir).Path.StartsWith((Resolve-Path $ProjectRoot).Path)) {
    Write-Error "Temp directory must be outside the project directory"
    exit 1
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

function Abort {
    Write-Error "Error: $($args[0])"
    # Attempt to switch back to the starting branch if an error occurs
    if ($StartingBranch) {
        git checkout $StartingBranch
    }
    Pop-Location
    exit 1
}

# Step 1: Verify working directory is the project root
Write-Host "Verifying working directory is the project root..." -ForegroundColor Yellow
if (-not (Test-Path -Path ".git")) {
    Abort "This script must be run from the root directory of a Git repository. Aborting."
}
if (-not (Test-Path -Path $FlutterMainFile)) {
    Abort "File '$FlutterMainFile' not found. Please ensure you are in the correct project directory. Aborting."
}

# Step 2: Verify Flutter is installed
Write-Host "Checking if Flutter is installed..." -ForegroundColor Yellow
if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Abort "Flutter is not installed or not in the PATH. Please install it and try again."
}

# Step 3: Verify source branch exists
Write-Host "Checking if branch '$SourceBranch' exists..." -ForegroundColor Yellow
$SourceBranchExists = git show-ref refs/heads/$SourceBranch 2>$null
if (-not $SourceBranchExists) {
    Abort "Source branch '$SourceBranch' does not exist. Please specify a valid branch and try again."
}

# Step 4: Verify we're starting from the source branch
Write-Host "Verifying current branch is '$SourceBranch'..." -ForegroundColor Yellow
if ($StartingBranch -ne $SourceBranch) {
    Abort "You are not on the '$SourceBranch' branch. Please switch to '$SourceBranch' and try again."
}

# Step 5: Check for uncommitted changes
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

# Step 6: Build the Flutter web app
Write-Host "Building the Flutter web app..." -ForegroundColor Green
Push-Location "devtest"
flutter build web -t main.dart
if (!(Test-Path -Path "build\web")) {
    Pop-Location
    Abort "Build directory 'build\web' not found after building. Aborting."
}
Pop-Location

# Step 7: Verify build contains required files
Write-Host "Verifying build output contains required files..." -ForegroundColor Yellow
foreach ($File in $RequiredFiles) {
    if (-not (Test-Path -Path (Join-Path "devtest\build\web" $File))) {
        Abort "Required file '$File' not found in build output. Aborting."
    }
}

# Step 8: Copy build files to external temp directory
Write-Host "Copying build files to external temp directory..." -ForegroundColor Green
$TempBuildDir = Join-Path $ExternalTempDir "gh-pages-build"
Write-Host "About to clear contents of temp directory: $TempBuildDir" -ForegroundColor Yellow
$confirmation = Read-Host "Do you want to continue? (y/n)"
if ($confirmation -ne 'y') {
    Write-Host "Operation cancelled by user." -ForegroundColor Yellow
    exit 0
}
Get-ChildItem -Path $TempBuildDir -Recurse | Remove-Item -Force -Recurse
Copy-Item -Recurse "$BuildDir\*" $TempBuildDir -Force -ErrorAction Stop
Write-Host "Build files backed up to: $TempBuildDir" -ForegroundColor Green

# Step 9: Check if gh-pages branch exists
Write-Host "Checking if branch '$GhPagesBranch' exists..." -ForegroundColor Green
$BranchExists = git show-ref refs/heads/$GhPagesBranch 2>$null
if (-not $BranchExists) {
    Write-Host "Branch '$GhPagesBranch' not found. Creating it..."
    git branch $GhPagesBranch
    if ($LASTEXITCODE -ne 0) {
        Abort "Failed to create '$GhPagesBranch' branch."
    }
}

# Step 10: Switch to gh-pages branch
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

# Step 11: Clean up old files safely (exclude .git and .gitignore)
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

# Step 12: Copy new build files from temp directory
Write-Host "Copying build files from temp directory to '$GhPagesBranch' branch..." -ForegroundColor Green
Copy-Item -Recurse "$TempBuildDir\*" . -Force -ErrorAction Stop

# Step 13: Commit and push changes with timestamp
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

# Step 14: Switch back to source branch
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

# Step 15: Optional cleanup of generated files
if (-not $SkipCleanup) {
    Write-Host "Performing optional cleanup of generated files..." -ForegroundColor Yellow
    if ((Read-Host "Do you want to clean up generated files? (y/n)") -eq "y") {
        Remove-Item -Recurse -Force $BuildDir -ErrorAction Stop
        Write-Host "Cleaned up generated files." -ForegroundColor Green
    }
} else {
    Write-Host "Skipping cleanup of generated files." -ForegroundColor Yellow
}

# Success message with deployed URL
Write-Host "Deployment to GitHub Pages completed successfully!" -ForegroundColor Green
Write-Host "You can view your site at: $DeployedURL" -ForegroundColor Cyan

# Restore original directory
Pop-Location
