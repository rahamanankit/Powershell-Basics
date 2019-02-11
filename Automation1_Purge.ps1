#Setting up variables
$BASE_DIR=(Resolve-Path .\).Path
$ddMMyyyy=(Get-Date).ToString('dd-MM-yyyy');

$LOG_DIR=$BASE_DIR + "\LogFolder"
$LOG_FILE=$LOG_DIR + "\purge-"+$ddMMyyyy +".log"

$xml_config=$BASE_DIR + "\purge_config.xml"
[xml]$xml_content=Get-Content $xml_config

# Starting the script execution
write-output "===========================================================================" >> $LOG_FILE;
write-output "$(get-date) : Staring the script " | out-file $LOG_FILE -Append -Force;  


foreach ($entity in $xml_content.GetElementsByTagName("DIR_RETENTION") ){ 
	$retention=[int32]$entity.RETENTION
	$dir=$entity.DIR
		
	write-output "$(get-date) : Deleteing at $dir with retention period of $retention days" >> $LOG_FILE;

		Get-ChildItem -File -Recurse $dir | 
		Where-object {$_.LastWriteTime -lt (get-date).adddays(-$retention)} | % { 
			$_.fullname | del -Force
			$_.fullname | Out-File $LOG_FILE -Append
		}
}

write-output "$(get-date) : Script execution completed " | out-file $LOG_FILE -Append -Force;  
write-output "========================================================================= " | out-file $LOG_FILE -Append -Force;  
