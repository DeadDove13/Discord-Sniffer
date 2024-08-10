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
        'FF D8 FF E0' { return "jpg" }       # JPEG image
        '89 50 4E 47' { return "png" }       # PNG image
        '47 49 46 38' { return "gif" }       # GIF image
        '25 50 44 46' { return "pdf" }       # PDF document
        '50 4B 03 04' { return "zip" }       # ZIP archive
        '42 4D'       { return "bmp" }       # BMP image
        '49 44 33'    { return "mp3" }       # MP3 audio
        '52 49 46 46' { return "avi" }       # AVI video
        '00 00 01 BA' { return "mpg" }       # MPEG video
        '1F 8B 08'    { return "gz" }        # GZIP compressed file
        '25 21 50 53' { return "ps" }        # PostScript file
        'D0 CF 11 E0' { return "doc" }       # DOC (Microsoft Word)
        '7F 45 4C 46' { return "elf" }       # ELF (Executable and Linkable Format)
        '52 61 72 21' { return "rar" }       # RAR archive
        '3C 3F 78 6D' { return "xml" }       # XML document
        '50 4B 07 08' { return "docx" }      # DOCX (Microsoft Word)
        '50 4B 05 06' { return "jar" }       # JAR (Java archive)
        '50 4B 03 04' { return "xlsx" }      # XLSX (Microsoft Excel)
        '7B 5C 72 74' { return "rtf" }       # RTF (Rich Text Format)
        '38 42 50 53' { return "psd" }       # PSD (Adobe Photoshop)
        '66 74 79 70' { return "mp4" }       # MP4 video
        '00 01 00 00' { return "ico" }       # ICO (Icon file)
        '4F 67 67 53' { return "ogg" }       # OGG (Audio or video file)
        '66 4C 61 43' { return "flac" }      # FLAC (Audio file)
        '25 50 58 20' { return "pxd" }       # PXD (Pixel data)
        'FF FB'       { return "mp3" }       # MP3 audio (alternative signature)
        '4D 5A'       { return "exe" }       # EXE (Executable)
        default       { return $null }       # Default case if no match
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
