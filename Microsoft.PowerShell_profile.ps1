# PowerShell Core: ~\Documents\PowerShell 
# Windows PowerShell: ~\Documents\WindowsPowerShell

function Get-Branch () {

    $branch = git rev-parse --abbrev-ref HEAD

    if ($branch -eq "HEAD") {
        $sha = git rev-parse --short HEAD
        if ($sha) {
            return @{
                Branch = "detached $sha";
                Color  = "red"
            }
        }
        else {
            return @{
                Branch = "empty";
                Color  = "yellow"
            }
        }
    }
    elseif ($branch) {
        return @{
            Branch = $branch;
            Color  = "blue"
        }
    }
    else {
        return @{}
    }
}

function Write-Branch ($branch) {
    Write-Host " ($($branch.Branch))" -ForegroundColor $branch.Color
}

function prompt {
    $branch = Get-Branch
    $currentLocation = $executionContext.SessionState.Path.CurrentLocation
    $currentDirectory = (Split-Path -Path ($currentLocation) -Leaf)

    Write-Host $currentLocation -NoNewline -ForegroundColor "green"
    $host.ui.RawUI.WindowTitle = $currentDirectory

    if ($branch.Branch) {
        Write-Branch ($branch)
    }
    else {
        Write-Host
    }
    
    return "$('>' * ($nestedPromptLevel + 1)) "
}
