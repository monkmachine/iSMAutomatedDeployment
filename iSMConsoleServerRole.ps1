param(
    $Authorization = "aXdheTppd2F5",
    $iSMHeaders = @{'Authorization' = "Basic " + $Authorization; 'Origin' = 'http://localhost:9999' },
    $configuration = 'base',
    $action = 'add',
    $roleName = 'Integration Admins',
    $roleDesc = 'Admins11',
    $roleType = 'security',
    $ismadmin = 'true',
    $createconfig = 'true',
    $deleteconfig = 'true',
    $stopserver = 'true',
    $restartserver = 'true',
    $serverpages = 'true',
    $channelpages = 'true',
    $repospages = 'true',
    $read = 'true',
    $write = 'true',
    $monitor = 'true',
    $cmdrun = 'true',
    $cmdshell = 'true',
    $cmdflow = 'true',
    $cmdsetreg = 'true',
    $cmdsetprop = 'true',
    $cmdsetacl = 'true',
    $cmdsetpolicy = 'true',
    $cmdstart = 'true',
    $cmdstop = 'true',
    $cmdrefresh = 'true',
    $cmdpull = 'true',
    $cmdremote = 'true'

)
$Uri = 'http://localhost:9999/ism/ServerRoleAdd'
$Form = @{
    configuration =  $configuration
    action        = $action       
    roleName      = $roleName     
    roleDesc      = $roleDesc     
    roleType      = $roleType     
    ismadmin      = $ismadmin     
    createconfig  = $createconfig 
    deleteconfig  = $deleteconfig 
    stopserver    = $stopserver   
    restartserver = $restartserver
    serverpages   = $serverpages  
    channelpages  = $channelpages 
    repospages    = $repospages   
    read          = $read         
    write         = $write        
    monitor       = $monitor      
    cmdrun        =  $cmdrun       
    cmdshell      = $cmdshell     
    cmdflow       = $cmdflow      
    cmdsetreg     = $cmdsetreg    
    cmdsetprop    = $cmdsetprop   
    cmdsetacl     = $cmdsetacl    
    cmdsetpolicy  = $cmdsetpolicy 
    cmdstart      = $cmdstart     
    cmdstop       = $cmdstop      
    cmdrefresh    = $cmdrefresh   
    cmdpull       = $cmdpull      
    cmdremote     = $cmdremote    
 
}

$Result = Invoke-WebRequest -Uri $Uri -Method Post -Body $Form -ContentType "application/x-www-form-urlencoded" -Headers $iSMHeaders -MaximumRedirection 0 -PreserveAuthorizationOnRedirect
[xml] $ResultHtml = $Result.Content 
$roleNameResult = (Select-Xml -Xml $ResultHtml -XPath "/html/body/div/div/table/tr/td[3]/form/fieldset/table/tr[2]/td[1]/input/@value" | Select-Object).Node.Value.split(';')[0] 
$roleDescResult = (Select-Xml -Xml $ResultHtml -XPath "/html/body/div/div/table/tr/td[3]/form/fieldset/table/tr[2]/td[4]/span/text()" | Select-Object).Node.Value.trim()
Write-Host($roleNameResult)
Write-Host($roleDescResult)

if ($roleNameResult -eq $roleName -and $roleDescResult -eq $roleDesc) {
    Write-Host("Success")
}
else {
    throw "Error Updating Domain"
}






