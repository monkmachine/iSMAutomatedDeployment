param(
    $Source    ="C:\Temp\",
    $Target    ="ibi_sm_9.1.0_iway91.exe"
    )

Copy-Item -Path $Source -Destination $Target -Recurse