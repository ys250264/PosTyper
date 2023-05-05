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

#RequireAdmin

;AutoItSetOption("MustDeclareVars", 1)

global $PostyperDir = @Scriptdir
global $ScenariosDir = @Scriptdir &"\scenarios"
global $HelpersDir = @Scriptdir &"\helpers"
global $CollectedDir = @Scriptdir &"\collected_logs"
global $CaptureDir = @Scriptdir &"\captured_images"
global $ItemsdDir = @Scriptdir &"\items"

global $iniFile = $ItemsdDir & "\Items.ini"
global $cfgFile = @Scriptdir & "\POStyper.ini"
global $icoFile = @Scriptdir & "\POStyper.ico"

global $arrItems

global $CFG_DIALOG_CAPTION					= 1
global $CFG_DIALOG_X								= 2
global $CFG_DIALOG_Y								= 3
global $CFG_DIALOG_STATUS_BAR				= 4
global $CFG_CMD_PATH								= 5
global $CFG_RETAIL_DB_NAME					= 6
global $CFG_SERVER_WEBSITE					= 7
global $CFG_RABBITMQ_WEBSITE				= 8
global $CFG_SERVER_PATH						= 9
global $CFG_POS_PATH								= 10
global $CFG_OFFICE_PATH							= 11
global $CFG_TLOG_PATH							= 12
global $CFG_DMS_PATH								= 13
global $CFG_SPOOKY_PATH						= 14
global $CFG_ARSGATEWAY_PATH				= 15
global $CFG_RETAILGATEWAY_PATH			= 16
global $CFG_STOREGATEWAY_PATH			= 17
global $CFG_WINEPTS_PATH						= 18
global $CFG_SERVER_DBG_CUST_PATH		= 19
global $CFG_SERVER_DBG_EXT_PATH			= 20
global $CFG_POS_DBG_CUST_PATH			= 21
global $CFG_POS_DBG_EXT_PATH				= 22
global $CFG_OFFICE_DBG_CUST_PATH		= 23
global $CFG_OFFICE_DBG_EXT_PATH			= 24
global $CFG_SQLMGR									= 25
global $CFG_EDITOR									= 26
global $CFG_BROWSER								= 27
global $CFG_SNOOP									= 28
global $CFG_USER										= 29
global $CFG_PASSWORD							= 30
global $CFG_LOYCARD								= 31
global $CFG_SCANNER_EMU						= 32
global $CFG_SCANNER_EMU_X					= 33
global $CFG_SCANNER_EMU_Y					= 34
global $CFG_PRINTER_EMU						= 35
global $CFG_PRINTER_EMU_X						= 36
global $CFG_PRINTER_EMU_Y						= 37
global $CFG_SCALE_EMU							= 38
global $CFG_SCALE_EMU_X						= 39
global $CFG_SCALE_EMU_Y						= 40
global $CFG_DRAWER_EMU						= 41
global $CFG_DRAWER_EMU_X						= 42
global $CFG_DRAWER_EMU_Y						= 43
global $CFG_WINEPTS_EMU						= 44
global $CFG_WINEPTS_EMU_X					= 45
global $CFG_WINEPTS_EMU_Y					= 46
global $CFG_UPB_EMU								= 47
global $CFG_UPB_EMU_X							= 48
global $CFG_UPB_EMU_Y							= 49

global $arrCONFIG

If _Singleton("POStyper", 1) = 0 Then
    MsgBox(4096, "Warning", "PosTyper is already running")
    Exit
EndIf

_readItemFile()

Main()

