# Discord-Sniffer

Discord-Sniffer is a PowerShell script that extracts and converts Discord cache files into their correct formats.

## What It Does

- Extracts Discord cache files from `AppData\Roaming\discord\Cache\Cache_Data`.
- Identifies the file type based on its signature.
- Renames the files with the correct extension.
- Saves the processed files in a timestamped folder on your desktop.

## How to Use

1. **Download** the script by cloning the repository or downloading the script file directly.
2. **Run** the script in a PowerShell terminal.
3. **Follow** the on-screen prompts:
   - Press `1` to run the script.
   - Press `0` to exit.

## How It Works

1. **File Extraction**:
   - The script locates the Discord cache folder in your `AppData` directory.
   - It copies all files to a new folder on your desktop named `discSniffoutput_<timestamp>`.

2. **File Type Detection**:
   - The script reads the file signatures (the first few bytes of each file) to determine its type.
   - It renames the file with the appropriate extension (e.g., `.jpg`, `.png`).

3. **Output**:
   - The processed files are saved in the `discSniffoutput_<timestamp>` folder on your desktop.

## Author

- GitHub: [DeadDove13](https://github.com/DeadDove13)
