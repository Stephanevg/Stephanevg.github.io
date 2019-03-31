Enum ComputerType {
    Server
    Client
}

Class Computer {
    [String]$Name
    [ComputerType]$Type

    Computer($type){
        $this.Type = $type
        $this.Name = $this.GetNewName()

    }

    [String]GetNewName(){
        $Guid = [guid]::NewGuid()
        $FullName = ''
        switch ($this.type) {
            'client' {
                $FullName = 'CLT-' + $Guid 
                break
              }'Server' {
                $FullName = 'SRV-' + $Guid 
              }
        }

        return $FullName
    }
}

Function Get-InternalStuff {
    #Does internal stuff 
}

Function Get-ComputerData {
    #Does stuff<
}

Function New-Computer {
    Param(
        [ComputerType]$Type

    )
    [Computer]::New($Type)
}

Export-ModuleMember -Function Get-ComputerData,New-Computer