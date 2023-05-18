param(
    $Authorization = "aXdheTppd2F5",
    $iSMHeaders = @{'Authorization' = "Basic " + $Authorization; 'Origin' = 'http://localhost:9999' },
    $configuration= 'base',
    $action= 'update',
    $port= 'SREG(ibse-port)',
    $baseurlhost= 'hostname',
    $sslcontext= 'base_ssl'
)

$Uri = 'http://localhost:9999/ism/serverSOAPConfig?'
$Form = @{
    configuration  = $configuration
    action         = $action       
    port           = $port         
    baseurlhost    = $baseurlhost  
    sslcontext     = $sslcontext   
}

$Result = Invoke-WebRequest -Uri $Uri -Method Post -Body $Form -ContentType "application/x-www-form-urlencoded" -Headers $iSMHeaders -MaximumRedirection 0 -PreserveAuthorizationOnRedirect
[xml] $ResultHtml = $Result.Content 
$DomainUpdateResult = (Select-Xml -Xml $ResultHtml -XPath "/html/body/div/div/table/tr/td[3]/form/div/table/tbody/tr[5]/td[2]/table/tr/td[1]/input/@value" | Select-Object).Node.Value
Write-Host($DomainUpdateResult)
if ($DomainUpdateResult = $sslcontext) {
    Write-Host("Success")
}
else {
    throw "Error Updating Domain"
}





