# Define color codes
$ErrorColour = "Red"
$PassColour = "Green"
$ExitMessage = "Press Enter to exit"

# Function to determine the file type based on the file signature
function Get-FileType {
    param (
        [byte[]]$FileBytes
    )

    # Convert bytes to hex string
    $fileSignature = ($FileBytes[0..3] | ForEach-Object { $_.ToString("X2") }) -join ' '

    switch ($fileSignature) {
        'FF D8 FF E0' { return "jpg" }
        '89 50 4E 47' { return "png" }
        '47 49 46 38' { return "gif" }
        '25 50 44 46' { return "pdf" }
        '50 4B 03 04' { return "zip" }
        '42 4D'       { return "bmp" }
        '49 44 33'    { return "mp3" }
        '52 49 46 46' { return "avi" }
        '00 00 01 BA' { return "mpg" }
        '1F 8B 08'    { return "gz" }
        '25 21 50 53' { return "ps" }
        'D0 CF 11 E0' { return "doc" }
        '7F 45 4C 46' { return "elf" }
        '52 61 72 21' { return "rar" }
        '3C 3F 78 6D' { return "xml" }
        '50 4B 07 08' { return "docx" }
        '50 4B 05 06' { return "jar" }
        '50 4B 03 04' { return "xlsx" }
        '7B 5C 72 74' { return "rtf" }
        '38 42 50 53' { return "psd" }
        '66 74 79 70' { return "mp4" }
        '00 01 00 00' { return "ico" }
        '4F 67 67 53' { return "ogg" }
        '66 4C 61 43' { return "flac" }
        '25 50 58 20' { return "pxd" }
        'FF FB'       { return "mp3" }
        '4D 5A'       { return "exe" }
        default       { return $null }
    }
}

# Main function that performs the operations
function Main {
    # Find the path to the user's AppData\Roaming\discord\Cache\Cache_Data folder
    $roamingPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('ApplicationData'), "discord", "Cache", "Cache_Data")

    # Path to the desktop
    $desktopPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'))

    # Create a timestamp for the folder name
    $timestamp = Get-Date -Format "yyyyddMMHHmmss"

    # Path to the new folder on the desktop with timestamp
    $newFolderPath = [System.IO.Path]::Combine($desktopPath, "discSniffoutput_$timestamp")

    # Create the new folder if it doesn't exist
    if (-not (Test-Path -Path $newFolderPath)) {
        New-Item -ItemType Directory -Path $newFolderPath
    }

    # Copy files to the new folder
    Get-ChildItem -Path $roamingPath | Copy-Item -Destination $newFolderPath

    # Process each file in the new folder
    Get-ChildItem -Path $newFolderPath | ForEach-Object {
        $filePath = $_.FullName
        $fileBytes = [System.IO.File]::ReadAllBytes($filePath)

        # Determine the file type
        $fileType = Get-FileType -FileBytes $fileBytes

        if ($fileType) {
            $newFileName = "$($_.BaseName).$fileType"
            Rename-Item -Path $filePath -NewName $newFileName
            Write-Host "Converted $filePath to $newFileName" -ForegroundColor $PassColour
        } else {
            Write-Host "Unknown file type for $filePath" -ForegroundColor $ErrorColour
        }
    }

    Write-Host "Files copied and converted successfully." -ForegroundColor $PassColour
}

# ASCII art and GitHub information
$asciiArt = @"
_____  _                       _        _____       _  __  __          
|  __ \(_)                     | |      / ____|     (_)/ _|/ _|         
| |  | |_ ___  ___ ___  _ __ __| |_____| (___  _ __  _| |_| |_ ___ _ __ 
| |  | | / __|/ __/ _ \| '__/ _` |______\___ \| '_ \| |  _|  _/ _ \ '__|
| |__| | \__ \ (_| (_) | | | (_| |      ____) | | | | | | | ||  __/ |   
|_____/|_|___/\___\___/|_|  \__,_|     |_____/|_| |_|_|_| |_| \___|_|   
"@

$githubText = @"
    GitHub: DeadDove13
"@

# Display ASCII art and GitHub information
Write-Host $asciiArt -ForegroundColor Blue
Write-Host $githubText -ForegroundColor White

# Description of the script
$description = @"

This script automates the process of deobfuscating and organizing Discord cache files.
The processed files will be saved in a folder named `discSniffoutput_<timestamp>` 
on your desktop, where `<timestamp>` is the date and time of execution.

"@

Write-Host $description -ForegroundColor Yellow

# User input loop to run the script or exit
do {
    $choice = Read-Host "Press 1 to run the script or 0 to close"

    # Execute based on user's choice
    if ($choice -eq "1") {
        Main
        break
    } elseif ($choice -eq "0") {
        Write-Host "Exiting the script." -ForegroundColor White
        Exit
    } else {
        Write-Host "B R U H!!! Invalid input. Please try again." -ForegroundColor $ErrorColour
    }
} while ($true)

# Prompt to exit
Read-Host -Prompt $ExitMessage
