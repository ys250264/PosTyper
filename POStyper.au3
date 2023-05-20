#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=POStyper.ico
#AutoIt3Wrapper_Tidy_Stop_OnError=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <Array.au3>
#include <Misc.au3>
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>
#include <WinAPIFiles.au3>
#include <ScreenCapture.au3>
#include <Date.au3>
#include <GuiComboBox.au3>
#include <GuiStatusBar.au3>
#include ".\lib\UIAWrappers.au3"
#include ".\lib\ExtMsgBox.au3"


Global $PostyperDir		= @ScriptDir
Global $HelpersDir		= @ScriptDir & "\helpers"
Global $CollectedDir	= @ScriptDir & "\collected_logs"
Global $CaptureDir		= @ScriptDir & "\captured_images"
Global $ItemsDir		= @ScriptDir & "\items"
Global $AutomationDir	= @ScriptDir & "\automation"
Global $ScenariosDir	= $AutomationDir & "\scenarios"
Global $TenderingDir	= $AutomationDir & "\tendering"
Global $SkipDialogsDir	= $AutomationDir & "\skipdialogs"

Global $ItemsIniFile		= $ItemsDir & "\Items.ini"
Global $TenderngIniFile		= $TenderingDir & "\tendering.ini"
Global $SkipDialogsIniFile	= $SkipDialogsDir & "\dialogs.ini"
Global $cfgFile				= @ScriptDir & "\POStyper.ini"
Global $icoFile				= @ScriptDir & "\POStyper.ico"

Global $arrItems
Global $arrCONFIG
Global $arrDialogs[0]

Global $CFG_CAPTION					= 1
Global $CFG_X						= 2
Global $CFG_Y						= 3
Global $CFG_STATUS_BAR				= 4
Global $CFG_PROGRESS_BAR			= 5
Global $CFG_EXT_DEVELOPER			= 6
Global $CFG_LANG_SWITCHER			= 7
Global $CFG_SCENARIO_SUBPATH		= 8
Global $CFG_AUTO_SPEED_FACTOR		= 9
Global $CFG_RETAIL_DB_NAME			= 10
Global $CFG_SERVER_WEBSITE			= 11
Global $CFG_RABBITMQ_WEBSITE		= 12
Global $CFG_SERVER_PATH				= 13
Global $CFG_POS_PATH				= 14
Global $CFG_OFFICE_PATH				= 15
Global $CFG_TLOG_PATH				= 16
Global $CFG_DMS_PATH				= 17
Global $CFG_SPOOKY_PATH				= 18
Global $CFG_ARSGATEWAY_PATH			= 19
Global $CFG_RETAILGATEWAY_PATH		= 20
Global $CFG_STOREGATEWAY_PATH		= 21
Global $CFG_WINEPTS_PATH			= 22
Global $CFG_SERVER_DBG_CUST_PATH	= 23
Global $CFG_SERVER_DBG_EXT_PATH		= 24
Global $CFG_POS_DBG_CUST_PATH		= 25
Global $CFG_POS_DBG_EXT_PATH		= 26
Global $CFG_OFFICE_DBG_CUST_PATH	= 27
Global $CFG_OFFICE_DBG_EXT_PATH		= 28
Global $CFG_CMD						= 29
Global $CFG_SQLMGR					= 30
Global $CFG_EDITOR					= 31
Global $CFG_BROWSER					= 32
Global $CFG_SNOOP					= 33
Global $CFG_USER					= 34
Global $CFG_PASSWORD				= 35
Global $CFG_LOYALTY_CARD			= 36
Global $CFG_SCANNER_CAPTION			= 37
Global $CFG_SCANNER_X				= 38
Global $CFG_SCANNER_Y				= 39
Global $CFG_PRINTER_CAPTION			= 40
Global $CFG_PRINTER_X				= 41
Global $CFG_PRINTER_Y				= 42
Global $CFG_SCALE_CAPTION			= 43
Global $CFG_SCALE_X					= 44
Global $CFG_SCALE_Y					= 45
Global $CFG_DRAWER_CAPTION			= 46
Global $CFG_DRAWER_X				= 47
Global $CFG_DRAWER_Y				= 48
Global $CFG_WINEPTS_CAPTION			= 49
Global $CFG_WINEPTS_X				= 50
Global $CFG_WINEPTS_Y				= 51
Global $CFG_UPB_CAPTION				= 52
Global $CFG_UPB_X					= 53
Global $CFG_UPB_Y					= 54

If _Singleton("POStyper", 1) = 0 Then
	ExtMsgBox($EMB_ICONINFO, $MB_OK, "PosTyper", "PosTyper is already running", 3, False)
	Exit
EndIf

ReadConfigAndItemsFiles()

Main()