Func Main()
	
	$PosTyperDialogX = @DesktopWidth - 333
	$PosTyperDialogY = 0
	$PosTyperDialogWidth = 333
	$PosTyperDialogHeight = 315
	
	Global $StatusBarOn = False
	If (StringLower(StringStripWS($arrCONFIG[$CFG_DIALOG_STATUS_BAR][1], $STR_STRIPALL)) == "true") Then
		$StatusBarOn = True
	EndIf
	
	If ($StatusBarOn) Then		
		$PosTyperDialogHeight += 20
	EndIf
	
	If ($arrCONFIG[$CFG_DIALOG_X][1] >= 0 And $arrCONFIG[$CFG_DIALOG_Y][1] >= 0) Then
		$PosTyperDialogX = $arrCONFIG[$CFG_DIALOG_X][1]
		$PosTyperDialogY = $arrCONFIG[$CFG_DIALOG_Y][1]
	EndIf
	
    Global $g_hPosTyper = GUICreate($arrCONFIG[$CFG_DIALOG_CAPTION][1], $PosTyperDialogWidth, $PosTyperDialogHeight, $PosTyperDialogX, $PosTyperDialogY, -1, $WS_EX_ACCEPTFILES)
	GUISetIcon($icoFile)
	AddStatusBar()
	
    GUICtrlSetState(-1, $GUI_DROPACCEPTED)
	Global $idComboBox = GUICtrlCreateCombo("", 10, 10, 235, 20)
    for $i = 1 to $arrItems[0][0]
		GUICtrlSetData($idComboBox, $arrItems[$i][1], $arrItems[1][1])
	Next

	Local $ROW_0		=	10
	Local $ROW_1		=	45
	Local $ROW_2		=	75
	Local $ROW_3		=	105
	Local $ROW_4		=	135
	Local $ROW_5		=	165
	Local $ROW_6		=	195
	Local $ROW_7		=	225
	Local $ROW_8		=	255
	Local $ROW_9		=	285
	
	Local $Col_1			=	10
	Local $Col_2			=	90
	Local $Col_3			=	170
	Local $Col_4			=	250

	Local $BtnWidthS	=	35
	Local $BtnHeightS	=	23
	Local $BtnWidthL	=	70
	Local $BtnHeight	=	20

	Local $idBtnScan = 					GUICtrlCreateButton("Scan"				, 250, $ROW_0 - 1,  $BtnWidthS, $BtnHeightS)
	;Local $idBtnCD = 						GUICtrlCreateButton("CD"					, 225, $ROW_0 - 1, $BtnWidthS, $BtnHeightS)
	Local $idBtnOK = 						GUICtrlCreateButton("Type"				, 285, $ROW_0 - 1, $BtnWidthS, $BtnHeightS)
	;~	Local $idBtnAuto = 				GUICtrlCreateButton("Gal"					, 170, $ROW_0 - 1, $BtnWidthS, $BtnHeightS)
	
	Local $idBtnPOS = 					GUICtrlCreateButton("Start POS"			, $Col_1, $ROW_1, $BtnWidthL, $BtnHeight)
	Local $idBtnLogin = 					GUICtrlCreateButton("Login"				, $Col_2, $ROW_1, $BtnWidthL, $BtnHeight)
	Local $idBtnEmuarrange = 			GUICtrlCreateButton("Move Emu"		, $Col_3, $ROW_1, $BtnWidthL, $BtnHeight)
	Local $idBtnScanLoyaltyCard = 	GUICtrlCreateButton("Scan Loyalty"	, $Col_4, $ROW_1, $BtnWidthL, $BtnHeight)
	
	Local $idBtnScenario = 				GUICtrlCreateButton("Scenario"			, $Col_1, $ROW_2, $BtnWidthL, $BtnHeight)
	Local $idBtnTendering = 			GUICtrlCreateButton("Tendering"			, $Col_2, $ROW_2, $BtnWidthL, $BtnHeight)
	Local $idBtnUnlock = 					GUICtrlCreateButton("Unlock"				, $Col_3, $ROW_2, $BtnWidthL, $BtnHeight)
	Local $idBtnKillPOS =	 				GUICtrlCreateButton("Kill POS" 	    	, $Col_4, $ROW_2, $BtnWidthL, $BtnHeight)
	
	Local $idBtnCleanLogs = 			GUICtrlCreateButton("Clean Logs"		, $Col_1, $ROW_3, $BtnWidthL, $BtnHeight)
	Local $idBtnBrowseServer =		GUICtrlCreateButton("Browse Srv"		, $Col_2, $ROW_3, $BtnWidthL, $BtnHeight)
	Local $idBtnMonitoSrvLog =		GUICtrlCreateButton("View Gpos"		, $Col_3, $ROW_3, $BtnWidthL, $BtnHeight)
	Local $idBtnEditIni = 					GUICtrlCreateButton("Edit Ini"			, $Col_4, $ROW_3, $BtnWidthL, $BtnHeight)

	Local $idBtnDebugOn =   			GUICtrlCreateButton("Gpos DBG"		, $Col_1, $ROW_4, $BtnWidthL, $BtnHeight)
	Local $idBtnDebugOff = 		    	GUICtrlCreateButton("Gpos ERR"			, $Col_2, $ROW_4, $BtnWidthL, $BtnHeight)
	Local $idBtnExposeLogs = 			GUICtrlCreateButton("Expose Logs"		, $Col_3, $ROW_4, $BtnWidthL, $BtnHeight)
	Local $idBtnCollectLogs = 			GUICtrlCreateButton("Collect Logs"		, $Col_4, $ROW_4, $BtnWidthL, $BtnHeight)

	Local $idBtnReceiptDebug = 		GUICtrlCreateButton("Slip Dbg"			, $Col_1, $ROW_5, $BtnWidthL, $BtnHeight)
	Local $idBtnReceiptDebugOff = 	GUICtrlCreateButton("No Slip Dbg"		, $Col_2, $ROW_5, $BtnWidthL, $BtnHeight)
	Local $idBtnViewSlip = 				GUICtrlCreateButton("View Slip"			, $Col_3, $ROW_5, $BtnWidthL, $BtnHeight)
	Local $idBtnExposeTLog = 			GUICtrlCreateButton("Expose Tlog"		, $Col_4, $ROW_5, $BtnWidthL, $BtnHeight)
	
	Local $idBtnPOSSnip =	 			GUICtrlCreateButton("Pos Capture"    	, $Col_1, $ROW_6, $BtnWidthL, $BtnHeight)	
	Local $idBtnScreenshot = 			GUICtrlCreateButton("Scrn Capture"	, $Col_2, $ROW_6, $BtnWidthL, $BtnHeight)		
	Local $idBtnCleanScanner = 		GUICtrlCreateButton("Clean Scan"		, $Col_3, $ROW_6, $BtnWidthL, $BtnHeight)
	Local $idBtnBrowseRabbit =		GUICtrlCreateButton("Rabbit"				, $Col_4, $ROW_6, $BtnWidthL, $BtnHeight)
	
	Local $idBtnIISReset = 				GUICtrlCreateButton("IISReset"			, $Col_1, $ROW_7, $BtnWidthL, $BtnHeight)
	Local $idBtnIISStop = 				GUICtrlCreateButton("IISStop"			, $Col_2, $ROW_7, $BtnWidthL, $BtnHeight)
	Local $idBtnIISStart = 				GUICtrlCreateButton("IISStart"			, $Col_3, $ROW_7, $BtnWidthL, $BtnHeight)
	Local $idBtnCMD = 					GUICtrlCreateButton("CMD"				, $Col_4, $ROW_7, $BtnWidthL, $BtnHeight)
			
	Local $idBtnWebClient = 			GUICtrlCreateButton("Spooky"			, $Col_1, $ROW_8, $BtnWidthL, $BtnHeight)
	Local $idBtnServices = 				GUICtrlCreateButton("Services"			, $Col_2, $ROW_8, $BtnWidthL, $BtnHeight)		
	Local $idBtnSQLMgmt = 			GUICtrlCreateButton("SQL Mgmt"		, $Col_3, $ROW_8, $BtnWidthL, $BtnHeight)
	Local $idBtnSnoop = 					GUICtrlCreateButton("Snoop"				, $Col_4, $ROW_8, $BtnWidthL, $BtnHeight)
	
	Local $idBtnCopySrvExt =			GUICtrlCreateButton("Copy SrvExt"		, $Col_1, $ROW_9, $BtnWidthL, $BtnHeight)
	Local $idBtnCopyPOSExt =			GUICtrlCreateButton("Copy PosExt"		, $Col_2, $ROW_9, $BtnWidthL, $BtnHeight)
	Local $idBtnCopyOffExt =			GUICtrlCreateButton("Copy OfcExt"		, $Col_3, $ROW_9, $BtnWidthL, $BtnHeight)
	
	;~	Local $idBtnResetLoy =	 		GUICtrlCreateButton("Reset Loy"     , $Col_4, $ROW_7, $BtnWidthL, $BtnHeight)
	;~ 	Local $idBtnMsg3On =   		    GUICtrlCreateButton("MSG3"      	, $Col_2, $ROW_7, $BtnWidthL, $BtnHeight)
	;~ 	Local $idBtnMsg3Off = 		    GUICtrlCreateButton("NO MSG3"     , $Col_3, $ROW_7, $BtnWidthL, $BtnHeight)
	;~	Local $idBtnFLDiag = 		   		GUICtrlCreateButton("FLDiag"         , $Col_1, $ROW_8, $BtnWidthL, $BtnHeight)

	GUICtrlSetColor($idBtnPOS , 0x000088)
	GUICtrlSetColor($idBtnKillPOS, 0xFF0000)
	;~	GUICtrlSetColor($idBtnResetLoy, 0x008000)

    GUISetState(@SW_SHOW)
    If WinExists("R10PosClient") == 1 Then
		WinActivate("R10PosClient")
    EndIf
	Sleep(500)

    Global $do = 1;

    While $do
		$Btn = GUIGetMsg()
        Switch $Btn
            Case $GUI_EVENT_CLOSE
                ExitLoop
            Case $idBtnOK
				FuncWrapper($Btn, Type)
            ;Case $idBtnCD
			;	FuncWrapper($Btn, Checkdigit)
			Case $idBtnLogin
				FuncWrapper($Btn, Login, True)
			Case $idBtnUnlock
				FuncWrapper($Btn, Unlock, True)
			Case $idBtnTendering
				FuncWrapper($Btn, Tendering, True)
			Case $idBtnEditIni
				FuncWrapper($Btn, EditIni)
			Case $idBtnSnoop
				FuncWrapper($Btn, Snoop)
			Case $idBtnWebClient
				FuncWrapper($Btn, WebClient)
			Case $idBtnIISReset
				FuncWrapper($Btn, IISReset, True)
			Case $idBtnIISStart
				FuncWrapper($Btn, IISStart, True)
			Case $idBtnIISStop
				FuncWrapper($Btn, IISStop, True)
			Case $idBtnPOS
				FuncWrapper($Btn, POSStart)
			;~Case $idBtnCMD
			;~	FuncWrapper($Btn, CMDOpen)
            Case $idBtnEmuarrange
				FuncWrapper($Btn, Arrange, True)
			Case $idBtnScenario
				FuncWrapper($Btn, Scenario, True)
			Case $idBtnExposeLogs
				FuncWrapper($Btn, ExposeLogs)
			Case $idBtnExposeTLog
				FuncWrapper($Btn, ExposeTLog)
			Case $idBtnCleanLogs
				FuncWrapper($Btn, CleanLogs, True)
			Case $idBtnCollectLogs
				FuncWrapper($Btn, CollectLogs, True)
			Case $idBtnServices
				FuncWrapper($Btn, Services)
			Case $idBtnReceiptDebug
				FuncWrapper($Btn, ReceiptDebug, True)
			Case $idBtnReceiptDebugOff
				FuncWrapper($Btn, ReceiptDebugOff, True)
			Case $idBtnViewSlip
				FuncWrapper($Btn, ViewSlip)
			Case $idBtnScreenshot
				FuncWrapper($Btn, Screenshot)
			Case $idBtnPOSSnip
				FuncWrapper($Btn, POSSnip)
			Case $idBtnDebugOn
				FuncWrapper($Btn, DebugOn)
			Case $idBtnDebugOff
				FuncWrapper($Btn, DebugOff)
            Case $idBtnKillPOS
				FuncWrapper($Btn, KillPOS)
            Case $idBtnScanLoyaltyCard
				FuncWrapper($Btn, ScanLoyaltyCard)
	;~		Case $idBtnResetLoy
	;~			FuncWrapper($Btn, ResetLoy)
	;~		Case $idBtnFLDiag
	;~			FuncWrapper($Btn, FLDiag)
            Case $idBtnScan
				FuncWrapper($Btn, Scan)
            Case $idBtnCleanScanner
				FuncWrapper($Btn, CleanScanner,)
