param(
    $Authorization  = "aXdheTppd2F5",
    $name           = 'NewKeyStore',
    $desc           = 'NewKeyStore Description',
    $keystore       = 'c:\iway\dan.jks',
    $kspasswd       = '123',
    $kstype         = 'JKS'
    )
$iSMHeaders = @{'Authorization' = "Basic " + $Authorization; 'Origin' = 'http://localhost:9999' }
$Uri = 'http://localhost:9999/ism/serverFormSecurityKS'
$Form = @{
    configuration  = 'base'
    action         = 'add'
    actionParm = 'save'
    originalaction = 'add'
    name = $name
    desc = $desc
    keystore = $keystore
    kspasswd = $kspasswd
    kstype = $kstype
    ksprovider = 'NOT_SPECIFIED'
}

$Result = Invoke-WebRequest -Uri $Uri -Method Post -Body $Form -ContentType "application/x-www-form-urlencoded" -Headers $iSMHeaders -MaximumRedirection 0 -PreserveAuthorizationOnRedirect
[xml] $ResultHtml = $Result.Content 
$nameResult = (Select-Xml -Xml $ResultHtml -XPath "/html/body/div/div/table/tr/td[3]/form[1]/fieldset/div/div[2]/table/tbody[2]/tr/td[2]/a/text()" | Select-Object ).Node.Value.trim()
$descResult = (Select-Xml -Xml $ResultHtml -XPath "/html/body/div/div/table/tr/td[3]/form[1]/fieldset/div/div[2]/table/tbody[2]/tr/td[3]/text()" | Select-Object ).Node.Value.trim()
Write-Host($nameResult)
Write-Host($descResult)

if ($nameResult -eq $name -and $descResult -eq $desc) {
    Write-Host("Success")
}
else {
    throw "Error Updating Key Store"
}



