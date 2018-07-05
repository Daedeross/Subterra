param (
    [parameter(Position=0, Mandatory=$true)]
    [string] $Tag,
    [string] $InfoPath = "config/buildinfo.json",
    [string] $SourceFolder = "src",
    [string] $OutputPath = ""
)

# check for $Tag
$tags = git tag

# if ([string]::IsNullOrWhiteSpace($Tag) -or [string]::IsNullOrWhiteSpace($tags) -or -not ($tags.split([Environment]::NewLine) -contains $Tag))
# {
#     Write-Output "Specified tag does not exist."
#     exit
# }

$buildInfo = Get-Content "$InfoPath" | ConvertFrom-Json

$buildInfo.info.version = $Tag

$ReleaseName = $buildInfo.info.name + "_" + $buildInfo.info.version

Write-Output "Makng Temp Directory: $ReleaseName"
mkdir $ReleaseName

Write-Output "Copying files to temp location"
Copy-Item -Path "$SourceFolder\*" -Recurse -Destination "$ReleaseName"
ConvertTo-Json $buildInfo.info | % { [System.Text.RegularExpressions.Regex]::Unescape($_) } | Set-Content "$ReleaseName\info.json" -Encoding UTF8

Write-Output "Making Zip File"
Compress-Archive -Path  $ReleaseName -DestinationPath "$ReleaseName.zip"

Remove-Item $ReleaseName -Recurse

