# Points the report at the dashboard data built by the case-study pipeline.
# Usage: .\Set-DataFolder.ps1 -DataPath "C:\path\to\readmissions-case-study\outputs\powerbi\dashboard_data"
param([Parameter(Mandatory = $true)][string]$DataPath)
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$Expr = Join-Path $Root "Readmissions.SemanticModel\definition\expressions.tmdl"
$Required = @("patients.csv", "Capacity.csv", "CapacityAxis.csv", "Scenario.csv", "ModelMetrics.csv", "OddsRatios.csv", "EffectSizes.csv", "ROC.csv")
foreach ($File in $Required) {
    if (-not (Test-Path -LiteralPath (Join-Path $DataPath $File))) { throw "Missing $File in $DataPath. Run the case-study pipeline first." }
}
$Text = Get-Content -LiteralPath $Expr -Raw
$Text = [regex]::Replace($Text, 'expression DataFolder = "[^"]*"', ('expression DataFolder = "' + $DataPath.TrimEnd('\') + '"'))
[System.IO.File]::WriteAllText($Expr, $Text, (New-Object System.Text.UTF8Encoding($false)))
Write-Host "DataFolder set to $DataPath. Open Readmissions.pbip in Power BI Desktop and select Refresh."
