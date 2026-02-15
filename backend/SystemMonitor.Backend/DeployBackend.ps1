# ------------------------------
# DeployBackend.ps1 — One Command Full Deploy
# ------------------------------

Write-Output "=== Starting Full Backend Deploy ==="

# ------------------------------
# Step 0 — Auto-detect backend folder
# ------------------------------
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$BackendPath = $ScriptDir
$PublishPath = Join-Path $BackendPath "publish"
$ControllersPath = Join-Path $BackendPath "Controllers"
$ProjectFile = Join-Path $BackendPath "SystemMonitor.Backend.csproj"

Write-Output "Detected BackendPath: $BackendPath"

# ------------------------------
# Step 1 — Sanity check
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
Write-Output "✅ Publish succeeded. Publish folder: $PublishPath"

# ------------------------------
# Step 4 — Verify DLLs
# ------------------------------
$dlls = Get-ChildItem -Path $PublishPath -Filter "*.dll"
if ($dlls.Count -eq 0) { Write-Error "No DLLs found in publish folder!"; return }
Write-Output "✅ DLLs found:"
$dlls | ForEach-Object { Write-Output "   $_" }

$backendDll = Join-Path $PublishPath "SystemMonitor.Backend.dll"
if (-not (Test-Path $backendDll)) { Write-Error "Main backend DLL missing: $backendDll"; return }
Write-Output "✅ Main backend DLL exists: $backendDll"

# ------------------------------
# Step 5 — Git commit & push
# ------------------------------
Write-Output "Staging changes for Git..."
cd $BackendPath
git add .
if ($LASTEXITCODE -ne 0) { Write-Error "Git add failed!"; return }

Write-Output "Committing changes..."
git commit -m "Automated deploy: build and publish"
if ($LASTEXITCODE -ne 0) { Write-Warning "Nothing to commit; continuing..." }

Write-Output "Pushing to GitHub..."
git push origin main
if ($LASTEXITCODE -ne 0) { Write-Error "Git push failed!"; return }

Write-Output "✅ Git push complete. GitHub Actions should deploy to Azure automatically."

# ------------------------------
# Step 6 — Done
# ------------------------------
Write-Output "=== Full Backend Deploy Complete ==="
Write-Output "Check your GitHub Actions workflow and your Azure Web App to confirm deployment."
