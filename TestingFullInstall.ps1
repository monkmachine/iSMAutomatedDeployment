Invoke-Expression ".\iSM_Install.ps1 -ServerName -ismInstallerDir C:\Temp\ -iSMInsaller ibi_sm_9.1.0_iway91.exe -iSMResponseFile C:\Temp\iSMResponseFile.iss"
Invoke-Expression ".\startiSMBase.ps1 -iSMServiceName 'iWay9 base'"
Start-Sleep -Seconds 10
Invoke-Expression ".\iSMInstallCreateFolders.ps1 -FolderToBeCreated 'c:\iway\AppHome'"
Invoke-Expression ".\iSMInstallCreateFolders.ps1 -FolderToBeCreated 'c:\iway\Config'"
Invoke-Expression ".\iSMInstallCreateFolders.ps1 -FolderToBeCreated 'c:\iway\Security'"
Invoke-Expression ".\iSMAddKeyStore.ps1 -Authorization 'aXdheTppd2F5' -name 'NewKeyStore' -desc 'NewKeyStore Description' -keystore 'c:\iway\dan.jks' -kspasswd '123' -kstype 'JKS'"
Invoke-Expression ".\iSMDomainList.ps1 -Authorization 'aXdheTppd2F5' -confDomainName 'localhost,WINDEV2304EVAL,Domain6'"
Invoke-Expression ".\ISMJavaSettings.ps1 -Authorization 'aXdheTppd2F5' -jvmOptions '-Xmx2G'"