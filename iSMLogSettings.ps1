param(
    $Authorization = "aXdheTppd2F5",
    $iSMHeaders = @{'Authorization' = "Basic " + $Authorization; 'Origin' = 'http://localhost:9999' },
    $maxlogsize = "4048",
    $numlogstokeep = "1000",
    $datadebugsize = "128"
    )

$Uri = 'http://localhost:9999/ism/serverLogSettings?'
$Form = @{
    configuration  = 'base'
    action         = 'update'
    maxlogsize = $maxlogsize
    numlogstokeep = $numlogstokeep
    datadebugsize = $datadebugsize
}

$DomianUpdateResult = Invoke-WebRequest -Uri $Uri -Method Post -Body $Form -ContentType "application/x-www-form-urlencoded" -Headers $iSMHeaders -MaximumRedirection 0 -PreserveAuthorizationOnRedirect
[xml] $DomainUpdateHtml = $DomianUpdateResult.Content 
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUserDeclaredVarsMoreThanAssignments', '', Scope = 'Function')]
$maxlogsizeResult = Select-Xml -Xml $DomainUpdateHtml -XPath "/html/body/div/div/table/tr/td[4]/form/fieldset/div/table[4]/tr/td[3]/input[@name='maxlogsize']/@value" | Select-Object -ExpandProperty Node
$numlogstokeepResult = Select-Xml -Xml $DomainUpdateHtml -XPath "/html/body/div/div/table/tr/td[4]/form/fieldset/div/table[5]/tr/td[3]/input[@name='numlogstokeep']/@value" | Select-Object -ExpandProperty Node
$datadebugsizeResult = Select-Xml -Xml $DomainUpdateHtml -XPath "/html/body/div/div/table/tr/td[4]/form/fieldset/div/table[6]/tr/td[3]/input[@name='datadebugsize']/@value" | Select-Object -ExpandProperty Node

if ($maxlogsize -eq $maxlogsize -and $numlogstokeepResult -eq $numlogstokeep -and $datadebugsizeResult -eq $datadebugsize) {
    Write-Host("Success")
}
else {
    throw "Error Updating Domain"
}




