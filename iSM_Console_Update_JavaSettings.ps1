param(
    $Authorization = "aXdheTppd2F5",
    $jvmOptions = "-Xmx2G"
    )
    
$iSMHeaders = @{'Authorization' = "Basic " + $Authorization; 'Origin' = 'http://localhost:9999' }
$Uri = 'http://localhost:9999/ism/serverJavaSettings?configuration=base'
$Form = @{
    form = 'setJVM'
    configuration  = 'base'
    action         = 'update'
    jvmOptions = $jvmOptions
}

$Result = Invoke-WebRequest -Uri $Uri -Method Post -Body $Form -ContentType "application/x-www-form-urlencoded" -Headers $iSMHeaders -MaximumRedirection 0 -PreserveAuthorizationOnRedirect
[xml] $ResultHtml = $Result.Content 
$JVMUpdateResult = (Select-Xml -Xml $ResultHtml -XPath "/html/body/div/div/table/tr/td[4]/form[1]/fieldset/div/table/tr/td[3]/textarea/text()" | Select-Object).Node.Value
Write-Host($JVMUpdateResult)

if ($JVMUpdateResult = $jvmOptions) {
    Write-Host("Success")
}
else {
    throw "Error Updating Domain"
}




