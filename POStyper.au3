#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=POStyper.ico
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


Global $PostyperDir			= @ScriptDir
Global $HelpersDir			= @ScriptDir & "\helpers"
Global $CollectedDir		= @ScriptDir & "\collected_logs"
Global $CaptureDir			= @ScriptDir & "\captured_images"
Global $ItemsDir			= @ScriptDir & "\items"
Global $AutomationDir		= @ScriptDir & "\automation"
Global $ScenariosDir		= $AutomationDir & "\scenarios"
Global $FlowsDir			= $AutomationDir & "\flows"

Global $ItemsIniFile		= $ItemsDir & "\Items.ini"
Global $TenderingIniFile	= $FlowsDir & "\tendering.ini"
Global $PayingCashIniFile	= $FlowsDir & "\paying_cash.ini"
Global $PayingEFTIniFile	= $FlowsDir & "\paying_eft.ini"
Global $cfgFile				= @ScriptDir & "\POStyper.ini"
Global $icoFile				= @ScriptDir & "\POStyper.ico"

Global $sLastScenarioFileName
Global $arrItems
Global $arrPosTyper
Global $arrEnv
Global $arrR10
Global $arrDev
Global $arrHelpers
Global $arrPOS
Global $arrEmulators[0]
Global $arrDialogs[0]

Global $CFG_POSTYPER				= 1
Global $CFG_STATUS_BAR				= 2
Global $CFG_PROGRESS_BAR			= 3
Global $CFG_EXT_DEVELOPER			= 4
Global $CFG_LANG_SWITCHER			= 5
Global $CFG_SCENARIO_SUBPATH		= 6
Global $CFG_AUTO_SPEED_FACTOR		= 7

Global $CFG_RETAIL_DB_NAME			= 1
Global $CFG_SERVER_APPPOOL			= 2
Global $CFG_OFFICE_APPPOOL			= 3
Global $CFG_SERVER_WEBSITE			= 4
Global $CFG_OFFICE_WEBSITE			= 5
Global $CFG_RABBITMQ_WEBSITE		= 6

Global $CFG_SERVER_PATH				= 1
Global $CFG_POS_PATH				= 2
Global $CFG_OFFICE_PATH				= 3
Global $CFG_TLOG_PATH				= 4
Global $CFG_DMS_PATH				= 5
Global $CFG_SPOOKY_PATH				= 6
Global $CFG_ARSGATEWAY_PATH			= 7
Global $CFG_RETAILGATEWAY_PATH		= 8
Global $CFG_STOREGATEWAY_PATH		= 9
Global $CFG_WINEPTS_PATH			= 10
Global $CFG_RTIS_FIX_PATH			= 11

Global $CFG_SERVER_DBG_CUST_PATH	= 1
Global $CFG_SERVER_DBG_EXT_PATH		= 2
Global $CFG_LOYALTY_DBG_EXT_PATH	= 3
Global $CFG_POS_DBG_CUST_PATH		= 4
Global $CFG_POS_DBG_EXT_PATH		= 5
Global $CFG_OFFICE_DBG_CUST_PATH	= 6
Global $CFG_OFFICE_DBG_EXT_PATH		= 7
Global $CFG_SERVER_DBG_RTI_PATH		= 8

Global $CFG_CMD						= 1
Global $CFG_SQLMGR					= 2
Global $CFG_EDITOR					= 3
Global $CFG_BROWSER					= 4
Global $CFG_SNOOP					= 5

Global $CFG_USER					= 1
Global $CFG_PASSWORD				= 2
Global $CFG_LOYALTY_CARD			= 3

Global $CFG_SCANNER					= 1
Global $CFG_PRINTER					= 2
Global $CFG_SCALE					= 3
Global $CFG_DRAWER					= 4
Global $CFG_LINCSAFE				= 5
Global $CFG_WINEPTS					= 6
Global $CFG_UPB						= 7
Global $CFG_MTX						= 8

Global $CFG_SCREEN_ADD				= 1
Global $CFG_DIALOG_ZIP				= 2
Global $CFG_DIALOG_SEL_PROMO		= 3
Global $CFG_DIALOG_SEL_PROMO_CLL	= 4
Global $CFG_DIALOG_SPARE_CHANGE		= 5

If _Singleton("POStyper", 1) = 0 Then
	ExtMsgBox($EMB_ICONINFO, $MB_OK, "PosTyper", "PosTyper is already running", 3, False)
	Exit
EndIf

ReadIniFiles()

Main()

