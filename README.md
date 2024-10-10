# Timelapse Script Documentation

## Overview

The timelapse script allows you to automatically compile all images in a given directory into a timelapse video file. The script detects images with timestamps and assembles them in chronological order. Users can either provide variables interactively or directly at script startup via command line arguments.

## Requirements

- **Operating System**: Linux or a similar Unix environment
- **Software**:
  - `ffmpeg` must be installed to create the video from the images. You can install `ffmpeg` using the following command:
    ```bash
    sudo apt-get install ffmpeg
    ```
  - `ImageMagick` must be installed for filtering out dark images. You can install it using:
    ```bash
    sudo apt-get install imagemagick
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
- **Remove Dark Images**: The option to remove dark images from the timelapse (default: `no`).

#### 2. Running with Command Line Arguments

You can also provide the necessary information directly at startup:
```bash
./timelapse_assembler.sh -d /path/to/images -o output.mp4 -f 25 --remove-dark
```
- `-d` or `--directory`: Path to the directory with the images.
- `-o` or `--output`: Name of the output file.
- `-f` or `--fps`: Number of frames per second for the video.
- `--remove-dark`: Optional flag to filter out dark images.

### Example

1. **Interactive**:
   ```bash
   ./timelapse_assembler.sh
   ```
   The script will ask you for the directory, the output file name, the FPS, and whether to remove dark images.

2. **With Arguments**:
   ```bash
   ./timelapse_assembler.sh -d ./images -o timelapse.mp4 -f 24 --remove-dark
   ```
   This creates a timelapse from the images in the directory `./images` with 24 FPS, removes dark images, and saves it as `timelapse.mp4`.

## Script Functionality

- The script first processes any provided arguments. If no arguments are provided, it will prompt the user interactively for the required variables.
- It checks if the specified directory exists. If not, an error message is displayed, and the script terminates.
- If the `--remove-dark` option is used or selected, the script filters out dark images by calculating their brightness using `ImageMagick`. Only images above a certain brightness threshold are included.
- Using `ffmpeg`, the remaining `.jpg` images in the given directory are assembled into a timelapse video. The `-pattern_type glob` parameter allows the use of wildcards to find all `.jpg` files.
- The video is saved as an MP4 file, with the specified frame rate (`FPS`) and output file name (`OUTPUT_FILE`).

## Troubleshooting

- **Error: "The directory does not exist"**: Ensure that the path is correct and the directory exists.
- **`ffmpeg` or `ImageMagick` Error**: Make sure `ffmpeg` and `ImageMagick` are installed and available in the system path. You can verify their installation with:
  ```bash
  ffmpeg -version
  convert -version
  ```
- **Permission Issues**: Ensure that you have the necessary permissions for the directories and files being accessed.

## Extensions
- **File Formats**: The script is designed to process only `.jpg` files. It could be extended to support other image formats (`.png`, `.jpeg`, etc.).
- **Parallel Processing**: For a large number of images, consider optimizing the filtering process by parallelizing it.
- **Additional Filters**: You can add more `ffmpeg` filters to adjust the video output, such as adding text overlays or watermarks.

## Conclusion
The script provides a simple way to create a timelapse from a collection of images. It is flexible in usage, supporting both interactive input and command line control. With appropriate adjustments, the script can be tailored to meet various video editing needs.

