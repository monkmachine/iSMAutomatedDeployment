$ismInstallerDir="C:\Temp\"
$iSMInsaller="ibi_sm_9.1.0_iway91.exe"
$iSMResponseFile="C:\Temp\iSMResponseFile.iss"
$iSMInstalCommand=$ismInstallerDir + $iSMInsaller
$iSMArgumentList="-s -f1" + $iSMResponseFile


$p=start-process -passthru $iSMInstalCommand -ArgumentList $iSMArgumentList
$p.WaitForExit()