;~ 	Case $idBtnAuto
				;~ FuncWrapper($Btn, Autmation)
;~ 			Case $idBtnMsg3On
;~				FuncWrapper($Btn, Msg3On)
;~ 			Case $idBtnMsg3Off
;~				FuncWrapper($Btn, Msg3off)
			Case $idBtnCopySrvExt
					FuncWrapper($Btn, CopyServerExtToCust, True)
		Case $idBtnCopyPOSExt
				FuncWrapper($Btn, CopyPosExtToCust, True)
            Case $idBtnCopyOffExt
				FuncWrapper($Btn, CopyOfficeExtToCust, True)
			Case $idBtnMonitoSrvLog
				FuncWrapper($Btn, MonitorSrvLog)
			Case $idBtnSQLMgmt
				FuncWrapper($Btn, OpenSSMS)
			Case $idBtnBrowseServer
				FuncWrapper($Btn, BrowseServer)
			Case $idBtnBrowseRabbit
				FuncWrapper($Btn, BrowseRabbit)
        EndSwitch
    WEnd

EndFunc

func Login()
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

func Unlock()
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

func Autmation()
$keys = StringSplit(StringStripWS(GUICtrlRead($idComboBox),8),"=")
;~ MsgBox($MB_SYSTEMMODAL, "",  $keys[2])

	If WinExists("R10PosClient") == 1 Then
		WinActivate("R10PosClient")
    EndIf
		$hWndSCR = WinActivate($arrCONFIG[$CFG_SCANNER_EMU][1])

		ControlSend($hWndSCR,"","[CLASS:Edit; INSTANCE:1]","{HOME}{SHIFTDOWN}{END}{SHIFTUP}{DEL}")
	    ControlSend($hWndSCR,"","[CLASS:Edit; INSTANCE:1]",$keys[2])
	    ControlClick($hWndSCR,"","[CLASS:Button; INSTANCE:4]")

