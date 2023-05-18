#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
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

#RequireAdmin

;AutoItSetOption("MustDeclareVars", 1)

global $PostyperDir = @Scriptdir
global $ScenariosDir = @Scriptdir &"\scenarios"
global $HelpersDir = @Scriptdir &"\helpers"
global $CollectedDir = @Scriptdir &"\collected_logs"
global $CaptureDir = @Scriptdir &"\captured_images"
global $ItemsdDir = @Scriptdir &"\items"
global $TenderingDir = @Scriptdir &"\tendering"

global $ItemsIniFile = $ItemsdDir & "\Items.ini"
global $TenderngIniFile = $TenderingDir & "\tendering.ini"
global $cfgFile = @Scriptdir & "\POStyper.ini"
global $icoFile = @Scriptdir & "\POStyper.ico"

global $arrItems
global $arrCONFIG

global $CFG_DIALOG_CAPTION						= 1
global $CFG_DIALOG_X									= 2
global $CFG_DIALOG_Y									= 3
global $CFG_DIALOG_STATUS_BAR					= 4
global $CFG_DIALOG_PROGRESS_BAR			= 5
global $CFG_DIALOG_EXT_DEVELOPER			= 6
global $CFG_DIALOG_LANG_SWITCHER			= 7
global $CFG_DIALOG_SCENARIO_SUBPATH		= 8
global $CFG_DIALOG_AUTO_SPEED_FACTOR	= 9
global $CFG_RETAIL_DB_NAME						= 10
global $CFG_SERVER_WEBSITE						= 11
global $CFG_RABBITMQ_WEBSITE					= 12
global $CFG_SERVER_PATH							= 13
global $CFG_POS_PATH									= 14
global $CFG_OFFICE_PATH								= 15
global $CFG_TLOG_PATH								= 16
global $CFG_DMS_PATH									= 17
global $CFG_SPOOKY_PATH							= 18
global $CFG_ARSGATEWAY_PATH					= 19
global $CFG_RETAILGATEWAY_PATH				= 20
global $CFG_STOREGATEWAY_PATH				= 21
global $CFG_WINEPTS_PATH							= 22
global $CFG_SERVER_DBG_CUST_PATH			= 23
global $CFG_SERVER_DBG_EXT_PATH				= 24
global $CFG_POS_DBG_CUST_PATH				= 25
global $CFG_POS_DBG_EXT_PATH					= 26
global $CFG_OFFICE_DBG_CUST_PATH			= 27
global $CFG_OFFICE_DBG_EXT_PATH				= 28
global $CFG_CMD											= 29
global $CFG_SQLMGR										= 30
global $CFG_EDITOR										= 31
global $CFG_BROWSER									= 32
global $CFG_SNOOP										= 33
global $CFG_USER											= 34
global $CFG_PASSWORD								= 35
global $CFG_LOYALTY_CARD							= 36
global $CFG_SCANNER_EMU_CAPTION			= 37
global $CFG_SCANNER_EMU_X						= 38
global $CFG_SCANNER_EMU_Y						= 39
global $CFG_PRINTER_EMU_CAPTION				= 40
global $CFG_PRINTER_EMU_X							= 41
global $CFG_PRINTER_EMU_Y							= 42
global $CFG_SCALE_EMU_CAPTION					= 43
global $CFG_SCALE_EMU_X							= 44
global $CFG_SCALE_EMU_Y							= 45
global $CFG_DRAWER_EMU_CAPTION				= 46
global $CFG_DRAWER_EMU_X							= 47
global $CFG_DRAWER_EMU_Y							= 48
global $CFG_WINEPTS_EMU_CAPTION				= 49
global $CFG_WINEPTS_EMU_X						= 50
global $CFG_WINEPTS_EMU_Y						= 51
global $CFG_UPB_EMU_CAPTION					= 52
global $CFG_UPB_EMU_X								= 53
global $CFG_UPB_EMU_Y								= 54

If _Singleton("POStyper", 1) = 0 Then
	ExtMsgBox($EMB_ICONINFO, $MB_OK, "PosTyper", "PosTyper is already running", 3, False)	
    Exit
EndIf

_readItemFile()

Main()

Func _readItemFile()
	ReloadItemsFile()
	ReloadConfigFile()
EndFunc

