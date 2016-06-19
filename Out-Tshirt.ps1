$postIt = $true;

function Out-TShirt
{
    [CmdletBinding()] 
    param(
        [Parameter(Position=0, Mandatory=$true, ValueFromPipeline = $true)] [PSObject[]]$InputObject,
        [parameter(Mandatory=$false)][alias("TC")][string]$TShirtColor = "White",
        [parameter(Mandatory=$false)][alias("PC")][string]$ProductCode = "RNA1",
        [parameter(Mandatory=$false)][alias("CC")][string]$CurrencyCode = "USD"
    ) 

    Begin {
        if (!$env:Rapanui_API_key) {
             Throw "You need to register and get an API key from rapanui, and save it as environment variable `$env:Rapanui_API_key = `"YOUR_API_KEY`" `nFollow this link and get the API Key - https://rapanuistore.com/`n`n "
        }
        
        #See https://rapanuistore.com/api-product-gallery/    
        $allowedColors = "White", "Black", "Bright Blue", "Dark Grey", "Athletic Grey", "Red", "Rapanui Green", "Mustard", "Navy Blue";
        
        #See https://rapanuistore.com/api-product-gallery/    
        $allowedProductCodes = "RNA1", # Men's Basic T Shirt (default)
                            "RNB1", # Women's Basic T Shirt
                            "RNB3", # Women's vest top
                            "RNC1"  # Kid's Basic T Shirt
        if (!$allowedProductCodes.Contains($ProductCode)) {
            Throw "The product code must be one of: $allowedProductCodes`n`n "
        } else {
              switch ($ProductCode) 
              {
                'RNA1' { $allowedColors = "White", "Black", "Bright Blue", "Dark Grey", "Athletic Grey", "Red", "Rapanui Green", "Mustard", "Navy Blue" }
                'RNB1' { $allowedColors = 17 }
                'RNB3' { $allowedColors = 17 }
                'RNC1' { $allowedColors = 17 }
              }

        }        
    }
    Process {    
    
        foreach ($object in $InputObject) 
        { 
            $base64_image = [convert]::ToBase64String((get-content $object -encoding byte))
        
            # see https://rapanuistore.com/api-docs/
            $body = @{ 
                api_key = $env:Rapanui_API_key; 
                base64_image = $base64_image;
                item_code = $ProductCode; 
                color = $TShirtColor; # can be $allowedColors
                currency_code = $CurrencyCode; # can be GBP, USD*, EUR, RUB
                price_tier = $PriceTier; # can be "low","standard"*,"high"
            }
            

            Try
            {
                if ($postIt) {
                    $webpage = Invoke-WebRequest -Uri "https://rapanuiclothing.com/api-access-point/" `
                                                 -Body $body `
                                                 -Method POST `
                                                 -ErrorVariable EV
                    Write-Output $webpage.Content
                } else {
                    Write-Warning "Did not post as `$postIt $postIt "
                    Write-Verbose ("`$body = " + ($body|ConvertTo-Json))
                }
            }
            Catch
            {
                "Something went wrong, please try running again.";
                $ev.message 
                $webpage.RawContent
            }
        }
    }
}
# https://secretgeek.teemill.co.uk/api-product/custom-product-57641e8e5ce118-77943704/        
# https://secretgeek.teemill.co.uk/api-product/custom-product-5764230b297a87-64966033/        
# https://secretgeek.teemill.co.uk/api-product/custom-product-5764abe9efc107-95818213/
# https://secretgeek.teemill.co.uk/api-product/custom-product-5764ac62d1d799-53771567/