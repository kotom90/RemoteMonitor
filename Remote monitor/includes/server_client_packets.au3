;############# PACKETS ###############

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

;packeta tou client
Global $ReplyComputerName = 			"50"
Global $ReplySendingScreenShotFile = 	"51"
Global $ReplyFileTransferFinished = 	"ffin"
Global $ReplySendingLivePreviewData =   "52"
Global $ReplyTerminatedLiveView =		"TerminationSuccessful"