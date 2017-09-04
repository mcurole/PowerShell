

Deploy ProfileFiles {
    
    By FileSystem  {
    FromSource 'home'
    To (Resolve-Path "$profile\..")
    }
}