Func Main()
	
	$PosTyperDialogX = @DesktopWidth - 333
	$PosTyperDialogY = 0
	$PosTyperDialogWidth = 333
	$PosTyperDialogHeight = 285
	
	Global $DefaultAutomationSpeedFactor = 1
	Global $AutomationSpeedFactor = $DefaultAutomationSpeedFactor
	Global $ShowStatusBar = StringIsTrue($arrCONFIG[$CFG_DIALOG_STATUS_BAR][1])
	Global $ShowExtDeveloperLine = StringIsTrue($arrCONFIG[$CFG_DIALOG_EXT_DEVELOPER][1])
	Global $ShowLanguageSwitcherLine = StringIsTrue($arrCONFIG[$CFG_DIALOG_LANG_SWITCHER][1])
	Global $ShowProgressBar = StringIsTrue($arrCONFIG[$CFG_DIALOG_PROGRESS_BAR][1])
	
	$PosTyperDialogHeight = GetDialogHeight($PosTyperDialogHeight, $ShowStatusBar, $ShowExtDeveloperLine, $ShowLanguageSwitcherLine)
	
	If ($arrCONFIG[$CFG_DIALOG_X][1] >= 0 And $arrCONFIG[$CFG_DIALOG_Y][1] >= 0) Then
		$PosTyperDialogX = $arrCONFIG[$CFG_DIALOG_X][1]
		$PosTyperDialogY = $arrCONFIG[$CFG_DIALOG_Y][1]
	EndIf
	
    Global $g_hPosTyper = GUICreate($arrCONFIG[$CFG_DIALOG_CAPTION][1], $PosTyperDialogWidth, $PosTyperDialogHeight, $PosTyperDialogX, $PosTyperDialogY, -1, $WS_EX_ACCEPTFILES)
	
	GUISetIcon($icoFile)
	
	Global $g_hPosTyperStatusBar
	If ($ShowStatusBar) Then		
		$g_hPosTyperStatusBar = _GUICtrlStatusBar_Create($g_hPosTyper)
	EndIf	
	
    GUICtrlSetState(-1, $GUI_DROPACCEPTED)
	Global $idComboBox = GUICtrlCreateCombo("", 10, 10, 210, 20)
    for $i = 1 to $arrItems[0][0]
		GUICtrlSetData($idComboBox, $arrItems[$i][1], $arrItems[1][1])
	Next

	Local $captionScan = 					"Scan"
	;Local $captionCD = 						"CD"
	Local $captionType = 						"Type"
	Local $captionAutomationSpeed =	"x" & $DefaultAutomationSpeedFactor
	
	;Local $captionAuto = 					"Gal"
	
	Local $captionStartPOS = 				"Start POS"
	Local $captionLogin = 					"Login"
	Local $captionEmuArrange = 			"Move Emu"
	Local $captionScanLoyaltyCard = 	"Scan Loyalty"
	
	Local $captionScenario = 				"Scenario"
	Local $captionTendering = 				"Tendering"
	Local $captionUnlock = 					"Unlock"
	Local $captionKillPOS =	 				"Kill POS"
	
	Local $captionCleanLogs = 				"Clean Logs"
	Local $captionBrowseServer =		"Browse Srv"
	Local $captionMonitoSrvLog =			"View Gpos"
	Local $captionEditIni = 					"Edit Ini"

	Local $captionDebugOn =   			"Gpos DBG"
	Local $captionDebugOff = 		    	"Gpos ERR"
	Local $captionExposeLogs = 			"Expose Logs"
	Local $captionExposeTLog = 			"Expose Tlog"

	Local $captionReceiptDebugOn = 	"Slip Dbg"
	Local $captionReceiptDebugOff = 	"No Slip Dbg"
	Local $captionViewSlip = 				"View Slip"
	Local $captionCollectLogs = 			"Collect Logs"
	
	Local $captionSnipPos =	 				"Snip POS"
	Local $captionSnipScreen = 			"Snip Screen"
	Local $captionCleanScanner = 		"Clean Scan"
	Local $captionBrowseRabbit =			"Rabbit"
	
	Local $captionIISReset = 				"IISReset"
	Local $captionIISStop = 				"IISStop"
	Local $captionIISStart = 				"IISStart"
	Local $captionOpenCMD = 				"CMD"
			
	Local $captionOpenSpooky = 			"Spooky"
	Local $captionOpenServices = 		"Services"
	Local $captionSQLMgmt = 				"SQL Mgmt"
	Local $captionOpenSnoop = 			"Snoop"
	
	Local $captionCopySrvExtToCust =	"Copy SrvExt"
	Local $captionCopyPOSExtToCust =	"Copy PosExt"
	Local $captionCopyOffExtToCust =	"Copy OfcExt"
	
	Local $captionToEnglish =				"To English"
	Local $captionToDutch =					"To Dutch"
	
	;Local $captionResetLoy =	 			"Reset Loy"
	;Local $captionMsg3On =   		    "MSG3"
	;Local $captionMsg3Off = 		    	"NO MSG3"
	;Local $captionFLDiag = 		   		"FLDiag"

	$RowHeight = 30
	Local $ROW_0	=	10
	Local $ROW_1	=	$ROW_0 + $RowHeight
	Local $ROW_2	=	$ROW_1 + $RowHeight
	Local $ROW_3	=	$ROW_2 + $RowHeight
	Local $ROW_4	=	$ROW_3 + $RowHeight
	Local $ROW_5	=	$ROW_4 + $RowHeight
	Local $ROW_6	=	$ROW_5 + $RowHeight
	Local $ROW_7	=	$ROW_6 + $RowHeight
	Local $ROW_8	=	$ROW_7 + $RowHeight
	Local $ROW_9	=	$ROW_8 + $RowHeight
	Local $ROW_10	=	$ROW_9 + $RowHeight
	
	$INVALID_HEIGHT	=	-100
	if (Not $ShowLanguageSwitcherLine) Then
		$ROW_10 = $INVALID_HEIGHT
	EndIf
	If ($ShowLanguageSwitcherLine And Not $ShowExtDeveloperLine) Then
		$ROW_10 = $ROW_9 
	EndIf
	if (Not $ShowExtDeveloperLine) Then
		$ROW_9 = $INVALID_HEIGHT
	EndIf

	$ColWidth = 80
	Local $Col_1	=	10
	Local $Col_2	=	$Col_1 + $ColWidth
	Local $Col_3	=	$Col_2 + $ColWidth
	Local $Col_4	=	$Col_3 + $ColWidth

	Local $BtnWidthS	=	35
	Local $BtnHeightS	=	23
	Local $BtnWidthL	=	70
	Local $BtnHeight	=	20

	Local $idBtnScan = 						GUICtrlCreateButton($captionScan						, 225, $ROW_0 - 1, $BtnWidthS, $BtnHeightS)
	;Local $idBtnCD = 							GUICtrlCreateButton($captionCD							, 225, $ROW_0 - 1, $BtnWidthS, $BtnHeightS)
	Local $idBtnType = 						GUICtrlCreateButton($captionType						, 260, $ROW_0 - 1, $BtnWidthS, $BtnHeightS)
	Global $idBtnAutomationSpeed =	GUICtrlCreateButton($captionAutomationSpeed	, 295, $ROW_0 - 1, $BtnWidthS-10, $BtnHeightS)
	;Local $idBtnAuto = 						GUICtrlCreateButton($captionAuto						, 170, $ROW_0 - 1, $BtnWidthS, $BtnHeightS)
			
	Local $idBtnStartPOS = 					GUICtrlCreateButton($captionStartPOS				, $Col_1, $ROW_1, $BtnWidthL, $BtnHeight)
	Local $idBtnLogin = 						GUICtrlCreateButton($captionLogin						, $Col_2, $ROW_1, $BtnWidthL, $BtnHeight)
	Local $idBtnEmuArrange = 				GUICtrlCreateButton($captionEmuArrange			, $Col_3, $ROW_1, $BtnWidthL, $BtnHeight)
	Local $idBtnScanLoyaltyCard = 		GUICtrlCreateButton($captionScanLoyaltyCard		, $Col_4, $ROW_1, $BtnWidthL, $BtnHeight)
		
	Local $idBtnScenario = 					GUICtrlCreateButton($captionScenario					, $Col_1, $ROW_2, $BtnWidthL, $BtnHeight)
	Local $idBtnTendering = 				GUICtrlCreateButton($captionTendering				, $Col_2, $ROW_2, $BtnWidthL, $BtnHeight)
	Local $idBtnUnlock = 						GUICtrlCreateButton($captionUnlock					, $Col_3, $ROW_2, $BtnWidthL, $BtnHeight)
	Local $idBtnKillPOS =	 					GUICtrlCreateButton($captionKillPOS 	    			, $Col_4, $ROW_2, $BtnWidthL, $BtnHeight)
			
	Local $idBtnCleanLogs = 				GUICtrlCreateButton($captionCleanLogs				, $Col_1, $ROW_3, $BtnWidthL, $BtnHeight)
	Local $idBtnBrowseServer =			GUICtrlCreateButton($captionBrowseServer			, $Col_2, $ROW_3, $BtnWidthL, $BtnHeight)
	Local $idBtnMonitoSrvLog =			GUICtrlCreateButton($captionMonitoSrvLog			, $Col_3, $ROW_3, $BtnWidthL, $BtnHeight)
	Local $idBtnEditIni = 						GUICtrlCreateButton($captionEditIni					, $Col_4, $ROW_3, $BtnWidthL, $BtnHeight)
		
	Local $idBtnDebugOn =   				GUICtrlCreateButton($captionDebugOn				, $Col_1, $ROW_4, $BtnWidthL, $BtnHeight)
	Local $idBtnDebugOff = 		    		GUICtrlCreateButton($captionDebugOff				, $Col_2, $ROW_4, $BtnWidthL, $BtnHeight)
	Local $idBtnExposeLogs = 				GUICtrlCreateButton($captionExposeLogs			, $Col_3, $ROW_4, $BtnWidthL, $BtnHeight)
	Local $idBtnExposeTLog = 				GUICtrlCreateButton($captionExposeTLog			, $Col_4, $ROW_4, $BtnWidthL, $BtnHeight)
		
	Local $idBtnReceiptDebugOn = 		GUICtrlCreateButton($captionReceiptDebugOn		, $Col_1, $ROW_5, $BtnWidthL, $BtnHeight)
	Local $idBtnReceiptDebugOff = 		GUICtrlCreateButton($captionReceiptDebugOff		, $Col_2, $ROW_5, $BtnWidthL, $BtnHeight)
	Local $idBtnViewSlip = 					GUICtrlCreateButton($captionViewSlip					, $Col_3, $ROW_5, $BtnWidthL, $BtnHeight)
	Local $idBtnCollectLogs = 				GUICtrlCreateButton($captionCollectLogs				, $Col_4, $ROW_5, $BtnWidthL, $BtnHeight)
		
	Local $idBtnSnipPos =	 				GUICtrlCreateButton($captionSnipPos   				, $Col_1, $ROW_6, $BtnWidthL, $BtnHeight)	
	Local $idBtnSnipScreen = 				GUICtrlCreateButton($captionSnipScreen				, $Col_2, $ROW_6, $BtnWidthL, $BtnHeight)		
	Local $idBtnCleanScanner = 			GUICtrlCreateButton($captionCleanScanner			, $Col_3, $ROW_6, $BtnWidthL, $BtnHeight)
	Local $idBtnBrowseRabbit =			GUICtrlCreateButton($captionBrowseRabbit			, $Col_4, $ROW_6, $BtnWidthL, $BtnHeight)
			
	Local $idBtnIISReset = 					GUICtrlCreateButton($captionIISReset					, $Col_1, $ROW_7, $BtnWidthL, $BtnHeight)
	Local $idBtnIISStop = 					GUICtrlCreateButton($captionIISStop					, $Col_2, $ROW_7, $BtnWidthL, $BtnHeight)
	Local $idBtnIISStart = 					GUICtrlCreateButton($captionIISStart					, $Col_3, $ROW_7, $BtnWidthL, $BtnHeight)
	Local $idBtnOpenCMD = 				GUICtrlCreateButton($captionOpenCMD				, $Col_4, $ROW_7, $BtnWidthL, $BtnHeight)
		
	Local $idBtnOpenSpooky = 			GUICtrlCreateButton($captionOpenSpooky			, $Col_1, $ROW_8, $BtnWidthL, $BtnHeight)
	Local $idBtnSQLMgmt = 				GUICtrlCreateButton($captionSQLMgmt				, $Col_2, $ROW_8, $BtnWidthL, $BtnHeight)
	Local $idBtnOpenSnoop = 				GUICtrlCreateButton($captionOpenSnoop				, $Col_3, $ROW_8, $BtnWidthL, $BtnHeight)
	Local $idBtnOpenServices = 			GUICtrlCreateButton($captionOpenServices			, $Col_4, $ROW_8, $BtnWidthL, $BtnHeight)		
	
	Local $idBtnCopySrvExtToCust =		GUICtrlCreateButton($captionCopySrvExtToCust	, $Col_1, $ROW_9, $BtnWidthL, $BtnHeight)
	Local $idBtnCopyPOSExtToCust =	GUICtrlCreateButton($captionCopyPOSExtToCust	, $Col_2, $ROW_9, $BtnWidthL, $BtnHeight)
	Local $idBtnCopyOffExtToCust =		GUICtrlCreateButton($captionCopyOffExtToCust	, $Col_3, $ROW_9, $BtnWidthL, $BtnHeight)
	
	Local $idBtnToEnglish = 					GUICtrlCreateButton($captionToEnglish				, $Col_1, $ROW_10, $BtnWidthL, $BtnHeight)
	Local $idBtnToDutch = 					GUICtrlCreateButton($captionToDutch					, $Col_2, $ROW_10, $BtnWidthL, $BtnHeight)

	;~	Local $idBtnResetLoy =	 		GUICtrlCreateButton($captionResetLoy				, $Col_4, $ROW_7, $BtnWidthL, $BtnHeight)
	;~ 	Local $idBtnMsg3On =   		    GUICtrlCreateButton($captionMsg3On					, $Col_2, $ROW_7, $BtnWidthL, $BtnHeight)
	;~ 	Local $idBtnMsg3Off = 		    GUICtrlCreateButton($captionMsg3Off					, $Col_3, $ROW_7, $BtnWidthL, $BtnHeight)
	;~	Local $idBtnFLDiag = 		   		GUICtrlCreateButton($captionFLDiag					, $Col_1, $ROW_8, $BtnWidthL, $BtnHeight)

	If ($ShowLanguageSwitcherLine) Then
		DisableLanguageButtonsIfDbNotReady($idBtnToEnglish, $idBtnToDutch)
	EndIf
	
	GUICtrlSetColor($idBtnStartPOS , 0x000088)
	GUICtrlSetColor($idBtnKillPOS, 0xFF0000)

	Copyrights()
	
    GUISetState(@SW_SHOW)
    If (WinExists("R10PosClient")) Then
		WinActivate("R10PosClient")
    EndIf
	Sleep(500)

    Global $do = 1;

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
				FuncWrapper($Btn, $captionToDutch,ToDutch, True)				
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
EndFunc


