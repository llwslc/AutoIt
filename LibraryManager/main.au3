#Region AutoIt3Wrapper Ԥ�������(���ò���)
#AutoIt3Wrapper_Icon=res\app.ico							;ͼ��,֧��EXE,DLL,ICO
#AutoIt3Wrapper_OutFile=���ݿ�������.exe					;����ļ���
#AutoIt3Wrapper_OutFile_Type=exe							;�ļ�����
#AutoIt3Wrapper_Compression=4								;ѹ���ȼ�
#AutoIt3Wrapper_UseUPX=y 									;ʹ��ѹ��
#AutoIt3Wrapper_Res_Comment= 								;ע��
#AutoIt3Wrapper_Res_Description=							;��ϸ��Ϣ
#AutoIt3Wrapper_Res_FileVersion=1.0.0.0
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=p				;�Զ����°汾
#AutoIt3Wrapper_Res_LegalCopyright=��Ƕ��ʽ09001�� �		;��Ȩ
#AutoIt3Wrapper_Change2CUI=N                   				;�޸�����ĳ���ΪCUI(����̨����)
;#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%		;�Զ�����Դ��
;#AutoIt3Wrapper_Run_Tidy=                   				;�ű�����
;#AutoIt3Wrapper_Run_Obfuscator=      						;�����Ի�
;#AutoIt3Wrapper_Run_AU3Check= 								;�﷨���
;#AutoIt3Wrapper_Run_Before= 								;����ǰ
;#AutoIt3Wrapper_Run_After=									;���к�
#EndRegion AutoIt3Wrapper Ԥ�������(���ò���)
#cs �ߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣ�
	
	Au3 �汾:
	�ű�����:  ��Ƕ��ʽ09001�� �
	Email:  lich09@nou.com.cn
	QQ/TM:
	�ű��汾:
	�ű�����:
	
#ce �ߣߣߣߣߣߣߣߣߣߣߣߣߣߣ߽ű���ʼ�ߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣߣ�
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <WinAPI.au3>

#include <.\sqloperate.au3>
#include <.\login.au3>

