<#
1. 
This PowerShell script is designed to run on PowerShell version 3.0 and above.

Este script do PowerShell foi projetado para ser executado na versão 3.0 ou superior do PowerShell.

2. 
It leverages WMI (Windows Management Instrumentation) to retrieve information about running services.

Ele utiliza o WMI (Windows Management Instrumentation) para recuperar informações sobre serviços em execução.

3. 
This script should theoretically work on Windows Vista/Server 2008 and above where WMI is available.

Este script teoricamente deve funcionar no Windows Vista/Server 2008 e superior, onde o WMI está disponível.

4. 
DISCLAIMER: This code is provided AS IS without any warranty or support.

AVISOS LEGAIS: Este código é fornecido COMO ESTÁ, sem garantia ou suporte.

5. 

Have fun, I hope this code helps you and, may the force be with you!

Divirta-se, espero que esse código lhe ajude e, que a força esteja com você!

#>

#Retrieve running services using WMI.
#Recupera os serviços em execução usando o WMI.

$services = Get-WmiObject Win32_Service | Where-Object { $_.State -eq 'Running' } | ForEach-Object {
    
    #Retrieve service display name.
    #Recupera o nome de exibição do serviço.
    
    $serviceName = $_.DisplayName
    
    #Retrieve process ID associated with the service.
    #Recupera o ID do processo associado ao serviço.
    
    $processId = $_.ProcessId
    
    #Retrieve process information using the process ID.
    #Recupera as informações do processo usando o ID do processo.
    
    $process = Get-Process -Id $processId

    #Create a custom object containing service name, start time, and process ID.
    #Cria um objeto personalizado contendo nome do serviço, tempo de início e ID do processo.
    
    [PSCustomObject]@{
        ServiceName = $serviceName
        StartTime = $process.StartTime
        ProcessId = $processId
    }
}

# Output the list of services.
# Exibe a lista de serviços.

$services