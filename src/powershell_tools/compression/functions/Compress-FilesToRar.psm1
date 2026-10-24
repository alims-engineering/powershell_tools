# ====================================
#              Compress-FilesToRar
# ====================================

function Compress-FilesToRar {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    # --------------------------------
    # RAR.exe candidate path list
    # --------------------------------
    $rar_path_list = @(
        "$env:ProgramFiles\WinRAR\Rar.exe",
        "${env:ProgramFiles(x86)}\WinRAR\Rar.exe"
    )

    # --------------------------------
    # Find first existing RAR.exe
    # --------------------------------
    $rar = $rar_path_list |
        Where-Object { Test-Path -LiteralPath $_ -PathType Leaf } |
        Select-Object -First 1

    if (!$rar) {
        Write-Host ""
        Write-Host "Rar.exe not found"
        Write-Host "Please check your WinRAR installation"
        Write-Host ""

        foreach ($candidate in $rar_path_list) {
            Write-Host $candidate
        }

        return
    }

    # --------------------------------
    # Validate target directory
    # --------------------------------
    if (!(Test-Path -LiteralPath $Path -PathType Container)) {
        Write-Host "Directory not found: $Path"
        return
    }

    $target_path = (Resolve-Path -LiteralPath $Path).Path

    Write-Host ""
    Write-Host "Using RAR: $rar"
    Write-Host "Target   : $target_path"
    Write-Host ""

    # --------------------------------
    # Get files in target directory only
    # --------------------------------
    $files = Get-ChildItem -LiteralPath $target_path -File -Force

    # --------------------------------
    # Compress files one by one
    # --------------------------------
    foreach ($file in $files) {
        $rar_name = Join-Path $target_path "$($file.BaseName).rar"

        Write-Host "=================================="
        Write-Host "Compressing: $($file.Name)"
        Write-Host "Output     : $rar_name"
        Write-Host "=================================="

        # --------------------------------
        # Save original location
        # --------------------------------
        $original_path = Get-Location

        try {
            # Use LiteralPath to handle special characters
            Set-Location -LiteralPath $target_path -ErrorAction Stop

            # --------------------------------
            # Execute RAR
            # -ep excludes source paths
            # --------------------------------
            & $rar `
                a `
                -ep `
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

            $rar_exit_code = $LASTEXITCODE
        }
        catch {
            $rar_exit_code = -1
            Write-Host "Execution error: $($_.Exception.Message)"
        }
        finally {
            # Restore the original working directory literally
            Set-Location -LiteralPath $original_path.Path -ErrorAction SilentlyContinue
        }

        # --------------------------------
        # Check result
        # --------------------------------
        if ($rar_exit_code -eq 0) {
            Write-Host ""
            Write-Host "SUCCESS: $rar_name"
        }
        else {
            Write-Host ""
            Write-Host "FAILED : $rar_name"
            Write-Host "RAR Exit Code: $rar_exit_code"
        }

        Write-Host ""
    }

    Write-Host "=================================="
    Write-Host "All completed"
    Write-Host "=================================="
}