param (
    [switch] $NoClean,
    [switch] $NoPublish,
    [string] $InfoPath = "config/buildinfo.json",
    [string] $SourceFolder = "src"
)

$buildInfo = Get-Content "$InfoPath" | ConvertFrom-Json

$resolvedPath = rvpa $buildInfo.output_directory
$modsDir = $resolvedPath.ToString()

if(!$NoClean) {
    $glob = "$modsDir\" + $buildInfo.info.name + "_*"
    $oldDirs = ls -Path $glob -Name
    foreach ($dir in $oldDirs)
    {
        rmdir "$modsDir\$dir" -Recurse
    }
}

if (!$NoPublish) {
    $newDir = "$modsDir\" + $buildInfo.info.name + "_" + $buildInfo.info.version
    echo "$newDir"
    cp -Path "$SourceFolder" -Recurse -Destination "$newDir"
    ConvertTo-Json $buildInfo.info | Set-Content "$newDir\info.json"
}
