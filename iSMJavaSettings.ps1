param(
    $Authorization = "aXdheTppd2F5",
    $iSMHeaders = @{'Authorization' = "Basic " + $Authorization; 'Origin' = 'http://localhost:9999' },
    $jvmOptions = "-Xmx2G"
    )

$Uri = 'http://localhost:9999/ism/serverJavaSettings?configuration=base'
$Form = @{
    form = 'setJVM'
    configuration  = 'base'
    action         = 'update'
    jvmOptions = $jvmOptions
}

$JVMUpdateResult = Invoke-WebRequest -Uri $Uri -Method Post -Body $Form -ContentType "application/x-www-form-urlencoded" -Headers $iSMHeaders -MaximumRedirection 0 -PreserveAuthorizationOnRedirect
[xml] $JVMUpdateHtml = $JVMUpdateResult.Content 
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUserDeclaredVarsMoreThanAssignments', '', Scope = 'Function')]
$JVMUpdateResult = Select-Xml -Xml $JVMUpdateHtml -XPath "/html/body/div/div/table/tr/td[4]/form[1]/fieldset/div/table/tr/td[3]/textarea/text()" | Select-Object -ExpandProperty Node

if ($JVMUpdateResult = $jvmOptions) {
    Write-Host("Success")
}
else {
    throw "Error Updating Domain"
}




