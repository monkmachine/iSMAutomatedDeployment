param(
    $shareName = 'iWayDeploy',
    $shareFolder = 'C:\Temp\Test Folder',
    $fullAccess = 'Administrators',
    $changeAccess = '',
    $readAccess = ''
)

if ($changeAccess.Equals("")) {
  } else {
    $change = '-ChangeAccess ' + $changeAccess
  }
$full = if ($fullAccess) { '–FullAccess ' + $fullAccess }else { ''}
$read = if ($readAccess) { '-ReadAccess ' + $readAccess }else {''  }

$command = "–Name SharedFolder   –Path 'C:\Parent-Directory' "+  $full + " " + $change +" "+ $read

New-SMBShare  –Name SharedFolder  –Path 'C:\Parent-Directory' 