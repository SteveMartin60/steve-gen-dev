
CLS

#..............................................................................

#..............................................................................
Function Get-TimeZone
{
    $URI = "https://timezoneapi.io/api/address/?$City+$CountryCode"

    $TimeZone = Invoke-RestMethod $URI

    Return $TimeZone.data.addresses[0].timezone.id
}
#..............................................................................

#..............................................................................
Function Get-IpInfo
{
    Return Invoke-RestMethod https://ipinfo.io/json
}
#..............................................................................

#..............................................................................
Function Get-FreeGeoIp
{
    Return Invoke-RestMethod https://freegeoip.app/json
}
#..............................................................................

#..............................................................................
Function Get-MapUri
{
    $Latitude  = $GeoIpInfo.latitude
    $Longitude = $GeoIpInfo.longitude

    Return "https://nominatim.openstreetmap.org/reverse.php?format=jsonv2&accept-language=en&lat=$Latitude&lon=$Longitude"
}
#..............................................................................

#..............................................................................
Function Get-MapInfo
{
    $Latitude  = $GeoIpInfo.latitude
    $Longitude = $GeoIpInfo.longitude

    Return Invoke-RestMethod "https://nominatim.openstreetmap.org/reverse.php?format=jsonv2&accept-language=en&lat=$Latitude&lon=$Longitude"

}
#..............................................................................

#..............................................................................

$StartTime = Get-Date

$IpInfo    = Get-IpInfo
$GeoIpInfo = Get-FreeGeoIp
$MapInfo   = Get-MapInfo
$MapURI    = Get-MapURI

$Address   = $MapInfo.address

$IPAddress     = $GeoIpInfo.ip
$Latitude      = $GeoIpInfo.latitude
$Longitude     = $GeoIpInfo.longitude
$CountryCode   = $GeoIpInfo.country_code
$CountryName   = $GeoIpInfo.country_name
$PostalCode    = $GeoIpInfo.zip_code

$ISP           = $IpInfo.org
$HostName      = $IpInfo.hostname

if($MapInfo.address.city.Length -gt 1)
{
    $City = $MapInfo.address.city
}
else
{
    $City = $GeoIpInfo.city
}

if($PostalCode.Length -gt 1)
{
    $PostalCode = $MapInfo.address.postcode
}

if($GeoIpInfo.time_zone.Length -gt 0)
{
    $TimeZone = $GeoIpInfo.time_zone
}
else
{
    $TimeZone = Get-TimeZone
}

$ExternalConnection  = New-Object Object

$ExternalConnectionTemp = @{}

$ExternalConnection = {$ExternalConnectionTemp}.Invoke()

$ExternalConnection =
    @{
         "IPAddress"    = $IPAddress
         "Latitude"     = $Latitude
         "Longitude"    = $Longitude
         "City"         = $City
         "CountryCode"  = $countryCode
         "CountryName"  = $CountryName
         "TimeZone"     = $TimeZone
         "PostalCode"   = $PostalCode
         "ISP"          = $ISP
     }


if($IpInfo.   phone.              Length -gt 0){$ExternalConnection += @{"PhoneAreaCode"     = $IpInfo.   phone            }}
if($GeoIpInfo.metro_code.         Length -gt 1){$ExternalConnection += @{"MetroCode"         = $GeoIpInfo.metro_code       }}
if($GeoIpInfo.region_code.        Length -gt 1){$ExternalConnection += @{"RegionCode"        = $GeoIpInfo.region_code      }}
if($GeoIpInfo.region_name.        Length -gt 1){$ExternalConnection += @{"RegionName"        = $GeoIpInfo.region_name      }}
if($Address.  building.           Length -gt 0){$ExternalConnection += @{"Building"          = $Address.building           }}
if($Address.  city_district.      Length -gt 0){$ExternalConnection += @{"CityDistrict"      = $Address.city_district      }}
if($Address.  county.             Length -gt 0){$ExternalConnection += @{"County"            = $Address.county             }}
if($Address.  footway.            Length -gt 0){$ExternalConnection += @{"Footway"           = $Address.footway            }}
if($Address.  hamlet.             Length -gt 0){$ExternalConnection += @{"Hamlet"            = $Address.hamlet             }}
if($Address.  hotel.              Length -gt 0){$ExternalConnection += @{"Hotel"             = $Address.hotel              }}
if($Address.  house_number.       Length -gt 0){$ExternalConnection += @{"HouseNumber"       = $Address.house_number       }}
if($Address.  neighbourhood.      Length -gt 0){$ExternalConnection += @{"Neighbourhood"     = $Address.neighbourhood      }}
if($Address.  pedestrian.         Length -gt 0){$ExternalConnection += @{"Pedestrian"        = $Address.pedestrian         }}
if($Address.  region.             Length -gt 0){$ExternalConnection += @{"Region"            = $Address.region             }}
if($Address.  residential.        Length -gt 0){$ExternalConnection += @{"Residential"       = $Address.residential        }}
if($Address.  road.               Length -gt 0){$ExternalConnection += @{"Road"              = $Address.Road               }}
if($Address.  state.              Length -gt 0){$ExternalConnection += @{"State"             = $Address.state              }}
if($Address.  state_district.     Length -gt 0){$ExternalConnection += @{"StateDistrict"     = $Address.state_district     }}
if($Address.  suburb.             Length -gt 0){$ExternalConnection += @{"Suburb"            = $Address.suburb             }}
if($Address.  town.               Length -gt 0){$ExternalConnection += @{"Town"              = $Address.town               }}
if($Address.  townhall.           Length -gt 0){$ExternalConnection += @{"Townhall"          = $Address.townhall           }}
if($Address.  village.            Length -gt 0){$ExternalConnection += @{"Village"           = $Address.village            }}
if($Address.  water.              Length -gt 0){$ExternalConnection += @{"Water"             = $Address.water              }}
if($Address.  mall.               Length -gt 0){$ExternalConnection += @{"Mall"              = $Address.mall               }}
if($Address.  shop.               Length -gt 0){$ExternalConnection += @{"Shop"              = $Address.shop               }}

$ExternalConnection | Out-File "System-External-Connection.txt"
