# Out-TShirt

A powershell cmdLet for sending output onto a t-shirt.

Also includes a cmdLet for turning text into an image. 

Put them together and, from the commandline, you can quickly turning a text slogan into a t-shirt available on-line.

(There's also a function, "shirty", which simplifies it all, and demonstrates using both cmdlets together)


# Details

**Out-TShirt**

Given the name of an image file, it will upload that image to an online t-shirt provider (TeeMill/Rapanui) and hand you back a URL where you can purchase the T-Shirt.


**ConvertTo-Image**

Given some text (and a bunch of optional parameters) will give you back the name of a PNG file containing that text.

The optional parameters let you control many aspects of the style and colours of the text image.

## Unicode

You can send unicode characters, such as the famous Emojis to ConvertTo-Image, but that doesn't mean the chosen font family can render them.

In order to see which (if any) of the fonts on my machine would render an Emoji, I wrote the following example. It creates one file for each font family on the machine. You can inspect the files to see if the Emoji shows up. In most cases it is just rendered as a square, or a question mark.


(Relies on the `get-emoji` module.)

Script for creating one image with every font on your machine 

    Add-Type -AssemblyName System.Drawing

    $objFonts = New-Object System.Drawing.Text.InstalledFontCollection
    $objFonts.Families | % {
        $FontName = $_.Name;
        (get-emoji "beer mug") + "`n$FontName" | ConvertTo-Image -mt 50 -fg SteelBlue -bg White -ha Center -FontName $FontName }

# End to End Example 


    "I'm hardcore`nbuddy`nyes I am." | ConvertTo-Image -mt 50 -fg SteelBlue -bg White -fs 48 | Out-TShirt | % { start $_ }
    

With Emoji:
    
    (get-emoji "beer mug") + "`ndinner" | ConvertTo-Image -mt 50 -fg Orange -bg Black -ha Center -fontName "Segoe UI Emoji" | out-tshirt | % { start $_ }
     
