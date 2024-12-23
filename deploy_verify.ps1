# Detailed deployment script with verification

$ErrorActionPreference = "Stop"  # Stop on any error
$VerbosePreference = "Continue"  # Show detailed output

# Define paths
$ProjectRoot = $PSScriptRoot
$WebBuildDir = Join-Path $ProjectRoot "web_build"
$BuildOutputDir = Join-Path $WebBuildDir "build\web"
$IntegrationTestDir = Join-Path $ProjectRoot "..\diagram_integration_test"

Write-Host "`n=== Starting Deployment Process ===" -ForegroundColor Green

# 1. Verify directories exist
Write-Host "`nVerifying directories..." -ForegroundColor Yellow
if (-not (Test-Path $WebBuildDir)) {
    throw "Web build directory not found at: $WebBuildDir"
}
if (-not (Test-Path $IntegrationTestDir)) {
    throw "Integration test directory not found at: $IntegrationTestDir"
}

# 2. Clean previous build
Write-Host "`nCleaning previous build..." -ForegroundColor Yellow
Push-Location $WebBuildDir
try {
    Write-Host "Running flutter clean..."
    flutter clean
    if ($LASTEXITCODE -ne 0) { throw "flutter clean failed" }

    # 3. Get dependencies
    Write-Host "`nGetting dependencies..." -ForegroundColor Yellow
    Write-Host "Running flutter pub get..."
    flutter pub get
    if ($LASTEXITCODE -ne 0) { throw "flutter pub get failed" }

    # 4. Build web
    Write-Host "`nBuilding web app..." -ForegroundColor Yellow
    Write-Host "Running flutter build web..."
    flutter build web --web-renderer canvaskit --release
    if ($LASTEXITCODE -ne 0) { throw "flutter build web failed" }
}
finally {
    Pop-Location
}

# 5. Verify build output exists
Write-Host "`nVerifying build output..." -ForegroundColor Yellow
$requiredFiles = @("index.html", "main.dart.js", "flutter.js")
foreach ($file in $requiredFiles) {
    $path = Join-Path $BuildOutputDir $file
    if (-not (Test-Path $path)) {
        throw "Required file not found in build output: $file"
    }
    Write-Host "Found required file: $file"
}

# 6. Clean integration test directory
Write-Host "`nCleaning integration test directory..." -ForegroundColor Yellow
Get-ChildItem -Path $IntegrationTestDir -Exclude @("diagram-layer", ".gitignore") | Remove-Item -Recurse -Force

# 7. Copy files
Write-Host "`nCopying files to integration test directory..." -ForegroundColor Yellow
Copy-Item -Path "$BuildOutputDir\*" -Destination $IntegrationTestDir -Recurse -Force

# 8. Verify copied files
Write-Host "`nVerifying copied files..." -ForegroundColor Yellow
foreach ($file in $requiredFiles) {
    $path = Join-Path $IntegrationTestDir $file
    if (-not (Test-Path $path)) {
        throw "Required file not found in integration test directory: $file"
    }
    Write-Host "Verified copied file: $file"
}

Write-Host "`n=== Deployment Complete ===" -ForegroundColor Green
Write-Host "Build files copied to: $IntegrationTestDir"
Write-Host "Please verify the application at: http://localhost:xxxx/index.html"
