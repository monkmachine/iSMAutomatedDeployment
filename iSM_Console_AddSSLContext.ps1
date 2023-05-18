param(
    $Authorization = "aXdheTppd2F5",
    $iSMHeaders = @{'Authorization' = "Basic " + $Authorization; 'Origin' = 'http://localhost:9999' },
    $name = 'base_ssl',
    $desc = 'baseSSLDesc',
    $secprotocol = 'TLS',
    $cachesize = '100',
    $sessiontimeout = '300',
    $ksprov = 'NewKeyStore',
    $tsprov = 'NewKeyStore'
    )
    
$Uri = 'http://localhost:9999/ism/serverFormSecuritySSC'
$Form = @{
    configuration  = 'base'
    action         = 'add'
    actionParm = 'save'
    originalaction = 'add'
    name = $name
    desc = $desc
    ksprov = $ksprov
    tsprov = $tsprov
    secprotocol = $secprotocol
    cachesize = $cachesize
    sessiontimeout = $sessiontimeout
}

$Result = Invoke-WebRequest -Uri $Uri -Method Post -Body $Form -ContentType "application/x-www-form-urlencoded" -Headers $iSMHeaders -MaximumRedirection 0 -PreserveAuthorizationOnRedirect
[xml] $ResultHtml = $Result.Content 
$nameResult = (Select-Xml -Xml $ResultHtml -XPath "/html/body/div/div/table/tr/td[3]/form[2]/fieldset/div/div[2]/table/tbody[2]/tr/td[1]/input/@value"| Select-Object).Node.Value.trim()
$descResult = (Select-Xml -Xml $ResultHtml -XPath "/html/body/div/div/table/tr/td[3]/form[2]/fieldset/div/div[2]/table/tbody[2]/tr/td[3]/text()" | Select-Object).Node.Value.trim()
Write-Host($nameResult)
Write-Host($descResult)
if ($nameResult -eq $name -and $descResult -eq $desc) {
    Write-Host("Success")
}
else {
    throw "Error Updating Domain"
}



