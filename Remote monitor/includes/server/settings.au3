Global $serverPort ; Port Number
Global $server ; Server IpAddress
Global $maxConnections ; Maximum Amount Of Concurrent Connections

$iniFile = "settings.ini"
if not FileExists($iniFile) Then
	MsgBox(16,"Error","Settings file not found. Closing...")
	Exit
EndIf
$serverAddress = IniRead($iniFile, "network", "serverAddress", "")
$serverPort = IniRead($iniFile, "network", "serverPort", "")
$maxConnections = IniRead($iniFile, "network", "maxConnections", "")