#!/bin/bash
###############################
#  A B O U T
#
# Script by JessicaJ, last updated 2022-07-26
# Shared with https://www.amazonforum.com/s/question/0D56Q000084k8NgSAI/how-to-connect-using-internet-printing-protocol-from-windows
# 
# Modified by Paranoid Android, last update 2025-05-17
# Updated to remove Python scaling code. Modified ImageMagick command to resize to 576 pixels.
# Shared at https://github.com/parandandrd/AmazonStickyNoteSavior
# 
# License: use it how you'd like, commercial or otherwise, just give me credit if you re-share it (leave this A B O U T
#          section intact, appending your own information as appropriate for any modifications you made to the script)
#
# Requisites:
# - Imagemagick, because how else are you going to process images
###############################
#  S E T T I N G S
#
# The file you want to process. Specified as an argument to the script.
infile=$1
#
# The processed output. We could probably capture this to a buffer and send it directly to IPP but it's just easier to use
# an output file. Maybe add a "-d" argument or something if you want it to delete the output file when it's done?
outfile="/tmp/sticky-processed.bmp"
#
# The printer's IP address. I recommend setting up a static assignment for your own sanity!
printerip="PRINTER IP ADDRESS"
#
# The IPP instruction file to use. This gets created/set using the base64-encoded chunk below, but feel free to replace
# with your own file if you know what you're doing.
ippfile="./bitmap.ipp"
#
# Set up the IPP file. Use base64decode.com to see it for yourself if you don't trust this <3
# Alternatively just fill out the $ippfile specified above yourself and remove this line:
echo "ewogIFZFUlNJT04gMi4wCiAgT1BFUkFUSU9OIFByaW50LUpvYgogIFJFUVVFU1QtSUQgNDIKCiAgR1JPVVAgb3BlcmF0aW9uLWF0dHJpYnV0ZXMtdGFnCiAgQVRUUiB1cmkgcHJpbnRlci11cmkgJHVyaQogIEFUVFIgbWltZU1lZGlhVHlwZSBkb2N1bWVudC1mb3JtYXQgaW1hZ2UvcmV2ZXJzZS1lbmNvZGluZy1ibXAKCiAgRklMRSAkZmlsZW5hbWUKfQ==" | base64 -d > "$ippfile"
#
# $infile is our input file (duh)
# -resize: sizes to 576 pixels wide
# -monochrome: converts to black and white
# -flip: vertically flips to get our "reverse-encoded bitmap"
# $outfile is the processed output.
#   The BMP3 prefix keeps it from saving as BMP4 or something else that will break on the printer.
magick "$infile" -resize 576 -monochrome -flip "BMP3:${outfile}"
echo "Converted image to BMP. Sending to printer..."
#
# Send the $outfile processed image via the $ippfile instructions to the printer at $printerip
ipptool -f "$outfile" "ipp://${printerip}/" "$ippfile" -v
echo "Image sent to printer."
#
# Cleans up the temp BMP file.
rm "/tmp/sticky-processed.bmp"
