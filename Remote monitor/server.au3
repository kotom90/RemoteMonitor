#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=server.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <string.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <ScreenCapture.au3>

;my includes
#include "includes/server/settings.au3"
#include "includes/server/globals.au3"
#include "includes/server/gui.au3"
#include "includes/server_client_packets.au3"
#include "includes/server/serverFunctions.au3"
#include "includes/server/msgLoop.au3"
#include "includes/server/receiveLoop.au3"

;hotkeys
HotKeySet("{F11}","StopLivePreview")

;############## PROGRAM START ##############
TCPStartup()

$MainSocket = TCPListen($serverAddress,$serverPort)

If $MainSocket = -1 Then Exit MsgBox(16, "Error", "Unable to intialize socket.")
While 1
	;send connection check to all available sockets, check every 10 sec 200*50 ms
	$timeCounter = $timeCounter + 1
	if $timeCounter = $connCheckDelayCounter Then
		$timeCounter = 0
		$ConnectedSocket = TCPAccept($MainSocket)
		;new connection
		if $ConnectedSocket <> -1 Then 							;if a connection is found
			$ClientsNum = $ClientsNum + 1							;increase the number of connected sockets by 1
			$ConnectedSockets[$ClientsNum] = $ConnectedSocket   	;append the socket to the array
			TCPSend($ConnectedSocket,$RequestComputerName)			;ask for computer name
		EndIf
	EndIf
	;sleep($loopDelay)
	;traytip("",$ClientsNum,0)

	receiveLoop() ; Network listening task
	messageLoop() ; GUI management

WEnd
TCPCloseSocket($MainSocket)
TCPShutdown()