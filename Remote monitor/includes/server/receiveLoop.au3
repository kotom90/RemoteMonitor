;to receive loop
Func receiveLoop()
	for $socketIndex = 0 to $ClientsNum 							; gia olous tous clients
		$data = TCPRecv($ConnectedSockets[$socketIndex],$MaxLength)
		if @error = 10054 Then
			RemoveSocketFromArray($socketIndex)
		EndIf
		$action = StringLeft($data,2)								;to prwto byte einai ti paei na kanei o client, ta client packets diladi
		$cleanData = StringTrimLeft($data,2)						;i pliroforia xwris to client packet
		Select
			case $action = $ReplyComputerName
				GUICtrlSetData($clientsCombo,$cleanData)
				$comboSocketPcName[$socketIndex] = $cleanData
				TrayTip("New client connected",$cleanData,3,1)
			case $action = $ReplySendingScreenShotFile				; erxetai screenshot apo to client
				$fhandle = FileOpen($screenShotTempDir,16+8+2)   ;anigma enos temp arxeiou sto opoio tha apothikeftei to screenshot
				receiveFile($socketIndex,$fHandle)
				if DirGetSize($screenShotDir) = -1 Then  ;an de vrethei o fakelos
					DirCreate($screenShotDir)			 ;na ton dimiourgisei
				EndIf
				FileClose($fHandle)
				FileCopy($screenShotTempDir,$screenShotDir & "\" &$screenShotFileNumber & ".jpg",1) ;antigrafei to temp arxeio sto fakelo "screenshots" dipla sto script
				$screenShotFileNumber = $screenShotFileNumber + 1    ;na afksisei ton arithmo afton pou dinxei to onoma tou epomenou arxeiou
				SplashOffAndEnableMainWindow()
				TrayTip("Screenshot","File transfer complete.",1,1)
			case $action = $ReplySendingLivePreviewData
				SplashOff() ; edw tha figei mono to splash alla to main window tha parameinei disabled, giati tha embodizei to live preview
				$livePreviewEnabled = 1
				GUICreate($livePreviewTitle,1024,768)
				$livePreviewHwnd = WinGetHandle($livePreviewTitle,"")
				GUISetState(@SW_SHOW)
				_ScreenCapture_Capture($screenShotTempDir)				;ena screencapture gia na dimiourgithei ena default jpg, alliws i CtrlCreatePic tha vgei fail
				$pic = GUICtrlCreatePic($screenShotTempDir,0,0,1024,768)
				while $livePreviewEnabled								;na ginetai to live preview sinexeia mexri na klisei
					$fHandle = FileOpen($screenShotTempDir,16+8+2)   ;anigma enos temp arxeiou sto opoio tha apothikeftei to screenshot
					receiveFile($socketIndex,$fHandle)
					FileClose($fHandle)
					GUICtrlSetImage($pic,$screenShotTempDir)
				wend
				TCPSend($ConnectedSockets[$socketIndex], $RequestLiveViewTermination)
				GUISetState(@SW_HIDE)
				SplashOffAndEnableMainWindow()
		EndSelect
	next
EndFunc