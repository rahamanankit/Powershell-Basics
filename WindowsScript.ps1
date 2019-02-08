$log_path = "D:\WindowsScheduledRestart.log"
$sleep_time = 10
[xml]$xml_content = Get-Content "D:\service_details.xml"
Write-Output "===================================================" | Out-File $log_path
Write-Output "$(Get-Date) The automation process is starting" | Out-File $log_path -Append
foreach($entity in $xml_content.GetElementsByTagName("MACHINE_SERVICE")){
$computer_name = $entity.COMP_NAME
$service_name = $entity.SERVICE_NAME
try
{
$service = Get-Service -Name $service_name
Write-Output "$(Get-Date) The service $service_name is stopping on computer $computer_name" | Out-File $log_path -Append
$service.Stop()
Start-Sleep -Seconds $sleep_time
if($service.Status -eq "Stopped"){
Write-Output "$(Get-Date) The service $service_name has stopped successfully on computer $computer_name " | Out-File $log_path -Append
}
else
{
Write-Output "$(Get-Date) The service $service_name cannot be stopped on computer $computer_name" | Out-File $log_path -Append
}
Start-Sleep -Seconds $sleep_time
Write-Output "$(Get-Date) The service $service_name is starting on computer $computer_name" | Out-File $log_path -Append
$service.Start()
Start-Sleep -Seconds $sleep_time
if($service.Status -eq "Running"){
Write-Output "$(Get-Date) The service $service_name has restarted successfully on computer $computer_name" | Out-File $log_path -Append
}
else
{
Write-Output "$(Get-Date) The service $service_name cannot be restarted on computer $computer_name" | Out-File $log_path -Append
}
}
catch{
$exception_message = $_.Exception.Message
Write-Output "$(Get-Date) An exception has occured $exception_message" | Out-File $log_path -Append
}
}
Write-Output "The Automation Process is completed now" | Out-File $log_path -Append
Write-Output "Please check the logs at $log_path" | Out-File $log_path -Append
Write-Output "=====================================================================" |Out-File $log_path -Append