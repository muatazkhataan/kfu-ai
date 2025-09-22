#!/usr/bin/env python3
"""
Script to generate Android launch screen icon from mosa3ed_kfu_icon_app.jpg
"""

import os
from PIL import Image, ImageOps
import shutil

def create_android_launch_icon(image_path, output_path, size):
    """Create an Android launch screen icon from the source image"""
    try:
        # Open the image
        img = Image.open(image_path)
        
        # Convert to RGBA if not already
        if img.mode != 'RGBA':
            img = img.convert('RGBA')
        
        # Calculate the scaling factor to fit the image within the target size
        # while maintaining aspect ratio
        width, height = img.size
        scale = min(size / width, size / height)
        
        # Calculate new dimensions
        new_width = int(width * scale)
        new_height = int(height * scale)
        
        # Resize the image while maintaining aspect ratio
        img = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
        
        # Create a new image with the target size and transparent background
        new_img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
        
        # Calculate position to center the image
        x = (size - new_width) // 2
        y = (size - new_height) // 2
        
        # Paste the resized image onto the center of the new image
        new_img.paste(img, (x, y), img)
        
        # Save the icon
        new_img.save(output_path, 'PNG')
        print(f"Created {output_path} ({size}x{size}) with aspect ratio preserved")
        
    except Exception as e:
        print(f"Error creating {output_path}: {e}")

def main():
    # Source image path
    source_image = "assets/images/mosa3ed_kfu_icon_app.jpg"
    
    if not os.path.exists(source_image):
        print(f"Source image not found: {source_image}")
        return
    
    print("Generating Android launch screen icon from mosa3ed_kfu_icon_app.jpg...")
    
    # Android launch icon size (larger for better visibility)
    android_launch_size = 200
    
    # Create the launch icon
    output_path = "android/app/src/main/res/mipmap-xxxhdpi/launcher_icon.png"
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    
    create_android_launch_icon(source_image, output_path, android_launch_size)
    
    print("\nAndroid launch screen icon generated successfully!")

if __name__ == "__main__":
    main()