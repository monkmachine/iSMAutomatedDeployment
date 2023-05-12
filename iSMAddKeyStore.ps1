param(
    $Authorization = "aXdheTppd2F5",
    $iSMHeaders = @{'Authorization' = "Basic " + $Authorization; 'Origin' = 'http://localhost:9999' },
    $name = 'NewKeyStore',
    $desc = 'NewKeyStore Description',
    $keystore = 'c:\iway\dan.jks',
    $kspasswd = '123',
    $kstype = 'JKS'
    )


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

$KeyStoreUpdateResult = Invoke-WebRequest -Uri $Uri -Method Post -Body $Form -ContentType "application/x-www-form-urlencoded" -Headers $iSMHeaders -MaximumRedirection 0 -PreserveAuthorizationOnRedirect
[xml] $KeyStoreUpdateHtml = $KeyStoreUpdateResult.Content 
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUserDeclaredVarsMoreThanAssignments', '', Scope = 'Function')]
$nameResult = Select-Xml -Xml $KeyStoreUpdateHtml -XPath "/html/body/div/div/table/tr/td[3]/form[1]/fieldset/div/div[2]/table/tbody[2]/tr/td[2]/a" | Select-Object 
$descResult = Select-Xml -Xml $KeyStoreUpdateHtml -XPath "/html/body/div/div/table/tr/td[3]/form[1]/fieldset/div/div[2]/table/tbody[2]/tr/td[3]/text()" | Select-Object 


if ($nameResult.Node.Value -eq $name -and $descResult.Node.Value -eq $desc) {
    Write-Host("Success")
}
else {
    throw "Error Updating Domain"
}