Func Main()

	Global $CFG_CAPTION	= 1
	Global $CFG_X		= 2
	Global $CFG_Y		= 3

	$PosTyperDialogX		= @DesktopWidth - 333
	$PosTyperDialogY		= 0
	$PosTyperDialogWidth	= 333
	$PosTyperDialogHeight	= 310

	Global $DefaultAutomationSpeedFactor = 1
	Global $AutomationSpeedFactor = $DefaultAutomationSpeedFactor

	Global $ShowStatusBar				= StringIsTrue($arrPosTyper[$CFG_STATUS_BAR][1])
	Global $ShowExtDeveloperLine		= StringIsTrue($arrPosTyper[$CFG_EXT_DEVELOPER][1])
	Global $ShowLanguageSwitcherLine	= StringIsTrue($arrPosTyper[$CFG_LANG_SWITCHER][1])
	Global $ShowProgressBar				= StringIsTrue($arrPosTyper[$CFG_PROGRESS_BAR][1])

	$PosTyperDialogHeight = GetDialogHeight($PosTyperDialogHeight, $ShowStatusBar, $ShowExtDeveloperLine, $ShowLanguageSwitcherLine)

	$CFG_POSTYPER = StringSplit($arrPosTyper[$CFG_POSTYPER][1], "|")

	If ($CFG_POSTYPER[$CFG_X] >= 0 And $CFG_POSTYPER[$CFG_Y] >= 0) Then
		$PosTyperDialogX = $CFG_POSTYPER[$CFG_X]
		$PosTyperDialogY = $CFG_POSTYPER[$CFG_Y]
	EndIf

	Global $g_hPosTyper = GUICreate($CFG_POSTYPER[$CFG_CAPTION], $PosTyperDialogWidth, $PosTyperDialogHeight, $PosTyperDialogX, $PosTyperDialogY, -1, $WS_EX_ACCEPTFILES)

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
	Local $captionPayingCash		= "Pay Cash"
	Local $captionPayingEFT			= "Pay PIN"

	Local $captionUnlock			= "Unlock"
	Local $captionBrowseServer		= "Server"
	Local $captionBrowseOffice		= "Office"
	Local $captionBrowseRabbit		= "Rabbit"
	 
	Local $captionCleanLogs			= "Clean Logs"
	Local $captionExposeLogs		= "Expose Logs"
	Local $captionExposeTLog		= "Expose Tlog"
	Local $captionCollectLogs		= "Collect Logs"
 
	Local $captionDebugOn			= "Gpos DBG"
	Local $captionDebugOff			= "Gpos ERR"
	Local $captionMonitoSrvLog		= "View Gpos"
	Local $captionKillPOS			= "Kill POS"
 
	Local $captionReceiptDebugOn	= "Slip Dbg"
	Local $captionReceiptDebugOff	= "No Slip Dbg"
	Local $captionViewSlip			= "View Slip"
	Local $captionEditIni			= "Edit Ini"
	 
	Local $captionSnipPos			= "Snip POS"
	Local $captionSnipScreen		= "Snip Screen"
	Local $captionCleanScanner		= "Clean Scan"
	 
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
	Local $captionCopyFromMsiFolder	= "Copy MSI"
	 
	Local $captionToEnglish			= "To English"
	Local $captionToDutch			= "To Dutch"
	Local $captionFixRTIs			= "Fix RTIs"

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
	Local $ROW_11	= $ROW_10 + $RowHeight
	
	$INVALID_HEIGHT	= -100
	If Not $ShowLanguageSwitcherLine Then
		$ROW_11 = $INVALID_HEIGHT
	EndIf
	If $ShowLanguageSwitcherLine And Not $ShowExtDeveloperLine Then
		$ROW_11 = $ROW_10
	EndIf
	If Not $ShowExtDeveloperLine Then
		$ROW_10 = $INVALID_HEIGHT
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
	Global $idBtnScanLoyaltyCard	= GUICtrlCreateButton($captionScanLoyaltyCard	, $Col_4, $ROW_1	, $BtnWidthL, $BtnHeight)
			
	Local $idBtnScenario			= GUICtrlCreateButton($captionScenario			, $Col_1, $ROW_2	, $BtnWidthL, $BtnHeight)
	Global $idBtnTendering			= GUICtrlCreateButton($captionTendering			, $Col_2, $ROW_2	, $BtnWidthL, $BtnHeight)
	Global $idBtnPayingCash			= GUICtrlCreateButton($captionPayingCash		, $Col_3, $ROW_2	, $BtnWidthL, $BtnHeight)
	Global $idBtnPayingEFT			= GUICtrlCreateButton($captionPayingEFT			, $Col_4, $ROW_2	, $BtnWidthL, $BtnHeight)

	Local $idBtnUnlock				= GUICtrlCreateButton($captionUnlock			, $Col_1, $ROW_3	, $BtnWidthL, $BtnHeight)
	Local $idBtnBrowseServer		= GUICtrlCreateButton($captionBrowseServer		, $Col_2, $ROW_3	, $BtnWidthL, $BtnHeight)
	Local $idBtnBrowseOffice		= GUICtrlCreateButton($captionBrowseOffice		, $Col_3, $ROW_3	, $BtnWidthL, $BtnHeight)
	Local $idBtnBrowseRabbit		= GUICtrlCreateButton($captionBrowseRabbit		, $Col_4, $ROW_3	, $BtnWidthL, $BtnHeight)	
				
	Local $idBtnCleanLogs			= GUICtrlCreateButton($captionCleanLogs			, $Col_1, $ROW_4	, $BtnWidthL, $BtnHeight)
	Local $idBtnExposeLogs			= GUICtrlCreateButton($captionExposeLogs		, $Col_2, $ROW_4	, $BtnWidthL, $BtnHeight)
	Local $idBtnExposeTLog			= GUICtrlCreateButton($captionExposeTLog		, $Col_3, $ROW_4	, $BtnWidthL, $BtnHeight)
	Local $idBtnCollectLogs			= GUICtrlCreateButton($captionCollectLogs		, $Col_4, $ROW_4	, $BtnWidthL, $BtnHeight)
	
	Local $idBtnDebugOn				= GUICtrlCreateButton($captionDebugOn			, $Col_1, $ROW_5	, $BtnWidthL, $BtnHeight)
	Local $idBtnDebugOff			= GUICtrlCreateButton($captionDebugOff			, $Col_2, $ROW_5	, $BtnWidthL, $BtnHeight)
	Local $idBtnMonitoSrvLog		= GUICtrlCreateButton($captionMonitoSrvLog		, $Col_3, $ROW_5	, $BtnWidthL, $BtnHeight)
	Local $idBtnKillPOS				= GUICtrlCreateButton($captionKillPOS 	    	, $Col_4, $ROW_5	, $BtnWidthL, $BtnHeight)
			
	Local $idBtnReceiptDebugOn		= GUICtrlCreateButton($captionReceiptDebugOn	, $Col_1, $ROW_6	, $BtnWidthL, $BtnHeight)
	Local $idBtnReceiptDebugOff		= GUICtrlCreateButton($captionReceiptDebugOff	, $Col_2, $ROW_6	, $BtnWidthL, $BtnHeight)
	Local $idBtnViewSlip			= GUICtrlCreateButton($captionViewSlip			, $Col_3, $ROW_6	, $BtnWidthL, $BtnHeight)
	Local $idBtnEditIni				= GUICtrlCreateButton($captionEditIni			, $Col_4, $ROW_6	, $BtnWidthL, $BtnHeight)
			
	Local $idBtnSnipPos				= GUICtrlCreateButton($captionSnipPos   		, $Col_1, $ROW_7	, $BtnWidthL, $BtnHeight)	
	Local $idBtnSnipScreen			= GUICtrlCreateButton($captionSnipScreen		, $Col_2, $ROW_7	, $BtnWidthL, $BtnHeight)		
	Local $idBtnCleanScanner		= GUICtrlCreateButton($captionCleanScanner		, $Col_3, $ROW_7	, $BtnWidthL, $BtnHeight)
				
	Local $idBtnIISReset			= GUICtrlCreateButton($captionIISReset			, $Col_1, $ROW_8	, $BtnWidthL, $BtnHeight)
	Local $idBtnIISStop				= GUICtrlCreateButton($captionIISStop			, $Col_2, $ROW_8	, $BtnWidthL, $BtnHeight)
	Local $idBtnIISStart			= GUICtrlCreateButton($captionIISStart			, $Col_3, $ROW_8	, $BtnWidthL, $BtnHeight)
	Local $idBtnOpenCMD				= GUICtrlCreateButton($captionOpenCMD			, $Col_4, $ROW_8	, $BtnWidthL, $BtnHeight)
			
	Local $idBtnOpenSpooky			= GUICtrlCreateButton($captionOpenSpooky		, $Col_1, $ROW_9	, $BtnWidthL, $BtnHeight)
	Local $idBtnSQLMgmt				= GUICtrlCreateButton($captionSQLMgmt			, $Col_2, $ROW_9	, $BtnWidthL, $BtnHeight)
	Local $idBtnOpenSnoop			= GUICtrlCreateButton($captionOpenSnoop			, $Col_3, $ROW_9	, $BtnWidthL, $BtnHeight)
	Local $idBtnOpenServices		= GUICtrlCreateButton($captionOpenServices		, $Col_4, $ROW_9	, $BtnWidthL, $BtnHeight)		
		
	Global $idBtnCopySrvExtToCust	= GUICtrlCreateButton($captionCopySrvExtToCust	, $Col_1, $ROW_10	, $BtnWidthL, $BtnHeight)
	Global $idBtnCopyPOSExtToCust	= GUICtrlCreateButton($captionCopyPOSExtToCust	, $Col_2, $ROW_10	, $BtnWidthL, $BtnHeight)
	Global $idBtnCopyOffExtToCust	= GUICtrlCreateButton($captionCopyOffExtToCust	, $Col_3, $ROW_10	, $BtnWidthL, $BtnHeight)
	Global $idBtnCopyFromMsiFolder	= GUICtrlCreateButton($captionCopyFromMsiFolder	, $Col_4, $ROW_10	, $BtnWidthL, $BtnHeight)
	 
	Local $idBtnToEnglish			= GUICtrlCreateButton($captionToEnglish			, $Col_1, $ROW_11	, $BtnWidthL, $BtnHeight)
	Local $idBtnToDutch				= GUICtrlCreateButton($captionToDutch			, $Col_2, $ROW_11	, $BtnWidthL, $BtnHeight)
	Global $idBtnFixRTIs			= GUICtrlCreateButton($captionFixRTIs			, $Col_3, $ROW_11	, $BtnWidthL, $BtnHeight)