FileInstall(".\res\bkhead.jpg", @TempDir & "\")

_checkLoginmain()


Func _checkLoginmain()
	If _loginmain() Then
		_mainMenu()
	EndIf
EndFunc   ;==>_checkLoginmain

Func _mainMenu()
	
	Local $mainMenu, $bkHead, $reReadBut, $readBut, $insertBut, $deleteBut, $updateBut, $selectBut
	Local $SQLdsn, $SQLdsnInput, $SQLdsnCheck, $SQLdsnConnect, $SQLtab
	
	$mainMenu = GUICreate("���ݿ����", 300, 480, -1, -1, $GUI_SS_DEFAULT_GUI, $WS_EX_LAYERED)
	$bkHead = GUICtrlCreatePic(@TempDir & "\bkhead.jpg", 0, 0, 300, 70)
	
	$readBut = GUICtrlCreateButton("��ȡ", 0, 75, 40, 25)
	$reReadBut = GUICtrlCreateButton("ˢ��", 52, 75, 40, 25) ;����Ӻ�ɾ��,$nMsg��õ��˿ؼ���Ϣ
	GUICtrlDelete($reReadBut)
	$insertBut = GUICtrlCreateButton("��", 104, 75, 40, 25)
	GUICtrlDelete($insertBut)
	$deleteBut = GUICtrlCreateButton("ɾ", 156, 75, 40, 25)
	GUICtrlDelete($deleteBut)
	$updateBut = GUICtrlCreateButton("��", 208, 75, 40, 25)
	GUICtrlDelete($updateBut)
	$selectBut = GUICtrlCreateButton("��", 260, 75, 40, 25)
	GUICtrlDelete($selectBut)
	$SQLdsnConnect = GUICtrlCreateButton("��   ��", 110, 250, 80, 40)
	GUICtrlDelete($SQLdsnConnect)

	GUISetBkColor(0xA4D4D3)
	_WinAPI_SetLayeredWindowAttributes($mainMenu, 0xA4D4D3, 255)
	$MARGINS = DllStructCreate("int;int;int;int")
	DllStructSetData($MARGINS, 1, -1)
	DllCall("dwmapi.dll", "none", "DwmExtendFrameIntoClientArea", "hwnd", $mainMenu, "ptr", DllStructGetPtr($MARGINS))
	GUISetState(@SW_SHOW)

	While 1
		
		$nMsg = GUIGetMsg()
		Switch $nMsg
			
			Case $GUI_EVENT_CLOSE
				
				FileDelete(@TempDir & "\bkhead.jpg")
				FileDelete(@TempDir & "\login.jpg")
				
				_SQLExit()
				Exit
				
			Case $readBut
				
				GUICtrlDelete($SQLtab)
				GUICtrlDelete($reReadBut)
				GUICtrlDelete($insertBut)
				GUICtrlDelete($deleteBut)
				GUICtrlDelete($updateBut)
				GUICtrlDelete($selectBut)
				
				ControlDisable("", "", $readBut)
				
				$SQLdsn = GUICtrlCreateLabel("��������Դ", 100, 120, 100, 30)
				GUICtrlSetFont(-1, 15, 400, 0, "΢���ź�", 3)
				$SQLdsnInput = GUICtrlCreateInput("lcsql", 50, 160, 200, 40)
				GUICtrlSetFont(-1, 15, 400, 0, "΢���ź�")
				$SQLdsnCheck = GUICtrlCreateLabel("��ȷ��DSN������ȷ,���Ӳ��ɹ���ֱ���˳�!", 70, 210, 160, 30)
				$SQLdsnConnect = GUICtrlCreateButton("��   ��", 110, 250, 80, 40)
				GUICtrlSetFont(-1, 15, 400, 0, "΢���ź�")
				
			Case $SQLdsnConnect
				
				ControlEnable("", "", $readBut)

				_SQLConnect(GUICtrlRead($SQLdsnInput))
				_SQLreadDbfName()
				_SQLreadFieldName()
				
				$reReadBut = GUICtrlCreateButton("ˢ��", 52, 75, 40, 25)
				$insertBut = GUICtrlCreateButton("��", 104, 75, 40, 25)
				$deleteBut = GUICtrlCreateButton("ɾ", 156, 75, 40, 25)
				$updateBut = GUICtrlCreateButton("��", 208, 75, 40, 25)
				$selectBut = GUICtrlCreateButton("��", 260, 75, 40, 25)
				GUICtrlDelete($SQLdsn)
				GUICtrlDelete($SQLdsnInput)
				GUICtrlDelete($SQLdsnCheck)
				GUICtrlDelete($SQLdsnConnect)
				
				_SQLdisplayDbfTab($SQLtab)
				
			Case $reReadBut

				GUICtrlDelete($SQLtab)
				_SQLreadDbfName()
				_SQLreadFieldName()
				_SQLdisplayDbfTab($SQLtab)

			Case $insertBut
				
				ControlDisable("", "", $readBut)
				ControlDisable("", "", $reReadBut)
				ControlDisable("", "", $deleteBut)
				ControlDisable("", "", $updateBut)
				ControlDisable("", "", $selectBut)
				
				GUICtrlDelete($SQLtab)
				_SQLinsertDate($reReadBut)
				
				ControlEnable("", "", $readBut)
				ControlEnable("", "", $reReadBut)
				ControlEnable("", "", $deleteBut)
				ControlEnable("", "", $updateBut)
				ControlEnable("", "", $selectBut)
				
			Case $deleteBut
				
				ControlDisable("", "", $readBut)
				ControlDisable("", "", $reReadBut)
				ControlDisable("", "", $insertBut)
				ControlDisable("", "", $updateBut)
				ControlDisable("", "", $selectBut)
				
				GUICtrlDelete($SQLtab)
				_SQLdeleteDate($reReadBut)
				
				ControlEnable("", "", $readBut)
				ControlEnable("", "", $reReadBut)
				ControlEnable("", "", $insertBut)
				ControlEnable("", "", $updateBut)
				ControlEnable("", "", $selectBut)
				
			Case $updateBut
				
				ControlDisable("", "", $readBut)
				ControlDisable("", "", $reReadBut)
				ControlDisable("", "", $insertBut)
				ControlDisable("", "", $deleteBut)
				ControlDisable("", "", $selectBut)
				
				GUICtrlDelete($SQLtab)
				_SQLupdateDate($reReadBut)
				
				ControlEnable("", "", $readBut)
				ControlEnable("", "", $reReadBut)
				ControlEnable("", "", $insertBut)
				ControlEnable("", "", $deleteBut)
				ControlEnable("", "", $selectBut)
				
			Case $selectBut
				
				ControlDisable("", "", $readBut)
				ControlDisable("", "", $reReadBut)
				ControlDisable("", "", $insertBut)
				ControlDisable("", "", $deleteBut)
				ControlDisable("", "", $updateBut)
				
				GUICtrlDelete($SQLtab)
				_SQLselectDate($reReadBut)
				
				ControlEnable("", "", $readBut)
				ControlEnable("", "", $reReadBut)
				ControlEnable("", "", $insertBut)
				ControlEnable("", "", $deleteBut)
				ControlEnable("", "", $updateBut)
				
		EndSwitch
	WEnd
	
EndFunc   ;==>_mainMenu