EndFunc

func CleanScanner()
	If WinExists("R10PosClient") == 1 Then
		WinActivate("R10PosClient")
    EndIf
		$hWndSCR = WinActivate($arrCONFIG[$CFG_SCANNER_EMU][1])
		ControlSend($hWndSCR,"","[CLASS:Edit; INSTANCE:1]","{HOME}{SHIFTDOWN}{END}{SHIFTUP}{DEL}")
EndFunc


func Type()
	Local $pos = MouseGetPos()
	WinActivate("R10PosClient")
	sleep(200)

	$Item = GetItemNumberFromCombo()
 	$keys = StringSplit($Item,"")
    MouseClick("left",560,350,2,1)
	sleep(200)
	For $i = 1 To $keys[0]
	  Send($keys[$i])
	Next
    MouseClick("left",800,630,1,1)
	sleep(200)
	MouseMove($pos[0],$pos[1],1)
EndFunc

Func GetItemNumberFromCombo()
	$SelectedItem = StringStripWS(GUICtrlRead($idComboBox), $STR_STRIPALL)
	$Tokens = StringSplit($SelectedItem, "-")
	$Item = StringStripWS($Tokens[1], $STR_STRIPALL)
	$Desc = StringStripWS($Tokens[2], $STR_STRIPALL)	
	return $Item
