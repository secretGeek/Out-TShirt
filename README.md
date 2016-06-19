# Out-TShirt

A powershell cmdLet for sending output onto a t-shirt.

Also includes a cmdLet for turning text into an image. 

# Details

**Out-TShirt**



**ConvertTo-Image**



# Example


    "I'm hardcore`nbuddy`nyes I am." | ConvertTo-Image -mt 50 -fg SteelBlue -bg White -fs 48 | Out-TShirt | % { start $_ }