; === Main Functions =============================================================================================


Func Type()
	Local $pos = MouseGetPos()
	WinActivate("R10PosClient")
	sleep(200)
	$Item = GetItemNumberFromCombo()
	If ($Item  == "") Then
		Return
	EndIf
 	$keys = StringSplit($Item,"")
    MouseClick("left",560,350,2,1)
	sleep(200)
	$SleepMsBetweenTypes = 300
	If ($keys[0]>4) Then
		$SleepMsBetweenTypes = 100
	EndIf
	For $i = 1 To $keys[0]
		Send($keys[$i])
		sleep($SleepMsBetweenTypes)
	Next
    MouseClick("left",800,630,1,1)
	sleep(200)
	MouseMove($pos[0],$pos[1],1)
EndFunc


Func AutomationSpeed()
	$UserAutomationSpeedFactor = $arrCONFIG[$CFG_DIALOG_AUTO_SPEED_FACTOR][1]
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
EndFunc


Func Scan()
	;~$Scanme = StringStripWS(GUICtrlRead($idComboBox),8)
	$Scanme = GetItemNumberFromCombo()
	If ($Scanme  == "") Then
		Return
	EndIf	
	$hWndSCR = WinActivate($arrCONFIG[$CFG_SCANNER_EMU_CAPTION][1])
	ControlSend($hWndSCR,"","[CLASS:Edit; INSTANCE:1]","{HOME}{SHIFTDOWN}{END}{SHIFTUP}{DEL}")
	ControlSend($hWndSCR,"","[CLASS:Edit; INSTANCE:1]",$Scanme)
	ControlClick($hWndSCR,"","[CLASS:Button; INSTANCE:5]")
	WinActivate("R10PosClient")
