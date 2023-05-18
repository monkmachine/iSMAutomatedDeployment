param(
    $Authorization = "aXdheTppd2F5",
    $iSMHeaders = @{'Authorization' = "Basic " + $Authorization; 'Origin' = 'http://localhost:9999' },
    $name = 'ldapTest',
    $desc = 'ldapTestDesc',
    $ldapprovider = 'ldapTest',
    $userbase = '',
    $userpattern = '',
    $usersubtree = 'true',
    $usersearch = 'sAMAccountName={0}',
    $userpass = '',
    $rolebase = 'OU=ISTS,OU=Maritime Naval Ships,OU=Account Group Delegation',
    $rolesubtree = 'true',
    $rolesearch = 'Member={0}',
    $rolename = 'CN',
    $userrolename = 'memberOf'

    )
$Uri = 'http://localhost:9999/ism/serverFormAuthRealm'
$Form = @{
    configuration  = 'base'
    action         = 'add'
    originalaction = 'add'
    actionParm = 'save'
    ptype = 'ldaprealm'
    name = $name
    desc = $desc
    ldapprov = $ldapprovider
    userbase = $userbase
    userpattern = $userpattern
    usersubtree = $usersubtree
    usersearch = $usersearch
    userpass = $userpass
    rolebase = $rolebase
    rolesubtree = $rolesubtree
    rolesearch = $rolesearch
    rolename = $rolename
    userrolename = $userrolename 
}

$Result = Invoke-WebRequest -Uri $Uri -Method Post -Body $Form -ContentType "application/x-www-form-urlencoded" -Headers $iSMHeaders -MaximumRedirection 0 -PreserveAuthorizationOnRedirect
[xml] $ResultHtml = $Result.Content 
$nameResult = (Select-Xml -Xml $ResultHtml -XPath "/html/body/div/div/table/tr/td[3]/form/fieldset/div/div[2]/table/tbody[2]/tr/td[1]/input/@value" | Select-Object).Node.Value.trim()
$descResult = (Select-Xml -Xml $ResultHtml -XPath "/html/body/div/div/table/tr/td[3]/form/fieldset/div/div[2]/table/tbody[2]/tr/td[4]/text()" | Select-Object).Node.Value.trim()
Write-Host($nameResult)
Write-Host($descResult)

if ($nameResult -eq $name -and $descResult -eq $desc) {
    Write-Host("Success")
}
else {
    throw "Error Updating Domain"
}