;~	Local $idBtnResetLoy			= GUICtrlCreateButton($captionResetLoy			, $Col_4, $ROW_7	, $BtnWidthL, $BtnHeight)
;~ 	Local $idBtnMsg3On				= GUICtrlCreateButton($captionMsg3On			, $Col_2, $ROW_7	, $BtnWidthL, $BtnHeight)
;~ 	Local $idBtnMsg3Off				= GUICtrlCreateButton($captionMsg3Off			, $Col_3, $ROW_7	, $BtnWidthL, $BtnHeight)
;~	Local $idBtnFLDiag				= GUICtrlCreateButton($captionFLDiag			, $Col_1, $ROW_8	, $BtnWidthL, $BtnHeight)


	Global $LINCSAFE_DIST_X					= 80
	Global $LINCSAFE_DIST_Y					= 30
	Global $LINCSAFE_DIST_Y_COINS			= 75

	Global $LINCSAFE_COL_0					= 800
	Global $LINCSAFE_COL_1					= $LINCSAFE_COL_0 + $LINCSAFE_DIST_X
	Global $LINCSAFE_ROW_0					= 225
	Global $LINCSAFE_ROW_1					= $LINCSAFE_ROW_0 + $LINCSAFE_DIST_Y
	Global $LINCSAFE_ROW_2					= $LINCSAFE_ROW_0 + $LINCSAFE_DIST_Y_COINS
	Global $LINCSAFE_ROW_3					= $LINCSAFE_ROW_2 + $LINCSAFE_DIST_Y
	Global $LINCSAFE_ROW_4					= $LINCSAFE_ROW_3 + $LINCSAFE_DIST_Y

	Global $LINCSAFE_BANKNOTE_50_X_OFFSET	= $LINCSAFE_COL_0
	Global $LINCSAFE_BANKNOTE_50_Y_OFFSET	= $LINCSAFE_ROW_0
	Global $LINCSAFE_BANKNOTE_20_X_OFFSET	= $LINCSAFE_COL_1
	Global $LINCSAFE_BANKNOTE_20_Y_OFFSET	= $LINCSAFE_ROW_0
	Global $LINCSAFE_BANKNOTE_10_X_OFFSET	= $LINCSAFE_COL_0
	Global $LINCSAFE_BANKNOTE_10_Y_OFFSET	= $LINCSAFE_ROW_1
	Global $LINCSAFE_BANKNOTE_5_X_OFFSET	= $LINCSAFE_COL_1
	Global $LINCSAFE_BANKNOTE_5_Y_OFFSET	= $LINCSAFE_ROW_1

	Global $LINCSAFE_COIN_2_0_X_OFFSET		= $LINCSAFE_COL_0
	Global $LINCSAFE_COIN_2_0_Y_OFFSET		= $LINCSAFE_ROW_2
	Global $LINCSAFE_COIN_1_0_X_OFFSET		= $LINCSAFE_COL_1
	Global $LINCSAFE_COIN_1_0_Y_OFFSET		= $LINCSAFE_ROW_2
	Global $LINCSAFE_COIN_0_5_X_OFFSET		= $LINCSAFE_COL_0
	Global $LINCSAFE_COIN_0_5_Y_OFFSET		= $LINCSAFE_ROW_3
	Global $LINCSAFE_COIN_0_2_X_OFFSET		= $LINCSAFE_COL_1
	Global $LINCSAFE_COIN_0_2_Y_OFFSET		= $LINCSAFE_ROW_3
	Global $LINCSAFE_COIN_0_1_X_OFFSET		= $LINCSAFE_COL_0 
	Global $LINCSAFE_COIN_0_1_Y_OFFSET		= $LINCSAFE_ROW_4
	Global $LINCSAFE_COIN_0_0_5_X_OFFSET	= $LINCSAFE_COL_1
	Global $LINCSAFE_COIN_0_0_5_Y_OFFSET	= $LINCSAFE_ROW_4


	If $ShowLanguageSwitcherLine Then
		DisableLanguageButtonsIfDbNotReady($idBtnToEnglish, $idBtnToDutch)
	EndIf

	DisableButtonsOnStartup()

	GUICtrlSetColor($idBtnStartPOS, 0x000088)
	GUICtrlSetColor($idBtnKillPOS, 0xFF0000)

	Copyrights()

	GUISetState(@SW_SHOW)
	If WinExists("R10PosClient") Then
		WinActivate("R10PosClient")
	EndIf
	Sleep(500)

	Local $do = True

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
			Case $idBtnPayingCash
				FuncWrapper($Btn, $captionPayingCash, PayingCash, True)
			Case $idBtnPayingEFT
				FuncWrapper($Btn, $captionPayingEFT, PayingEFT, True)
			Case $idBtnUnlock
				FuncWrapper($Btn, $captionUnlock, Unlock, True)
			Case $idBtnBrowseServer
				FuncWrapper($Btn, $captionBrowseServer, BrowseServer)
			Case $idBtnBrowseOffice
				FuncWrapper($Btn, $captionBrowseOffice, BrowseOffice)
			Case $idBtnBrowseRabbit
				FuncWrapper($Btn, $captionBrowseRabbit, BrowseRabbit)
			Case $idBtnCleanLogs
				FuncWrapper($Btn, $captionCleanLogs, CleanLogs, True)
			Case $idBtnExposeLogs
				FuncWrapper($Btn, $captionExposeLogs, ExposeLogs)
			Case $idBtnExposeTLog
				FuncWrapper($Btn, $captionExposeTLog, ExposeTLog)
			Case $idBtnCollectLogs
				FuncWrapper($Btn, $captionCollectLogs, CollectLogs, True)
			Case $idBtnDebugOn
				FuncWrapper($Btn, $captionDebugOn, DebugOn)
			Case $idBtnDebugOff
				FuncWrapper($Btn, $captionDebugOff, DebugOff)
			Case $idBtnMonitoSrvLog
				FuncWrapper($Btn, $captionMonitoSrvLog, MonitorSrvLog)
			Case $idBtnKillPOS
				FuncWrapper($Btn, $captionKillPOS, KillPOS)
			Case $idBtnReceiptDebugOn
				FuncWrapper($Btn, $captionReceiptDebugOn, ReceiptDebugOn, True)
			Case $idBtnReceiptDebugOff
				FuncWrapper($Btn, $captionReceiptDebugOff, ReceiptDebugOff, True)
			Case $idBtnViewSlip
				FuncWrapper($Btn, $captionViewSlip, ViewSlip)
			Case $idBtnEditIni
				FuncWrapper($Btn, $captionEditIni, EditIni)
			Case $idBtnSnipPos
				FuncWrapper($Btn, $captionSnipPos, SnipPOS)
			Case $idBtnSnipScreen
				FuncWrapper($Btn, $captionSnipScreen, SnipScreen)
			Case $idBtnCleanScanner
				FuncWrapper($Btn, $captionCleanScanner, CleanScanner)
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
			Case $idBtnCopyFromMsiFolder
				FuncWrapper($Btn, $captionCopyFromMsiFolder, CopyFromMsiFolder, True)
			Case $idBtnToEnglish
				FuncWrapper($Btn, $captionToEnglish, ToEnglish, True)
			Case $idBtnToDutch
				FuncWrapper($Btn, $captionToDutch, ToDutch, True)
			Case $idBtnFixRTIs
				FuncWrapper($Btn, $captionFixRTIs, FixRTIs, True)
	
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


