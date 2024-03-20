;##############GUI################
Global $mainWinTitle = "Admin Panel"
Global $mainWindowHwnd = GUICreate($mainWinTitle,325,500)
GUICtrlCreateLabel("Clients Connected:",10,10,100,22)
Global $clientsCombo = GUICtrlCreateCombo("",120,7,170,22)
Global $comboSocketPcName [100]
$sendMessageInputBox = GUICtrlCreateInput("",10,250,200,22)
$sendMessageButton = GUICtrlCreateButton("Send",230,250,60,22)

GUICtrlCreateGroup("Image stuff",5,40,315,240)
Global $takeScreenshotButton = GUICtrlCreateButton("Take screenshot",10,60,150,22)
GUICtrlCreateLabel("quality",220,48,100,22)
Global $screenShotQualitySlider = GUICtrlCreateSlider(163,60,150,20)
GUICtrlSetLimit($screenShotQualitySlider,100,1)
Global $disableWindowsButton = GUICtrlCreateButton("Disable all windows",10,85,150,22)
Global $enableWindowsButton = GUICtrlCreateButton("Enable windows back",165,85,150,22,$WS_DISABLED)
Global $freezeMouseButton = GUICtrlCreateButton("Freeze mouse",10,110,150,22)
Global $unfreezeMouseButton = GUICtrlCreateButton("Unfreeze mouse",165,110,150,22,$WS_DISABLED)
Global $startLivePreviewButton = GUICtrlCreateButton("Start live preview",10,135,150,22)
Global $restartComputerButton = GUICtrlCreateButton("Restart Computer",10,185,150,22)

GUISetState(@SW_SHOW)