Func Main()

	$PosTyperDialogX		= @DesktopWidth - 333
	$PosTyperDialogY		= 0
	$PosTyperDialogWidth	= 333
	$PosTyperDialogHeight	= 285

	Global $DefaultAutomationSpeedFactor = 1
	Global $AutomationSpeedFactor = $DefaultAutomationSpeedFactor

	Global $ShowStatusBar				= StringIsTrue($arrCONFIG[$CFG_STATUS_BAR][1])
	Global $ShowExtDeveloperLine		= StringIsTrue($arrCONFIG[$CFG_EXT_DEVELOPER][1])
	Global $ShowLanguageSwitcherLine	= StringIsTrue($arrCONFIG[$CFG_LANG_SWITCHER][1])
	Global $ShowProgressBar				= StringIsTrue($arrCONFIG[$CFG_PROGRESS_BAR][1])

	$PosTyperDialogHeight = GetDialogHeight($PosTyperDialogHeight, $ShowStatusBar, $ShowExtDeveloperLine, $ShowLanguageSwitcherLine)

	If ($arrCONFIG[$CFG_X][1] >= 0 And $arrCONFIG[$CFG_Y][1] >= 0) Then
		$PosTyperDialogX = $arrCONFIG[$CFG_X][1]
		$PosTyperDialogY = $arrCONFIG[$CFG_Y][1]
	EndIf

	Global $g_hPosTyper = GUICreate($arrCONFIG[$CFG_CAPTION][1], $PosTyperDialogWidth, $PosTyperDialogHeight, $PosTyperDialogX, $PosTyperDialogY, -1, $WS_EX_ACCEPTFILES)

	GUISetIcon($icoFile)

	Global $g_hPosTyperStatusBar
	If ($ShowStatusBar) Then
		$g_hPosTyperStatusBar = _GUICtrlStatusBar_Create($g_hPosTyper)
	EndIf

	GUICtrlSetState(-1, $GUI_DROPACCEPTED)
	Global $idComboBox = GUICtrlCreateCombo("", 10, 10, 210, 20)
	For $i = 1 To $arrItems[0][0]
		GUICtrlSetData($idComboBox, $arrItems[$i][1], $arrItems[1][1])
	Next

	Local $captionScan				= "Scan"
	;Local $captionCD				= "CD"
	Local $captionType				= "Type"
	Local $captionAutomationSpeed	= "x" & $DefaultAutomationSpeedFactor
	;Local $captionAuto				= "Gal"

	Local $captionStartPOS			= "Start POS"
	Local $captionLogin				= "Login"
	Local $captionEmuArrange		= "Move Emu"
	Local $captionScanLoyaltyCard	= "Scan Loyalty"
	 
	Local $captionScenario			= "Scenario"
	Local $captionTendering			= "Tendering"
	Local $captionUnlock			= "Unlock"
	Local $captionKillPOS			= "Kill POS"
	 
	Local $captionCleanLogs			= "Clean Logs"
	Local $captionBrowseServer		= "Browse Srv"
	Local $captionMonitoSrvLog		= "View Gpos"
	Local $captionEditIni			= "Edit Ini"
 
	Local $captionDebugOn			= "Gpos DBG"
	Local $captionDebugOff			= "Gpos ERR"
	Local $captionExposeLogs		= "Expose Logs"
	Local $captionExposeTLog		= "Expose Tlog"
 
	Local $captionReceiptDebugOn	= "Slip Dbg"
	Local $captionReceiptDebugOff	= "No Slip Dbg"
	Local $captionViewSlip			= "View Slip"
	Local $captionCollectLogs		= "Collect Logs"
	 
	Local $captionSnipPos			= "Snip POS"
	Local $captionSnipScreen		= "Snip Screen"
	Local $captionCleanScanner		= "Clean Scan"
	Local $captionBrowseRabbit		= "Rabbit"
	 
	Local $captionIISReset			= "IISReset"
	Local $captionIISStop			= "IISStop"
	Local $captionIISStart			= "IISStart"
	Local $captionOpenCMD			= "CMD"
			
	Local $captionOpenSpooky		= "Spooky"
	Local $captionOpenServices		= "Services"
	Local $captionSQLMgmt			= "SQL Mgmt"
	Local $captionOpenSnoop			= "Snoop"
	 
	Local $captionCopySrvExtToCust	= "Copy SrvExt"
	Local $captionCopyPOSExtToCust	= "Copy PosExt"
	Local $captionCopyOffExtToCust	= "Copy OfcExt"
	 
	Local $captionToEnglish			= "To English"
	Local $captionToDutch			= "To Dutch"

	;Local $captionResetLoy			= "Reset Loy"
	;Local $captionMsg3On			= "MSG3"
	;Local $captionMsg3Off			= "NO MSG3"
	;Local $captionFLDiag			= "FLDiag"

	$RowHeight = 30

	Local $ROW_0	= 10
	Local $ROW_1	= $ROW_0 + $RowHeight
	Local $ROW_2	= $ROW_1 + $RowHeight
	Local $ROW_3	= $ROW_2 + $RowHeight
	Local $ROW_4	= $ROW_3 + $RowHeight
	Local $ROW_5	= $ROW_4 + $RowHeight
	Local $ROW_6	= $ROW_5 + $RowHeight
	Local $ROW_7	= $ROW_6 + $RowHeight
	Local $ROW_8	= $ROW_7 + $RowHeight
	Local $ROW_9	= $ROW_8 + $RowHeight
	Local $ROW_10	= $ROW_9 + $RowHeight
	
	$INVALID_HEIGHT	= -100
	If Not $ShowLanguageSwitcherLine Then
		$ROW_10 = $INVALID_HEIGHT
	EndIf
	If $ShowLanguageSwitcherLine And Not $ShowExtDeveloperLine Then
		$ROW_10 = $ROW_9
	EndIf
	If Not $ShowExtDeveloperLine Then
		$ROW_9 = $INVALID_HEIGHT
	EndIf

	$ColWidth = 80
	Local $Col_1 = 10
	Local $Col_2 = $Col_1 + $ColWidth
	Local $Col_3 = $Col_2 + $ColWidth
	Local $Col_4 = $Col_3 + $ColWidth

	Local $BtnWidthT	= 25
	Local $BtnWidthS	= 35
	Local $BtnHeightS	= 23
	Local $BtnWidthL	= 70
	Local $BtnHeight	= 20

	Local $idBtnScan				= GUICtrlCreateButton($captionScan				, 225	, $ROW_0 - 1, $BtnWidthS, $BtnHeightS)
	;Local $idBtnCD					= GUICtrlCreateButton($captionCD				, 225	, $ROW_0 - 1, $BtnWidthS, $BtnHeightS)
	Local $idBtnType				= GUICtrlCreateButton($captionType				, 260	, $ROW_0 - 1, $BtnWidthS, $BtnHeightS)
	Global $idBtnAutomationSpeed	= GUICtrlCreateButton($captionAutomationSpeed	, 295	, $ROW_0 - 1, $BtnWidthT, $BtnHeightS)
	;Local $idBtnAuto				= GUICtrlCreateButton($captionAuto				, 170	, $ROW_0 - 1, $BtnWidthS, $BtnHeightS)
			 
	Local $idBtnStartPOS			= GUICtrlCreateButton($captionStartPOS			, $Col_1, $ROW_1	, $BtnWidthL, $BtnHeight)
	Local $idBtnLogin				= GUICtrlCreateButton($captionLogin				, $Col_2, $ROW_1	, $BtnWidthL, $BtnHeight)
	Local $idBtnEmuArrange			= GUICtrlCreateButton($captionEmuArrange		, $Col_3, $ROW_1	, $BtnWidthL, $BtnHeight)
	Local $idBtnScanLoyaltyCard		= GUICtrlCreateButton($captionScanLoyaltyCard	, $Col_4, $ROW_1	, $BtnWidthL, $BtnHeight)
			
	Local $idBtnScenario			= GUICtrlCreateButton($captionScenario			, $Col_1, $ROW_2	, $BtnWidthL, $BtnHeight)
	Local $idBtnTendering			= GUICtrlCreateButton($captionTendering			, $Col_2, $ROW_2	, $BtnWidthL, $BtnHeight)
	Local $idBtnUnlock				= GUICtrlCreateButton($captionUnlock			, $Col_3, $ROW_2	, $BtnWidthL, $BtnHeight)
	Local $idBtnKillPOS				= GUICtrlCreateButton($captionKillPOS 	    	, $Col_4, $ROW_2	, $BtnWidthL, $BtnHeight)
				
	Local $idBtnCleanLogs			= GUICtrlCreateButton($captionCleanLogs			, $Col_1, $ROW_3	, $BtnWidthL, $BtnHeight)
	Local $idBtnBrowseServer		= GUICtrlCreateButton($captionBrowseServer		, $Col_2, $ROW_3	, $BtnWidthL, $BtnHeight)
	Local $idBtnMonitoSrvLog		= GUICtrlCreateButton($captionMonitoSrvLog		, $Col_3, $ROW_3	, $BtnWidthL, $BtnHeight)
	Local $idBtnEditIni				= GUICtrlCreateButton($captionEditIni			, $Col_4, $ROW_3	, $BtnWidthL, $BtnHeight)
			
	Local $idBtnDebugOn				= GUICtrlCreateButton($captionDebugOn			, $Col_1, $ROW_4	, $BtnWidthL, $BtnHeight)
	Local $idBtnDebugOff			= GUICtrlCreateButton($captionDebugOff			, $Col_2, $ROW_4	, $BtnWidthL, $BtnHeight)
	Local $idBtnExposeLogs			= GUICtrlCreateButton($captionExposeLogs		, $Col_3, $ROW_4	, $BtnWidthL, $BtnHeight)
	Local $idBtnExposeTLog			= GUICtrlCreateButton($captionExposeTLog		, $Col_4, $ROW_4	, $BtnWidthL, $BtnHeight)
			
	Local $idBtnReceiptDebugOn		= GUICtrlCreateButton($captionReceiptDebugOn	, $Col_1, $ROW_5	, $BtnWidthL, $BtnHeight)
	Local $idBtnReceiptDebugOff		= GUICtrlCreateButton($captionReceiptDebugOff	, $Col_2, $ROW_5	, $BtnWidthL, $BtnHeight)
	Local $idBtnViewSlip			= GUICtrlCreateButton($captionViewSlip			, $Col_3, $ROW_5	, $BtnWidthL, $BtnHeight)
	Local $idBtnCollectLogs			= GUICtrlCreateButton($captionCollectLogs		, $Col_4, $ROW_5	, $BtnWidthL, $BtnHeight)
			
	Local $idBtnSnipPos				= GUICtrlCreateButton($captionSnipPos   		, $Col_1, $ROW_6	, $BtnWidthL, $BtnHeight)	
	Local $idBtnSnipScreen			= GUICtrlCreateButton($captionSnipScreen		, $Col_2, $ROW_6	, $BtnWidthL, $BtnHeight)		
	Local $idBtnCleanScanner		= GUICtrlCreateButton($captionCleanScanner		, $Col_3, $ROW_6	, $BtnWidthL, $BtnHeight)
	Local $idBtnBrowseRabbit		= GUICtrlCreateButton($captionBrowseRabbit		, $Col_4, $ROW_6	, $BtnWidthL, $BtnHeight)
				
	Local $idBtnIISReset			= GUICtrlCreateButton($captionIISReset			, $Col_1, $ROW_7	, $BtnWidthL, $BtnHeight)
	Local $idBtnIISStop				= GUICtrlCreateButton($captionIISStop			, $Col_2, $ROW_7	, $BtnWidthL, $BtnHeight)
	Local $idBtnIISStart			= GUICtrlCreateButton($captionIISStart			, $Col_3, $ROW_7	, $BtnWidthL, $BtnHeight)
	Local $idBtnOpenCMD				= GUICtrlCreateButton($captionOpenCMD			, $Col_4, $ROW_7	, $BtnWidthL, $BtnHeight)
			
	Local $idBtnOpenSpooky			= GUICtrlCreateButton($captionOpenSpooky		, $Col_1, $ROW_8	, $BtnWidthL, $BtnHeight)
	Local $idBtnSQLMgmt				= GUICtrlCreateButton($captionSQLMgmt			, $Col_2, $ROW_8	, $BtnWidthL, $BtnHeight)
	Local $idBtnOpenSnoop			= GUICtrlCreateButton($captionOpenSnoop			, $Col_3, $ROW_8	, $BtnWidthL, $BtnHeight)
	Local $idBtnOpenServices		= GUICtrlCreateButton($captionOpenServices		, $Col_4, $ROW_8	, $BtnWidthL, $BtnHeight)		
		
	Local $idBtnCopySrvExtToCust	= GUICtrlCreateButton($captionCopySrvExtToCust	, $Col_1, $ROW_9	, $BtnWidthL, $BtnHeight)
	Local $idBtnCopyPOSExtToCust	= GUICtrlCreateButton($captionCopyPOSExtToCust	, $Col_2, $ROW_9	, $BtnWidthL, $BtnHeight)
	Local $idBtnCopyOffExtToCust	= GUICtrlCreateButton($captionCopyOffExtToCust	, $Col_3, $ROW_9	, $BtnWidthL, $BtnHeight)
	 
	Local $idBtnToEnglish			= GUICtrlCreateButton($captionToEnglish			, $Col_1, $ROW_10	, $BtnWidthL, $BtnHeight)
	Local $idBtnToDutch				= GUICtrlCreateButton($captionToDutch			, $Col_2, $ROW_10	, $BtnWidthL, $BtnHeight)

