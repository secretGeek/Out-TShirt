# Out-TShirt

A powershell cmdLet for sending output onto a t-shirt.

Also includes a cmdLet for turning text into an image. 

# Details

**Out-TShirt**



**ConvertTo-Image**


You can send unicode characters, such as the famous Emojis to ConvertTo-Image, but that doesn't mean the chosen font family can render them.

In order to see which (if any) of the fonts on my machine would render an Emoji, I wrote the following example. It creates on file for each font family on the machine. You can inspect the files to see if the Emoji shows up. In most cases it is just rendered as a square, or a question mark.


Script for creating one image with every font on your machine 

    Add-Type -AssemblyName System.Drawing

    $objFonts = New-Object System.Drawing.Text.InstalledFontCollection
    $objFonts.Families | % {
        $FontName = $_.Name;
        (get-emoji "beer mug") + "`n$FontName" | ConvertTo-Image -mt 50 -fg SteelBlue -bg White -ha Center -FontName $FontName }

# End to End Example 


    "I'm hardcore`nbuddy`nyes I am." | ConvertTo-Image -mt 50 -fg SteelBlue -bg White -fs 48 | Out-TShirt | % { start $_ }
    
    
    (get-emoji "beer mug") + "`nIt's what's for dinner" | ConvertTo-Image -mt 50 -fg SteelBlue -bg White -ha Center | % { start $_ }
    
    (get-emoji "beer mug") + "`nIt's what's for dinner" | ConvertTo-Image -mt 50 -fg SteelBlue -bg White -ha Center | Out-TShirt | % { start $_ }