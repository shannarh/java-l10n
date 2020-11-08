$StartTime = Get-Date
$SdkFilename = "OpenJDK15U-jdk_x64_windows_hotspot_15.0.1_9.zip"
$SdkUrl = "https://github.com/AdoptOpenJDK/openjdk15-binaries/releases/download/jdk-15.0.1%2B9/$SdkFilename"
$SdkDescription = "Java SDK 15.0.1+9"
$GradleFilename = "gradle-6.7-bin.zip"
$GradleUrl = "https://services.gradle.org/distributions/$GradleFilename"
$GradleDescription = "Gradle 6.7"

Import-Module BitsTransfer

$BitsRunningOutput = Get-Service -Name "BITS" | Where-Object {$_.Status -eq "Running"}
$BitsRunning = $($BitsRunningOutput -ne $null)

function Download-Dependency {
    param (
        [string]$Url,
        [string]$DestinationFilename,
        [string]$Description
    )

    $DestinationPath = "$PSScriptRoot\$DestinationFilename"

    Write-Output "Downloading $Description from $Url ..."

    if ($BitsRunning) {
        Start-BitsTransfer `
            -Source "$Url" `
            -Destination "$DestinationPath" `
            -DisplayName "Downloading dependencies..." `
            -Description "$Description from $Url" #`
            #-Dynamic  # Otherwise GitHub fails with a 403 Unauthorized
        return
    }

    # Fallback
    Write-Output "Using .NET ..."
    (New-Object System.Net.WebClient).DownloadFile("$Url", "$DestinationPath")
}

#Download-Dependency `
#    -Url $SdkUrl `
#    -DestinationFilename $SdkFilename `
#    -Description $SdkDescription

Download-Dependency `
    -Url $GradleUrl `
    -DestinationFilename $GradleFilename `
    -Description $GradleDescription

Write-Output "Time taken: $((Get-Date).Subtract($StartTime).Seconds) second(s)"
Pause
