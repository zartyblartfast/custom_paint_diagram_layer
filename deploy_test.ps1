# Deploy script for copying Flutter web build to integration test directory

# Source and target directories
$SourceDir = "web_build/build/web"
$TargetDir = "../diagram_integration_test"

# Ensure we're in the right directory
Set-Location $PSScriptRoot

# Clean and build Flutter web app
Write-Host "Cleaning Flutter build..." -ForegroundColor Green
Push-Location web_build
flutter clean
flutter pub get
flutter build web --web-renderer canvaskit --release
Pop-Location

# Copy files to integration test directory
Write-Host "Copying files to integration test directory..." -ForegroundColor Green
Copy-Item -Path "$SourceDir/*" -Destination $TargetDir -Recurse -Force

Write-Host "Deployment complete!" -ForegroundColor Green
