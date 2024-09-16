CLS

$ModsRootDir="G:\SERVER\DAYZ-EMPTYMAP-1"
$MetaCppList="metacpp-list.txt"

Get-ChildItem -Path $ModsRootDir\ -Filter meta.cpp -Recurse | %{$_.FullName} > $MetaCppList

ForEach ($MetaCpp in Get-Content $MetaCppList) {
	
	[string]$publishedid = (Get-Content $MetaCpp | select-string 'publishedid' -SimpleMatch)
	
	[string]$name = (Get-Content $MetaCpp | select-string 'name' -SimpleMatch)
	
	$modid = ($publishedid).substring(14).replace(';','')
	$modname = ',@' + ($name).substring(8).replace('"','').replace(';','')
	
	Write-Output "$modid$modname"
}