EndFunc


Func StartPOS()
    If (Not WinExists("R10PosClient")) Then
		Run($arrCONFIG[$CFG_POS_PATH][1] & "\Retalix.Client.POS.Shell.exe",$arrCONFIG[$CFG_POS_PATH][1])
    EndIf
	Sleep(500)
	WinActivate("R10PosClient")
EndFunc


Func Login()
	If Not IsPosClientRunning() Then
		return
	Endif
	WinActivate("R10PosClient")
	Local $pos = MouseGetPos()
	Sleep(300)
    BlockInput(1)
 	$keys = StringSplit($arrCONFIG[$CFG_USER][1],"")
	MouseClick("left",750,400,1,1)
	Sleep(300)
	Send ("{HOME}{SHIFTDOWN}{END}{SHIFTUP}{DEL}")
	For $i = 1 To $keys[0]
	  Send($keys[$i])
    Next
	Sleep(1000)
	Send("{TAB}")
    Sleep(500)
	Send ("{HOME}{SHIFTDOWN}{END}{SHIFTUP}{DEL}")
 	$keys = StringSplit($arrCONFIG[$CFG_PASSWORD][1],"")
	For $i = 1 To $keys[0]
	  Send($keys[$i])
    Next
	MouseClick("left",920,220,1,1)
	BlockInput(0)
	MouseMove($pos[0],$pos[1],1)
EndFunc


Func ArrangeEmulators()
	If Not IsPosClientRunning() Then
		return
	Endif
	$WndHnd = WinActivate($arrCONFIG[$CFG_SCANNER_EMU_CAPTION][1])
	If ($WndHnd > 0) Then
		WinMove($arrCONFIG[$CFG_SCANNER_EMU_CAPTION][1],"",$arrCONFIG[$CFG_SCANNER_EMU_X][1], $arrCONFIG[$CFG_SCANNER_EMU_Y][1])
	EndIf
	$WndHnd = WinActivate($arrCONFIG[$CFG_PRINTER_EMU_CAPTION][1])
	If ($WndHnd > 0) Then
		WinMove($arrCONFIG[$CFG_PRINTER_EMU_CAPTION][1],"",$arrCONFIG[$CFG_PRINTER_EMU_X][1], $arrCONFIG[$CFG_PRINTER_EMU_Y][1])
	EndIf
	$WndHnd = WinActivate($arrCONFIG[$CFG_SCALE_EMU_CAPTION][1])
	If ($WndHnd > 0) Then
		WinMove($arrCONFIG[$CFG_SCALE_EMU_CAPTION][1],"",$arrCONFIG[$CFG_SCALE_EMU_X][1], $arrCONFIG[$CFG_SCALE_EMU_Y][1])
	EndIf
	$WndHnd = WinActivate($arrCONFIG[$CFG_DRAWER_EMU_CAPTION][1])
	If ($WndHnd > 0) Then
		WinMove($arrCONFIG[$CFG_DRAWER_EMU_CAPTION][1],"",$arrCONFIG[$CFG_DRAWER_EMU_X][1], $arrCONFIG[$CFG_DRAWER_EMU_Y][1])
	EndIf
	$WndHnd = WinActivate($arrCONFIG[$CFG_WINEPTS_EMU_CAPTION][1])
	If ($WndHnd > 0) Then
		WinMove($arrCONFIG[$CFG_WINEPTS_EMU_CAPTION][1],"",$arrCONFIG[$CFG_WINEPTS_EMU_X][1], $arrCONFIG[$CFG_WINEPTS_EMU_Y][1])
	EndIf
	$WndHnd = WinActivate($arrCONFIG[$CFG_UPB_EMU_CAPTION][1])
	If ($WndHnd > 0) Then
		WinMove($arrCONFIG[$CFG_UPB_EMU_CAPTION][1],"",$arrCONFIG[$CFG_UPB_EMU_X][1], $arrCONFIG[$CFG_UPB_EMU_Y][1])
	EndIf
EndFunc


Func ScanLoyaltyCard()
	If Not IsPosClientRunning() Then
		return
	Endif
	$Scanme = StringStripWS(GUICtrlRead($idComboBox),8)
	$hWndSCR = WinActivate($arrCONFIG[$CFG_SCANNER_EMU_CAPTION][1])
	ControlSend($hWndSCR,"","[CLASS:Edit; INSTANCE:1]","{HOME}{SHIFTDOWN}{END}{SHIFTUP}{DEL}")
	ControlSend($hWndSCR,"","[CLASS:Edit; INSTANCE:1]",$arrCONFIG[$CFG_LOYALTY_CARD][1])
	ControlClick($hWndSCR,"","[CLASS:Button; INSTANCE:5]")
	WinActivate("R10PosClient")
EndFunc


