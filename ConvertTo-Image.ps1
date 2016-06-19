function ConvertTo-Image
{
    [CmdletBinding()] 
    param(
        [Parameter(Position=0, Mandatory=$true, ValueFromPipeline = $true)] [PSObject[]]$InputObject,
        
        [parameter(Mandatory=$false)][alias("F")][string]$FontName = "Consolas",
        [parameter(Mandatory=$false)][alias("BG")][string]$BackgroundColor = "Black", # see all colors http://www.pardesiservices.com/softomatix/colorchart.asp
        [parameter(Mandatory=$false)][alias("FG")][string]$ForegroundColor = "Green",
        [parameter(Mandatory=$false)][alias("FS")][int]$FontSize = 48,
        [parameter(Mandatory=$false)][alias("ML")][int]$MarginLeft = 10,
        [parameter(Mandatory=$false)][alias("MR")][int]$MarginRight = 10,
        [parameter(Mandatory=$false)][alias("MT")][int]$MarginTop = 10,
        [parameter(Mandatory=$false)][alias("MB")][int]$MarginBottom = 10,
        [parameter(Mandatory=$false)][alias("HA")][ValidateSet('Near','Center','Far')][string]$HorizontalAlignment = "Center",
        [parameter(Mandatory=$false)][alias("VA")][ValidateSet('Near','Center','Far')][string]$VerticalAlignment = "Center"
    ) 

    Begin {
        Add-Type -AssemblyName System.Drawing
        Add-Type -AssemblyName System.Windows.Forms

        #TODO: validate
        #  foregroundcolor, background color, fontname.
    }    

    Process {    
        foreach ($object in $InputObject) 
        { 
            $filename1 = (Join-Path $psScriptRoot (([guid]::NewGuid().ToString())+".png"))
            $font = new-object System.Drawing.Font $FontName,$FontSize
            $textSize = [System.Windows.Forms.TextRenderer]::MeasureText($object, $font)
            # the size of the image is based on the measure size of the text, plus any margins.
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
            $format = new-object System.Drawing.StringFormat
            $format.Alignment = [System.Drawing.StringAlignment]::$HorizontalAlignment; #Horizontal Alignment
            $format.LineAlignment = [System.Drawing.StringAlignment]::Center; # Vertical Alignment
            
            switch ($HorizontalAlignment) 
            {
                'Far' { $alignmentOffsetLeft = $textSize.Width }
                'Near' { $alignmentOffsetLeft = 0 }
                'Center' { $alignmentOffsetLeft = $textSize.Width /2 }
            }

            switch ($VerticalAlignment) 
            {
                'Far' { $alignmentOffsetTop = $textSize.Height }
                'Near' { $alignmentOffsetTop = 0 }
                'Center' { $alignmentOffsetTop = $textSize.Height /2 }
            }

            $graphics.DrawString($object,$font,$brushFg,$marginLeft+$alignmentOffsetLeft, $marginTop+$alignmentOffsetTop,$format) 
            $graphics.Dispose() 
            $bmp1.Save($filename1) 
            $fileName1;
        }
    }
}
