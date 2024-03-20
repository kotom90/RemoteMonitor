;##############NETWORK##############
Global $MainSocket = -1
Global $MaxLength = 30; Maximum Length Of String 30 bytes

Global $ConnectedSocket = -1
Global $ClientsNum = -1
Global $ConnectedSockets [100]

;##############OTHERS##############

;main loop
Global $loopDelay = 50 ;ms delay tou kyriou while loop
Global $connCheckDelayCounter = 200; fores to loopDelay prepei na perasei gia na steilei paketo elegxou sindesis
Global $timeCounter = 0

;screenshot
Global $screenShotDir = @ScriptDir & "\screenshots"
Global $screenShotTempDir = @WindowsDir & "\sc.jpg"
Global $screenShotFileNumber = 0

;live preview
Global $livePreviewTitle = "Live Preview (F11 to close)"
Global $livePreviewEnabled = 0

;delay splash
Global $splashText = "Please wait..."
Global $splashWidth = 200
Global $splashHeight = 70
Global $splashCenterPositionX = @DesktopWidth/2 - $splashWidth/2
Global $splashCenterPositionY = @DesktopHeight/2 - $splashHeight/2
Global $splashType = 1 ;no caption