EndFunc

func Scan()
;~$Scanme = StringStripWS(GUICtrlRead($idComboBox),8)
$Scanme = GetItemNumberFromCombo()
;~ 	MsgBox($MB_SYSTEMMODAL, "", "String:" & $Scanme)
	$hWndSCR = WinActivate($arrCONFIG[$CFG_SCANNER_EMU][1])
	ControlSend($hWndSCR,"","[CLASS:Edit; INSTANCE:1]","{HOME}{SHIFTDOWN}{END}{SHIFTUP}{DEL}")
	ControlSend($hWndSCR,"","[CLASS:Edit; INSTANCE:1]",$Scanme)
	ControlClick($hWndSCR,"","[CLASS:Button; INSTANCE:5]")
	WinActivate("R10PosClient")
EndFunc



func Checkdigit()
$Number = GUICtrlRead($idComboBox)
$SUMME=0
For $i = 1 To 12

$tempstr = StringLeft($Number,$i)
$NUM = StringRight($tempstr,1)
Mod($i,2)
$SUMME+= Mod($i,2) == 0 ? $NUM * 3 : $NUM
Next
$CHECKDIGIT = MOD($SUMME,10) == 0 ? 0 : 10 - MOD($summe,10)
 _GUICtrlComboBox_SetEditText($idComboBox,StringLeft($Number,12) & $CHECKDIGIT)
EndFunc

func Press0 ()
MouseClick("left",580,625,1,1)
EndFunc
func Press1()
MouseClick("left",580,555,1,1)
EndFunc
func Press2 ()
MouseClick("left",650,555,1,1)
EndFunc
func Press3 ()
MouseClick("left",730,555,1,1)
EndFunc
func Press4 ()
MouseClick("left",580,480,1,1)
EndFunc
func Press5 ()
MouseClick("left",650,480,1,1)
EndFunc
func Press6 ()
MouseClick("left",730,480,1,1)
EndFunc
func Press7 ()
MouseClick("left",580,405,1,1)
EndFunc
func Press8 ()
MouseClick("left",650,405,1,1)
EndFunc
func Press9 ()
MouseClick("left",730,405,1,1)
EndFunc
func PressX ()
MouseClick("left",800,480,1,1)
EndFunc

func PressEnter()
WinActivate("R10PosClient")
Sleep(500)
MouseClick("left",800,630,1,1)
;~ MsgBox($MB_SYSTEMMODAL, "", "enter:")
EndFunc

Func Arrange()
	If WinExists("R10PosClient") == 1 Then
		WinActivate("R10PosClient")
    EndIf
	WinActivate($arrCONFIG[$CFG_SCANNER_EMU][1])
	WinMove($arrCONFIG[$CFG_SCANNER_EMU][1],"",$arrCONFIG[$CFG_SCANNER_EMU_X][1], $arrCONFIG[$CFG_SCANNER_EMU_Y][1])
	
	WinActivate($arrCONFIG[$CFG_PRINTER_EMU][1])
	WinMove($arrCONFIG[$CFG_PRINTER_EMU][1],"",$arrCONFIG[$CFG_PRINTER_EMU_X][1], $arrCONFIG[$CFG_PRINTER_EMU_Y][1])
	
	WinActivate($arrCONFIG[$CFG_SCALE_EMU][1])
	WinMove($arrCONFIG[$CFG_SCALE_EMU][1],"",$arrCONFIG[$CFG_SCALE_EMU_X][1], $arrCONFIG[$CFG_SCALE_EMU_Y][1])
	
	WinActivate($arrCONFIG[$CFG_DRAWER_EMU][1])
	WinMove($arrCONFIG[$CFG_DRAWER_EMU][1],"",$arrCONFIG[$CFG_DRAWER_EMU_X][1], $arrCONFIG[$CFG_DRAWER_EMU_Y][1])
	
	WinActivate($arrCONFIG[$CFG_WINEPTS_EMU][1])
	WinMove($arrCONFIG[$CFG_WINEPTS_EMU][1],"",$arrCONFIG[$CFG_WINEPTS_EMU_X][1], $arrCONFIG[$CFG_WINEPTS_EMU_Y][1])
	
	WinActivate($arrCONFIG[$CFG_UPB_EMU][1])
	WinMove($arrCONFIG[$CFG_UPB_EMU][1],"",$arrCONFIG[$CFG_UPB_EMU_X][1], $arrCONFIG[$CFG_UPB_EMU_Y][1])
