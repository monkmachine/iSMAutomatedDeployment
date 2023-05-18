param(
    $Authorization = "aXdheTppd2F5",
    $iSMHeaders = @{'Authorization' = "Basic " + $Authorization; 'Origin' = 'http://localhost:9999' },
    $jvmOptions = "-Xmx2G",
    $name = 'ldapTest',
    $desc = 'ldapTestDesc',
    $url = 'ldaps://ref.hcdag.net:636/DC=ref,DC=hcdag,DC=net',
    $poolsize = '2',
    $auth = 'Not Specified',
    $userid = 'Dan.Coldrick',
    $Userpass = '1234',
    $sslcontext = 'sslcontext'
    )

$Uri = 'http://localhost:9999/ism/serverFormLdap'
$Form = @{
    configuration  = 'base'
    action         = 'add'
    actionParm = 'save'
    name = $name
    desc = $desc
    originalaction = 'add'
    url = $url
    userid = $userid
    password = $Userpass
    poolsize = $poolsize
    sslcontext = $sslcontext
}

$Result = Invoke-WebRequest -Uri $Uri -Method Post -Body $Form -ContentType "application/x-www-form-urlencoded" -Headers $iSMHeaders -MaximumRedirection 0 -PreserveAuthorizationOnRedirect
[xml] $ResultHtml = $Result.Content 
$nameResult = (Select-Xml -Xml $ResultHtml -XPath "/html/body/div/div/table/tr/td[3]/form/fieldset/table/tr[2]/td[2]/a/text()" | Select-Object).Node.Value.trim()
$descResult = (Select-Xml -Xml $ResultHtml -XPath "/html/body/div/div/table/tr/td[3]/form/fieldset/table/tr[2]/td[3]/span/text()" | Select-Object).Node.Value.trim()
Write-Host($nameResult)
Write-Host($descResult)

if ($nameResult -eq $name -and $descResult -eq $desc) {
    Write-Host("Success")
}
else {
    throw "Error Updating Domain"
}




