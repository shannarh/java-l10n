$StartTime = Get-Date
$BuildDepsPath = "$PSScriptRoot\builddeps"
$SdkFilename = "OpenJDK15U-jdk_x64_windows_hotspot_15.0.1_9.zip"
$SdkUrl = "https://github.com/AdoptOpenJDK/openjdk15-binaries/releases/download/jdk-15.0.1%2B9/$SdkFilename"
$GradleFilename = "gradle-6.7-bin.zip"
$GradleUrl = "https://services.gradle.org/distributions/$GradleFilename"

function Invoke-FileDownload([string]$Url, [string]$Filename) {
    # Author: LincolnAtkinson
    # Source: https://stackoverflow.com/a/18154449/1431146
    Add-Type -TypeDef @"
        using System;
        using System.Text;
        using System.Net;
        using System.IO;

        public class Downloader
        {
            private Uri source;
            private string destination;
            private string log;
            private object syncRoot = new object();
            private int percent = 0;

            public Downloader(string source, string destination, string log)
            {
                this.source = new Uri(source);
                this.destination = destination;
                this.log = log;
            }

            public void Download()
            {
                WebClient wc = new WebClient();
                wc.DownloadProgressChanged += new DownloadProgressChangedEventHandler(OnProgressChanged);
                wc.DownloadFileAsync(source, destination);
            }

            private void OnProgressChanged(object sender, DownloadProgressChangedEventArgs e)
            {
                lock (this.syncRoot)
                {
                    if (e.ProgressPercentage > this.percent)
                    {
                        this.percent = e.ProgressPercentage;
                        string message = String.Format("{0}: {1} percent", DateTime.Now, this.percent);
                        File.AppendAllLines(this.log, new string[1] { message }, Encoding.ASCII);
                    }
                }
            }
        }
"@

    $source = "$Url"
    $dest = "$Filename"
    $log = [io.path]::GetTempFileName()

    $downloader = New-Object Downloader $source,$dest,$log
    # TODO: Error handling
    $downloader.Download();
    
    Write-Output "Downloading $Url"
    do {
        Get-Content $log -Tail 1 -Wait `
         | ? { $_ -match ': (\d+) percent' } `
         | % {
             $percent = [int]$matches[1]
             if ($percent -lt 100) {
                 Write-Progress `
                    -Activity "Downloading $source" `
                    -Status "${percent}% complete" `
                    -PercentComplete $percent
             }
             else {
                 break
             }
         }
    } while ($false) # dummy loop so that `break` can be used above
    Write-Output "Done"
}

# Reset build dependencies directory
if (Test-Path $BuildDepsPath) {
    Remove-Item -Recurse -Path "$BuildDepsPath"
}
New-Item -Type Directory -Path $BuildDepsPath | Out-Null

# Create temp dir
$tempFolderPath = Join-Path $Env:Temp $(New-Guid)
New-Item -Type Directory -Path $tempFolderPath | Out-Null
Write-Output "Temp dir: $tempFolderPath"

# Download dependencies
Write-Output "Downloading dependencies..."
Invoke-FileDownload -Url $SdkUrl -Filename "$tempFolderPath\$SdkFilename"
Invoke-FileDownload -Url $GradleUrl -Filename "$tempFolderPath\$GradleFilename"

# Extract downloaded files
Write-Output "Extracting dependencies..."
Write-Output "Extracting $SdkFilename"
Expand-Archive -Path "$tempFolderPath\$SdkFilename" -DestinationPath "$BuildDepsPath"
Write-Output "Done"
Write-Output "Extracting $GradleFilename"
Expand-Archive -Path "$tempFolderPath\$GradleFilename" -DestinationPath "$BuildDepsPath"
Write-Output "Done"

# Delete temp dir
Remove-Item -Recurse -Path "$tempFolderPath"

Write-Output "Time taken: $((Get-Date).Subtract($StartTime).Seconds) second(s)"
