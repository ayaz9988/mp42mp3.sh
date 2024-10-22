#!/bin/bash

# Function to check if ffmpeg is installed
check_ffmpeg() {
  if command -v ffmpeg &> /dev/null; then
    echo "ffmpeg is installed."
  else
    echo "ffmpeg is not installed. Installing it now..."
    install_ffmpeg
  fi
}

# Function to install ffmpeg based on the Linux distribution
install_ffmpeg() {
  # Check the package manager
  if [ -x "$(command -v apt)" ]; then
    # For Debian, Ubuntu, and Mint
    sudo apt update && sudo apt install -y ffmpeg
  elif [ -x "$(command -v dnf)" ]; then
    # For Fedora, RHEL, CentOS
    sudo dnf install -y ffmpeg
  elif [ -x "$(command -v yum)" ]; then
    # For older RHEL/CentOS versions
    sudo yum install -y ffmpeg
  elif [ -x "$(command -v pacman)" ]; then
    # For Arch Linux and its derivatives
    sudo pacman -S ffmpeg
  elif [ -x "$(command -v zypper)" ]; then
    # For OpenSUSE
    sudo zypper install ffmpeg
  elif [ -x "$(command -v apk)" ]; then
    # For Alpine Linux
    sudo apk add ffmpeg
  elif [ -x "$(command -v pkg)" ]; then
    # For FreeBSD
    sudo pkg install ffmpeg
  else
    echo "Unsupported system. Please install ffmpeg manually."
    exit 1
  fi
}

# Check if ffmpeg is installed
check_ffmpeg

# Specify the input and output directories from command-line arguments
if [ $# -ne 2 ]; then
  echo "Usage: $0 <input_directory> <output_directory>"
  exit 1
fi

INPUT_DIR="$1"
OUTPUT_DIR="$2"

# Create the output directory if it does not exist
mkdir -p "$OUTPUT_DIR"

# Loop through all .mp4 files in the input directory
for file in "$INPUT_DIR"/*.mp4; do
  # Check if the file exists
  if [ -f "$file" ]; then
    # Extract the filename without the extension
    filename=$(basename "$file" .mp4)
    # Check if the output .mp3 file already exists
    if [ -f "$OUTPUT_DIR/$filename.mp3" ]; then
      echo "File $OUTPUT_DIR/$filename.mp3 already exists. Skipping..."
    else
      # Convert the file to mp3 and save it in the output directory
      ffmpeg -i "$file" -vn -acodec libmp3lame -ab 192k "$OUTPUT_DIR/$filename.mp3"
      echo "Converted $file to $OUTPUT_DIR/$filename.mp3"
    fi
  else
    echo "File $file does not exist. Skipping..."
  fi
done
