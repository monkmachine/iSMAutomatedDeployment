param(
    $Authorization = "aXdheTppd2F5",
    $confDomainName = "localhost,WINDEV2304EVAL,Domain6"
    )
$iSMHeaders = @{'Authorization' = "Basic " + $Authorization; 'Origin' = 'http://localhost:9999' }
$Uri = 'http://localhost:9999/ism/serverConsoleSettings?'
$Form = @{
    configuration  = 'base'
    action         = 'update'
    confDomainName = $confDomainName
}

$Result = Invoke-WebRequest -Uri $Uri -Method Post -Body $Form -ContentType "application/x-www-form-urlencoded" -Headers $iSMHeaders -MaximumRedirection 0 -PreserveAuthorizationOnRedirect
[xml] $ResultHtml = $Result.Content 
$DomainUpdateResult = (Select-Xml -Xml $ResultHtml -XPath "/html/body/div/div/table/tr/td[3]/form/div/table/tbody/tr[3]/td[2]/input/@value" | Select-Object).Node.Value
Write-Host($DomainUpdateResult)
if ($DomainUpdateResult = $confDomainName) {
    Write-Host("Success")
}
else {
    throw "Error Updating Domain"
}




