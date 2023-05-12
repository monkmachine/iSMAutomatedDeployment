param(
    $Authorization = "aXdheTppd2F5",
    $iSMHeaders = @{'Authorization' = "Basic " + $Authorization; 'Origin' = 'http://localhost:9999' },
    $maxlogsize = "4048",
    $numlogstokeep = "1001",
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

$LogUpdateResult = Invoke-WebRequest -Uri $Uri -Method Post -Body $Form -ContentType "application/x-www-form-urlencoded" -Headers $iSMHeaders -MaximumRedirection 0 -PreserveAuthorizationOnRedirect
[xml] $LogUpdateHtml = $LogUpdateResult.Content 
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUserDeclaredVarsMoreThanAssignments', '', Scope = 'Function')]
$maxlogsizeResult = Select-Xml -Xml $LogUpdateHtml -XPath "/html/body/div/div/table/tr/td[4]/form/fieldset/div/table[4]/tr/td[3]/input[@name='maxlogsize']/@value" | Select-Object 
$numlogstokeepResult = Select-Xml -Xml $LogUpdateHtml -XPath "/html/body/div/div/table/tr/td[4]/form/fieldset/div/table[5]/tr/td[3]/input[@name='numlogstokeep']/@value" | Select-Object 
$datadebugsizeResult = Select-Xml -Xml $LogUpdateHtml -XPath "/html/body/div/div/table/tr/td[4]/form/fieldset/div/table[6]/tr/td[3]/input[@name='datadebugsize']/@value" | Select-Object 

if ($maxlogsizeResult.Node.Value -eq $maxlogsize -and $numlogstokeepResult.Node.Value -eq $numlogstokeep -and $datadebugsizeResult.Node.Value -eq $datadebugsize) {
    Write-Host("Success")
}
else {
    throw "Error Updating Domain"
}




