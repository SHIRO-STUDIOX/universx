# Variables
HUGGING_FACE_TOKEN="hf_your_token_here"  # Hugging Face Token
UNET_MODEL_LINK="https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/flux1-dev.safetensors"  # UNET Model link
VAE_MODEL_LINK="https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/ae.safetensors"  # VAE Model link
CLIP_TEXTENCODER_MODEL_LINK="https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors"  # CLIP FLUX Text Encoder link
CLIP_FP16_MODEL_LINK="https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors"  # CLIP FP16 Model link

# Save Path File
SAVE_PATH_UNET="/workspace/ComfyUI/models/unet/"  # Save Path for UNET Model
SAVE_PATH_VAE="/workspace/ComfyUI/models/vae/"  # Save Path for VAE Model
SAVE_PATH_CLIP_TEXTENCODER="/workspace/ComfyUI/models/clip/"  # Save Path for CLIP FLUX Text Encoder
SAVE_PATH_CLIP_FP16="/workspace/ComfyUI/models/clip/"  # Save Path for CLIP FP16

# Function to get the file size from the URL
get_file_size() {
  local model_link=$1
  # Using curl to get the file size from the server (Content-Length in bytes)
  file_size=$(curl -sI --header "Authorization: Bearer $HUGGING_FACE_TOKEN" "$model_link" | grep -i Content-Length | awk '{print $2}' | tr -d '\r')
  echo $file_size
}

# Function to download model and verify file size
download_model() {
  local model_link=$1
  local save_path=$2
  local filename=$(basename "$model_link")

  # Create directory if it doesn't exist
  mkdir -p "$save_path"

  # Get original file size from the server
  original_size=$(get_file_size "$model_link")

  # Check if the file already exists
  if [ -f "$save_path/$filename" ]; then
    # Get the size of the downloaded file
    downloaded_size=$(stat -c%s "$save_path/$filename")

    # Compare the sizes
    if [ "$original_size" -eq "$downloaded_size" ]; then
      echo "File $filename already exists and matches the original size. Skipping download."
      return
    else
      echo "File $filename exists but size does not match. Redownloading..."
      rm "$save_path/$filename"
    fi
  fi

  # Download the file
  wget --header="Authorization: Bearer $HUGGING_FACE_TOKEN" "$model_link" -P "$save_path"

  # Check size again after download
  downloaded_size=$(stat -c%s "$save_path/$filename")

  if [ "$original_size" -eq "$downloaded_size" ]; then
    echo "File $filename downloaded successfully and size matches."
  else
    echo "Error: File $filename size does not match after download. Retrying..."
    rm "$save_path/$filename"
    wget --header="Authorization: Bearer $HUGGING_FACE_TOKEN" "$model_link" -P "$save_path"
  fi
}

# 1. Download UNET Model
echo "Downloading UNET Model..."
download_model "$UNET_MODEL_LINK" "$SAVE_PATH_UNET"

# 2. Download VAE Model
echo "Downloading VAE Model..."
download_model "$VAE_MODEL_LINK" "$SAVE_PATH_VAE"

# 3. Download CLIP FLUX Text Encoder
echo "Downloading CLIP FLUX Text Encoder..."
download_model "$CLIP_TEXTENCODER_MODEL_LINK" "$SAVE_PATH_CLIP_TEXTENCODER"

# 4. Download CLIP FP16
echo "Downloading CLIP FP16..."
download_model "$CLIP_FP16_MODEL_LINK" "$SAVE_PATH_CLIP_FP16"

# Success message
echo "Download and installation completed successfully."