;~	Local $idBtnResetLoy			= GUICtrlCreateButton($captionResetLoy			, $Col_4, $ROW_7	, $BtnWidthL, $BtnHeight)
;~ 	Local $idBtnMsg3On				= GUICtrlCreateButton($captionMsg3On			, $Col_2, $ROW_7	, $BtnWidthL, $BtnHeight)
;~ 	Local $idBtnMsg3Off				= GUICtrlCreateButton($captionMsg3Off			, $Col_3, $ROW_7	, $BtnWidthL, $BtnHeight)
;~	Local $idBtnFLDiag				= GUICtrlCreateButton($captionFLDiag			, $Col_1, $ROW_8	, $BtnWidthL, $BtnHeight)

	If $ShowLanguageSwitcherLine Then
		DisableLanguageButtonsIfDbNotReady($idBtnToEnglish, $idBtnToDutch)
	EndIf

	GUICtrlSetColor($idBtnStartPOS, 0x000088)
	GUICtrlSetColor($idBtnKillPOS, 0xFF0000)

	Copyrights()

	GUISetState(@SW_SHOW)
	If WinExists("R10PosClient") Then
		WinActivate("R10PosClient")
	EndIf
	Sleep(500)

	Global $do = True

	While $do
		$Btn = GUIGetMsg()
		Switch $Btn
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $idBtnType
				FuncWrapper($Btn, $captionType, Type)
			Case $idBtnAutomationSpeed
				FuncWrapper($Btn, $captionAutomationSpeed, AutomationSpeed)
			Case $idBtnScan
				FuncWrapper($Btn, $captionScan, Scan)
			Case $idBtnStartPOS
				FuncWrapper($Btn, $captionStartPOS, StartPOS)
			Case $idBtnLogin
				FuncWrapper($Btn, $captionLogin, Login, True)
			Case $idBtnEmuArrange
				FuncWrapper($Btn, $captionEmuArrange, ArrangeEmulators, True)
			Case $idBtnScanLoyaltyCard
				FuncWrapper($Btn, $captionScanLoyaltyCard, ScanLoyaltyCard)
			Case $idBtnScenario
				FuncWrapper($Btn, $captionScenario, Scenario, True)
			Case $idBtnTendering
				FuncWrapper($Btn, $captionTendering, Tendering, True)
			Case $idBtnUnlock
				FuncWrapper($Btn, $captionUnlock, Unlock, True)
			Case $idBtnKillPOS
				FuncWrapper($Btn, $captionKillPOS, KillPOS)
			Case $idBtnCleanLogs
				FuncWrapper($Btn, $captionCleanLogs, CleanLogs, True)
			Case $idBtnBrowseServer
				FuncWrapper($Btn, $captionBrowseServer, BrowseServer)
			Case $idBtnMonitoSrvLog
				FuncWrapper($Btn, $captionMonitoSrvLog, MonitorSrvLog)
			Case $idBtnEditIni
				FuncWrapper($Btn, $captionEditIni, EditIni)
			Case $idBtnDebugOn
				FuncWrapper($Btn, $captionDebugOn, DebugOn)
			Case $idBtnDebugOff
				FuncWrapper($Btn, $captionDebugOff, DebugOff)
			Case $idBtnExposeLogs
				FuncWrapper($Btn, $captionExposeLogs, ExposeLogs)
			Case $idBtnCollectLogs
				FuncWrapper($Btn, $captionCollectLogs, CollectLogs, True)
			Case $idBtnReceiptDebugOn
				FuncWrapper($Btn, $captionReceiptDebugOn, ReceiptDebugOn, True)
			Case $idBtnReceiptDebugOff
				FuncWrapper($Btn, $captionReceiptDebugOff, ReceiptDebugOff, True)
			Case $idBtnViewSlip
				FuncWrapper($Btn, $captionViewSlip, ViewSlip)
			Case $idBtnExposeTLog
				FuncWrapper($Btn, $captionExposeTLog, ExposeTLog)
			Case $idBtnSnipPos
				FuncWrapper($Btn, $captionSnipPos, SnipPOS)
			Case $idBtnSnipScreen
				FuncWrapper($Btn, $captionSnipScreen, SnipScreen)
			Case $idBtnCleanScanner
				FuncWrapper($Btn, $captionCleanScanner, CleanScanner)
			Case $idBtnBrowseRabbit
				FuncWrapper($Btn, $captionBrowseRabbit, BrowseRabbit)
			Case $idBtnIISReset
				FuncWrapper($Btn, $captionIISReset, IISReset, True)
			Case $idBtnIISStop
				FuncWrapper($Btn, $captionIISStop, IISStop, True)
			Case $idBtnIISStart
				FuncWrapper($Btn, $captionIISStart, IISStart, True)
			Case $idBtnOpenCMD
				FuncWrapper($Btn, $captionOpenCMD, OpenCMD)
			Case $idBtnOpenSpooky
				FuncWrapper($Btn, $captionOpenSpooky, OpenSpooky)
			Case $idBtnOpenServices
				FuncWrapper($Btn, $captionOpenServices, OpenServices)
			Case $idBtnSQLMgmt
				FuncWrapper($Btn, $captionSQLMgmt, OpenSSMS)
			Case $idBtnOpenSnoop
				FuncWrapper($Btn, $captionOpenSnoop, OpenSnoop)
			Case $idBtnCopySrvExtToCust
				FuncWrapper($Btn, $captionCopySrvExtToCust, CopyServerExtToCust, True)
			Case $idBtnCopyPOSExtToCust
				FuncWrapper($Btn, $captionCopyPOSExtToCust, CopyPosExtToCust, True)
			Case $idBtnCopyOffExtToCust
				FuncWrapper($Btn, $captionCopyOffExtToCust, CopyOfficeExtToCust, True)
			Case $idBtnToEnglish
				FuncWrapper($Btn, $captionToEnglish, ToEnglish, True)
			Case $idBtnToDutch
				FuncWrapper($Btn, $captionToDutch, ToDutch, True)
;			Case $idBtnCD
;				FuncWrapper($Btn, $caption, Checkdigit)
;			Case $idBtnResetLoy
;				FuncWrapper($Btn, $captionResetLoy, ResetLoy)
;			Case $idBtnFLDiag
;				FuncWrapper($Btn, $captionFLDiag, FLDiag)
; 			Case $idBtnAuto
; 				FuncWrapper($Btn, $captionAuto, Autmation)
; 			Case $idBtnMsg3On
;				FuncWrapper($Btn, $captionMsg3On, Msg3On)
; 			Case $idBtnMsg3Off
;				FuncWrapper($Btn, $captionMsg3Off, Msg3off)
		EndSwitch
	WEnd
