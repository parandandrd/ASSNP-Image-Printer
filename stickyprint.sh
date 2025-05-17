#!/bin/bash
###############################
#  A B O U T
#
# Script by JessicaJ, last updated 2022-07-26
# Shared with https://www.amazonforum.com/s/question/0D56Q000084k8NgSAI/how-to-connect-using-internet-printing-protocol-from-windows
#
# License: use it how you'd like, commercial or otherwise, just give me credit if you re-share it (leave this A B O U T
#          section intact, appending your own information as appropriate for any modifications you made to the script)
#
# Requisites:
# - Some flavor of Python for floating point math
# - Imagemagick, because how else are you going to process images?
###############################
#  S E T T I N G S
#
echo "Enter the pathname:"
read filename
# The file you want to process. You could also do clever stuff like specifying this as an argument to the script.
infile=$filename
#
# The processed output. We could probably capture this to a buffer and send it directly to IPP but it's just easier to use
# an output file. Maybe add a "-d" argument or something if you want it to delete the output file when it's done?
outfile="/tmp/sticky-processed.bmp"
#
# The printer's IP address. I recommend setting up a static assignment for your own sanity!
printerip="10.0.1.153"
#
# The IPP instruction file to use. This gets created/set using the base64-encoded chunk below, but feel free to replace
# with your own file if you know what you're doing.
ippfile="./bitmap.ipp"
#
# Maximum width. For the Amazon Sticky Note Printer (and probably most similar white-label/knockoffs) this is 576px
maxw=576
###############################
# Stuff below is for nerds. Here be dragons, etc etc.

# Set up the IPP file. Use base64decode.com to see it for yourself if you don't trust this <3
# Alternatively just fill out the $ippfile specified above yourself and remove this line:
echo "ewogIFZFUlNJT04gMi4wCiAgT1BFUkFUSU9OIFByaW50LUpvYgogIFJFUVVFU1QtSUQgNDIKCiAgR1JPVVAgb3BlcmF0aW9uLWF0dHJpYnV0ZXMtdGFnCiAgQVRUUiB1cmkgcHJpbnRlci11cmkgJHVyaQogIEFUVFIgbWltZU1lZGlhVHlwZSBkb2N1bWVudC1mb3JtYXQgaW1hZ2UvcmV2ZXJzZS1lbmNvZGluZy1ibXAKCiAgRklMRSAkZmlsZW5hbWUKfQ==" | base64 -d > "$ippfile"

# This assumes a valid image file; should probably do error checking in case it's not :P
size=$(identify "$infile" | cut -d' ' -f 3)
w=${size%%x*}
h=${size##*x}

# Text output for informational purposes. Remove it if you'd like.
echo "${w} wide by ${h} high"

# Default scale = 100%
scale=100
neww="$w"
newh="$h"

# If it's wider than the printer can deal with
if (( w > maxw )); then
  # cheap hack to get scale percentage to two decimal places, but rounded down
  scale="$(python -c "print(int(${maxw}0000/${w})/100)")"
  neww="$(python -c "print(round(${w} * (${scale}/100)))")"
  newh="$(python -c "print(round(${h} * (${scale}/100)))")"
fi

# More text output, remove if you'd like.
echo "Scaling to ${scale}%"
echo "New dimensions: ${neww}x${newh}"

# Do the actual conversion:
# $infile is our input file (duh)
# -scale: resizes with a box filter, if the image is too big
# -threshold: convert to B&W... feel free to fiddle with the percentage if you're so inclined
# -colors: forces to two-color bitmap (anything else breaks on the printer)
# -flip: vertically flips to get our "reverse-encoded bitmap"
# $outfile is the processed output.
#   The BMP3 prefix keeps it from saving as BMP4 or something else that will break on the printer.
convert "$infile" -resize 576 -threshold 50% -colors 2 -flip "BMP3:${outfile}"
echo "Converted file to BMP. Sending to printer..."
# Send the $outfile processed image via the $ippfile instructions to the printer at $printerip
ipptool -f "$outfile" "ipp://${printerip}/" "$ippfile" -v
echo "Check printer for output"
