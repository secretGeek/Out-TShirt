#Helper function, for instantly shirtifying any slogan and seeing the result in a browser
# e.g. > shirty "¯\_(ツ)_/¯"
# https://secretgeek.teemill.co.uk/api-product/custom-product-576690a93b2a67-04107795/?currency=USD
function shirty($slogan) {
    convertto-image $slogan -fg Black -bg White -ha Center -va Center -fs 96 | out-Tshirt | % { start $_ }
}    