Func Type($Item = Null)
	Local $pos = MouseGetPos()
	If Not $Item Then
		$Item = GetItemNumberFromCombo()
		WinActivate("R10PosClient")
	EndIf
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


Func Scan()
;~$Scanme = StringStripWS(GUICtrlRead($idComboBox),8)
	$Scanme = GetItemNumberFromCombo()
	If $Scanme == "" Then
		Return
	EndIf
	$hWndSCR = ActivateScanner()
	ControlSend($hWndSCR, "", "[CLASS:Edit; INSTANCE:1]", "{HOME}{SHIFTDOWN}{END}{SHIFTUP}{DEL}")
	ControlSend($hWndSCR, "", "[CLASS:Edit; INSTANCE:1]", $Scanme)
	ControlClick($hWndSCR, "", "[CLASS:Button; INSTANCE:5]")
	WinActivate("R10PosClient")
EndFunc   ;==>Scan


Func AutomationSpeed()
	$UserAutomationSpeedFactor = $arrPosTyper[$CFG_AUTO_SPEED_FACTOR][1]
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


Func StartPOS()
	If Not WinExists("R10PosClient") Then
		$cmd = $HelpersDir & "\StartPOS.cmd"
		$arguments = $arrR10[$CFG_POS_PATH][1]
		ShellExecute($cmd, $arguments, "", "", @SW_MINIMIZE)
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
	MouseClick("left", 750, 400, 1, 1)
	;BlockInput(1)

	$keys = StringSplit($arrPOS[$CFG_USER][1], "")
	Sleep(300)
	Send("{HOME}{SHIFTDOWN}{END}{SHIFTUP}{DEL}")
	For $i = 1 To $keys[0]
		Send($keys[$i])
	Next

	Sleep(1000)
	Send("{TAB}")
	Sleep(500)

	Send("{HOME}{SHIFTDOWN}{END}{SHIFTUP}{DEL}")
	$keys = StringSplit($arrPOS[$CFG_PASSWORD][1], "")
	For $i = 1 To $keys[0]
		Send($keys[$i])
	Next

	MouseClick("left", 920, 220, 1, 1)
	;BlockInput(0)

	MouseMove($pos[0], $pos[1], 1)
EndFunc   ;==>Login


Func ArrangeEmulators()
	If Not IsPosClientRunning() Then
		Return
	EndIf
	$NumOfEmulators = $arrEmulators[0][0]
	For $i = 1 To $NumOfEmulators
		$arrEmulator = $arrEmulators[$i][1]
		If WinActivate($arrEmulator[$CFG_CAPTION], "") Then		
			WinMove($arrEmulator[$CFG_CAPTION], "", $arrEmulator[$CFG_X], $arrEmulator[$CFG_Y])
		EndIf
	Next
EndFunc   ;==>ArrangeEmulators


Func ScanLoyaltyCard()
	If Not IsPosClientRunning() Then
		Return
	EndIf
	$Scanme = StringStripWS(GUICtrlRead($idComboBox), 8)
	$hWndSCR = ActivateScanner()
	ControlSend($hWndSCR, "", "[CLASS:Edit; INSTANCE:1]", "{HOME}{SHIFTDOWN}{END}{SHIFTUP}{DEL}")
	ControlSend($hWndSCR, "", "[CLASS:Edit; INSTANCE:1]", $arrPOS[$CFG_LOYALTY_CARD][1])
	ControlClick($hWndSCR, "", "[CLASS:Button; INSTANCE:5]")
	WinActivate("R10PosClient")
EndFunc   ;==>ScanLoyaltyCard


