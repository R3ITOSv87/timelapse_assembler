#!/bin/bash

# Function to get input values either interactively or from arguments
function get_variable() {
    local var_name="$1"
    local prompt="$2"
    local default_value="$3"
    local value

    if [[ -n "${!var_name}" ]]; then
        value="${!var_name}"
    else
        read -p "$prompt [$default_value]: " value
        value="${value:-$default_value}"
    fi

    echo "$value"
}

# Process arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -d|--directory)
            DIRECTORY="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        -f|--fps)
            FPS="$2"
            shift 2
            ;;
        *)
            echo "Unknown option $1"
            exit 1
            ;;
    esac
done

# Prompt for variables if not set
DIRECTORY=$(get_variable DIRECTORY "Enter the directory of images" "./images")
OUTPUT_FILE=$(get_variable OUTPUT_FILE "Enter the output file name" "timelapse.mp4")
FPS=$(get_variable FPS "Enter frames per second (FPS)" "30")

# Check if the specified directory exists
if [[ ! -d "$DIRECTORY" ]]; then
    echo "Error: The directory '$DIRECTORY' does not exist."
    exit 1
fi

# Use ffmpeg to create a timelapse
ffmpeg -pattern_type glob -i "$DIRECTORY/*.jpg" -vf "fps=$FPS" -pix_fmt yuv420p "$OUTPUT_FILE"

if [[ $? -eq 0 ]]; then
    echo "Timelapse successfully created: $OUTPUT_FILE"
else
    echo "Error creating timelapse."
    exit 1
fi
