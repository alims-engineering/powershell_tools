# ====== ====== ====== .ps1 ====== ====== ======
# ====================================
#               action
# ====================================
#
#
# ====================================
#             How to use
# ====================================
# // Just put it in the folder where you want to use it.
#



# --------------------------------
# RAR.exe candidate path list
# --------------------------------
$rar_path_list = @(
    "C:\Program Files\WinRAR\Rar.exe",
    "C:\Program Files (x86)\WinRAR\Rar.exe"
)

# --------------------------------
# Find first existing RAR.exe
# --------------------------------
$rar = $rar_path_list | Where-Object {
    Test-Path $_
} | Select-Object -First 1

# --------------------------------
# Check if RAR exists
# --------------------------------
if (!$rar) {
    Write-Host ""
    Write-Host "Rar.exe not found"
    Write-Host "Please check your WinRAR installation"
    Write-Host ""

    foreach ($path in $rar_path_list) {
        Write-Host $path
    }

    exit
}

Write-Host ""
Write-Host "Using RAR:"
Write-Host $rar
Write-Host ""

# --------------------------------
# Current script file name
# --------------------------------
$self_file_name = $MyInvocation.MyCommand.Name

# --------------------------------
# Get current directory files
# --------------------------------
$files = Get-ChildItem -File

# --------------------------------
# Compress files one by one
# --------------------------------
foreach ($file in $files) {

    # Skip script itself
    if ($file.Name -eq $self_file_name) {
        continue
    }

    # Output archive name
    $rar_name = "$($file.BaseName).rar"

    Write-Host "=================================="
    Write-Host "Compressing: $($file.Name)"
    Write-Host "Output     : $rar_name"
    Write-Host "=================================="

    # --------------------------------
    # Execute RAR
    # --------------------------------
    & $rar `
        a `
        -r0 `
        -ma5 `
        -m5 `
        -md256m `
        -rr6p `
        -htb `
        -t `
        -- `
        $rar_name `
        $file.Name

    # --------------------------------
    # Check result
    # --------------------------------
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "SUCCESS: $rar_name"
    }
    else {
        Write-Host ""
        Write-Host "FAILED : $rar_name"
        Write-Host "RAR Exit Code: $LASTEXITCODE"
    }

    Write-Host ""
}

Write-Host "=================================="
Write-Host "All completed"
Write-Host "=================================="