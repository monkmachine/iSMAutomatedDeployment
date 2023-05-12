param(
    $shareName = 'iWayDeploy',
    $shareFolder = 'C:\Temp\Test Folder',
    $fullAccess = 'Administrators',
    $changeAccess = '',
    $readAccess = ''
)

if ($changeAccess.Equals('')) {
  } else {
    $change = '-ChangeAccess ' + $changeAccess
  }
$full = if ($fullAccess = '') { '' }else { '–FullAccess ' + $fullAccess }
$read = if ($readAccess = '') { '' }else { '-ReadAccess ' + $readAccess }

New-SMBShare  –Name SharedFolder   –Path 'C:\Parent-Directory'  $full  $change  $read
