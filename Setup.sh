# متغیرها
HUGGING_FACE_TOKEN="hf_your_token_here"  # توکن Hugging Face خود را وارد کنید
UNET_MODEL_LINK="https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/flux1-dev.safetensors"  # لینک فایل Model UNET
VAE_MODEL_LINK="https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/ae.safetensors"  # لینک فایل Model VAE
CLIP_TEXTENCODER_MODEL_LINK="https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors"  # لینک فایل CLIP FLUX Text Encoder
CLIP_FP16_MODEL_LINK="https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors"  # لینک فایل CLIP FP16

# مسیرهای ذخیره‌سازی
SAVE_PATH_UNET="/workspace/ComfyUI/models/unet/"  # مسیر ذخیره‌سازی Model UNET
SAVE_PATH_VAE="/workspace/ComfyUI/models/vae/"  # مسیر ذخیره‌سازی Model VAE
SAVE_PATH_CLIP_TEXTENCODER="/workspace/ComfyUI/models/clip/"  # مسیر ذخیره‌سازی CLIP FLUX Text Encoder
SAVE_PATH_CLIP_FP16="/workspace/ComfyUI/models/clip/"  # مسیر ذخیره‌سازی CLIP FP16

# تابع Download و حفظ نام فایل اورجینال
download_model() {
  local model_link=$1
  local save_path=$2
  local filename=$(basename "$model_link")

  # ساخت پوشه در صورت وجود نداشتن
  mkdir -p "$save_path"
  
  # بررسی وجود فایل قبل از دانلود
  if [ ! -f "$save_path/$filename" ]; then
    # Download فایل با حفظ نام اصلی
    wget --header="Authorization: Bearer $HUGGING_FACE_TOKEN" "$model_link" -P "$save_path"
  else
    echo "فایل $filename از قبل وجود دارد. Download نمی شود."
  fi
}

# 1. Download Model UNET
echo "Download Model UNET..."
download_model "$UNET_MODEL_LINK" "$SAVE_PATH_UNET"

# 2. Download Model VAE
echo "Download Model VAE..."
download_model "$VAE_MODEL_LINK" "$SAVE_PATH_VAE"

# 3. Download CLIP FLUX Text Encoder
echo "Download CLIP FLUX Text Encoder..."
download_model "$CLIP_TEXTENCODER_MODEL_LINK" "$SAVE_PATH_CLIP_TEXTENCODER"

# 4. Download CLIP FP16
echo "Download CLIP FP16..."
download_model "$CLIP_FP16_MODEL_LINK" "$SAVE_PATH_CLIP_FP16"

# پیام موفقیت‌آمیز بودن عملیات
echo "Download and install successfully"
