#Region AutoIt3Wrapper Ԥ�������(���ò���)
#AutoIt3Wrapper_Icon=res\app.ico							;ͼ��,֧��EXE,DLL,ICO
#AutoIt3Wrapper_OutFile=									;����ļ���
#AutoIt3Wrapper_OutFile_Type=exe							;�ļ�����
#AutoIt3Wrapper_Compression=4								;ѹ���ȼ�
#AutoIt3Wrapper_UseUPX=y 									;ʹ��ѹ��
#AutoIt3Wrapper_Res_Comment= 								;ע��
#AutoIt3Wrapper_Res_Description=							;��ϸ��Ϣ
#AutoIt3Wrapper_Res_FileVersion=							;�ļ��汾
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=p				;�Զ����°汾
#AutoIt3Wrapper_Res_LegalCopyright= 						;��Ȩ
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
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>

FileInstall(".\res\login.jpg", @TempDir & "\")

Func _loginmain()
	
	Local $loginForm, $backgroundPic, $uidInput, $pwInput, $loginButton, $MARGINS, $uid, $pw
	
	$loginForm = GUICreate("�û���¼", 384, 240, -1, -1, $GUI_SS_DEFAULT_GUI, $WS_EX_LAYERED)
	$backgroundPic = GUICtrlCreatePic(@TempDir & "\login.jpg", 0, 0, 141, 240)

	GUICtrlCreateLabel("�û���", 160, 30, 60, 30)
	GUICtrlSetFont(-1, 15, 400, 0, "΢���ź�", 3)
	$uidInput = GUICtrlCreateInput("", 230, 30, 135, 30)
	GUICtrlSetFont(-1, 15, 400, 0, "΢���ź�")
	GUICtrlCreateLabel("��   ��", 160, 80, 60, 30)
	GUICtrlSetFont(-1, 15, 400, 0, "΢���ź�", 3)
	$pwInput = GUICtrlCreateInput("", 230, 80, 135, 30, $ES_PASSWORD)
	GUICtrlSetFont(-1, 15, 400, 0, "΢���ź�")

	$loginButton = GUICtrlCreateButton("��  ¼", 197, 140, 140, 90)
	GUICtrlSetFont(-1, 30, 400, 0, "΢���ź�")

	GUISetBkColor(0xA4D4D3)
	_WinAPI_SetLayeredWindowAttributes($loginForm, 0xA4D4D3, 255)
	$MARGINS = DllStructCreate("int;int;int;int")
	DllStructSetData($MARGINS, 1, -1)
	DllCall("dwmapi.dll", "none", "DwmExtendFrameIntoClientArea", "hwnd", $loginForm, "ptr", DllStructGetPtr($MARGINS))
	GUISetState(@SW_SHOW)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				FileDelete(@TempDir & "\login.jpg")
				Exit
			Case $loginButton
				$uid = GUICtrlRead($uidInput)
				$pw = GUICtrlRead($pwInput)
				If _checkUidPw($uid, $pw) Then
					GUISetState(@SW_HIDE, $loginForm)
					Return True
				Else
					MsgBox(0x40, "����", "�û������������!")
				EndIf
		EndSwitch
	WEnd

EndFunc   ;==>_loginmain

Func _checkUidPw($uid, $pw)
	
	If $uid = "admin" And $pw = "admin" Then
		Return True
	Else
		Return False
	EndIf
	
EndFunc   ;==>_checkUidPw