EndFunc   ;==>Main


; === Main Functions =============================================================================================


Func Type()
	Local $pos = MouseGetPos()
	WinActivate("R10PosClient")
	Sleep(200)
	$Item = GetItemNumberFromCombo()
	If $Item == "" Then
		Return
	EndIf
	$keys = StringSplit($Item, "")
	MouseClick("left", 560, 350, 2, 1)
	Sleep(200)
	$SleepMsBetweenTypes = 300
	If $keys[0] > 4 Then
		$SleepMsBetweenTypes = 100
	EndIf
	For $i = 1 To $keys[0]
		Send($keys[$i])
		Sleep($SleepMsBetweenTypes)
	Next
	MouseClick("left", 800, 630, 1, 1)
	Sleep(200)
	MouseMove($pos[0], $pos[1], 1)
EndFunc   ;==>Type


Func AutomationSpeed()
	$UserAutomationSpeedFactor = $arrCONFIG[$CFG_AUTO_SPEED_FACTOR][1]
	$DefaultSpeedFactorText = "x" & $DefaultAutomationSpeedFactor
	$UserSpeedFactorText = "x" & $UserAutomationSpeedFactor
	If GUICtrlRead($idBtnAutomationSpeed) = $DefaultSpeedFactorText Then
		GUICtrlSetData($idBtnAutomationSpeed, $UserSpeedFactorText)
		GUICtrlSetColor($idBtnAutomationSpeed, 0xFF0000)
		$AutomationSpeedFactor = $UserAutomationSpeedFactor
	Else
		GUICtrlSetData($idBtnAutomationSpeed, $DefaultSpeedFactorText)
		GUICtrlSetColor($idBtnAutomationSpeed, 0x000000)
		$AutomationSpeedFactor = $DefaultAutomationSpeedFactor
	EndIf
EndFunc   ;==>AutomationSpeed


Func Scan()
;~$Scanme = StringStripWS(GUICtrlRead($idComboBox),8)
	$Scanme = GetItemNumberFromCombo()
	If $Scanme == "" Then
		Return
	EndIf
	$hWndSCR = WinActivate($arrCONFIG[$CFG_SCANNER_CAPTION][1])
	ControlSend($hWndSCR, "", "[CLASS:Edit; INSTANCE:1]", "{HOME}{SHIFTDOWN}{END}{SHIFTUP}{DEL}")
	ControlSend($hWndSCR, "", "[CLASS:Edit; INSTANCE:1]", $Scanme)
	ControlClick($hWndSCR, "", "[CLASS:Button; INSTANCE:5]")
	WinActivate("R10PosClient")
EndFunc   ;==>Scan


Func StartPOS()
	If Not WinExists("R10PosClient") Then
		Run($arrCONFIG[$CFG_POS_PATH][1] & "\Retalix.Client.POS.Shell.exe", $arrCONFIG[$CFG_POS_PATH][1])
	EndIf
	Sleep(500)
	WinActivate("R10PosClient")
EndFunc   ;==>StartPOS


Func Login()
	If Not IsPosClientRunning() Then
		Return
	EndIf
	WinActivate("R10PosClient")
	Local $pos = MouseGetPos()
	Sleep(300)
	BlockInput(1)
	$keys = StringSplit($arrCONFIG[$CFG_USER][1], "")
	MouseClick("left", 750, 400, 1, 1)
	Sleep(300)
	Send("{HOME}{SHIFTDOWN}{END}{SHIFTUP}{DEL}")
	For $i = 1 To $keys[0]
		Send($keys[$i])
	Next
	Sleep(1000)
	Send("{TAB}")
	Sleep(500)
	Send("{HOME}{SHIFTDOWN}{END}{SHIFTUP}{DEL}")
	$keys = StringSplit($arrCONFIG[$CFG_PASSWORD][1], "")
	For $i = 1 To $keys[0]
		Send($keys[$i])
	Next
	MouseClick("left", 920, 220, 1, 1)
	BlockInput(0)
	MouseMove($pos[0], $pos[1], 1)
EndFunc   ;==>Login


Func ArrangeEmulators()
	If Not IsPosClientRunning() Then
		Return
	EndIf
	$WndHnd = WinActivate($arrCONFIG[$CFG_SCANNER_CAPTION][1])
	If $WndHnd > 0 Then
		WinMove($arrCONFIG[$CFG_SCANNER_CAPTION][1], "", $arrCONFIG[$CFG_SCANNER_X][1], $arrCONFIG[$CFG_SCANNER_Y][1])
	EndIf
	$WndHnd = WinActivate($arrCONFIG[$CFG_PRINTER_CAPTION][1])
	If $WndHnd > 0 Then
		WinMove($arrCONFIG[$CFG_PRINTER_CAPTION][1], "", $arrCONFIG[$CFG_PRINTER_X][1], $arrCONFIG[$CFG_PRINTER_Y][1])
	EndIf
	$WndHnd = WinActivate($arrCONFIG[$CFG_SCALE_CAPTION][1])
	If $WndHnd > 0 Then
		WinMove($arrCONFIG[$CFG_SCALE_CAPTION][1], "", $arrCONFIG[$CFG_SCALE_X][1], $arrCONFIG[$CFG_SCALE_Y][1])
	EndIf
	$WndHnd = WinActivate($arrCONFIG[$CFG_DRAWER_CAPTION][1])
	If $WndHnd > 0 Then
		WinMove($arrCONFIG[$CFG_DRAWER_CAPTION][1], "", $arrCONFIG[$CFG_DRAWER_X][1], $arrCONFIG[$CFG_DRAWER_Y][1])
	EndIf
	$WndHnd = WinActivate($arrCONFIG[$CFG_WINEPTS_CAPTION][1])
	If $WndHnd > 0 Then
		WinMove($arrCONFIG[$CFG_WINEPTS_CAPTION][1], "", $arrCONFIG[$CFG_WINEPTS_X][1], $arrCONFIG[$CFG_WINEPTS_Y][1])
	EndIf
	$WndHnd = WinActivate($arrCONFIG[$CFG_UPB_CAPTION][1])
	If $WndHnd > 0 Then
		WinMove($arrCONFIG[$CFG_UPB_CAPTION][1], "", $arrCONFIG[$CFG_UPB_X][1], $arrCONFIG[$CFG_UPB_Y][1])
	EndIf
EndFunc   ;==>ArrangeEmulators


Func ScanLoyaltyCard()
	If Not IsPosClientRunning() Then
		Return
	EndIf
	$Scanme = StringStripWS(GUICtrlRead($idComboBox), 8)
	$hWndSCR = WinActivate($arrCONFIG[$CFG_SCANNER_CAPTION][1])
	ControlSend($hWndSCR, "", "[CLASS:Edit; INSTANCE:1]", "{HOME}{SHIFTDOWN}{END}{SHIFTUP}{DEL}")
	ControlSend($hWndSCR, "", "[CLASS:Edit; INSTANCE:1]", $arrCONFIG[$CFG_LOYALTY_CARD][1])
	ControlClick($hWndSCR, "", "[CLASS:Button; INSTANCE:5]")
	WinActivate("R10PosClient")
EndFunc   ;==>ScanLoyaltyCard