Func Scenario()
	If Not IsPosClientRunning() Then
		return
	Endif
	FileChangeDir($PostyperDir)
	$ScenariosFullDir = $ScenariosDir
	$SubPath = StringReplace($arrCONFIG[$CFG_DIALOG_SCENARIO_SUBPATH][1],'"', '')	
	if ($SubPath > 0) Then
		$ScenariosFullDir =  $ScenariosDir & "\" & $SubPath
	EndIf
    Local $sScenarioFileName = FileOpenDialog("Select input file", $ScenariosFullDir & "\", "All (*.ini)",1)
	If @error Then
		NoFilesSelectedMsgBox()		
        FileChangeDir($PostyperDir)
    Else
		$sFileName = GetFileNameFromFullPath($sScenarioFileName)
		ScenarioAutomation("Scenario: " & $sFileName, $sScenarioFileName)
	EndIf			
EndFunc


Func Tendering()
	If Not IsPosClientRunning() Then
		return
	Endif
	ScenarioAutomation("Tendering...", $TenderngIniFile)
EndFunc


Func Unlock()
	If Not IsPosClientRunning() Then
		return
	Endif	
	WinActivate("R10PosClient")
	Local $pos = MouseGetPos()
	Sleep(300)
    BlockInput(1)
 	MouseClick("left",400,250,1,1)
    Sleep(500)
	Send ("{HOME}{SHIFTDOWN}{END}{SHIFTUP}{DEL}")
 	$keys = StringSplit($arrCONFIG[$CFG_PASSWORD][1],"")
	For $i = 1 To $keys[0]
		Send($keys[$i])
    Next
	MouseClick("left",920,220,1,1)
	BlockInput(0)
	MouseMove($pos[0],$pos[1],1)
EndFunc


Func KillPOS()
	ShellExecute($HelpersDir & "\killPOS.cmd","","","",@SW_MINIMIZE)
EndFunc


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
	ShellExecute($cmd,$arguments,"","",@SW_MAXIMIZE)
EndFunc


Func BrowseServer()
	ShellExecute($arrCONFIG[$CFG_BROWSER][1], $arrCONFIG[$CFG_SERVER_WEBSITE][1])
EndFunc


Func MonitorSrvLog()
	$ServerLogsDir = $arrCONFIG[$CFG_SERVER_PATH][1] & "\Logs\"
	$hSearch = FileFindFirstFile($ServerLogsDir & "GPOSWebService_*.log")
	If $hSearch > 0 Then
		$LastGpos = FileFindNextFile($hSearch)	
		ShellExecute($arrCONFIG[$CFG_EDITOR][1],  " -monitor " & $ServerLogsDir & $LastGpos)
    EndIf
EndFunc


Func EditIni()
	ShellExecute($arrCONFIG[$CFG_EDITOR][1], $cfgFile)
	Sleep(5000)
	ReloadItemsFile()
	ReloadConfigFile()
EndFunc


Func DebugOn()
    FileChangeDir($HelpersDir)
	$WebLoggerConfig = $arrCONFIG[$CFG_SERVER_PATH][1] & "\" & "WebLoggerConfig.xml"
	ShellExecute($HelpersDir & "\SetLogger.exe",$WebLoggerConfig & " DEBUG","","",@SW_MAXIMIZE)
    FileChangeDir(@Scriptdir)
EndFunc


Func DebugOff()
	$WebLoggerConfig = $arrCONFIG[$CFG_SERVER_PATH][1] & "\" & "WebLoggerConfig.xml"
	ShellExecute($HelpersDir & "\SetLogger.exe",$WebLoggerConfig & " ERROR","","",@SW_MAXIMIZE)
EndFunc


Func ExposeLogs()
	$PosLogs = $arrCONFIG[$CFG_POS_PATH][1] & "\Logs"
  	if FileExists($PosLogs) Then
	     ShellExecute("C:\Windows\explorer.exe",$PosLogs)
	EndIf
	$ServerLogs = $arrCONFIG[$CFG_SERVER_PATH][1] & "\Logs"
	if FileExists($ServerLogs) Then
	      ShellExecute("C:\Windows\explorer.exe",$ServerLogs)
	  EndIf
EndFunc


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
	ShellExecute($cmd, $arguments,"","",@SW_MAXIMIZE)
EndFunc


Func ReceiptDebugOn()
	FileChangeDir($HelpersDir)
	ShellExecute($HelpersDir & "\receiptdebug.cmd",$arrCONFIG[$CFG_RETAIL_DB_NAME][1],"","",@SW_MAXIMIZE)
	FileChangeDir(@Scriptdir)
EndFunc


Func ReceiptDebugOff()
	FileChangeDir($HelpersDir)
	ShellExecute($HelpersDir & "\receiptdebugoff.cmd",$arrCONFIG[$CFG_RETAIL_DB_NAME][1],"","",@SW_MAXIMIZE)
	FileChangeDir(@Scriptdir)
EndFunc


Func ViewSlip()
    Local $sFileOpenDialog = FileOpenDialog("Select input file", $arrCONFIG[$CFG_TLOG_PATH][1], "TLOG (RetailTransactionLog*.xml)",1)
    If @error Then
		NoFilesSelectedMsgBox()
        FileChangeDir(@Scriptdir)
    Else
        FileChangeDir($HelpersDir)
		ShellExecute($HelpersDir & "\ReceiptView.exe",$sFileOpenDialog & " " & $HelpersDir,"","",@SW_MAXIMIZE)
		Sleep(1500)
		ShellExecute("c:\temp\Receipt.html","","","",@SW_MAXIMIZE)
        FileChangeDir(@Scriptdir)
    EndIf
EndFunc


Func ExposeTLog()
	$TLogs = $arrCONFIG[$CFG_TLOG_PATH][1]
  	if FileExists($TLogs) Then
		ShellExecute("C:\Windows\explorer.exe",$TLogs)
	EndIf
EndFunc
  
  
Func SnipPOS()
	If Not IsPosClientRunning() Then
		return;
	Endif	
    If Not FileExists($CaptureDir) Then
		DirCreate($CaptureDir)
	EndIf	
	Local $hBmp
	WinActivate($g_hPosTyper)
	WinSetState ( $g_hPosTyper, "", @SW_MINIMIZE )
	Sleep (250)
	$hBmp = _ScreenCapture_Capture("",0,0,1024,768)
	$ImageName = $CaptureDir  & "\PosSnip_" & @HOUR & "_" & @MIN & "_" & @SEC & ".jpg"
    _ScreenCapture_SaveImage($ImageName, $hBmp)
	ShellExecute($ImageName)
EndFunc


Func SnipScreen()
    If Not FileExists($CaptureDir) Then
		DirCreate($CaptureDir)
	EndIf	
	Local $hBmp
	WinActivate($g_hPosTyper)
	WinSetState ( $g_hPosTyper, "", @SW_MINIMIZE )
	Sleep (250)
	$hBmp = _ScreenCapture_Capture("")
	$ImageName = $CaptureDir  & "\ScreenSnip_" & @HOUR & "_" & @MIN & "_" & @SEC & ".jpg"
    _ScreenCapture_SaveImage($ImageName, $hBmp)
	ShellExecute($ImageName)
EndFunc


Func CleanScanner()
	If Not IsPosClientRunning() Then
		return
	Endif
	$hWndSCR = WinActivate($arrCONFIG[$CFG_SCANNER_EMU_CAPTION][1])
	ControlSend($hWndSCR,"","[CLASS:Edit; INSTANCE:1]","{HOME}{SHIFTDOWN}{END}{SHIFTUP}{DEL}")
EndFunc  


Func BrowseRabbit()
	ShellExecute($arrCONFIG[$CFG_BROWSER][1], $arrCONFIG[$CFG_RABBITMQ_WEBSITE][1])
EndFunc


Func IISReset()
	ShellExecute($HelpersDir & "\iisreset.cmd","","","",@SW_MAXIMIZE)
EndFunc


Func IISStop()
	ShellExecute($HelpersDir & "\iisreset_stop.cmd","","","",@SW_MAXIMIZE)
EndFunc


Func IISStart()
	ShellExecute($HelpersDir & "\iisreset_start.cmd","","","",@SW_MAXIMIZE)
EndFunc


Func OpenCMD()
   Run($arrCONFIG[$CFG_CMD][1])
EndFunc


Func OpenSpooky()
	$SpookyExe = $arrCONFIG[$CFG_SPOOKY_PATH][1] & "\" & "R10WebClient.exe"
	if FileExists($SpookyExe) Then
	  Run($SpookyExe,$arrCONFIG[$CFG_SPOOKY_PATH][1] & "\")
	EndIf
EndFunc


Func OpenServices()
	ShellExecute("C:\Windows\System32\services.msc")
EndFunc


Func OpenSSMS()
	ShellExecute($arrCONFIG[$CFG_SQLMGR][1],"-E")	
EndFunc


Func OpenSnoop()
	ShellExecute($arrCONFIG[$CFG_SNOOP][1],"")
EndFunc


Func CopyServerExtToCust()
	$cmd = $HelpersDir & "\CopyServerExtToCust.cmd"
	$arg1 = $arrCONFIG[$CFG_SERVER_DBG_CUST_PATH][1] & " "
	$arg2 = $arrCONFIG[$CFG_SERVER_DBG_EXT_PATH][1] & " "
	$arguments = $arg1 & $arg2
	ShellExecute($cmd,$arguments,"","",@SW_MAXIMIZE)
EndFunc


Func CopyPosExtToCust()
	$cmd = $HelpersDir & "\CopyPosExtToCust.cmd"
	$arg1 = $arrCONFIG[$CFG_POS_DBG_CUST_PATH][1] & " "
	$arg2 = $arrCONFIG[$CFG_POS_DBG_EXT_PATH][1] & " "
	$arguments = $arg1 & $arg2
	ShellExecute($cmd,$arguments,"","",@SW_MAXIMIZE)
EndFunc


Func CopyOfficeExtToCust()
	$cmd = $HelpersDir & "\CopyOfficeExtToCust.cmd"
	$arg1 = $arrCONFIG[$CFG_OFFICE_DBG_CUST_PATH][1] & " "
	$arg2 = $arrCONFIG[$CFG_OFFICE_DBG_EXT_PATH][1] & " "
	$arguments = $arg1 & $arg2
	ShellExecute($cmd,$arguments,"","",@SW_MAXIMIZE)
EndFunc


Func ToEnglish()
	FileChangeDir($HelpersDir)
	ShellExecute($HelpersDir & "\jumbo_update_to_english.cmd",$arrCONFIG[$CFG_RETAIL_DB_NAME][1],"","",@SW_MAXIMIZE)
	FileChangeDir(@Scriptdir)
EndFunc


Func ToDutch()
	FileChangeDir($HelpersDir)
	ShellExecute($HelpersDir & "\jumbo_update_to_dutch.cmd",$arrCONFIG[$CFG_RETAIL_DB_NAME][1],"","",@SW_MAXIMIZE)
	FileChangeDir(@Scriptdir)
EndFunc


; === Currently Unused Functions ================================================================================


;~ Func Autmation()
;~ 	$keys = StringSplit(StringStripWS(GUICtrlRead($idComboBox),8),"=")
;~ 	;~ MsgBox($MB_SYSTEMMODAL, "",  $keys[2])
;~ 	If WinExists("R10PosClient") == 1 Then
;~ 		WinActivate("R10PosClient")
;~     EndIf
;~ 	$hWndSCR = WinActivate($arrCONFIG[$CFG_SCANNER_EMU_CAPTION][1])
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


Func GetItemNumberFromCombo()
	$SelectedItem = StringStripWS(GUICtrlRead($idComboBox), $STR_STRIPALL)
	$Tokens = StringSplit($SelectedItem, "-")
	$numberOfTokens = $Tokens[0]
	if ($numberOfTokens < 1) Then
		return ""
	EndIf
	$Item = StringStripWS($Tokens[1], $STR_STRIPALL)
	$ItemIsNumber = StringRegExp($Item,"^\d+$")
	If (Not $ItemIsNumber) Then
		ExtMsgBox($EMB_ICONEXCLAM, $MB_OK, "PosTyper",  $Item & " is not a number", 3, $g_hPosTyper)
		Return ""
	EndIf
	if ($numberOfTokens > 1) Then
		$Desc = StringStripWS($Tokens[2], $STR_STRIPALL)	
	EndIf
	return $Item
EndFunc


Func Press0()
	MouseClick("left",580,625,1,1)
EndFunc

Func Press1()
	MouseClick("left",580,555,1,1)
EndFunc

Func Press2()
	MouseClick("left",650,555,1,1)
EndFunc

Func Press3()
	MouseClick("left",730,555,1,1)
EndFunc

Func Press4()
	MouseClick("left",580,480,1,1)
EndFunc

Func Press5()
	MouseClick("left",650,480,1,1)
EndFunc

Func Press6()
	MouseClick("left",730,480,1,1)
EndFunc

Func Press7()
	MouseClick("left",580,405,1,1)
EndFunc

Func Press8()
	MouseClick("left",650,405,1,1)
EndFunc

Func Press9()
	MouseClick("left",730,405,1,1)
EndFunc

Func PressX()
	MouseClick("left",800,480,1,1)
EndFunc

Func PressEnter()
	Sleep(500)
	MouseClick("left",800,630,1,1)
EndFunc


Func ScenarioAutomation($ProgressBarCaption, $sFileName)
	$LastBtnClickedOK = True
	FileChangeDir($PostyperDir)
	$arrItems=IniReadSection($sFileName,"ITEMS")

	If (WinExists("R10PosClient")) Then
		WinActivate("R10PosClient")
	EndIf

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
		
		if $KeyToStatusBar =  "wait" Then
			$ValToStatusBar *= $AutomationSpeedFactor
		EndIf
		
		$StatusBarText = $KeyToStatusBar & " = " & $ValToStatusBar
		WriteToStatusBar("Scenario", $StatusBarText)
		
		If $arrItems[$i][0] = "item" Or  $arrItems[$i][0] = "card" Then
			$hWndSCR = WinActivate($arrCONFIG[$CFG_SCANNER_EMU_CAPTION][1])
			ControlSend($hWndSCR,"","[CLASS:Edit; INSTANCE:1]","{HOME}{SHIFTDOWN}{END}{SHIFTUP}{DEL}")
			ControlSend($hWndSCR,"","[CLASS:Edit; INSTANCE:1]",$arrItems[$i][1])
			ControlClick($hWndSCR,"","[CLASS:Button; INSTANCE:5]")

			For $j = 1 To 10
				Sleep (50)
				$sText = ControlGetText($hWndSCR,"","[CLASS:Edit; INSTANCE:3]")
				If $sText = "Claimed,Enabled" Then	ExitLoop
			Next
			WinActivate("R10PosClient")		
		ElseIf $arrItems[$i][0] = "button" Then
			if $arrItems[$i][1] = "QTY" Then
			   PressX()
			EndIf
			if $arrItems[$i][1] = "ENTER" Or $arrItems[$i][1] = "TO_TENDER" Then
			   PressEnter()
			EndIf
			if $arrItems[$i][1] = "DIALOG_MID_OK" Then
			   MouseClick("left",520,520,1,1)
		   EndIf
			if $arrItems[$i][1] = "ADD_CUSTOMER_BACK_BTN" Then
				$LastBtnClickedOK = SkipAddCustomer()			
			EndIf			   			   
			if $arrItems[$i][1] = "DIALOG_ZIP_TO_SKIP_BTN" Then
				$LastBtnClickedOK = SkipZipCodeDialog()					
			EndIf			   
			if $arrItems[$i][1] = "TENDER_1" Then
			   MouseClick("left",930,110,1,1)
			EndIf
			if $arrItems[$i][1] = "TENDER_2" Then
			   MouseClick("left",930,170,1,1)
			EndIf
			if $arrItems[$i][1] = "TENDER_3" Then
			   MouseClick("left",930,240,1,1)
			EndIf
			if $arrItems[$i][1] = "TENDER_4" Then
			   MouseClick("left",930,310,1,1)
			EndIf
			if $arrItems[$i][1] = "TENDER_5" Then
			   MouseClick("left",930,370,1,1)
			EndIf
			if $arrItems[$i][1] = "TENDER_6" Then
			   MouseClick("left",930,440,1,1)
			EndIf
			if $arrItems[$i][1] = "TENDER_7" Then
			   MouseClick("left",930,510,1,1)
			EndIf
			if $arrItems[$i][1] = "TENDER_UP" Then
			   MouseClick("left",910,580,1,1)
			EndIf
			if $arrItems[$i][1] = "TENDER_DOWN" Then
			   MouseClick("left",960,580,1,1)
			EndIf
			if $arrItems[$i][1] = "TENDER_BACK" Then
			   MouseClick("left",930,630,1,1)
			EndIf
			if $arrItems[$i][1] = "CLOSE_CHANGE" Then
			   MouseClick("left",730,535,1,1)
			EndIf
			if $arrItems[$i][1] = '0' Then
			  Press0()
			EndIf
			if $arrItems[$i][1] = '1' Then
			  Press1()
			EndIf
			if $arrItems[$i][1] = '2' Then
			  Press2()
			EndIf
			if $arrItems[$i][1] = '3' Then
			  Press3()
			EndIf
			if $arrItems[$i][1] = '4' Then
			  Press4()
			EndIf
			if $arrItems[$i][1] = '5' Then
			  Press5()
			EndIf
			if $arrItems[$i][1] = '6' Then
			  Press6()
			EndIf
			if $arrItems[$i][1] = '7' Then
			  Press7()
			EndIf
			if $arrItems[$i][1] = '8' Then
			  Press8()
			EndIf
			if $arrItems[$i][1] = '9' Then
			  Press9()
			EndIf
		ElseIf $arrItems[$i][0] = "wait" Then
			If ($LastBtnClickedOK) Then
				Sleep($ValToStatusBar)
			EndIf
			$LastBtnClickedOK = True
		ElseIf $arrItems[$i][0] = "user" Then	
			ExtMsgBox($EMB_ICONINFO, $MB_OK, "PosTyper Automation - Wait for User", "Please: " & $arrItems[$i][1] & @CRLF & @CRLF & "Automation will continue when this dialog is dismissed", Null, False)	
		EndIf		
		
		If $ShowProgressBar Then		
			$Percents = Int($i / $NumOfItems * 100)
			ProgressSet($Percents, $StatusBarText, $Percents & "%")
		EndIf

	Next
	If $ShowProgressBar Then			
		ProgressOff()
	EndIf
EndFunc


Func SkipAddCustomer()
	WinActivate("R10PosClient")	
	$oP1=_UIA_getObjectByFindAll($UIA_oDesktop, "Title:=R10PosClient;controltype:=UIA_WindowControlTypeId;class:=Window", $treescope_children)
	$oBtnAnnuleren=_UIA_getObjectByFindAll($oP1, "title:=Annuleren;ControlType:=UIA_ButtonControlTypeId", $treescope_subtree)
	If isobj($oBtnAnnuleren) Then
		_UIA_action($oBtnAnnuleren,"click")
		return True
	EndIf
	$oBtnBack=_UIA_getObjectByFindAll($oP1, "title:=Back;ControlType:=UIA_ButtonControlTypeId", $treescope_subtree) 
	If (isobj($oBtnBack)) Then
		_UIA_action($oBtnBack,"click")
		return True
	EndIf
	return False
EndFunc


Func SkipZipCodeDialog()
	WinActivate("R10PosClient")	
	$oP1=_UIA_getObjectByFindAll($UIA_oDesktop, "Title:=Retalix.Jumbo.Client.POS.Presentation.ViewModels.ViewModels.BRM.ZipCodeViewModel;controltype:=UIA_WindowControlTypeId;class:=Window", $treescope_children)
	$oP0=_UIA_getObjectByFindAll($oP1, "Title:=;controltype:=UIA_CustomControlTypeId;class:=ZipCodeView", $treescope_children)
	$oBtnOverslaan=_UIA_getObjectByFindAll($oP0, "title:=Overslaan;ControlType:=UIA_ButtonControlTypeId", $treescope_subtree)
	If isobj($oBtnOverslaan) Then
		_UIA_action($oBtnOverslaan,"click")
		return True
	EndIf
	$oBtnToSkip=_UIA_getObjectByFindAll($oP0, "title:=To skip;ControlType:=UIA_ButtonControlTypeId", $treescope_subtree)
	If (isobj($oBtnToSkip)) Then
		_UIA_action($oBtnToSkip,"click")
		return True
	EndIf
	return False
EndFunc


;Func SelectCash()
;	WinActivate("R10PosClient")	
;	$oP1=_UIA_getObjectByFindAll($UIA_oDesktop, "Title:=R10PosClient;controltype:=UIA_WindowControlTypeId;class:=Window", $treescope_children)
;	$oUIElement=_UIA_getObjectByFindAll($oP1, "title:=Contant;ControlType:=UIA_ButtonControlTypeId", $treescope_subtree)
;	_UIA_action($oUIElement,"click")
;EndFunc
	
	
Func WriteToStatusBar($MethodName, $Txt = "")
	$Seperator = ": "
	If ($Txt == "") Then
		$Seperator = ""
	EndIf
	If ($ShowStatusBar) Then
		_GUICtrlStatusBar_SetText($g_hPosTyperStatusBar, "  " & $MethodName & $Seperator & $Txt)
	EndIf
EndFunc


Func FuncWrapper($Button, $BtnCaption, $FuncName, $Disable = False)
	WriteToStatusBar($BtnCaption)
	If ($Disable) Then
		GUICtrlSetState ($Button, $GUI_DISABLE)
		Sleep(200)
	EndIf
	$FuncName()
	If ($Disable) Then
		GUICtrlSetState ($Button, $GUI_ENABLE)
	EndIf
	WinActivate($g_hPosTyper)	
EndFunc


Func IsPosClientRunning()
	If (Not WinExists("R10PosClient")) Then
		ExtMsgBox($EMB_ICONEXCLAM, $MB_OK, "PosTyper", "PosClient not running", 7, $g_hPosTyper)
		return False
    EndIf
	return True
EndFunc

Func NoFilesSelectedMsgBox()
	ExtMsgBox($EMB_ICONINFO, " ", "PosTyper",  "No file(s) were selected", 1, $g_hPosTyper)
EndFunc

Func GetDialogHeight($Height, $ShowStatusBar, $ShowExtDeveloperLine, $ShowLanguageSwitcherLine)
	$RowHeight = 30
	$StatusBarHeight = 20
	if ($ShowExtDeveloperLine) Then
		$Height += $RowHeight
	EndIf
	if ($ShowLanguageSwitcherLine) Then
		$Height += $RowHeight
	EndIf
	If ($ShowStatusBar) Then		
		$Height += $StatusBarHeight
	EndIf
	return $Height
EndFunc


Func StringIsTrue($BoolString)
	return StringLower(StringStripWS($BoolString, $STR_STRIPALL)) == "true"
EndFunc


Func IsEnglishBackupDbTablesExist()
	FileChangeDir($HelpersDir)
	EnvSet("RETAIL_DB_NAME_TEMP_VAR", $arrCONFIG[$CFG_RETAIL_DB_NAME][1])
	$retCode = RunWait($HelpersDir & "\jumbo_test_english_exists.cmd", "", @SW_HIDE)
	$BackupExists = $retCode == 1
	FileChangeDir(@Scriptdir)
	return $BackupExists
EndFunc


Func IsDutchBackupDbTablesExist()
	FileChangeDir($HelpersDir)
	EnvSet("RETAIL_DB_NAME_TEMP_VAR", $arrCONFIG[$CFG_RETAIL_DB_NAME][1])
	$retCode = RunWait($HelpersDir & "\jumbo_test_dutch_exists.cmd", "", @SW_HIDE)
	$BackupExists = $retCode == 1
	FileChangeDir(@Scriptdir)
	return $BackupExists
EndFunc


Func DisableLanguageButtonsIfDbNotReady($idBtnToEnglish, $idBtnToDutch)
	If (Not IsEnglishBackupDbTablesExist()) Then
		GUICtrlSetState ($idBtnToEnglish, $GUI_DISABLE)
	EndIf	
	If (Not IsDutchBackupDbTablesExist()) Then
		GUICtrlSetState ($idBtnToDutch, $GUI_DISABLE)
	EndIf
EndFunc

Func Copyrights()
	WriteToStatusBar("© Created by Christian H, enhanced by Yossi S", "")
EndFunc

Func ExtMsgBox($vIcon, $vButton, $sTitle, $sText, $iTimeout, $hWin)
	;_ExtMsgBoxSet(2, $SS_CENTER, -1, -1, -1, -1, Default, Default, "#")
	$iRetValue = _ExtMsgBox($vIcon, $vButton, $sTitle, $sText, $iTimeout, $hWin) 
EndFunc

Func GetFileNameFromFullPath($TEST)
	$FILENAME=""
	$PATH=""
	$TITLE=""
	$EXT_START=0
	$FILE_START=0
	For $X = StringLen($TEST) To 2 Step -1
	   If StringMid($TEST,$X,1) = "." And $EXT_START = 0 Then $EXT_START = $X
	   If StringMid($TEST,$X,1) = "\" And $FILE_START = 0 Then $FILE_START = $X
	   If $FILE_START > 0 Then
		  $FILENAME = StringTrimLeft($TEST,$FILE_START)
		  $TITLE = StringLeft($FILENAME, $EXT_START - $FILE_START -1)
		  $PATH = StringLeft($TEST,$FILE_START)
		  ExitLoop
	   EndIf
   Next	
   return $FILENAME
EndFunc

Func ReloadConfigFile()
	$arrCONFIG=IniReadSection($cfgFile,"CONFIG")
EndFunc

Func ReloadItemsFile()
 	$arrItems=IniReadSection($ItemsIniFile,"ITEMS")
EndFunc