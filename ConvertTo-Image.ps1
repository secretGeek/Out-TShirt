
function ConvertTo-Image
{
    [CmdletBinding()] 
    param([Parameter(Position=0, Mandatory=$true, ValueFromPipeline = $true)] [PSObject[]]$InputObject) 

    Begin {
        Add-Type -AssemblyName System.Drawing
    }    

    Process {    
    
        foreach ($object in $InputObject) 
        { 

            # From http://stackoverflow.com/questions/2067920/can-i-draw-create-an-image-with-a-given-text-with-powershell
            $filename1 = (Join-Path $psScriptRoot (([guid]::NewGuid().ToString())+".png"))
            #TODO: Configure font name
            #TODO: Configure font size
            $font = new-object System.Drawing.Font Consolas,24 
            $textSize = [System.Windows.Forms.TextRenderer]::MeasureText($object, $font)
            # the size of the image is based on the measure size of the text.
            $bmp1 = new-object System.Drawing.Bitmap ($textSize.Width+20),($textSize.Height+20)
            #TODO: Configure background color (including transparency)
            $brushBg = [System.Drawing.Brushes]::Yellow 
            #TODO: Configure foreground color (including transparency)
            $brushFg = [System.Drawing.Brushes]::Black 
            #TODO: stretch goal... allow for text outline ('stroke')
            #TODO: stretch goal... allow for background to be an image
            $graphics = [System.Drawing.Graphics]::FromImage($bmp1) 
            $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
            $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
            $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
            $graphics.FillRectangle($brushBg,0,0,$bmp1.Width,$bmp1.Height) 
            $graphics.DrawString($object,$font,$brushFg,10,10) 
            $graphics.Dispose() 
            $bmp1.Save($filename1) 
            $fileName1;
        }
    }
}

#Invoke-Item $filename1 