Func Scenario()
	If Not IsPosClientRunning() Then
		Return
	EndIf
	FileChangeDir($PostyperDir)
	$ScenariosFullDir = $ScenariosDir
	$SubPath = StringReplace($arrPosTyper[$CFG_SCENARIO_SUBPATH][1], '"', '')
	If $SubPath > 0 Then
		$ScenariosFullDir = $ScenariosDir & "\" & $SubPath
	EndIf
	$sScenarioFileName = FileOpenDialog("Select input file", $ScenariosFullDir & "\", "All (*.ini)", 1)
	$sLastScenarioFileName = $sScenarioFileName
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
	ScenarioAutomation("Tendering...", $TenderingIniFile)
EndFunc   ;==>Tendering


Func PayingCash()
	If Not IsPosClientRunning() Then
		Return
	EndIf
	ScenarioAutomation("Paying Cash...", $PayingCashIniFile)
EndFunc   ;==>PayingCash


Func PayingEFT()
	If Not IsPosClientRunning() Then
		Return
	EndIf
	ScenarioAutomation("Paying EFT...", $PayingEFTIniFile)
EndFunc   ;==>PayingEFT

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
	$keys = StringSplit($arrPOS[$CFG_PASSWORD][1], "")
	For $i = 1 To $keys[0]
		Send($keys[$i])
	Next
	MouseClick("left", 920, 220, 1, 1)
	BlockInput(0)
	MouseMove($pos[0], $pos[1], 1)
EndFunc   ;==>Unlock


Func BrowseServer()
	ShellExecute($arrHelpers[$CFG_BROWSER][1], $arrEnv[$CFG_SERVER_WEBSITE][1])
EndFunc   ;==>BrowseServer


Func BrowseOffice()
	ShellExecute($arrHelpers[$CFG_BROWSER][1], $arrEnv[$CFG_OFFICE_WEBSITE][1])
EndFunc   ;==>BrowseOffice


Func BrowseRabbit()
	ShellExecute($arrHelpers[$CFG_BROWSER][1], $arrEnv[$CFG_RABBITMQ_WEBSITE][1])
EndFunc   ;==>BrowseRabbit


Func CleanLogs()
	$cmd = $HelpersDir & "\CleanLogs.cmd"
	$arg1  = $arrEnv[$CFG_SERVER_APPPOOL][1] & " "
	$arg2  = $arrEnv[$CFG_OFFICE_APPPOOL][1] & " "
	$arg3  = $arrR10[$CFG_SERVER_PATH][1] & " "
	$arg4  = $arrR10[$CFG_POS_PATH][1] & " "
	$arg5  = $arrR10[$CFG_OFFICE_PATH][1] & " "
	$arg6  = $arrR10[$CFG_DMS_PATH][1] & " "
	$arg7  = $arrR10[$CFG_ARSGATEWAY_PATH][1] & " "
	$arg8  = $arrR10[$CFG_RETAILGATEWAY_PATH][1] & " "
	$arg9  = $arrR10[$CFG_STOREGATEWAY_PATH][1] & " "
	$arg10 = $arrR10[$CFG_WINEPTS_PATH][1] & " "
	$arguments = $arg1 & $arg2 & $arg3 & $arg4 & $arg5 & $arg6 & $arg7 & $arg8 & $arg9 & $arg10
	ShellExecute($cmd, $arguments, "", "", @SW_MAXIMIZE)
EndFunc   ;==>CleanLogs


Func ExposeLogs()
	$PosLogs = $arrR10[$CFG_POS_PATH][1] & "\Logs"
	If FileExists($PosLogs) Then
		ShellExecute("C:\Windows\explorer.exe", $PosLogs)
	EndIf
	$ServerLogs = $arrR10[$CFG_SERVER_PATH][1] & "\Logs"
	If FileExists($ServerLogs) Then
		ShellExecute("C:\Windows\explorer.exe", $ServerLogs)
	EndIf
EndFunc   ;==>ExposeLogs


Func ExposeTLog()
	$TLogs = $arrR10[$CFG_TLOG_PATH][1]
	If FileExists($TLogs) Then
		ShellExecute("C:\Windows\explorer.exe", $TLogs)
	EndIf
EndFunc   ;==>ExposeTLog


Func CollectLogs()
	If Not FileExists($CollectedDir) Then
		DirCreate($CollectedDir)
	EndIf
	$cmd = $HelpersDir & "\CollectLogs.cmd"
	$arg1 = $CollectedDir & " "
	$arg2 = $arrR10[$CFG_SERVER_PATH][1] & " "
	$arg3 = $arrR10[$CFG_POS_PATH][1] & " "
	$arg4 = $arrR10[$CFG_OFFICE_PATH][1] & " "
	$arg5 = $arrR10[$CFG_DMS_PATH][1] & " "
	$arg6 = $arrR10[$CFG_ARSGATEWAY_PATH][1] & " "
	$arg7 = $arrR10[$CFG_RETAILGATEWAY_PATH][1] & " "
	$arg8 = $arrR10[$CFG_STOREGATEWAY_PATH][1] & " "
	$arg9 = $arrR10[$CFG_WINEPTS_PATH][1] & " "
	$arguments = $arg1 & $arg2 & $arg3 & $arg4 & $arg5 & $arg6 & $arg7 & $arg8 & $arg9
	ShellExecute($cmd, $arguments, "", "", @SW_MAXIMIZE)
EndFunc   ;==>CollectLogs


Func DebugOn()
	FileChangeDir($HelpersDir)
	$WebLoggerConfig = $arrR10[$CFG_SERVER_PATH][1] & "\" & "WebLoggerConfig.xml"
	ShellExecute($HelpersDir & "\SetLogger.exe", $WebLoggerConfig & " DEBUG", "", "", @SW_MAXIMIZE)
	FileChangeDir(@ScriptDir)
EndFunc   ;==>DebugOn


Func DebugOff()
	$WebLoggerConfig = $arrR10[$CFG_SERVER_PATH][1] & "\" & "WebLoggerConfig.xml"
	ShellExecute($HelpersDir & "\SetLogger.exe", $WebLoggerConfig & " ERROR", "", "", @SW_MAXIMIZE)
EndFunc   ;==>DebugOff


Func MonitorSrvLog()
	$ServerLogsDir = $arrR10[$CFG_SERVER_PATH][1] & "\Logs\"
	$hSearch = FileFindFirstFile($ServerLogsDir & "GPOSWebService_*.log")
	If $hSearch > 0 Then
		$LastGpos = FileFindNextFile($hSearch)
		ShellExecute($arrHelpers[$CFG_EDITOR][1], " -monitor " & $ServerLogsDir & $LastGpos)
	EndIf
EndFunc   ;==>MonitorSrvLog


Func KillPOS()
	ShellExecute($HelpersDir & "\killPOS.cmd", "", "", "", @SW_MINIMIZE)
EndFunc   ;==>KillPOS


Func ReceiptDebugOn()
	FileChangeDir($HelpersDir)
	ShellExecute($HelpersDir & "\receiptdebug.cmd", $arrEnv[$CFG_RETAIL_DB_NAME][1], "", "", @SW_MAXIMIZE)
	FileChangeDir(@ScriptDir)
EndFunc   ;==>ReceiptDebugOn


Func ReceiptDebugOff()
	FileChangeDir($HelpersDir)
	ShellExecute($HelpersDir & "\receiptdebugoff.cmd", $arrEnv[$CFG_RETAIL_DB_NAME][1], "", "", @SW_MAXIMIZE)
	FileChangeDir(@ScriptDir)
EndFunc   ;==>ReceiptDebugOff


Func ViewSlip()
	Local $sFileOpenDialog = FileOpenDialog("Select input file", $arrR10[$CFG_TLOG_PATH][1], "TLOG (RetailTransactionLog*.xml)", 1)
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


Func EditIni()
	ShellExecute($arrHelpers[$CFG_EDITOR][1], $cfgFile)
	Sleep(5000)
	ReloadItemsFile()
	ReloadConfigFile()
EndFunc   ;==>EditIni


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
	$hWndSCR = ActivateScanner()
	ControlSend($hWndSCR, "", "[CLASS:Edit; INSTANCE:1]", "{HOME}{SHIFTDOWN}{END}{SHIFTUP}{DEL}")
EndFunc   ;==>CleanScanner


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
	Run($arrHelpers[$CFG_CMD][1])
EndFunc   ;==>OpenCMD


Func OpenSpooky()
	$SpookyExe = $arrR10[$CFG_SPOOKY_PATH][1] & "\" & "R10WebClient.exe"
	If FileExists($SpookyExe) Then
		Run($SpookyExe, $arrR10[$CFG_SPOOKY_PATH][1] & "\")
	EndIf
EndFunc   ;==>OpenSpooky


Func OpenSSMS()
	ShellExecute($arrHelpers[$CFG_SQLMGR][1], "-E")
EndFunc   ;==>OpenSSMS


Func OpenSnoop()
	ShellExecute($arrHelpers[$CFG_SNOOP][1], "")
EndFunc   ;==>OpenSnoop


Func OpenServices()
	ShellExecute("C:\Windows\System32\services.msc")
EndFunc   ;==>OpenServices


Func CopyServerExtToCust()
	$cmd = $HelpersDir & "\CopyServerExtToCust.cmd"
	$arg1 = $arrEnv[$CFG_SERVER_APPPOOL][1] & " "
	$arg2 = $arrDev[$CFG_SERVER_DBG_CUST_PATH][1] & " "
	$arg3 = $arrDev[$CFG_SERVER_DBG_EXT_PATH][1] & " "
	$arg4 = $arrDev[$CFG_LOYALTY_DBG_EXT_PATH][1] & " "
	$arguments = $arg1 & $arg2 & $arg3 & $arg4
	ShellExecute($cmd, $arguments, "", "", @SW_MAXIMIZE)
EndFunc   ;==>CopyServerExtToCust


Func CopyPosExtToCust()
	$cmd = $HelpersDir & "\CopyPosExtToCust.cmd"
	$arg1 = $arrDev[$CFG_POS_DBG_CUST_PATH][1] & " "
	$arg2 = $arrDev[$CFG_POS_DBG_EXT_PATH][1] & " "
	$arguments = $arg1 & $arg2
	ShellExecute($cmd, $arguments, "", "", @SW_MAXIMIZE)
EndFunc   ;==>CopyPosExtToCust


Func CopyOfficeExtToCust()
	$cmd = $HelpersDir & "\CopyOfficeExtToCust.cmd"
	$arg1 = $arrEnv[$CFG_OFFICE_APPPOOL][1] & " "
	$arg2 = $arrDev[$CFG_OFFICE_DBG_CUST_PATH][1] & " "
	$arg3 = $arrDev[$CFG_OFFICE_DBG_EXT_PATH][1] & " "
	$arguments = $arg1 & $arg2 & $arg3
	ShellExecute($cmd, $arguments, "", "", @SW_MAXIMIZE)
EndFunc   ;==>CopyOfficeExtToCust


Func CopyFromMsiFolder()
	$cmd = $HelpersDir & "\CopyFromMsiFolder.cmd"
	$arg1 = $arrR10[$CFG_SERVER_PATH][1] & " "
	$arg2 = $arrR10[$CFG_POS_PATH][1] & " "
	$arg3 = $arrR10[$CFG_OFFICE_PATH][1] & " "
	$arg4 = $arrDev[$CFG_POS_DBG_EXT_PATH][1]	
	$arguments = $arg1 & $arg2 & $arg3 & $arg4
	ShellExecute($cmd, $arguments, "", "", @SW_MAXIMIZE)
EndFunc   ;==>CopyFromMsiFolder


Func ToEnglish()
	FileChangeDir($HelpersDir)
	ShellExecute($HelpersDir & "\jumbo_update_to_english.cmd", $arrEnv[$CFG_RETAIL_DB_NAME][1], "", "", @SW_MAXIMIZE)
	FileChangeDir(@ScriptDir)
EndFunc   ;==>ToEnglish


Func ToDutch()
	FileChangeDir($HelpersDir)
	ShellExecute($HelpersDir & "\jumbo_update_to_dutch.cmd", $arrEnv[$CFG_RETAIL_DB_NAME][1], "", "", @SW_MAXIMIZE)
	FileChangeDir(@ScriptDir)
EndFunc   ;==>ToDutch


Func FixRTIs()
	$cmd = $HelpersDir & "\FixRTIs.cmd"
	$arg1 = $arrR10[$CFG_RTIS_FIX_PATH][1] & " "
	$arg2 = $arrDev[$CFG_SERVER_DBG_EXT_PATH][1] & " "
	$arg3 = $arrDev[$CFG_SERVER_DBG_RTI_PATH][1] & " "
	$arguments = $arg1 & $arg2 & $arg3
	ShellExecute($cmd, $arguments, "", "", @SW_MAXIMIZE)
EndFunc   ;==>FixRTIs


; === Currently Unused Functions ================================================================================


;~ Func Autmation()
;~ 	$keys = StringSplit(StringStripWS(GUICtrlRead($idComboBox),8),"=")
;~ 	;~ MsgBox($MB_SYSTEMMODAL, "",  $keys[2])
;~ 	If WinExists("R10PosClient") == 1 Then
;~ 		WinActivate("R10PosClient")
;~     EndIf
;~  $hWndSCR = ActivateScanner()
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

Func ReadIniFiles()
	ReloadItemsFile()
	ReloadConfigFile()
EndFunc   ;==>ReadIniFiles


Func GetItemNumberFromCombo()
	$SelectedItem = StringStripWS(GUICtrlRead($idComboBox), $STR_STRIPALL)
	$Tokens = StringSplit($SelectedItem, "-")
	$numberOfTokens = $Tokens[0]
	If $numberOfTokens < 1 Then
		Return ""
	EndIf
	$Item = StringStripWS($Tokens[1], $STR_STRIPALL)
	;$ItemIsNumber = StringRegExp($Item, "^\d+$")
	;If Not $ItemIsNumber Then
	;	ExtMsgBox($EMB_ICONEXCLAM, $MB_OK, "PosTyper", $Item & " is not a number", 3, $g_hPosTyper)
	;	Return ""
	;EndIf
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

	StartProgressBar($ProgressBarCaption)

	$NumOfItems = $arrItems[0][0]

	$NumItemsUpToNextFlow = GetNumItemsUpToNextFlow($arrItems)

	For $i = 1 To $NumOfItems

		WinActivate("R10PosClient")

		$KeyToStatusBar = $arrItems[$i][0]
		$ValToStatusBar = $arrItems[$i][1]

		If $KeyToStatusBar = "wait" Then
			$ValToStatusBar *= $AutomationSpeedFactor
		EndIf

		$StatusBarText = $KeyToStatusBar & " = " & $ValToStatusBar
		WriteToStatusBar("Scenario", $StatusBarText)

		If $arrItems[$i][0] = "item" Or $arrItems[$i][0] = "card" Then
			$hWndSCR = ActivateScanner()
			ControlSend($hWndSCR, "", "[CLASS:Edit; INSTANCE:1]", "{HOME}{SHIFTDOWN}{END}{SHIFTUP}{DEL}")
			ControlSend($hWndSCR, "", "[CLASS:Edit; INSTANCE:1]", $arrItems[$i][1])
			ControlClick($hWndSCR, "", "[CLASS:Button; INSTANCE:5]")

			For $j = 1 To 10
				Sleep(50)
				$sText = ControlGetText($hWndSCR, "", "[CLASS:Edit; INSTANCE:3]")
				If $sText = "Claimed,Enabled" Then ExitLoop
			Next
			WinActivate("R10PosClient")
		ElseIf $arrItems[$i][0] = "linqsafe" Then
			$hWndLincSafe = ActivateLincSafe()
			If $hWndLincSafe > 0 Then
				ClickLincSafeButton($hWndLincSafe, $arrItems[$i][1])		
			EndIf
			WinActivate("R10PosClient")
		ElseIf $arrItems[$i][0] = "type" Then			
			Type($arrItems[$i][1])
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
		ElseIf $arrItems[$i][0] = "flow" Then
			$arrItems = ExecuteFlowAndReloadArrItems($arrItems[$i][1], $StatusBarText, $ProgressBarCaption)
		EndIf
		UpdateProgressBar($i, $NumOfItems, $StatusBarText)
	Next
	$EndGracefully = Not $bBreakByUser
	StopProgressBar($EndGracefully, $StatusBarText)
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
EndFunc   ;==>SkipDialog


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
	EnvSet("RETAIL_DB_NAME_TEMP_VAR", $arrEnv[$CFG_RETAIL_DB_NAME][1])
	$retCode = RunWait($HelpersDir & "\jumbo_test_english_exists.cmd", "", @SW_HIDE)
	$BackupExists = $retCode == 1
	FileChangeDir(@ScriptDir)
	Return $BackupExists
EndFunc   ;==>IsEnglishBackupDbTablesExist


Func IsDutchBackupDbTablesExist()
	FileChangeDir($HelpersDir)
	EnvSet("RETAIL_DB_NAME_TEMP_VAR", $arrEnv[$CFG_RETAIL_DB_NAME][1])
	$retCode = RunWait($HelpersDir & "\jumbo_test_dutch_exists.cmd", "", @SW_HIDE)
	$BackupExists = $retCode == 1
	FileChangeDir(@ScriptDir)
	Return $BackupExists
EndFunc   ;==>IsDutchBackupDbTablesExist


Func DisableLanguageButtonsIfDbNotReady($idBtnToEnglish, $idBtnToDutch)
	If Not IsEnglishBackupDbTablesExist() Then
		DisableButton($idBtnToEnglish)
	EndIf
	If Not IsDutchBackupDbTablesExist() Then
		DisableButton($idBtnToDutch)
	EndIf
EndFunc   ;==>DisableLanguageButtonsIfDbNotReady


Func DisableButtonsOnStartup()
	If (StringLen($arrPOS[$CFG_LOYALTY_CARD][1]) = 0) Then
		DisableButton($idBtnScanLoyaltyCard)
	EndIf
	If ((StringLen($arrDev[$CFG_SERVER_DBG_CUST_PATH][1]) = 0) Or (StringLen($arrDev[$CFG_SERVER_DBG_EXT_PATH][1]) = 0) Or (StringLen($arrDev[$CFG_LOYALTY_DBG_EXT_PATH][1]) = 0) ) Then
		DisableButton($idBtnCopySrvExtToCust)
	EndIf
	If ((StringLen($arrDev[$CFG_POS_DBG_CUST_PATH][1]) = 0) Or (StringLen($arrDev[$CFG_POS_DBG_EXT_PATH][1]) = 0)) Then
		DisableButton($idBtnCopyPOSExtToCust)
	EndIf
	If ((StringLen($arrDev[$CFG_OFFICE_DBG_CUST_PATH][1]) = 0) Or (StringLen($arrDev[$CFG_OFFICE_DBG_EXT_PATH][1]) = 0)) Then
		DisableButton($idBtnCopyOffExtToCust)
	EndIf
	If ((StringLen($arrDev[$CFG_SERVER_DBG_RTI_PATH][1]) = 0) Or (StringLen($arrDev[$CFG_SERVER_DBG_EXT_PATH][1]) = 0)) Then
		DisableButton($idBtnFixRTIs)
	EndIf
	If Not FileExists($TenderingIniFile) Then
		DisableButton($idBtnTendering)
	EndIf
	If Not FileExists($PayingCashIniFile) Then
		DisableButton($idBtnPayingCash)
	EndIf
	If Not FileExists($PayingEFTIniFile) Then
		DisableButton($idBtnPayingEFT)
	EndIf
EndFunc   ;==>DisableButtonsOnStartup


Func DisableButton($idBtn)
	GUICtrlSetState($idBtn, $GUI_DISABLE)
EndFunc   ;==>DisableButton


Func Copyrights()
	WriteToStatusBar("© Created by Christian H, enhanced by Yossi S", "")
EndFunc   ;==>Copyrights


Func ExtMsgBox($vIcon, $vButton, $sTitle, $sText, $iTimeout, $hWin)
	;_ExtMsgBoxSet(2, $SS_CENTER, -1, -1, -1, -1, Default, Default, "#")
	_ExtMsgBoxSet(1)
	$iRetValue = _ExtMsgBox($vIcon, $vButton, $sTitle, $sText, $iTimeout, $hWin)
	_ExtMsgBoxSet(Default)
	Return $iRetValue
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
	$arrPosTyper		= IniReadSection($cfgFile, "PosTyper")
	$arrEnv				= IniReadSection($cfgFile, "Env")
	$arrR10				= IniReadSection($cfgFile, "R10")
	$arrDev				= IniReadSection($cfgFile, "Dev")
	$arrHelpers			= IniReadSection($cfgFile, "Helpers")
	$arrPOS				= IniReadSection($cfgFile, "POS")
	$arrEmulatorsTemp	= IniReadSection($cfgFile, "Emulators")
	$arrDialogsTemp		= IniReadSection($cfgFile, "DialogsToSkip")
	SplitEmulatorValueToTokensArray($arrEmulatorsTemp)
	SplitDialogsValueToTokensArray($arrDialogsTemp)
EndFunc   ;==>ReloadConfigFile


Func SplitEmulatorValueToTokensArray($arrEmulatorsTemp)
	$NumOfItems = $arrEmulatorsTemp[0][0]
	ReDim $arrEmulators[$NumOfItems + 1][2]
	$arrEmulators[0][0] = $NumOfItems
	For $i = 1 To $NumOfItems
		$Val = $arrEmulatorsTemp[$i][1]
		$Tokens = StringSplit($Val, "|")
		$arrEmulators[$i][1] = $Tokens
	Next
EndFunc   ;==>SplitEmulatorValueToTokensArray


Func SplitDialogsValueToTokensArray($arrDialogsTemp)
	$NumOfItems = $arrDialogsTemp[0][0]
	ReDim $arrDialogs[$NumOfItems + 1][2]
	$arrDialogs[0][0] = $NumOfItems
	For $i = 1 To $NumOfItems
		$Val = $arrDialogsTemp[$i][1]
		$Tokens = StringSplit($Val, "|")
		$arrDialogs[$i][1] = $Tokens
	Next
EndFunc   ;==>SplitDialogsValueToTokensArray


Func ReloadItemsFile()
	$arrItems = IniReadSection($ItemsIniFile, "Items")
EndFunc   ;==>ReloadItemsFile


Func ActivateScanner()
	$arrEmulatorScanner = $arrEmulators[$CFG_SCANNER][1]
	Return WinActivate($arrEmulatorScanner[$CFG_CAPTION])
EndFunc   ;==>ActivateScanner


Func ActivateLincSafe()
	$arrEmulatorLincSafe = $arrEmulators[$CFG_LINCSAFE][1]
	Return WinActivate($arrEmulatorLincSafe[$CFG_CAPTION])
EndFunc   ;==>ActivateLincSafe


Func ClickLincSafeButton($hWndLincSafe, $amount)
	$xOffset = 0
	$yOffset = 0
	If $amount = "50" Then
		$xOffset = $LINCSAFE_BANKNOTE_50_X_OFFSET
		$yOffset = $LINCSAFE_BANKNOTE_50_Y_OFFSET
	ElseIf $amount = "20" Then
		$xOffset = $LINCSAFE_BANKNOTE_20_X_OFFSET
		$yOffset = $LINCSAFE_BANKNOTE_20_Y_OFFSET
	ElseIf $amount = "10" Then
		$xOffset = $LINCSAFE_BANKNOTE_10_X_OFFSET
		$yOffset = $LINCSAFE_BANKNOTE_10_Y_OFFSET
	ElseIf $amount = "5" Then
		$xOffset = $LINCSAFE_BANKNOTE_5_X_OFFSET
		$yOffset = $LINCSAFE_BANKNOTE_5_Y_OFFSET
	ElseIf $amount = "2" Then
		$xOffset = $LINCSAFE_COIN_2_0_X_OFFSET
		$yOffset = $LINCSAFE_COIN_2_0_Y_OFFSET
	ElseIf $amount = "1" Then
		$xOffset = $LINCSAFE_COIN_1_0_X_OFFSET
		$yOffset = $LINCSAFE_COIN_1_0_Y_OFFSET
	ElseIf $amount = "0.5" Then
		$xOffset = $LINCSAFE_COIN_0_5_X_OFFSET
		$yOffset = $LINCSAFE_COIN_0_5_Y_OFFSET
	ElseIf $amount = "0.2" Then
		$xOffset = $LINCSAFE_COIN_0_2_X_OFFSET
		$yOffset = $LINCSAFE_COIN_0_2_Y_OFFSET
	ElseIf $amount = "0.1" Then
		$xOffset = $LINCSAFE_COIN_0_1_X_OFFSET
		$yOffset = $LINCSAFE_COIN_0_1_Y_OFFSET
	ElseIf $amount = "0.05" Then
		$xOffset = $LINCSAFE_COIN_0_0_5_X_OFFSET
		$yOffset = $LINCSAFE_COIN_0_0_5_Y_OFFSET
	EndIf				
	$aPos = WinGetPos($hWndLincSafe)
	$x = $aPos[0] + $xOffset
	$y = $aPos[1] + $yOffset
	MouseClick("left", $x, $y, 1, 1)
EndFunc   ;==>ClickLincSafeButton


Func StartProgressBar($ProgressBarCaption)
	If $ShowProgressBar Then
		Global $ProgressBarPercents = 0
		$aPos = WinGetPos($g_hPosTyper)
		$xPOS = $aPos[0] + 15
		$yPOS = $aPos[1] + $aPos[3] / 4 + 30
		ProgressOn($ProgressBarCaption, "", $ProgressBarPercents & "%", $xPOS, $yPOS, $DLG_MOVEABLE)
	EndIf
EndFunc   ;==>StartProgressBar


Func UpdateProgressBar($i, $NumOfItems, $StatusBarText)
	If $ShowProgressBar Then
		$ProgressBarPercents = Int($i / $NumOfItems * 100)
		ProgressSet($ProgressBarPercents, $StatusBarText, $ProgressBarPercents & "%")
	EndIf
EndFunc   ;==>UpdateProgressBar


Func StopProgressBar($EndGracefully, $StatusBarText)
	If $ShowProgressBar Then
		If $EndGracefully Then
			ProgressSet(100, $StatusBarText, $ProgressBarPercents & "%")
			Sleep(500)
		EndIf
		ProgressOff()
	EndIf
EndFunc   ;==>StopProgressBar


Func GetNumItemsUpToNextFlow($arrItems)
	For $i = 1 To $arrItems[0][0]
		If $arrItems[$i][0] = "flow" Then
			Return $i - 1
		EndIf
	Next
	Return $arrItems[0][0]
EndFunc   ;==>GetNumItemsUpToNextFlow


Func ExecuteFlowAndReloadArrItems($FlowName, $StatusBarText, $ProgressBarCaption)
	Local $FuncName
	Switch $FlowName
		Case "TENDERING"
			$FuncName = Tendering
		Case "PAYING_CASH"
			$FuncName = PayingCash
		Case "PAYING_EFT"
			$FuncName = PayingEFT
		Case Else
			Return
	EndSwitch
	StopProgressBar(True, $StatusBarText)
	$FuncName()
	$arrItems = IniReadSection($sLastScenarioFileName, "SCENARIO")
	StartProgressBar($ProgressBarCaption)
	Return $arrItems
EndFunc   ;==>ExecuteFlowAndReloadArrItems
