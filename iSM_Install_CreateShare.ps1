param(
    $shareName = 'iWayDeploy',
    $shareFolder = 'C:\Temp\Test Folder'
)


New-SMBShare  –Name SharedFolder   –Path 'C:\Parent-Directory' 
