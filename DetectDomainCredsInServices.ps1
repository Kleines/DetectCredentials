# DetectDomainCredsInServices.ps1
# Polls all machines in AD via WMI, checks their services, and reports any not using LocalSystem, LocalService, or Network Service
# Author: Stephen Kleine [kleines2015@gmail.com]
# Version 1.0 - 20190725
#
#

Import-Module -Name ActiveDirectory -ErrorAction stop

$AllComputers = get-adcomputer -filter *
$ValidServiceAccounts = @('localSystem','NT AUTHORITY\NetworkService','NT AUTHORITY\LocalService')
Foreach ($system in $AllComputers) {
    #write-output $system.Name
    $Services = Get-WmiObject -Class Win32_Service -ComputerName $system.name, not-online -EA SilentlyContinue #silent fails on unreachable machines
    Foreach ($Servicename in $Services) {
        $count = 0
        Foreach ($ValidName in $ValidServiceAccounts) {
            if ($ServiceName.Startname -ieq $ValidName) { 
                $count--
            }
        }
        if ($count -eq $false) {Write-host $count, $system.name, $Servicename.DisplayName, $Servicename.StartName, $Servicename.State}
    }            
}
