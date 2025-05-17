# The Amazon Sticky Note Printer Savior

A method for printing images to an Amazon Smart Sticky Note Printer via IPP.

For Linux and macOS, the included script will take an image file as an argument,
perform the necessary conversions, and send it to the Amazon Smart Sticky Note Printer.
The IP address of the printer must be be entered into the script as the "printerip"
variable.

Example usage: `sh stickyprint.sh test.png`

For macOS, the included shortcut provides a Finder Quick Action that can be
used to send any image file to the Amazon Smart Sticky Note Printer. The IP address of the
printer must be entered into the "Run Shell Script" section of the shortcut as the
"printerip" variable.

For both the script and shortcut, ImageMagick must be installed (you can get it via
Homebrew on macOS, most Linux distros will have it available as a package).

The image is always converted to 576 pixels wide (the maximum width of the printer)
while maintaining aspect ratio.

The Amazon Sticky Note Printer must be configured with the Alexa app to
connect to your Wi-Fi.

# Background

A few years ago, Amazon released this "Smart" Sticky Note Printer that advertised itself as
being "IPP compatible", but in the real world, no drivers were ever released for the
printer so it could only be used for the very limited functionality available through
Alexa.

The printer itself is actually available via IPP, however, but can only accept a few
very specific formats: plain text, "reverse-encoded BMP", and some variants of PDF.

Back when I was playing with the printer in 2022, I was able to get as far as printing
plain text, but no further. I recently discovered JessicaJ's script, posted to Amazon's
customer service forums [here](https://www.amazonforum.com/s/question/0D56Q000084k8NgSAI/how-to-connect-using-internet-printing-protocol-from-windows).

The script was further refined and integrated into a macOS shortcut for easy access. I'm
making it available on GitHub in the hope that someone, somewhere, with one of these mostly 
useless devices will be able to use this to get some good out of it.

# To-Do

• Improve scaling behavior - add option to retain size for items smaller than 576px.

• Add text printing support.
