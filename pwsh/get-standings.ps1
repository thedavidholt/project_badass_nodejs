[CmdletBinding()]
param(
    # Parameter help description
    [Parameter(ValueFromPipeline=$true)]
    [String] $DataFilePath = "..\data\data.json",

    # Parameter help description
    [Parameter()]
    [String] $ApiKey = (Get-Content -Path "..\secret\api_key.txt")
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
        $DataAge = $(Get-Date).Subtract($DataFile.LastWriteTime).Minutes
    }
    
    if ($DataAge -lt 144) {
        Write-Debug "Data is fresh, retrieving from file..."

        $Data = $(Get-Content $DataFile)
    } else {
        Write-Debug "Data is stale, fetching from API..."

        $headers=@{}
        $headers.Add("X-RapidAPI-Key", "$ApiKey")
        $headers.Add("X-RapidAPI-Host", "tank01-nfl-live-in-game-real-time-statistics-nfl.p.rapidapi.com")
        $response = Invoke-WebRequest `
            -Uri 'https://tank01-nfl-live-in-game-real-time-statistics-nfl.p.rapidapi.com/getNFLTeams' `
            -Method GET `
            -Headers $headers
        $Data = $response.Content | Tee-Object $DataFilePath
    }

    return $Data
}

$Data = Get-Data $DataFilePath $ApiKey


