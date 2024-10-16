#!/bin/bash

# Function to get input values either interactively or from arguments
function get_variable() {
    local var_name="$1"
    local prompt="$2"
    local default_value="$3"
    local value

    read -p "$prompt [$default_value]: " value
    value="${value:-$default_value}"
    echo "$value"
}

# Process arguments
REMOVE_DARK=false
STABILIZE=false
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
        --remove-dark)
            REMOVE_DARK=true
            shift 1
            ;;
        --stabilize)
            STABILIZE=true
            shift 1
            ;;
        *)
            echo "Error: Unknown option '$1'. Use -h or --help for usage information."
            exit 1
            ;;
    esac
done

# Prompt for variables if not set
DIRECTORY=$(get_variable "DIRECTORY" "Enter the directory of images" "./images")
OUTPUT_FILE=$(get_variable "OUTPUT_FILE" "Enter the output file name" "timelapse.mp4")
FPS=$(get_variable "FPS" "Enter frames per second (FPS)" "30")

# Ask interactively if dark images should be removed
REMOVE_DARK_INPUT=$(get_variable "REMOVE_DARK" "Do you want to remove dark images? (yes/no)" "yes")
if [[ "$REMOVE_DARK_INPUT" == "yes" ]]; then
    REMOVE_DARK=true
else
    REMOVE_DARK=false
fi

# Ask interactively if stabilization should be applied
STABILIZE_INPUT=$(get_variable "STABILIZE" "Do you want to stabilize the timelapse? (yes/no)" "yes")
if [[ "$STABILIZE_INPUT" == "yes" ]]; then
    STABILIZE=true
else
    STABILIZE=false
fi

# Check if the specified directory exists
if [[ ! -d "$DIRECTORY" ]]; then
    echo "Error: The directory '$DIRECTORY' does not exist."
    exit 1
fi

# Create a temporary directory for filtered images if dark images should be removed
if [ "$REMOVE_DARK" = true ]; then
    temp_dir=$(mktemp -d)
    echo "Filtering out dark images..."
    for image in "$DIRECTORY"/*.jpg; do
        if [[ -f "$image" ]]; then
            avg_brightness=$(convert "$image" -colorspace Gray -format "%[fx:mean*255]" info: 2>/dev/null)
            if (( $(awk "BEGIN {print ($avg_brightness >= 25)}") )); then
                cp "$image" "$temp_dir"
            else
                echo "Skipping dark image: $image"
            fi
        fi
    done
    DIRECTORY="$temp_dir"
fi

# Use ffmpeg to create a timelapse
ffmpeg -pattern_type glob -i "$DIRECTORY/*.jpg" -vf "fps=$FPS" -pix_fmt yuvj420p "$OUTPUT_FILE" || {
    echo "Error creating timelapse."
    exit 1
}

# Stabilize the timelapse if requested
if [ "$STABILIZE" = true ]; then
    echo "Stabilizing the timelapse..."
    ffmpeg -i "$OUTPUT_FILE" -vf vidstabdetect=shakiness=10:accuracy=15:result="transforms.trf" -f null -
    ffmpeg -i "$OUTPUT_FILE" -vf vidstabtransform=smoothing=30:input="transforms.trf" -c:v libx264 -preset slow -crf 18 "$OUTPUT_FILE"_stabilized.mp4 || {
        echo "Error stabilizing timelapse."
        exit 1
    }
    mv "$OUTPUT_FILE"_stabilized.mp4 "$OUTPUT_FILE"
fi

# Clean up temporary directory if used
if [ "$REMOVE_DARK" = true ]; then
    rm -rf "$temp_dir"
fi

# Display success message
echo "Timelapse successfully created: $OUTPUT_FILE"
