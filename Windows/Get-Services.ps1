<#
This PowerShell script is designed to run on PowerShell version 3.0 and above.

Este script do PowerShell foi projetado para ser executado na versão 3.0 ou superior do PowerShell.
It leverages WMI (Windows Management Instrumentation) to retrieve information about running services.

Ele utiliza o WMI (Windows Management Instrumentation) para recuperar informações sobre serviços em execução.
This script should theoretically work on Windows Vista/Server 2008 and above where WMI is available.

Este script teoricamente deve funcionar no Windows Vista/Server 2008 e superior, onde o WMI está disponível.
DISCLAIMER: This code is provided AS IS without any warranty or support.

AVISOS LEGAIS: Este código é fornecido COMO ESTÁ, sem garantia ou suporte.
Have fun, I hope this code helps you and, may the force be with you!

Divirta-se, espero que esse código lhe ajude e, que a força esteja com você!
#>

#Retrieve running services using WMI.
#Recupera os serviços em execução usando o WMI.

$services = Get-WmiObject Win32_Service | Where-Object { $_.State -eq 'Running' } | ForEach-Object {
    
    #Retrieve service name.
    #Recupera o nome do serviço.
    
    $serviceName = $_.Name
    
    #Retrieve process ID associated with the service.
    #Recupera o ID do processo associado ao serviço.
    
    $processId = $_.ProcessId
    
    #Retrieve process information using the process ID.
    #Recupera as informações do processo usando o ID do processo.
    
    $process = Get-Process -Id $processId

    #Create a custom object containing service name, start time, process ID, and process name.
    #Cria um objeto personalizado contendo nome do serviço, tempo de início, ID do processo e nome do processo.
    
    [PSCustomObject]@{
        ServiceName = $serviceName
        ProcessName = $process.ProcessName
        StartTime = $process.StartTime
        ProcessId = $processId
    }
}

# Sort the list of services alphabetically by service name.
# Classifica a lista de serviços em ordem alfabética pelo nome do serviço.
$services = $services | Sort-Object ServiceName

# Output the sorted list of services.
# Exibe a lista classificada de serviços.
$services