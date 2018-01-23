

Deploy ProfileFiles {
    
    By FileSystem  {
    FromSource 'home'
    To (Join-Path $HOME "Documents\WindowsPowerShell")
    }

    By FileSystem {
        FromSource 'home'
        To (Join-Path $HOME "Documents\PowerShell")
    }
}