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
        return @{
            Branch = "no branch";
            Color  = "yellow"
        }
    }
}

function Write-Branch ($branch) {   
    Write-Host " ($($branch.Branch))" -ForegroundColor $branch.Color    
}

function prompt {
    $currentLocation = $executionContext.SessionState.Path.CurrentLocation
    $currentDirectory = (Split-Path -Path ($currentLocation) -Leaf)
    $currentPath = "$($currentLocation)"
    
    if (Test-Path .git) {
        $branch = Get-Branch
        Write-Host $currentPath -NoNewline -ForegroundColor "green"
        Write-Branch ($branch)
        $host.ui.RawUI.WindowTitle = $currentDirectory
    }
    else {        
        Write-Host $currentPath -ForegroundColor "green"
        $host.ui.RawUI.WindowTitle = $currentDirectory
    }
    
    return "$('>' * ($nestedPromptLevel + 1)) "
}
