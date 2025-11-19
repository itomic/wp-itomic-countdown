# PowerShell script to create GitHub pre-release via API
# Requires: GitHub Personal Access Token with repo permissions
# Usage: .\create-prerelease.ps1 -Token "your_github_token"

param(
    [Parameter(Mandatory=$true)]
    [string]$Token
)

$repo = "itomic/wp-itomic-countdown"
$tag = "v1.0.11-dev"
$version = "1.0.11-dev"
$zipFile = "itomic-countdown.zip"

Write-Host "Creating pre-release $tag for $repo..." -ForegroundColor Cyan

# Check if ZIP file exists
if (-not (Test-Path $zipFile)) {
    Write-Host "Error: $zipFile not found. Run package-plugin.sh first." -ForegroundColor Red
    exit 1
}

# Create release via GitHub API
$releaseBody = @"
## Version $version (Development Pre-Release)

This is a pre-release from the develop branch for testing auto-update functionality.

**⚠️ Do not use in production!**

### Changes
- Added pre-release support for testing auto-updates from develop branch
- Enhanced updater class to check for pre-releases when `ITOMIC_COUNTDOWN_CHECK_PRERELEASES` constant is set

### Testing
This release is intended for testing the auto-update mechanism on development/staging sites.

---
*This is a development pre-release for testing purposes only.*
"@

$releaseData = @{
    tag_name = $tag
    name = "Version $version (Development)"
    body = $releaseBody
    prerelease = $true
    draft = $false
} | ConvertTo-Json

$headers = @{
    "Authorization" = "token $Token"
    "Accept" = "application/vnd.github.v3+json"
}

try {
    # Create the release
    Write-Host "Creating release..." -ForegroundColor Yellow
    $releaseResponse = Invoke-RestMethod -Uri "https://api.github.com/repos/$repo/releases" `
        -Method Post `
        -Headers $headers `
        -Body $releaseData `
        -ContentType "application/json"
    
    $releaseId = $releaseResponse.id
    Write-Host "Release created with ID: $releaseId" -ForegroundColor Green
    
    # Upload the ZIP file
    Write-Host "Uploading $zipFile..." -ForegroundColor Yellow
    $uploadUrl = $releaseResponse.upload_url -replace '\{.*\}', "?name=$zipFile"
    
    $fileBytes = [System.IO.File]::ReadAllBytes((Resolve-Path $zipFile))
    $fileEnc = [System.Text.Encoding]::GetEncoding("ISO-8859-1").GetString($fileBytes)
    
    $uploadHeaders = @{
        "Authorization" = "token $Token"
        "Accept" = "application/vnd.github.v3+json"
        "Content-Type" = "application/zip"
    }
    
    $uploadResponse = Invoke-RestMethod -Uri $uploadUrl `
        -Method Post `
        -Headers $uploadHeaders `
        -Body $fileBytes
    
    Write-Host "✓ Pre-release created successfully!" -ForegroundColor Green
    Write-Host "Release URL: $($releaseResponse.html_url)" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Verify the release at: $($releaseResponse.html_url)" -ForegroundColor White
    Write-Host "2. Test update detection on wordpress.test" -ForegroundColor White
    
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ErrorDetails.Message) {
        Write-Host "Details: $($_.ErrorDetails.Message)" -ForegroundColor Red
    }
    exit 1
}

