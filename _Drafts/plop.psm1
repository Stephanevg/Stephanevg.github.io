
Enum ComputerType {
    Server
    Client
}

Class Computer {
    [String]$Name
    [ComputerType]$Type
}

Function Get-InternalStuff {
    #Do internal stuff 
}

Function Get-ComputerData {
    #Do stuff
}

Export-ModuleMember -Function Get-Data 
