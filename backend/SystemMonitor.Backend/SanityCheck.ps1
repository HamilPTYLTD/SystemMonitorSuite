# ------------------------------
# SanityCheck.ps1 — Auto-detect backend
# ------------------------------

Write-Output "SanityCheck script started..."

# ------------------------------
# Step 0 — Auto-detect script directory
# ------------------------------
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Write-Output "Script running from: $ScriptDir"

# Assume the script is inside: backend\SystemMonitor.Backend\
$BackendPath = $ScriptDir
$PublishPath = Join-Path $BackendPath "publish"
$ControllersPath = Join-Path $BackendPath "Controllers"
$ProjectFile = Join-Path $BackendPath "SystemMonitor.Backend.csproj"

Write-Output "Detected BackendPath: $BackendPath"

# ------------------------------
# Step 1 — Check essential files/folders
# ------------------------------
if (-not (Test-Path $BackendPath)) { Write-Error "Backend folder not found: $BackendPath"; return }
if (-not (Test-Path $ProjectFile)) { Write-Error "Project file missing: $ProjectFile"; return }
if (-not (Test-Path $ControllersPath)) { Write-Error "Controllers folder missing: $ControllersPath"; return }

Write-Output "✅ Backend folder, project file, and Controllers folder exist."

# ------------------------------
# Step 2 — Build project
# ------------------------------
Set-Location $BackendPath
Write-Output "Building project..."
dotnet build
if ($LASTEXITCODE -ne 0) { Write-Error "Build failed!"; return }
Write-Output "✅ Build succeeded."

# ------------------------------
# Step 3 — Publish project
# ------------------------------
Write-Output "Publishing project..."
dotnet publish -c Release -o $PublishPath
if ($LASTEXITCODE -ne 0) { Write-Error "Publish failed!"; return }
Write-Output "✅ Publish succeeded. Publish folder created at: $PublishPath"

# ------------------------------
# Step 4 — Check publish folder contents
# ------------------------------
$dlls = Get-ChildItem -Path $PublishPath -Filter "*.dll"
if ($dlls.Count -eq 0) { Write-Error "No DLLs found in publish folder!"; return }

Write-Output "✅ DLLs found in publish folder:"
$dlls | ForEach-Object { Write-Output "   $_" }

# ------------------------------
# Step 5 — Verify main backend DLL
# ------------------------------
$backendDll = Join-Path $PublishPath "SystemMonitor.Backend.dll"
if (-not (Test-Path $backendDll)) { Write-Error "Main backend DLL missing: $backendDll"; return }

Write-Output "✅ Main backend DLL exists: $backendDll"

# ------------------------------
# Step 6 — Ready for GitHub push
# ------------------------------
Write-Output "✅ All checks passed. Safe to commit and push to GitHub."
Write-Output "   cd C:\Projects\SystemMonitorSuite"
Write-Output "   git add ."
Write-Output "   git commit -m 'Sanity check passed, ready for deploy'"
Write-Output "   git push origin main"
