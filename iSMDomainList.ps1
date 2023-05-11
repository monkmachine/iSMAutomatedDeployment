param(
    $Authorization = "aXdheTppd2F5",
    $iSMHeaders = @{'Authorization' = "Basic " + $Authorization; 'Origin' = 'http://localhost:9999' },
    $confDomainName = "localhost,WINDEV2304EVAL,Domain6"
    )

$Uri = 'http://localhost:9999/ism/serverConsoleSettings?'
$Form = @{
    configuration  = 'base'
    action         = 'update'
    confDomainName = $confDomainName
}

$DomianUpdateResult = Invoke-WebRequest -Uri $Uri -Method Post -Body $Form -ContentType "application/x-www-form-urlencoded" -Headers $iSMHeaders -MaximumRedirection 0 -PreserveAuthorizationOnRedirect
[xml] $DomainUpdateHtml = $DomianUpdateResult.Content 
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUserDeclaredVarsMoreThanAssignments', '', Scope = 'Function')]
$DomainUpdateResult = Select-Xml -Xml $DomainUpdateHtml -XPath "/html/body/div/div/table/tr/td[3]/form/div/table/tbody/tr[3]/td[2]/input[@name='confDomainName']/@value" | Select-Object -ExpandProperty Node

if ($DomainUpdateResult = $confDomainName) {
    Write-Host("Success")
}
else {
    throw "Error Updating Domain"
}




