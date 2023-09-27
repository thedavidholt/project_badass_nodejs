[CmdletBinding()]
param(
    # Parameter help description
    [Parameter(ValueFromPipeline=$true)]
    [String] $DataFilePath = ".\data\data.json",

    # Parameter help description
    [Parameter()]
    [String] $ApiKey = (Get-Content -Path ".\secret\api_key.txt"),

    # Parameter help description
    [Parameter()]
    [hashtable] $Owners = (Get-Content -Path ".\data\owners.json" | ConvertFrom-Json -AsHashtable)
)

function Get-Data {
    param (
        [Parameter(Mandatory=$true)]
        [String] $DataFilePath,

        [Parameter(Mandatory=$true)]
        [String] $ApiKey
    )
    if (Test-Path $DataFilePath ) {
        $DataFile = Get-Item -Path $DataFilePath
    }
    
    if ($null -eq $DataFile.LastWriteTime) {
        $DataAge = 144
    } else {
        $DataAge = $(Get-Date).Subtract($DataFile.LastWriteTime).TotalMinutes
    }
    
    Write-Debug "DataAge (minutes): $DataAge"
    
    if ($DataAge -lt 144) {
        Write-Debug "Data is fresh, retrieving from file..."

        $JsonData = $(Get-Content $DataFile)
    } else {
        Write-Debug "Data is stale, fetching from API..."

        $headers=@{}
        $headers.Add("X-RapidAPI-Key", "$ApiKey")
        $headers.Add("X-RapidAPI-Host", "tank01-nfl-live-in-game-real-time-statistics-nfl.p.rapidapi.com")
        $response = Invoke-WebRequest `
            -Uri 'https://tank01-nfl-live-in-game-real-time-statistics-nfl.p.rapidapi.com/getNFLTeams' `
            -Method GET `
            -Headers $headers
        $JsonData = $response.Content | Tee-Object $DataFilePath
    }

    return $JsonData
}

$Data = Get-Data $DataFilePath $ApiKey | ConvertFrom-Json

$Points = @{label="points";expression={[int]$_.wins + ([int]$_.tie/2)}}
$Owner = @{label="owner";expression={$Owners[$_.teamAbv]}}
$DataWeCareAbout = $Data.body | Select-Object teamID, teamAbv, teamCity, teamName, wins, tie, loss, $Points, $Owner 

$DataWeCareAbout | Format-Table

$totalPoints = @{label="TotalPoints";expression={[int]($_.Group | Measure-Object -Property points -Sum).Sum}}
$DataWeCareAbout | Group-Object owner | Select-Object Name, $totalPoints | Sort-Object totalPoints -Descending | Format-Table
