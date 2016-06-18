#TODO: generate image from string
#$path = "C:\Users\Leon\dropbox\secretgeek\all_someday_projects\slackathon\out-tshirt\stupid_ideas_slackathon_logo.png"
#$base64_image = [convert]::ToBase64String((get-content $path -encoding byte))

# Out-TShirt "C:\Users\Leon\dropbox\secretgeek\all_someday_projects\slackathon\out-tshirt\stupid_ideas_slackathon_logo.png"
# "C:\Users\Leon\dropbox\secretgeek\all_someday_projects\slackathon\out-tshirt\stupid_ideas_slackathon_logo.png" | Out-TShirt

$postIt = $true;

function Out-TShirt
{
    [CmdletBinding()] 
    param([Parameter(Position=0, Mandatory=$true, ValueFromPipeline = $true)] [PSObject[]]$InputObject) 

    Begin {
        if (!$env:Rapanui_API_key) {
             Throw "You need to register and get an API key from rapanui, and save it as environment variable `$env:Rapanui_API_key = `"YOUR_API_KEY`" `nFollow this link and get the API Key - https://rapanuistore.com/`n`n "
        }
    }
    Process {    
    
        foreach ($object in $InputObject) 
        { 
            $base64_image = [convert]::ToBase64String((get-content $object -encoding byte))
        
            $body = @{ 
                api_key = $env:Rapanui_API_key; 
                base64_image = $base64_image;
                item_code = "RNA1";
                color = "White"
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