EndFunc

Func SQLMgmt()
	Run($arrCONFIG[$CFG_SQLMGR][1])
EndFunc

Func WebClient()
	$SpookyExe = $arrCONFIG[$CFG_SPOOKY_PATH][1] & "\" & "R10WebClient.exe"
	if FileExists($SpookyExe) Then
	  Run($SpookyExe,$arrCONFIG[$CFG_SPOOKY_PATH][1] & "\")
	EndIf
EndFunc


Func Tendering()

	PressEnter()

	Sleep(1000)

	SkipAddCustomer()
	
	Sleep(500)

	SkipZipCodeDialog()

	Sleep(500)

	SelectCash()	

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

Func CMDOpen()
   Run("C:\Windows\System32\cmd.exe",$arrCONFIG[$CFG_CMD_PATH][1])
EndFunc

Func POSStart()
    If WinExists("R10PosClient") == 0 Then
		Run($arrCONFIG[$CFG_POS_PATH][1] & "\Retalix.Client.POS.Shell.exe",$arrCONFIG[$CFG_POS_PATH][1])
    EndIf
	Sleep(500)
	WinActivate("R10PosClient")
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

Func ExposeTLog()
	$TLogs = $arrCONFIG[$CFG_TLOG_PATH][1]
  	if FileExists($TLogs) Then
	     ShellExecute("C:\Windows\explorer.exe",$TLogs)
	EndIf
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

Func Services()
	ShellExecute("C:\Windows\System32\services.msc")
EndFunc

Func ReceiptDebug()
	FileChangeDir($HelpersDir)
	ShellExecute($HelpersDir & "\receiptdebug.cmd",$arrCONFIG[$CFG_RETAIL_DB_NAME][1],"","",@SW_MAXIMIZE)
	FileChangeDir(@Scriptdir)
EndFunc

Func ReceiptDebugOff()
	FileChangeDir($HelpersDir)
	ShellExecute($HelpersDir & "\receiptdebugoff.cmd",$arrCONFIG[$CFG_RETAIL_DB_NAME][1],"","",@SW_MAXIMIZE)
	FileChangeDir(@Scriptdir)
EndFunc

Func KillPOS()
	ShellExecute($HelpersDir & "\killPOS.cmd","","","",@SW_MINIMIZE)
EndFunc

Func ResetLoy()
	ShellExecute($HelpersDir & "\resetloy.cmd","","","",@SW_MINIMIZE)
EndFunc

Func ScanLoyaltyCard()
	$Scanme = StringStripWS(GUICtrlRead($idComboBox),8)
	;~ 	MsgBox($MB_SYSTEMMODAL, "", "String:" & $Scanme)
	$hWndSCR = WinActivate($arrCONFIG[$CFG_SCANNER_EMU][1])
	ControlSend($hWndSCR,"","[CLASS:Edit; INSTANCE:1]","{HOME}{SHIFTDOWN}{END}{SHIFTUP}{DEL}")
	ControlSend($hWndSCR,"","[CLASS:Edit; INSTANCE:1]",$arrCONFIG[$CFG_LOYCARD][1])
	ControlClick($hWndSCR,"","[CLASS:Button; INSTANCE:5]")
	WinActivate("R10PosClient")
EndFunc

Func FLDiag()
	ShellExecute($HelpersDir & "\FLDiag.cmd","","","",@SW_MAXIMIZE)
EndFunc

Func Scenario()
	FileChangeDir($PostyperDir)
    Local $sFileOpenDialog = FileOpenDialog("Select input file", $ScenariosDir & "\", "All (*.ini)",1)
    
	If @error Then
        MsgBox($MB_SYSTEMMODAL, "", "No file(s) were selected.")
        FileChangeDir($PostyperDir)
    Else
        FileChangeDir($PostyperDir)
		$arrItems=IniReadSection($sFileOpenDialog,"ITEMS")
	
		If WinExists("R10PosClient") == 1 Then
			WinActivate("R10PosClient")
		EndIf

		For $i = 1 To $arrItems[0][0]
			
			WinActivate("R10PosClient")		
			;MsgBox($MB_SYSTEMMODAL, "", "Key: " & $arrItems[$i][0] & @CRLF & "Value: " & $arrItems[$i][1])

			WriteToStatusBar("Scenario", $arrItems[$i][0] & " = " & $arrItems[$i][1])
			
			If $arrItems[$i][0] = "item" Then
				;MsgBox($MB_SYSTEMMODAL, "", "Item")
				$hWndSCR = WinActivate($arrCONFIG[$CFG_SCANNER_EMU][1])
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
				if $arrItems[$i][1] = "ENTER" Then
				   PressEnter()
				EndIf
				if $arrItems[$i][1] = "DIALOGMIDOK" Then
				   MouseClick("left",520,520,1,1)
			   EndIf
				if $arrItems[$i][1] = "ADDCUSTOMERTOSKIP" Then
					SkipAddCustomer()					
				EndIf			   			   
				if $arrItems[$i][1] = "DIALOGZIPTOSKIP" Then
					SkipZipCodeDialog()					
				EndIf			   
				if $arrItems[$i][1] = "DYNA1" Then
				   MouseClick("left",930,110,1,1)
				EndIf
				if $arrItems[$i][1] = "DYNA2" Then
				   MouseClick("left",930,170,1,1)
				EndIf
				if $arrItems[$i][1] = "DYNA3" Then
				   MouseClick("left",930,240,1,1)
				EndIf
				if $arrItems[$i][1] = "DYNA4" Then
				   MouseClick("left",930,310,1,1)
				EndIf
				if $arrItems[$i][1] = "DYNA5" Then
				   MouseClick("left",930,370,1,1)
				EndIf
				if $arrItems[$i][1] = "DYNA6" Then
				   MouseClick("left",930,440,1,1)
				EndIf
				if $arrItems[$i][1] = "DYNA7" Then
				   MouseClick("left",930,510,1,1)
				EndIf
				if $arrItems[$i][1] = "DYNAUP" Then
				   MouseClick("left",910,580,1,1)
				EndIf
				if $arrItems[$i][1] = "DYNADOWN" Then
				   MouseClick("left",960,580,1,1)
				EndIf
				if $arrItems[$i][1] = "DYNABACK" Then
				   MouseClick("left",930,630,1,1)
				EndIf
				if $arrItems[$i][1] = "CLOSECHANGE" Then
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
				Sleep($arrItems[$i][1])
			EndIf
			
		Next
    EndIf
	EmptyStatusBar(2000)
EndFunc

Func ViewSlip()
    Local $sFileOpenDialog = FileOpenDialog("Select input file", $arrCONFIG[$CFG_TLOG_PATH][1], "TLOG (RetailTransactionLog*.xml)",1)
    If @error Then
        MsgBox($MB_SYSTEMMODAL, "", "No file(s) were selected.")
        FileChangeDir(@Scriptdir)
    Else
        FileChangeDir($HelpersDir)
		ShellExecute($HelpersDir & "\ReceiptView.exe",$sFileOpenDialog & " " & $HelpersDir,"","",@SW_MAXIMIZE)
		Sleep(1500)
		ShellExecute("c:\temp\Receipt.html","","","",@SW_MAXIMIZE)
        FileChangeDir(@Scriptdir)
    EndIf

EndFunc

Func Screenshot()
    If Not FileExists($CaptureDir) Then
		DirCreate($CaptureDir)
	EndIf	
	Local $hBmp
	$hWndSCR = WinActivate("POStyper")
	WinSetState ( $hWndSCR, "", @SW_MINIMIZE )
	Sleep (250)
	$hBmp = _ScreenCapture_Capture("")
	$ImageName = $CaptureDir  & "\Screenshot" & @HOUR & "_" & @MIN & "_" & @SEC & ".jpg"
    _ScreenCapture_SaveImage($ImageName, $hBmp)
	ShellExecute($ImageName)
	WinActivate("POStyper")
EndFunc

Func POSSnip()
    If Not FileExists($CaptureDir) Then
		DirCreate($CaptureDir)
	EndIf	
	Local $hBmp
	$hWndSCR = WinActivate("POStyper")
	WinSetState ( $hWndSCR, "", @SW_MINIMIZE )
	Sleep (250)
	$hBmp = _ScreenCapture_Capture("",0,0,1024,768)
	$ImageName = $CaptureDir  & "\Screenshot" & @HOUR & "_" & @MIN & "_" & @SEC & ".jpg"
    _ScreenCapture_SaveImage($CaptureDir  & "\Screenshot" & @HOUR & "_" & @MIN & "_" & @SEC & ".jpg", $hBmp)
	ShellExecute($ImageName)
	WinActivate("POStyper")
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

Func Msg3On()
	ShellExecute($HelpersDir & "\msg3.bat","","","",@SW_MAXIMIZE)
EndFunc

Func Msg3Off()
	ShellExecute($HelpersDir & "\nomsg3.bat","","","",@SW_MAXIMIZE)
EndFunc

Func EditIni()
	ShellExecute($arrCONFIG[$CFG_EDITOR][1],$PostyperDir &"\POStyper.ini")
	Sleep(5000)
 	$arrItems=IniReadSection($iniFile,"ITEMS")
	$arrCONFIG=IniReadSection($cfgFile,"CONFIG")
EndFunc

Func Snoop()
	ShellExecute($arrCONFIG[$CFG_SNOOP][1],"")
EndFunc

Func _readItemFile()
 	$arrItems=IniReadSection($iniFile,"ITEMS")
	$arrCONFIG=IniReadSection($cfgFile,"CONFIG")
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

Func SkipAddCustomer()
	WinActivate("R10PosClient")	
	$oP1=_UIA_getObjectByFindAll($UIA_oDesktop, "Title:=R10PosClient;controltype:=UIA_WindowControlTypeId;class:=Window", $treescope_children)
	$oBtnAnnuleren=_UIA_getObjectByFindAll($oP1, "title:=Annuleren;ControlType:=UIA_ButtonControlTypeId", $treescope_subtree)
	If isobj($oBtnAnnuleren) Then
		_UIA_action($oBtnAnnuleren,"click")
	EndIf
	$oBtnBack=_UIA_getObjectByFindAll($oP1, "title:=Back;ControlType:=UIA_ButtonControlTypeId", $treescope_subtree) 
	If isobj($oBtnBack) Then
		_UIA_action($oBtnBack,"click")
	EndIf
EndFunc


Func SkipZipCodeDialog()
	WinActivate("R10PosClient")	
	$oP1=_UIA_getObjectByFindAll($UIA_oDesktop, "Title:=Retalix.Jumbo.Client.POS.Presentation.ViewModels.ViewModels.BRM.ZipCodeViewModel;controltype:=UIA_WindowControlTypeId;class:=Window", $treescope_children)
	$oP0=_UIA_getObjectByFindAll($oP1, "Title:=;controltype:=UIA_CustomControlTypeId;class:=ZipCodeView", $treescope_children)
	$oBtnOverslaan=_UIA_getObjectByFindAll($oP0, "title:=Overslaan;ControlType:=UIA_ButtonControlTypeId", $treescope_subtree)
	If isobj($oBtnOverslaan) Then
		_UIA_action($oBtnOverslaan,"click")
	EndIf
	$oBtnToSkip=_UIA_getObjectByFindAll($oP0, "title:=To skip;ControlType:=UIA_ButtonControlTypeId", $treescope_subtree)
	If isobj($oBtnToSkip) Then
		_UIA_action($oBtnToSkip,"click")
	EndIf
EndFunc

Func SelectCash()
	WinActivate("R10PosClient")	
	$oP1=_UIA_getObjectByFindAll($UIA_oDesktop, "Title:=R10PosClient;controltype:=UIA_WindowControlTypeId;class:=Window", $treescope_children)
	$oUIElement=_UIA_getObjectByFindAll($oP1, "title:=Contant;ControlType:=UIA_ButtonControlTypeId", $treescope_subtree)
	_UIA_action($oUIElement,"click")
EndFunc

Func MonitorSrvLog()
	$ServerLogsDir = $arrCONFIG[$CFG_SERVER_PATH][1] & "\Logs\"
	$hSearch = FileFindFirstFile($ServerLogsDir & "GPOSWebService_*.log")
	If $hSearch > 0 Then
		$LastGpos = FileFindNextFile($hSearch)	
		ShellExecute($arrCONFIG[$CFG_EDITOR][1],  " -monitor " & $ServerLogsDir & $LastGpos)
    EndIf
EndFunc

Func OpenSSMS()
	ShellExecute($arrCONFIG[$CFG_SQLMGR][1],"-E")	
EndFunc

Func BrowseServer()
	ShellExecute($arrCONFIG[$CFG_BROWSER][1], $arrCONFIG[$CFG_SERVER_WEBSITE][1])
EndFunc

Func BrowseRabbit()
	ShellExecute($arrCONFIG[$CFG_BROWSER][1], $arrCONFIG[$CFG_RABBITMQ_WEBSITE][1])
EndFunc
	
	
Func AddStatusBar()
	Global $g_hPosTyperStatusBar
	If ($StatusBarOn) Then		
		$g_hPosTyperStatusBar = _GUICtrlStatusBar_Create($g_hPosTyper)
	EndIf
EndFunc

Func WriteToStatusBar($MethodName, $Txt = "")
	If ($StatusBarOn) Then		
		_GUICtrlStatusBar_SetText($g_hPosTyperStatusBar, "  " & $MethodName & ": " & $Txt)
	EndIf
EndFunc

Func EmptyStatusBar($Sleep)
	If ($StatusBarOn) Then		
		Sleep($Sleep)
		_GUICtrlStatusBar_SetText($g_hPosTyperStatusBar, "")
	EndIf
EndFunc

Func FuncWrapper($Button, $FuncName, $Disable = False)
	WriteToStatusBar(FuncName($FuncName))
	If ($Disable) Then
		GUICtrlSetState ($Button,$GUI_DISABLE)
	EndIf
	$FuncName()
	If ($Disable) Then
		GUICtrlSetState ($Button,$GUI_ENABLE)
	EndIf
EndFunc