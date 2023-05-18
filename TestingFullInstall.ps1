Invoke-Expression ".\iSM_Install.ps1 -ServerName -ismInstallerDir C:\Temp\ -iSMInsaller ibi_sm_9.1.0_iway91.exe -iSMResponseFile C:\Temp\iSMResponseFile.iss"
Invoke-Expression ".\iSM_Install_StartBaseService.ps1 -iSMServiceName 'iWay9 base'"
Invoke-Expression ".\iSM_Install_CreateFolders.ps1 -FolderToBeCreated 'c:\iway\AppHome'"
Invoke-Expression ".\iSM_Install_CreateFolders.ps1 -FolderToBeCreated 'c:\iway\Config'"
Invoke-Expression ".\iSM_Install_CreateFolders.ps1 -FolderToBeCreated 'c:\iway\Security'"
Invoke-Expression ".\ISM_Install_CopyJars.ps1 -Source 'C:\Temp\' -Target 'C:\iway9\etc\manager\extensions'"

$maxRetryAttempts = 10
$retryDelaySeconds = 20
$retryAttempts = 0
$success = $false
do {
    try {
        Invoke-Expression ".\iSM_Console_AddKeyStore.ps1 -Authorization 'aXdheTppd2F5' -name 'NewKeyStore' -desc 'NewKeyStore Description' -keystore 'c:\iway\dan.jks' -kspasswd '123' -kstype 'JKS'"
        $success = $true
    }
    catch {
        Write-Host "Command failed. Retrying in $retryDelaySeconds seconds..."
        Start-Sleep -Seconds $retryDelaySeconds
        $retryAttempts++
    }
} while (-not $success -and $retryAttempts -lt $maxRetryAttempts)

if (-not $success) {
    Write-Host "Command failed after $maxRetryAttempts attempts."
}

Invoke-Expression ".\iSM_Console_UpdateDomainList.ps1 -Authorization 'aXdheTppd2F5' -confDomainName 'localhost,WINDEV2304EVAL,Domain6'"
Invoke-Expression ".\iSM_Console_Update_JavaSettings.ps1 -Authorization 'aXdheTppd2F5' -jvmOptions '-Xmx2G'"
Invoke-Expression ".\iSM_Console_AddServerRole.ps1 -Authorization 'aXdheTppd2F5' -configuration 'base' -action 'add' -roleName 'Integration Admins' -roleDesc 'Admins11' -roleType 'security' -ismadmin 'true' -createconfig 'true' -deleteconfig 'true' -stopserver 'true' -restartserver 'true' -serverpages 'true' -channelpages 'true' -repospages 'true' -read 'true' -write 'true' -monitor 'true' -cmdrun 'true' -cmdshell 'true' -cmdflow 'true' -cmdsetreg 'true' -cmdsetprop 'true' -cmdsetacl 'true' -cmdsetpolicy 'true' -cmdstart 'true' -cmdstop 'true' -cmdrefresh 'true' -cmdpull 'true' -cmdremote 'true'"
Invoke-Expression ".\iSM_Console_UpdateSoapSSL.ps1 -Authorization 'aXdheTppd2F5' -configuration 'base' -action 'update' -port 'SREG(ibse-port)' -baseurlhost 'hostname' -sslcontext 'base_ssl'"
Invoke-Expression ".\iSM_Console_AddLDAPProvider.ps1 -Authorization 'aXdheTppd2F5' -jvmOptions '-Xmx2G' -name 'ldapTest' -desc 'ldapTestDesc' -url 'ldaps://ref.hcdag.net:636/DC=ref,DC=hcdag,DC=net' -poolsize '2' -auth 'Not Specified' -userid 'Dan.Coldrick' -Userpass '1234' -sslcontext 'sslcontext'"
Invoke-Expression ".\iSM_Console_AddLDAPRealm.ps1 -Authorization 'aXdheTppd2F5' -name 'ldapTest' -desc 'ldapTestDesc' -ldapprovider 'ldapTest' -userbase '' -userpattern '' -usersubtree 'true' -usersearch 'sAMAccountName={0}' -userpass '' -rolebase 'OU=ISTS,OU=Maritime Naval Ships,OU=Account Group Delegation' -rolesubtree 'true' -rolesearch 'Member={0}' -rolename 'CN' -userrolename 'memberOf'"
Invoke-Expression ".\iSM_Console_UpdateLogSettings.ps1 -Authorization 'aXdheTppd2F5' -maxlogsize '4048' -numlogstokeep '1001' -datadebugsize '128'"
Invoke-Expression ".\iSM_Console_AddSSLContext.ps1 -Authorization 'aXdheTppd2F5' -name 'base_ssl' -desc 'baseSSLDesc' -secprotocol 'TLS' -cachesize '100' -sessiontimeout '300' -ksprov 'NewKeyStore' -tsprov 'NewKeyStore'"
