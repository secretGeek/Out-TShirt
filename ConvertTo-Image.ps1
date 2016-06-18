
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
            $bmp1 = new-object System.Drawing.Bitmap 250,61 
            $font = new-object System.Drawing.Font Consolas,24 
            $brushBg = [System.Drawing.Brushes]::Yellow 
            $brushFg = [System.Drawing.Brushes]::Black 
            $graphics = [System.Drawing.Graphics]::FromImage($bmp1) 
            $graphics.FillRectangle($brushBg,0,0,$bmp1.Width,$bmp1.Height) 
            $graphics.DrawString($object,$font,$brushFg,10,10) 
            $graphics.Dispose() 
            $bmp1.Save($filename1) 
            $fileName1;
        }
    }
}

#Invoke-Item $filename1 