;############# SERVER FUNCTIONS ###############

;network stuff
Func SocketIsInArray($socket) ;elegxei an to socket einai sto array, kai epistrefei true/false
	$found = 0
	for $i = 0 to $ClientsNum
		if $socket = $ConnectedSockets[$i] Then
			$found = 1
		Endif
	next
	if $found = 1 Then
		return True
	Else
		return false
	EndIf
EndFunc

Func RemoveSocketFromArray($badSocketIndex) ;aferei to socket apo to array (aposyndedemenos xrhsths)
	TrayTip("Info","Client "&$comboSocketPcName[$badSocketIndex]&" disconnected.",5)
	If $badSocketIndex < $ClientsNum Then				;an to aposundedemeno socket den einai sto telos
		for $i = $badSocketIndex+1 to $ClientsNum				;na ksekinisei apo to epomeno meta apo to aposundedemeno
			$ConnectedSockets[$i-1] = $ConnectedSockets[$i]			;kai na ta metakinisei ola mia thesi pisw panw sto aposundedemeno
			$comboSocketPcName[$i-1] = $comboSocketPcName[$i]
		next
	EndIf
	if $ClientsNum = 0 Then ; an itan o monadikos client tote
		$comboSocketPcName[0] = "" ; na katharisei to onoma
		GUICtrlSetData($clientsCombo,"");na katharisei to onoma
	EndIf
	$ClientsNum = $ClientsNum - 1  	;na miwthei to array kata 1, efoson ola ta dedomena pigan mia thesi pisw, i aplws to aposundedemeno socket itan to telefteo
	for $i = 0 to $ClientsNum ; na ksanaftiaksei to combo list me ta kainouria connected pcs
		GUICtrlSetData($clientsCombo,"|" & $comboSocketPcName[$i])
	next
EndFunc

Func GetSocketFromCombo() ;analoga me to index tou combo vriskei kai to socket apo to array
	$selectedClientPcName = GUICtrlRead($clientsCombo) ;diavazei to keimeno apo to combo
	for $i = 0 to $ClientsNum							;vriskei pio index twn sockets einai afto pou dialextike sto combo box
		if ($selectedClientPcName = $comboSocketPcName[$i]) Then
			$socketIndex = $i							;vrike to index
		EndIf
	next
	return $ConnectedSockets[$socketIndex]				;epistrefei to socket sto opoio prepei na ginei i apostoli
EndFunc

Func receiveFile($socketIndex,$fHandle)
	While 1												;mexri pou erxontai dedomena ektos apo to string "finished", simainei pws to arxeio den teliose
		$fData = TCPRecv($ConnectedSockets[$socketIndex],$MaxLength)
		if @error >= 6 Then
			MsgBox(16,"Error","File transfer cancelled")
			$livePreviewEnabled = 0
			ExitLoop
		EndIf
		If $fData = $ReplyFileTransferFinished Then ExitLoop ;se periptwsi pou erthei to string "finished", exit apo to loop
		FileWrite($fHandle, $fData)
	Wend
	return $fData
EndFunc

;splash
Func SplashAndDisableMainWindow() ;apenergopoiei to parathiro otan xreiazetai
	WinSetState($mainWinTitle,"",@SW_DISABLE)
	SplashTextOn("",$splashText,$splashWidth,$splashHeight,$splashCenterPositionX,$splashCenterPositionY,$splashType)
EndFunc

Func SplashOffAndEnableMainWindow() ;to energopoiei ksana
	SplashOff()
	WinSetState($mainWinTitle,"",@SW_ENABLE)
EndFunc

;hotkey functions
; F11
Func StopLivePreview()
	TCPSend(GetSocketFromCombo(),$RequestLiveViewTermination)
	$livePreviewEnabled = 0
EndFunc