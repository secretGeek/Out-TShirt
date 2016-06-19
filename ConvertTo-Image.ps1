
function ConvertTo-Image
{
    [CmdletBinding()] 
    param(
        [Parameter(Position=0, Mandatory=$true, ValueFromPipeline = $true)] [PSObject[]]$InputObject,
        
        [parameter(Mandatory=$false)][alias("F")][string]$FontName = "Consolas",
        [parameter(Mandatory=$false)][alias("BG")][string]$BackgroundColor = "Black",
        [parameter(Mandatory=$false)][alias("FG")][string]$ForegroundColor = "Green",
        [parameter(Mandatory=$false)][alias("FS")][int]$FontSize = 24,
        [parameter(Mandatory=$false)][alias("ML")][int]$MarginLeft = 10,
        [parameter(Mandatory=$false)][alias("MR")][int]$MarginRight = 10,
        [parameter(Mandatory=$false)][alias("MT")][int]$MarginTop = 10,
        [parameter(Mandatory=$false)][alias("MB")][int]$MarginBottom = 10
    ) 

    Begin {
        Add-Type -AssemblyName System.Drawing
    }    

    Process {    
    
        foreach ($object in $InputObject) 
        { 
            # From http://stackoverflow.com/questions/2067920/can-i-draw-create-an-image-with-a-given-text-with-powershell
            $filename1 = (Join-Path $psScriptRoot (([guid]::NewGuid().ToString())+".png"))
            #TODO: If text contains newlines (is multi line) then alignment becomes important.
            $font = new-object System.Drawing.Font $FontName,$FontSize
            $textSize = [System.Windows.Forms.TextRenderer]::MeasureText($object, $font)
            # the size of the image is based on the measure size of the text.
            $bmp1 = new-object System.Drawing.Bitmap ($textSize.Width+$marginLeft+$marginRight),($textSize.Height+$marginTop+$marginBottom)
            #TODO: Allow for transparent background
            $brushBg = [System.Drawing.Brushes]::$BackgroundColor 
            #TODO: Allow for transparent foreground
            $brushFg = [System.Drawing.Brushes]::$ForegroundColor 
            #TODO: stretch goal... allow for text outline ('stroke')
            #TODO: stretch goal... allow for background to be an image
            $graphics = [System.Drawing.Graphics]::FromImage($bmp1) 
            $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
            $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
            $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
            $graphics.FillRectangle($brushBg,0,0,$bmp1.Width,$bmp1.Height) 
            $graphics.DrawString($object,$font,$brushFg,$marginLeft,$marginTop) 
            $graphics.Dispose() 
            $bmp1.Save($filename1) 
            $fileName1;
        }
    }
}

#Invoke-Item $filename1 