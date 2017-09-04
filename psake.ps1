# PSake makes variables declared here available in other scriptblocks
# Init some things
Properties {
    # Find the build folder based on build system
    $ProjectRoot = Resolve-Path "$PSScriptRoot\.."
    $Timestamp = Get-Date -UFormat "%Y%m%d-%H%M%S"
    $PSVersion = $PSVersionTable.PSVersion.Major
    $TestFile = "TestResults_PS$PSVersion`_$TimeStamp.xml"
    $lines = '----------------------------------------------------------------------'

    $Verbose = @{}
}

Task default -depends Test, Deploy

Task Test {
    $lines
    "`n`tSTATUS: Testing with PowerShell $PSVersion"
    $TestResults = Invoke-Pester -PassThru

    # Failed tests?
    # Need to tell psake or it will proceed to the deployment. Danger!
    if ($TestResults.FailedCount -gt 0)
    {
        Write-Error "Failed '$($TestResults.FailedCount)' tests, build failed"
    }
    "`n"
}

Task Deploy {
    $lines
    
    Invoke-PSDeploy -Force
}