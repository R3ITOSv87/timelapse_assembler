# Timelapse Script Documentation

## Overview

The timelapse script allows you to automatically compile all images in a given directory into a timelapse video file. The script automatically detects images with timestamps and assembles them into a video in chronological order. Users can either provide variables interactively or directly at script startup via command line arguments.

## Requirements

- **Operating System**: Linux or a similar Unix environment
- **Software**: `ffmpeg` must be installed to create the video from the images. You can install `ffmpeg` using the following command:
  ```bash
  sudo apt-get install ffmpeg
  ```
- **Shell Access**: The script is executed via the command line.

## Usage

The script can be used interactively by running it without parameters or by passing parameters for more flexibility.

### Preparation

Before you can run the script, you need to make it executable. Use the following command:
```bash
chmod +x timelapse_assembler.sh
```

### Execution

#### 1. Interactive Input

Run the script without additional arguments:
```bash
./timelapse_assembler.sh
```
The script will then prompt for the necessary information:
- **Directory of Images**: The path to the directory containing the images (default: `./images`).
- **Output File Name**: The name of the timelapse file to be created (default: `timelapse.mp4`).
- **Frames per Second (FPS)**: The number of frames per second for the video (default: `30`).

#### 2. Running with Command Line Arguments

You can also provide the necessary information directly at startup:
```bash
./timelapse_assembler.sh -d /path/to/images -o output.mp4 -f 25
```
- `-d` or `--directory`: Path to the directory with the images.
- `-o` or `--output`: Name of the output file.
- `-f` or `--fps`: Number of frames per second for the video.

### Example

1. **Interactive**:
   ```bash
   ./timelapse_assembler.sh
   ```
   The script will ask you for the directory, the output file name, and the FPS.

2. **With Arguments**:
   ```bash
   ./timelapse_assembler.sh -d ./images -o timelapse.mp4 -f 24
   ```
   This creates a timelapse from the images in the directory `./images` with 24 FPS and saves it as `timelapse.mp4`.

## Script Functionality

- The script first processes the given arguments. If no arguments are provided, it will prompt for the required variables interactively.
- It then checks whether the specified directory exists. If it does not, an error message is displayed and the script terminates.
- Using `ffmpeg`, all `.jpg` images in the given directory are assembled into a timelapse video. The `-pattern_type glob` parameter allows the use of wildcards to find all `.jpg` files.
- The video is saved as an MP4 file, with the specified frame rate (`FPS`) and output file name (`OUTPUT_FILE`).

## Troubleshooting

- **Error: "The directory does not exist"**: Ensure that the path is correct and the directory exists.
- **`ffmpeg` Error**: Make sure `ffmpeg` is installed and available in the system path. Check by running:
  ```bash
  ffmpeg -version
  ```
- **Permission Issues**: Ensure that you have the necessary write permissions for the directory where the output file will be saved.

## Extensions
- **File Formats**: The script is designed to process only `.jpg` files. It could be extended to support other image formats (`.png`, `.jpeg`, etc.).
- **Parallel Processing**: For very large numbers of images, parallelization or preprocessing could help speed up the timelapse creation.
- **Additional Filters**: The `ffmpeg` command can be adjusted to add additional video effects or filters, such as adding music or watermarks.

## Conclusion
The script provides a simple way to create a timelapse from a collection of images. It is flexible in usage, supporting both interactive input and command line control. With appropriate adjustments, the script can be tailored to meet various video editing needs.
