# Version Bump Script for Itomic Countdown Plugin
# Increments version number in plugin file and readme.txt

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("patch", "minor", "major")]
    [string]$Type = "patch"
)

$PLUGIN_FILE = "itomic-countdown.php"
$README_FILE = "readme.txt"

Write-Host "Bumping version ($Type)..." -ForegroundColor Cyan
Write-Host ""

# Read current version from plugin file
$pluginContent = Get-Content $PLUGIN_FILE -Raw
if ($pluginContent -match 'Version: (\d+)\.(\d+)\.(\d+)') {
    $major = [int]$matches[1]
    $minor = [int]$matches[2]
    $patch = [int]$matches[3]
    
    $oldVersion = "$major.$minor.$patch"
    Write-Host "Current version: $oldVersion" -ForegroundColor Yellow
    
    # Increment version based on type
    switch ($Type) {
        "major" {
            $major++
            $minor = 0
            $patch = 0
        }
        "minor" {
            $minor++
            $patch = 0
        }
        "patch" {
            $patch++
        }
    }
    
    $newVersion = "$major.$minor.$patch"
    Write-Host "New version: $newVersion" -ForegroundColor Green
    Write-Host ""
    
    # Update plugin file
    Write-Host "Updating $PLUGIN_FILE..." -ForegroundColor Yellow
    $pluginContent = $pluginContent -replace "Version: $oldVersion", "Version: $newVersion"
    $pluginContent = $pluginContent -replace "define\( 'ITOMIC_COUNTDOWN_VERSION', '$oldVersion' \)", "define( 'ITOMIC_COUNTDOWN_VERSION', '$newVersion' )"
    Set-Content -Path $PLUGIN_FILE -Value $pluginContent -NoNewline
    Write-Host "✓ Plugin file updated" -ForegroundColor Green
    
    # Update readme.txt
    Write-Host "Updating $README_FILE..." -ForegroundColor Yellow
    $readmeContent = Get-Content $README_FILE -Raw
    $readmeContent = $readmeContent -replace "Stable tag: $oldVersion", "Stable tag: $newVersion"
    Set-Content -Path $README_FILE -Value $readmeContent -NoNewline
    Write-Host "✓ readme.txt updated" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "Version bumped successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "1. Review changes: git diff" -ForegroundColor White
    Write-Host "2. Commit changes: git add $PLUGIN_FILE $README_FILE" -ForegroundColor White
    Write-Host "3. Commit: git commit -m 'Bump version to $newVersion'" -ForegroundColor White
    Write-Host "4. Push to main: git push origin main" -ForegroundColor White
    Write-Host "5. GitHub Actions will automatically create release v$newVersion" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "Error: Could not find version in $PLUGIN_FILE" -ForegroundColor Red
    exit 1
}