Func Scenario()
	If Not IsPosClientRunning() Then
		Return
	EndIf
	FileChangeDir($PostyperDir)
	$ScenariosFullDir = $ScenariosDir
	$SubPath = StringReplace($arrCONFIG[$CFG_SCENARIO_SUBPATH][1], '"', '')
	If $SubPath > 0 Then
		$ScenariosFullDir = $ScenariosDir & "\" & $SubPath
	EndIf
	Local $sScenarioFileName = FileOpenDialog("Select input file", $ScenariosFullDir & "\", "All (*.ini)", 1)
	If @error Then
		NoFilesSelectedMsgBox()
		FileChangeDir($PostyperDir)
	Else
		$sFileName = GetFileNameFromFullPath($sScenarioFileName)
		ScenarioAutomation("Scenario: " & $sFileName, $sScenarioFileName)
	EndIf
EndFunc   ;==>Scenario


Func Tendering()
	If Not IsPosClientRunning() Then
		Return
	EndIf
	ScenarioAutomation("Tendering...", $TenderngIniFile)
EndFunc   ;==>Tendering


Func Unlock()
	If Not IsPosClientRunning() Then
		Return
	EndIf
	WinActivate("R10PosClient")
	Local $pos = MouseGetPos()
	Sleep(300)
	BlockInput(1)
	MouseClick("left", 400, 250, 1, 1)
	Sleep(500)
	Send("{HOME}{SHIFTDOWN}{END}{SHIFTUP}{DEL}")
	$keys = StringSplit($arrCONFIG[$CFG_PASSWORD][1], "")
	For $i = 1 To $keys[0]
		Send($keys[$i])
	Next
	MouseClick("left", 920, 220, 1, 1)
	BlockInput(0)
	MouseMove($pos[0], $pos[1], 1)
EndFunc   ;==>Unlock


Func KillPOS()
	ShellExecute($HelpersDir & "\killPOS.cmd", "", "", "", @SW_MINIMIZE)
EndFunc   ;==>KillPOS


Func CleanLogs()
	$cmd = $HelpersDir & "\CleanLogs.cmd"
	$arg1 = $arrCONFIG[$CFG_SERVER_PATH][1] & " "
	$arg2 = $arrCONFIG[$CFG_POS_PATH][1] & " "
	$arg3 = $arrCONFIG[$CFG_OFFICE_PATH][1] & " "
	$arg4 = $arrCONFIG[$CFG_DMS_PATH][1] & " "
	$arg5 = $arrCONFIG[$CFG_ARSGATEWAY_PATH][1] & " "
	$arg6 = $arrCONFIG[$CFG_RETAILGATEWAY_PATH][1] & " "
	$arg7 = $arrCONFIG[$CFG_STOREGATEWAY_PATH][1] & " "
	$arg8 = $arrCONFIG[$CFG_WINEPTS_PATH][1] & " "
	$arguments = $arg1 & $arg2 & $arg3 & $arg4 & $arg5 & $arg6 & $arg7 & $arg8
	ShellExecute($cmd, $arguments, "", "", @SW_MAXIMIZE)
EndFunc   ;==>CleanLogs


Func BrowseServer()
	ShellExecute($arrCONFIG[$CFG_BROWSER][1], $arrCONFIG[$CFG_SERVER_WEBSITE][1])
EndFunc   ;==>BrowseServer


Func MonitorSrvLog()
	$ServerLogsDir = $arrCONFIG[$CFG_SERVER_PATH][1] & "\Logs\"
	$hSearch = FileFindFirstFile($ServerLogsDir & "GPOSWebService_*.log")
	If $hSearch > 0 Then
		$LastGpos = FileFindNextFile($hSearch)
		ShellExecute($arrCONFIG[$CFG_EDITOR][1], " -monitor " & $ServerLogsDir & $LastGpos)
	EndIf
EndFunc   ;==>MonitorSrvLog


Func EditIni()
	ShellExecute($arrCONFIG[$CFG_EDITOR][1], $cfgFile)
	Sleep(5000)
	ReloadItemsFile()
	ReloadConfigFile()
EndFunc   ;==>EditIni


Func DebugOn()
	FileChangeDir($HelpersDir)
	$WebLoggerConfig = $arrCONFIG[$CFG_SERVER_PATH][1] & "\" & "WebLoggerConfig.xml"
	ShellExecute($HelpersDir & "\SetLogger.exe", $WebLoggerConfig & " DEBUG", "", "", @SW_MAXIMIZE)
	FileChangeDir(@ScriptDir)
EndFunc   ;==>DebugOn


Func DebugOff()
	$WebLoggerConfig = $arrCONFIG[$CFG_SERVER_PATH][1] & "\" & "WebLoggerConfig.xml"
	ShellExecute($HelpersDir & "\SetLogger.exe", $WebLoggerConfig & " ERROR", "", "", @SW_MAXIMIZE)
EndFunc   ;==>DebugOff


Func ExposeLogs()
	$PosLogs = $arrCONFIG[$CFG_POS_PATH][1] & "\Logs"
	If FileExists($PosLogs) Then
		ShellExecute("C:\Windows\explorer.exe", $PosLogs)
	EndIf
	$ServerLogs = $arrCONFIG[$CFG_SERVER_PATH][1] & "\Logs"
	If FileExists($ServerLogs) Then
		ShellExecute("C:\Windows\explorer.exe", $ServerLogs)
	EndIf
EndFunc   ;==>ExposeLogs


Func CollectLogs()
	If Not FileExists($CollectedDir) Then
		DirCreate($CollectedDir)
	EndIf
	$cmd = $HelpersDir & "\CollectLogs.cmd"
	$arg1 = $CollectedDir & " "
	$arg2 = $arrCONFIG[$CFG_SERVER_PATH][1] & " "
	$arg3 = $arrCONFIG[$CFG_POS_PATH][1] & " "
	$arg4 = $arrCONFIG[$CFG_OFFICE_PATH][1] & " "
	$arg5 = $arrCONFIG[$CFG_DMS_PATH][1] & " "
	$arg6 = $arrCONFIG[$CFG_ARSGATEWAY_PATH][1] & " "
	$arg7 = $arrCONFIG[$CFG_RETAILGATEWAY_PATH][1] & " "
	$arg8 = $arrCONFIG[$CFG_STOREGATEWAY_PATH][1] & " "
	$arg9 = $arrCONFIG[$CFG_WINEPTS_PATH][1] & " "
	$arguments = $arg1 & $arg2 & $arg3 & $arg4 & $arg5 & $arg6 & $arg7 & $arg8 & $arg9
	ShellExecute($cmd, $arguments, "", "", @SW_MAXIMIZE)
EndFunc   ;==>CollectLogs


Func ReceiptDebugOn()
	FileChangeDir($HelpersDir)
	ShellExecute($HelpersDir & "\receiptdebug.cmd", $arrCONFIG[$CFG_RETAIL_DB_NAME][1], "", "", @SW_MAXIMIZE)
	FileChangeDir(@ScriptDir)
EndFunc   ;==>ReceiptDebugOn


Func ReceiptDebugOff()
	FileChangeDir($HelpersDir)
	ShellExecute($HelpersDir & "\receiptdebugoff.cmd", $arrCONFIG[$CFG_RETAIL_DB_NAME][1], "", "", @SW_MAXIMIZE)
	FileChangeDir(@ScriptDir)
EndFunc   ;==>ReceiptDebugOff


Func ViewSlip()
	Local $sFileOpenDialog = FileOpenDialog("Select input file", $arrCONFIG[$CFG_TLOG_PATH][1], "TLOG (RetailTransactionLog*.xml)", 1)
	If @error Then
		NoFilesSelectedMsgBox()
		FileChangeDir(@ScriptDir)
	Else
		FileChangeDir($HelpersDir)
		ShellExecute($HelpersDir & "\ReceiptView.exe", $sFileOpenDialog & " " & $HelpersDir, "", "", @SW_MAXIMIZE)
		Sleep(1500)
		ShellExecute("c:\temp\Receipt.html", "", "", "", @SW_MAXIMIZE)
		FileChangeDir(@ScriptDir)
	EndIf
EndFunc   ;==>ViewSlip


Func ExposeTLog()
	$TLogs = $arrCONFIG[$CFG_TLOG_PATH][1]
	If FileExists($TLogs) Then
		ShellExecute("C:\Windows\explorer.exe", $TLogs)
	EndIf
EndFunc   ;==>ExposeTLog


Func SnipPOS()
	If Not IsPosClientRunning() Then
		Return
	EndIf
	If Not FileExists($CaptureDir) Then
		DirCreate($CaptureDir)
	EndIf
	Local $hBmp
	WinActivate($g_hPosTyper)
	WinSetState($g_hPosTyper, "", @SW_MINIMIZE)
	Sleep(250)
	$hBmp = _ScreenCapture_Capture("", 0, 0, 1024, 768)
	$ImageName = $CaptureDir & "\PosSnip_" & @HOUR & "_" & @MIN & "_" & @SEC & ".jpg"
	_ScreenCapture_SaveImage($ImageName, $hBmp)
	ShellExecute($ImageName)
EndFunc   ;==>SnipPOS


Func SnipScreen()
	If Not FileExists($CaptureDir) Then
		DirCreate($CaptureDir)
	EndIf
	Local $hBmp
	WinActivate($g_hPosTyper)
	WinSetState($g_hPosTyper, "", @SW_MINIMIZE)
	Sleep(250)
	$hBmp = _ScreenCapture_Capture("")
	$ImageName = $CaptureDir & "\ScreenSnip_" & @HOUR & "_" & @MIN & "_" & @SEC & ".jpg"
	_ScreenCapture_SaveImage($ImageName, $hBmp)
	ShellExecute($ImageName)
EndFunc   ;==>SnipScreen


Func CleanScanner()
	If Not IsPosClientRunning() Then
		Return
	EndIf
	$hWndSCR = WinActivate($arrCONFIG[$CFG_SCANNER_CAPTION][1])
	ControlSend($hWndSCR, "", "[CLASS:Edit; INSTANCE:1]", "{HOME}{SHIFTDOWN}{END}{SHIFTUP}{DEL}")
EndFunc   ;==>CleanScanner


Func BrowseRabbit()
	ShellExecute($arrCONFIG[$CFG_BROWSER][1], $arrCONFIG[$CFG_RABBITMQ_WEBSITE][1])
EndFunc   ;==>BrowseRabbit


Func IISReset()
	ShellExecute($HelpersDir & "\iisreset.cmd", "", "", "", @SW_MAXIMIZE)
EndFunc   ;==>IISReset


Func IISStop()
	ShellExecute($HelpersDir & "\iisreset_stop.cmd", "", "", "", @SW_MAXIMIZE)
EndFunc   ;==>IISStop


Func IISStart()
	ShellExecute($HelpersDir & "\iisreset_start.cmd", "", "", "", @SW_MAXIMIZE)
EndFunc   ;==>IISStart


Func OpenCMD()
	Run($arrCONFIG[$CFG_CMD][1])
EndFunc   ;==>OpenCMD


Func OpenSpooky()
	$SpookyExe = $arrCONFIG[$CFG_SPOOKY_PATH][1] & "\" & "R10WebClient.exe"
	If FileExists($SpookyExe) Then
		Run($SpookyExe, $arrCONFIG[$CFG_SPOOKY_PATH][1] & "\")
	EndIf
EndFunc   ;==>OpenSpooky


Func OpenServices()
	ShellExecute("C:\Windows\System32\services.msc")
EndFunc   ;==>OpenServices


Func OpenSSMS()
	ShellExecute($arrCONFIG[$CFG_SQLMGR][1], "-E")
EndFunc   ;==>OpenSSMS


Func OpenSnoop()
	ShellExecute($arrCONFIG[$CFG_SNOOP][1], "")
EndFunc   ;==>OpenSnoop


Func CopyServerExtToCust()
	$cmd = $HelpersDir & "\CopyServerExtToCust.cmd"
	$arg1 = $arrCONFIG[$CFG_SERVER_DBG_CUST_PATH][1] & " "
	$arg2 = $arrCONFIG[$CFG_SERVER_DBG_EXT_PATH][1] & " "
	$arguments = $arg1 & $arg2
	ShellExecute($cmd, $arguments, "", "", @SW_MAXIMIZE)
EndFunc   ;==>CopyServerExtToCust


Func CopyPosExtToCust()
	$cmd = $HelpersDir & "\CopyPosExtToCust.cmd"
	$arg1 = $arrCONFIG[$CFG_POS_DBG_CUST_PATH][1] & " "
	$arg2 = $arrCONFIG[$CFG_POS_DBG_EXT_PATH][1] & " "
	$arguments = $arg1 & $arg2
	ShellExecute($cmd, $arguments, "", "", @SW_MAXIMIZE)
EndFunc   ;==>CopyPosExtToCust


Func CopyOfficeExtToCust()
	$cmd = $HelpersDir & "\CopyOfficeExtToCust.cmd"
	$arg1 = $arrCONFIG[$CFG_OFFICE_DBG_CUST_PATH][1] & " "
	$arg2 = $arrCONFIG[$CFG_OFFICE_DBG_EXT_PATH][1] & " "
	$arguments = $arg1 & $arg2
	ShellExecute($cmd, $arguments, "", "", @SW_MAXIMIZE)
EndFunc   ;==>CopyOfficeExtToCust


Func ToEnglish()
	FileChangeDir($HelpersDir)
	ShellExecute($HelpersDir & "\jumbo_update_to_english.cmd", $arrCONFIG[$CFG_RETAIL_DB_NAME][1], "", "", @SW_MAXIMIZE)
	FileChangeDir(@ScriptDir)
EndFunc   ;==>ToEnglish


Func ToDutch()
	FileChangeDir($HelpersDir)
	ShellExecute($HelpersDir & "\jumbo_update_to_dutch.cmd", $arrCONFIG[$CFG_RETAIL_DB_NAME][1], "", "", @SW_MAXIMIZE)
	FileChangeDir(@ScriptDir)
EndFunc   ;==>ToDutch


; === Currently Unused Functions ================================================================================


;~ Func Autmation()
;~ 	$keys = StringSplit(StringStripWS(GUICtrlRead($idComboBox),8),"=")
;~ 	;~ MsgBox($MB_SYSTEMMODAL, "",  $keys[2])
;~ 	If WinExists("R10PosClient") == 1 Then
;~ 		WinActivate("R10PosClient")
;~     EndIf
;~ 	$hWndSCR = WinActivate($arrCONFIG[$CFG_SCANNER_CAPTION][1])
;~ 	ControlSend($hWndSCR,"","[CLASS:Edit; INSTANCE:1]","{HOME}{SHIFTDOWN}{END}{SHIFTUP}{DEL}")
;~     ControlSend($hWndSCR,"","[CLASS:Edit; INSTANCE:1]",$keys[2])
;~     ControlClick($hWndSCR,"","[CLASS:Button; INSTANCE:4]")
;~ EndFunc

;~ Func Checkdigit()
;~ 	$Number = GUICtrlRead($idComboBox)
;~ 	$SUMME=0
;~ 	For $i = 1 To 12
;~ 	$tempstr = StringLeft($Number,$i)
;~ 	$NUM = StringRight($tempstr,1)
;~ 	Mod($i,2)
;~ 	$SUMME+= Mod($i,2) == 0 ? $NUM * 3 : $NUM
;~ 	Next
;~ 	$CHECKDIGIT = MOD($SUMME,10) == 0 ? 0 : 10 - MOD($summe,10)
;~ 	 _GUICtrlComboBox_SetEditText($idComboBox,StringLeft($Number,12) & $CHECKDIGIT)
;~ EndFunc

;~ Func ResetLoy()
;~ 	ShellExecute($HelpersDir & "\resetloy.cmd","","","",@SW_MINIMIZE)
;~ EndFunc


;~ Func FLDiag()
;~ 	ShellExecute($HelpersDir & "\FLDiag.cmd","","","",@SW_MAXIMIZE)
;~ EndFunc

;~ Func Msg3On()
;~ 	ShellExecute($HelpersDir & "\msg3.bat","","","",@SW_MAXIMIZE)
;~ EndFunc

;~ Func Msg3Off()
;~ 	ShellExecute($HelpersDir & "\nomsg3.bat","","","",@SW_MAXIMIZE)
;~ EndFunc




; === Helper Functions ==============================================================================================

Func ReadConfigAndItemsFiles()
	ReloadItemsFile()
	ReloadConfigFile()
	ReloadDialogsFile()
EndFunc   ;==>ReadConfigAndItemsFiles


Func GetItemNumberFromCombo()
	$SelectedItem = StringStripWS(GUICtrlRead($idComboBox), $STR_STRIPALL)
	$Tokens = StringSplit($SelectedItem, "-")
	$numberOfTokens = $Tokens[0]
	If $numberOfTokens < 1 Then
		Return ""
	EndIf
	$Item = StringStripWS($Tokens[1], $STR_STRIPALL)
	$ItemIsNumber = StringRegExp($Item, "^\d+$")
	If Not $ItemIsNumber Then
		ExtMsgBox($EMB_ICONEXCLAM, $MB_OK, "PosTyper", $Item & " is not a number", 3, $g_hPosTyper)
		Return ""
	EndIf
	If $numberOfTokens > 1 Then
		$Desc = StringStripWS($Tokens[2], $STR_STRIPALL)
	EndIf
	Return $Item
EndFunc   ;==>GetItemNumberFromCombo


Func Press0()
	MouseClick("left", 580, 625, 1, 1)
EndFunc   ;==>Press0

Func Press1()
	MouseClick("left", 580, 555, 1, 1)
EndFunc   ;==>Press1

Func Press2()
	MouseClick("left", 650, 555, 1, 1)
EndFunc   ;==>Press2

Func Press3()
	MouseClick("left", 730, 555, 1, 1)
EndFunc   ;==>Press3

Func Press4()
	MouseClick("left", 580, 480, 1, 1)
EndFunc   ;==>Press4

Func Press5()
	MouseClick("left", 650, 480, 1, 1)
EndFunc   ;==>Press5

Func Press6()
	MouseClick("left", 730, 480, 1, 1)
EndFunc   ;==>Press6

Func Press7()
	MouseClick("left", 580, 405, 1, 1)
EndFunc   ;==>Press7

Func Press8()
	MouseClick("left", 650, 405, 1, 1)
EndFunc   ;==>Press8

Func Press9()
	MouseClick("left", 730, 405, 1, 1)
EndFunc   ;==>Press9

Func PressX()
	MouseClick("left", 800, 480, 1, 1)
EndFunc   ;==>PressX

Func PressEnter()
	Sleep(500)
	MouseClick("left", 800, 630, 1, 1)
EndFunc   ;==>PressEnter


Func ScenarioAutomation($ProgressBarCaption, $sFileName)
	$LastBtnClickedOK = True
	FileChangeDir($PostyperDir)
	$arrItems = IniReadSection($sFileName, "SCENARIO")

	If WinExists("R10PosClient") Then
		WinActivate("R10PosClient")
	EndIf

	$bBreakByUser = False

	If $ShowProgressBar Then
		$aPos = WinGetPos($g_hPosTyper)
		$xPOS = $aPos[0] + 15
		$yPOS = $aPos[1] + $aPos[3] / 4 + 30
		ProgressOn($ProgressBarCaption, "", "0%", $xPOS, $yPOS, $DLG_MOVEABLE)
	EndIf

	$NumOfItems = $arrItems[0][0]

	For $i = 1 To $NumOfItems

		WinActivate("R10PosClient")
		;MsgBox($MB_SYSTEMMODAL, "", "Key: " & $arrItems[$i][0] & @CRLF & "Value: " & $arrItems[$i][1])

		$KeyToStatusBar = $arrItems[$i][0]
		$ValToStatusBar = $arrItems[$i][1]

		If $KeyToStatusBar = "wait" Then
			$ValToStatusBar *= $AutomationSpeedFactor
		EndIf

		$StatusBarText = $KeyToStatusBar & " = " & $ValToStatusBar
		WriteToStatusBar("Scenario", $StatusBarText)

		If $arrItems[$i][0] = "item" Or $arrItems[$i][0] = "card" Then
			$hWndSCR = WinActivate($arrCONFIG[$CFG_SCANNER_CAPTION][1])
			ControlSend($hWndSCR, "", "[CLASS:Edit; INSTANCE:1]", "{HOME}{SHIFTDOWN}{END}{SHIFTUP}{DEL}")
			ControlSend($hWndSCR, "", "[CLASS:Edit; INSTANCE:1]", $arrItems[$i][1])
			ControlClick($hWndSCR, "", "[CLASS:Button; INSTANCE:5]")

			For $j = 1 To 10
				Sleep(50)
				$sText = ControlGetText($hWndSCR, "", "[CLASS:Edit; INSTANCE:3]")
				If $sText = "Claimed,Enabled" Then ExitLoop
			Next
			WinActivate("R10PosClient")
		ElseIf $arrItems[$i][0] = "button" Then
			If $arrItems[$i][1] = "QTY" Then
				PressX()
			EndIf
			If $arrItems[$i][1] = "ENTER" Or $arrItems[$i][1] = "TO_TENDER" Then
				PressEnter()
			EndIf
			If $arrItems[$i][1] = "DIALOG_MID_OK" Then
				MouseClick("left", 520, 520, 1, 1)
			EndIf
			If $arrItems[$i][1] = "TENDER_1" Then
				MouseClick("left", 930, 110, 1, 1)
			EndIf
			If $arrItems[$i][1] = "TENDER_2" Then
				MouseClick("left", 930, 170, 1, 1)
			EndIf
			If $arrItems[$i][1] = "TENDER_3" Then
				MouseClick("left", 930, 240, 1, 1)
			EndIf
			If $arrItems[$i][1] = "TENDER_4" Then
				MouseClick("left", 930, 310, 1, 1)
			EndIf
			If $arrItems[$i][1] = "TENDER_5" Then
				MouseClick("left", 930, 370, 1, 1)
			EndIf
			If $arrItems[$i][1] = "TENDER_6" Then
				MouseClick("left", 30, 440, 1, 1)
			EndIf
			If $arrItems[$i][1] = "TENDER_7" Then
				MouseClick("left", 930, 510, 1, 1)
			EndIf
			If $arrItems[$i][1] = "TENDER_UP" Then
				MouseClick("left", 910, 580, 1, 1)
			EndIf
			If $arrItems[$i][1] = "TENDER_DOWN" Then
				MouseClick("left", 960, 580, 1, 1)
			EndIf
			If $arrItems[$i][1] = "TENDER_BACK" Then
				MouseClick("left", 930, 630, 1, 1)
			EndIf
			If $arrItems[$i][1] = "CLOSE_CHANGE" Then
				MouseClick("left", 730, 535, 1, 1)
			EndIf
			If $arrItems[$i][1] = "LEFT_TOP" Then
				MouseClick("left", 585, 140, 1, 1)
			EndIf
			If $arrItems[$i][1] = "RIGHT_TOP" Then
				MouseClick("left", 690, 140, 1, 1)
			EndIf
			If $arrItems[$i][1] = "LEFT_BOTTOM" Then
				MouseClick("left", 589, 195, 1, 1)
			EndIf
			If $arrItems[$i][1] = "RIGHT_BOTTOM" Then
				MouseClick("left", 690, 195, 1, 1)
			EndIf
			If $arrItems[$i][1] = "MANUAL_ENTRY" Then
				MouseClick("left", 795, 165, 1, 1)
			EndIf
			If $arrItems[$i][1] = '0' Then
				Press0()
			EndIf
			If $arrItems[$i][1] = '1' Then
				Press1()
			EndIf
			If $arrItems[$i][1] = '2' Then
				Press2()
			EndIf
			If $arrItems[$i][1] = '3' Then
				Press3()
			EndIf
			If $arrItems[$i][1] = '4' Then
				Press4()
			EndIf
			If $arrItems[$i][1] = '5' Then
				Press5()
			EndIf
			If $arrItems[$i][1] = '6' Then
				Press6()
			EndIf
			If $arrItems[$i][1] = '7' Then
				Press7()
			EndIf
			If $arrItems[$i][1] = '8' Then
				Press8()
			EndIf
			If $arrItems[$i][1] = '9' Then
				Press9()
			EndIf
		ElseIf $arrItems[$i][0] = "wait" Then
			If $LastBtnClickedOK Then
				Sleep($ValToStatusBar)
			EndIf
			$LastBtnClickedOK = True
		ElseIf $arrItems[$i][0] = "skip" Then
			$NumOfDialogs = $arrDialogs[0][0]
			For $j = 1 To $NumOfDialogs
				$arrDialog = $arrDialogs[$j][1]
				If $arrItems[$i][1] = $arrDialog[1] Then
					$LastBtnClickedOK = SkipDialog($arrDialog)
					ExitLoop
				EndIf
			Next
		ElseIf $arrItems[$i][0] = "user" Then
			ExtMsgBox($EMB_ICONINFO, $MB_OK, "PosTyper Automation - Wait for User", $arrItems[$i][1] & @CRLF & @CRLF & "Dismiss me to continue scenario", Null, $g_hPosTyper)
		ElseIf $arrItems[$i][0] = "break" Then
			$nAnswer = ExtMsgBox($EMB_ICONQUERY, "Yes|~No", "PosTyper Automation - Quit Scenario", $arrItems[$i][1], 6, $g_hPosTyper)
			If $nAnswer = 1 Then
				$bBreakByUser = True
				ExitLoop
			EndIf
		EndIf
		If $ShowProgressBar Then
			$Percents = Int($i / $NumOfItems * 100)
			ProgressSet($Percents, $StatusBarText, $Percents & "%")
		EndIf
	Next
	If $ShowProgressBar Then
		If Not $bBreakByUser Then
			ProgressSet(100, $StatusBarText, $Percents & "%")
			Sleep(2000)
		EndIf
		ProgressOff()
	EndIf
EndFunc   ;==>ScenarioAutomation


Func SkipDialog($Tokens)
	WinActivate("R10PosClient")
	$oP1 = _UIA_getObjectByFindAll($UIA_oDesktop, "Title:=" & $Tokens[2] & ";controltype:=UIA_WindowControlTypeId;class:=Window", $treescope_children)
	$oText1 = _UIA_getObjectByFindAll($oP1, "title:=" & $Tokens[3] & ";ControlType:=UIA_ButtonControlTypeId", $treescope_subtree)
	If IsObj($oText1) Then
		_UIA_action($oText1, "click")
		Return True
	EndIf
	$oText2 = _UIA_getObjectByFindAll($oP1, "title:=" & $Tokens[4] & ";ControlType:=UIA_ButtonControlTypeId", $treescope_subtree)
	If IsObj($oText2) Then
		_UIA_action($oText2, "click")
		Return True
	EndIf
	Return False
EndFunc


Func WriteToStatusBar($MethodName, $Txt = "")
	$Seperator = ": "
	If $Txt == "" Then
		$Seperator = ""
	EndIf
	If $ShowStatusBar Then
		_GUICtrlStatusBar_SetText($g_hPosTyperStatusBar, "  " & $MethodName & $Seperator & $Txt)
	EndIf
EndFunc   ;==>WriteToStatusBar


Func FuncWrapper($Button, $BtnCaption, $FuncName, $Disable = False)
	WriteToStatusBar($BtnCaption)
	If $Disable Then
		GUICtrlSetState($Button, $GUI_DISABLE)
		Sleep(200)
	EndIf
	$FuncName()
	If $Disable Then
		GUICtrlSetState($Button, $GUI_ENABLE)
	EndIf
	WinActivate($g_hPosTyper)
EndFunc   ;==>FuncWrapper


Func IsPosClientRunning()
	If Not WinExists("R10PosClient") Then
		ExtMsgBox($EMB_ICONEXCLAM, $MB_OK, "PosTyper", "PosClient not running", 7, $g_hPosTyper)
		Return False
	EndIf
	Return True
EndFunc   ;==>IsPosClientRunning


Func NoFilesSelectedMsgBox()
	ExtMsgBox($EMB_ICONINFO, $MB_OK, "PosTyper", "No file(s) were selected", 4, $g_hPosTyper)
EndFunc   ;==>NoFilesSelectedMsgBox


Func GetDialogHeight($Height, $ShowStatusBar, $ShowExtDeveloperLine, $ShowLanguageSwitcherLine)
	$RowHeight = 30
	$StatusBarHeight = 20
	If $ShowExtDeveloperLine Then
		$Height += $RowHeight
	EndIf
	If $ShowLanguageSwitcherLine Then
		$Height += $RowHeight
	EndIf
	If $ShowStatusBar Then
		$Height += $StatusBarHeight
	EndIf
	Return $Height
EndFunc   ;==>GetDialogHeight


Func StringIsTrue($BoolString)
	Return StringLower(StringStripWS($BoolString, $STR_STRIPALL)) == "true"
EndFunc   ;==>StringIsTrue


Func IsEnglishBackupDbTablesExist()
	FileChangeDir($HelpersDir)
	EnvSet("RETAIL_DB_NAME_TEMP_VAR", $arrCONFIG[$CFG_RETAIL_DB_NAME][1])
	$retCode = RunWait($HelpersDir & "\jumbo_test_english_exists.cmd", "", @SW_HIDE)
	$BackupExists = $retCode == 1
	FileChangeDir(@ScriptDir)
	Return $BackupExists
EndFunc   ;==>IsEnglishBackupDbTablesExist


Func IsDutchBackupDbTablesExist()
	FileChangeDir($HelpersDir)
	EnvSet("RETAIL_DB_NAME_TEMP_VAR", $arrCONFIG[$CFG_RETAIL_DB_NAME][1])
	$retCode = RunWait($HelpersDir & "\jumbo_test_dutch_exists.cmd", "", @SW_HIDE)
	$BackupExists = $retCode == 1
	FileChangeDir(@ScriptDir)
	Return $BackupExists
EndFunc   ;==>IsDutchBackupDbTablesExist


Func DisableLanguageButtonsIfDbNotReady($idBtnToEnglish, $idBtnToDutch)
	If Not IsEnglishBackupDbTablesExist() Then
		GUICtrlSetState($idBtnToEnglish, $GUI_DISABLE)
	EndIf
	If Not IsDutchBackupDbTablesExist() Then
		GUICtrlSetState($idBtnToDutch, $GUI_DISABLE)
	EndIf
EndFunc   ;==>DisableLanguageButtonsIfDbNotReady


Func Copyrights()
	WriteToStatusBar("© Created by Christian H, enhanced by Yossi S", "")
EndFunc   ;==>Copyrights


Func ExtMsgBox($vIcon, $vButton, $sTitle, $sText, $iTimeout, $hWin)
	;_ExtMsgBoxSet(2, $SS_CENTER, -1, -1, -1, -1, Default, Default, "#")
	_ExtMsgBoxSet(1)
	$iRetValue = _ExtMsgBox($vIcon, $vButton, $sTitle, $sText, $iTimeout, $hWin)
	_ExtMsgBoxSet(Default)
	return $iRetValue
EndFunc   ;==>ExtMsgBox


Func GetFileNameFromFullPath($TEST)
	$FILENAME = ""
	$PATH = ""
	$TITLE = ""
	$EXT_START = 0
	$FILE_START = 0
	For $X = StringLen($TEST) To 2 Step -1
		If StringMid($TEST, $X, 1) = "." And $EXT_START = 0 Then $EXT_START = $X
		If StringMid($TEST, $X, 1) = "\" And $FILE_START = 0 Then $FILE_START = $X
		If $FILE_START > 0 Then
			$FILENAME = StringTrimLeft($TEST, $FILE_START)
			$TITLE = StringLeft($FILENAME, $EXT_START - $FILE_START - 1)
			$PATH = StringLeft($TEST, $FILE_START)
			ExitLoop
		EndIf
	Next
	Return $FILENAME
EndFunc   ;==>GetFileNameFromFullPath


Func ReloadConfigFile()
	$arrPosTyper	= IniReadSection($cfgFile, "PosTyper")
	$arrEnv			= IniReadSection($cfgFile, "Env")
	$arrR10			= IniReadSection($cfgFile, "R10")
	$arrDev			= IniReadSection($cfgFile, "Dev")
	$arrHelpers		= IniReadSection($cfgFile, "Helpers")
	$arrPOS			= IniReadSection($cfgFile, "POS")
	$arrEmulators	= IniReadSection($cfgFile, "Emulators")
	$arrCONFIG = $arrPosTyper
	_ArrayConcatenate($arrCONFIG, $arrEnv, 1)
	_ArrayConcatenate($arrCONFIG, $arrR10, 1)
	_ArrayConcatenate($arrCONFIG, $arrDev, 1)
	_ArrayConcatenate($arrCONFIG, $arrHelpers, 1)
	_ArrayConcatenate($arrCONFIG, $arrPOS, 1)
	_ArrayConcatenate($arrCONFIG, $arrEmulators, 1)
	$arrCONFIG[0][0] = $arrPosTyper[0][0] + $arrEnv[0][0] + $arrR10[0][0] + $arrDev[0][0] + $arrHelpers[0][0] + $arrPOS[0][0] + $arrEmulators[0][0]
EndFunc   ;==>ReloadConfigFile


Func ReloadDialogsFile()
	$arrDialogsTemp = IniReadSection($SkipDialogsIniFile, "Vocabulary")
	$NumOfItems = $arrDialogsTemp[0][0]
	ReDim $arrDialogs[$NumOfItems+1][2]
	$arrDialogs[0][0] = $NumOfItems
	For $i = 1 To $NumOfItems
		$Val = $arrDialogsTemp[$i][1]
		$Tokens = StringSplit($Val, "|")
		$arrDialogs[$i][1] = $Tokens
	Next
EndFunc   ;==>ReloadDialogsFile


Func ReloadItemsFile()
	$arrItems = IniReadSection($ItemsIniFile, "Items")
EndFunc   ;==>ReloadItemsFile
