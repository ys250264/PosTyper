Dim str_ServerCore, str_ServerExt, str_POSCore, str_POSExt, str_OfficeCore, str_OfficeExt, str_ForecourtCore, str_ForecourtExt, str_RetailGatewayCore, str_RetailGatewayExt, str_PriceCheckerCore, str_PriceCheckerExt, str_GloryAdapterExt

'' MsgBox "This VBscript shows ONLY Installed MSIs Versions" & vbNewLine & vbNewLine  & "Note: " & vbNewLine & "To get the correct Extensions builds values of your Project, neeed to change the Registry Paths in the script"



'''''''''''''the below line can be duplicated with new Registry path, new parameter and also need to add NEW parameter in the Definition section of first line of this VBS and also need to add it to MsgBox of results
'str_xxx = readfromRegistry("HKEY_LOCAL_MACHINE\SOFTWARE\Retalix\Retalix10\Core\StoreServer\Version", "Not_Found")

str_ServerCore = readfromRegistry("HKEY_LOCAL_MACHINE\SOFTWARE\Retalix\Retalix10\Core\StoreServer\Version", "Not_Found")

str_ServerExt = readfromRegistry("HKEY_LOCAL_MACHINE\SOFTWARE\NCR\R10\Extensions\Italian_Market\Version", "Not_Found")

str_ServerExtUFI = readfromRegistry("HKEY_LOCAL_MACHINE\SOFTWARE\Retalix\Retalix10\Extensions\COOP_Italy\Version", "Not_Found")

If str_ServerExt =  "Not_Found" Then  
str_ServerExt = str_ServerExtUFI
End If

str_POSCore = readfromRegistry("HKEY_LOCAL_MACHINE\SOFTWARE\Retalix\Retalix10\Core\POSClient\Version", "Not_Found")

str_POSExt = readfromRegistry("HKEY_LOCAL_MACHINE\SOFTWARE\NCR\Italian_Market\Extensions\Italian_Market_Client\Version", "Not_Found")

str_POSExtUFI = readfromRegistry("HKEY_LOCAL_MACHINE\SOFTWARE\Retalix\Retalix10\Extensions\Coop_ItaliaClient\Version", "Not_Found")

If str_POSExt =  "Not_Found" Then  
str_POSExt = str_POSExtUFI
End If


str_OfficeCore = readfromRegistry("HKEY_LOCAL_MACHINE\SOFTWARE\Retalix\Retalix10\Core\StoreManager\Version", "Not_Found")

str_OfficeExt = readfromRegistry("HKEY_LOCAL_MACHINE\SOFTWARE\NCR\Italian_Market\Extensions\Italian_Market_OfficeClient\Version", "Not_Found")

str_OfficeExtUFI = readfromRegistry("HKEY_LOCAL_MACHINE\SOFTWARE\Retalix\Retalix10\Extensions\Coop_ItaliaOfficeClient\Version", "Not_Found")

If str_OfficeExt =  "Not_Found" Then  
str_OfficeExt = str_OfficeExtUFI
End If

str_RetailGatewayCore = readfromRegistry("HKEY_LOCAL_MACHINE\SOFTWARE\Retalix\RetailGateway\Core\Version", "Not_Found")

str_RetailGatewayExt = readfromRegistry("HKEY_LOCAL_MACHINE\SOFTWARE\Retalix\RetailGateway\Ext\ItalianMarket\Version", "Not_Found")

str_StoreGateway = readfromRegistry("HKEY_LOCAL_MACHINE\SOFTWARE\NCR\R10\Italian_Market\StoreGateway\Version", "Not_Found")



MsgBox "Results: (can copy it using Ctrl+C)" & vbNewLine &_
"----------------------------------------------------" & vbNewLine &_
 "ServerCore:  " & str_ServerCore & vbNewLine &_
 "ServerExt:     " & str_ServerExt & vbNewLine &_
 vbNewLine &_
 "POSCore:  " & str_POSCore & vbNewLine &_
 "POSExt:     " & str_POSExt & vbNewLine &_
 vbNewLine &_
 "OfficeCore:  " & str_OfficeCore & vbNewLine &_
 "OfficeExt:    " & str_OfficeExt & vbNewLine &_
 vbNewLine &_
 "StoreGateway:     " & str_StoreGateway & vbNewLine &_
 vbNewLine &_
 "RetailGatewayCore:  " & str_RetailGatewayCore & vbNewLine &_
 "RetailGatewayExt:    " & str_RetailGatewayExt & vbNewLine &_
  vbNewLine &_
 "----------------------------------------------------"
 




function readFromRegistry (strRegistryKey, strDefault )
    Dim WSHShell, value

    On Error Resume Next
    Set WSHShell = CreateObject("WScript.Shell")
    value = WSHShell.RegRead( strRegistryKey )

    if err.number <> 0 then
        readFromRegistry= strDefault
    else
        readFromRegistry=value
    end if

    set WSHShell = nothing
end function